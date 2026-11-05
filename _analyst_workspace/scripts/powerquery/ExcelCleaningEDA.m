(output as text, optional sourceName as nullable text) as table =>
let
    Contract = CleaningMetadata,
    Missing = (v as any) as logical => v=null or List.Contains({"","null","none","nan","n/a","na"},Text.Lower(Text.Trim(Text.From(v)))),
    TextValue = (v as any) as text => if v=null then "" else Text.Trim(Text.From(v)),
    NumberValue = (v as any) as nullable number => let n=try Number.FromText(TextValue(v),"en-GB") otherwise null in if n=null then null else if Number.IsNaN(n) or n=#infinity or n=-#infinity then null else n,
    Digits = (v as text) as logical => Text.Length(v)>0 and Text.Select(v,{"0".."9"})=v,
    YearOK = (s as text) as logical => Text.Length(s)=4 and Digits(s) and Number.FromText(s)>=2018 and Number.FromText(s)<=2024,
    LabelOK = (s as text) as logical => Text.Length(s)=7 and Text.Middle(s,4,2)="-Q" and YearOK(Text.Start(s,4)) and List.Contains({"1","2","3","4"},Text.End(s,1)),
    Cell = (v as any,f as record) as record =>
        let s=TextValue(v), k=f[Kind], n=if List.Contains({"number","integer"},k) then NumberValue(v) else null,
            status=if Missing(v) then "Missing" else if k="identifier" then (if Digits(if Text.StartsWith(s,"-") then Text.Range(s,1) else s) then "Valid" else "Invalid identifier")
                else if k="boolean" then (if List.Contains({"true","false"},Text.Lower(s)) then "Valid" else "Invalid boolean")
                else if k="year" then (if YearOK(s) then "Valid" else "Invalid calendar")
                else if k="quarter" then (if List.Contains({"1","2","3","4"},s) then "Valid" else "Invalid calendar")
                else if k="quarter_label" then (if LabelOK(s) then "Valid" else "Invalid calendar")
                else if k="iso3" then (if Text.Length(s)=3 and Text.Select(Text.Upper(s),{"A".."Z"})=Text.Upper(s) then "Valid" else "Invalid code format")
                else if List.Contains({"number","integer"},k) then (if n=null or (k="integer" and Number.RoundTowardZero(n)<>n) then "Invalid number" else if (f[Minimum]<>null and n<f[Minimum]) or (f[Maximum]<>null and n>f[Maximum]) then "Outside domain" else if f[ReviewMaximum]<>null and n>f[ReviewMaximum] then "Review capacity definition" else "Valid") else "Valid",
            value=if status<>"Valid" and k<>"identifier" then null else if k="boolean" then Text.Lower(s)="true" else if k="year" or k="quarter" then Number.FromText(s) else if List.Contains({"number","integer"},k) then n else if k="iso3" then Text.Upper(s) else s
        in [Value=value,Status=status],
    Folder=Table.Buffer(Folder.Contents(pSourceFolder)),
    ReadSource=(source as record) as table =>
        let found=Table.SelectRows(Folder,each [Name]=source[File]),binary=if Table.RowCount(found)=1 then found{0}[Content] else error "Expected one canonical file: " & source[File],
            parsed=Table.PromoteHeaders(Csv.Document(binary,[Delimiter=",",Encoding=65001,QuoteStyle=QuoteStyle.Csv,ExtraValues=ExtraValues.Error]),[PromoteAllScalars=true]),
            checked=if Table.ColumnNames(parsed)=source[Columns] and Table.RowCount(parsed)=source[Rows] then parsed else error "Source schema or row count changed; review the input contract: " & source[File]
        in Table.Buffer(Table.AddIndexColumn(checked,"_source_row",1,1,Int64.Type)),
    Raw=Record.FromList(List.Transform(Contract[Sources],ReadSource),List.Transform(Contract[Sources],each [Table])),
    SourceContract=(name as text) as record => List.First(List.Select(Contract[Sources],each [Table]=name)),
    KeyMaps=Record.FromList(List.Transform(Contract[Sources],(s)=>let grouped=Table.Buffer(Table.Group(Record.Field(Raw,s[Table]),{s[PrimaryKey]},{{"N",each Table.RowCount(_),Int64.Type},{"First",each if s[Table]="fact_health_performance" then null else Table.First(_),type any}})) in Record.FromList(List.Transform(Table.ToRecords(grouped),each [N=[N],First=[First]]),List.Transform(Table.Column(grouped,s[PrimaryKey]),TextValue))),List.Transform(Contract[Sources],each [Table])),
    Parent=(tableName as text,key as any) as record => if Missing(key) then [N=0,First=null] else Record.FieldOrDefault(Record.Field(KeyMaps,tableName),TextValue(key),[N=0,First=null]),
    AttributeState=(r as record) as text => let a=Parent("dim_health_system",r[system_id]),b=Parent("dim_workforce",r[workforce_id]) in if a[N]<>1 or b[N]<>1 then "Not testable" else if TextValue(a[First][country_id])<>TextValue(r[country_id]) or TextValue(b[First][system_id])<>TextValue(r[system_id]) then "Conflict" else "Agrees",
    JoinState=(r as record) as text => let ns=List.Transform({{"dim_country","country_id"},{"dim_date","date_id"},{"dim_health_system","system_id"},{"dim_workforce","workforce_id"}},each Parent(_{0},Record.Field(r,_{1}))[N]) in if List.Contains(ns,0) then "Missing parent" else if List.AnyTrue(List.Transform(ns,each _>1)) then "Ambiguous parent" else "Single parents",
    CountryState=(r as record) as text => let country=Text.Lower(TextValue(r[country_name])),prefixes=List.Transform({r[region],r[income_group]},each if Text.Contains(TextValue(_)," -> ") then Text.Lower(Text.BeforeDelimiter(TextValue(_)," -> ")) else null) in if List.AnyTrue(List.Transform(List.RemoveNulls(prefixes),each _<>country)) then "Conflicting supplied attributes" else "No prefix conflict detected",
    CleanSource=(source as record) as table =>
        let records=List.Transform(Table.ToRecords(Record.Field(Raw,source[Table])),(row)=>
                let cells=List.Buffer(List.Transform(source[Fields],each Cell(Record.Field(row,[Name]),_))),values=List.Transform(cells,each [Value]),
                    issues=List.RemoveNulls(List.Transform(List.Positions(cells),(i)=>if cells{i}[Status]="Valid" then null else source[Fields]{i}[Name] & ": " & cells{i}[Status])),
                    core=Record.FromList(values,source[Columns]),lineage=Record.AddField(core,"_source_row",row[_source_row]),
                    key=Record.AddField(lineage,"_key_status",if Parent(source[Table],Record.Field(row,source[PrimaryKey]))[N]>1 then "Repeated declared key" else "Unique declared key"),
                    joined=if source[Table]="fact_health_performance" then Record.AddField(Record.AddField(key,"_join_status",JoinState(row)),"_attribution_status",AttributeState(row)) else if source[Table]="dim_country" then Record.AddField(key,"_attribute_status",CountryState(row)) else key,
                    flagged=Record.AddField(Record.AddField(joined,"_issue_count",List.Count(issues)),"_issues",Text.Combine(issues,"; "))
                in flagged),
            table=Table.FromRecords(records),types=List.Transform(source[Fields],each {[Name],if List.Contains({"year","quarter","integer"},[Kind]) then Int64.Type else if [Kind]="number" then type number else if [Kind]="boolean" then type logical else type text})
        in Table.TransformColumnTypes(table,types & {{"_source_row",Int64.Type},{"_issue_count",Int64.Type}},"en-GB"),
    Clean=Record.FromList(List.Transform(Contract[Sources],CleanSource),List.Transform(Contract[Sources],each [Table])),
    ProfileRecords=List.Combine(List.Transform(Contract[Sources],(s)=>List.Transform(s[Fields],(f)=>
        let cells=List.Buffer(List.Transform(Table.Column(Record.Field(Raw,s[Table]),f[Name]),each Cell(_,f))),numeric=List.Sort(List.RemoveNulls(List.Transform(cells,each if [Status]="Valid" and List.Contains({"integer","number"},f[Kind]) then [Value] else null))),
            q1=if List.IsEmpty(numeric) then null else List.Percentile(numeric,.25),q3=if List.IsEmpty(numeric) then null else List.Percentile(numeric,.75),iqr=if q1=null then null else q3-q1,
            CountStatus=(label as text) as number=>List.Count(List.Select(cells,each [Status]=label))
        in [Source=s[Table],Field=f[Name],Metric=f[Label],Unit=f[Unit],Kind=f[Kind],Records=List.Count(cells),Valid=CountStatus("Valid"),Missing=CountStatus("Missing"),Invalid=List.Count(List.Select(cells,each not List.Contains({"Valid","Missing","Review capacity definition"},[Status]))),Review=CountStatus("Review capacity definition"),Minimum=if List.IsEmpty(numeric) then null else List.Min(numeric),P25=q1,Median=if List.IsEmpty(numeric) then null else List.Median(numeric),P75=q3,Maximum=if List.IsEmpty(numeric) then null else List.Max(numeric),IqrOutliers=if q1=null then 0 else List.Count(List.Select(numeric,each _<q1-1.5*iqr or _>q3+1.5*iqr))]))),
    Profiles=Table.Buffer(Table.FromRecords(ProfileRecords)),
    MetricProfiles=Table.SelectRows(Profiles,each List.Contains({"integer","number"},[Kind])),
    Validity=Table.Unpivot(Table.SelectColumns(MetricProfiles,{"Source","Field","Metric","Valid","Missing","Invalid","Review"}),{"Valid","Missing","Invalid","Review"},"Status","Records"),
    Histograms=Table.FromRecords(List.Combine(List.Transform(Contract[Sources],(s)=>List.Combine(List.Transform(List.Select(s[Fields],each [HistogramWidth]<>null),(f)=>
        let width=f[HistogramWidth],valid=List.RemoveNulls(List.Transform(Table.Column(Record.Field(Raw,s[Table]),f[Name]),each Cell(_,f)[Value])),bins=Table.FromList(List.Transform(valid,each if f[Maximum]<>null and _=f[Maximum] then List.Max({0,Number.RoundDown(_/width)-1}) else Number.RoundDown(_/width)),Splitter.SplitByNothing(),{"Bucket"}),counts=Table.Group(bins,{"Bucket"},{{"Records",each Table.RowCount(_),Int64.Type}})
        in List.Transform(Table.ToRecords(counts),each [Metric=f[Label],BinStart=[Bucket]*width,Bin=Number.ToText([Bucket]*width,"0000","en-GB") & " to " & Number.ToText(([Bucket]+1)*width,"0000","en-GB"),Records=[Records]])))))),
    KeyGroups=Table.FromRecords(List.Combine(List.Transform(Contract[Sources],(s)=>let g=Table.Group(Record.Field(Clean,s[Table]),{"_key_status"},{{"Records",each Table.RowCount(_),Int64.Type}}) in List.Transform(Table.ToRecords(g),each [Source=s[Table],Group=[_key_status],Records=[Records]])))),
    Fact=Record.Field(Clean,"fact_health_performance"),
    JoinGroups=Table.RenameColumns(Table.Group(Fact,{"_join_status"},{{"Records",each Table.RowCount(_),Int64.Type}}),{{"_join_status","Group"}}),
    AttributionGroups=Table.RenameColumns(Table.Group(Fact,{"_attribution_status"},{{"Records",each Table.RowCount(_),Int64.Type}}),{{"_attribution_status","Group"}}),
    SystemTypes=Table.RenameColumns(Table.Group(Record.Field(Clean,"dim_health_system"),{"system_type"},{{"Records",each Table.RowCount(_),Int64.Type}}),{{"system_type","SystemType"}}),
    Pairs=Table.FromRecords(List.Transform(Contract[Pairs],(p)=>
        let fields=SourceContract(p[Source])[Fields],xf=List.First(List.Select(fields,each [Name]=p[X])),yf=List.First(List.Select(fields,each [Name]=p[Y])),cleanPairs=Table.FromRecords(List.Transform(Table.ToRecords(Table.SelectColumns(Record.Field(Raw,p[Source]),{p[X],p[Y]})),each [X=Cell(Record.Field(_,p[X]),xf)[Value],Y=Cell(Record.Field(_,p[Y]),yf)[Value]])),selected=Table.SelectRows(cleanPairs,each [X]<>null and [Y]<>null),xs=List.Buffer(selected[X]),ys=List.Buffer(selected[Y]),n=List.Count(xs),mx=if n=0 then null else List.Average(xs),my=if n=0 then null else List.Average(ys),
            covariance=if n<30 then null else List.Sum(List.Transform(List.Positions(xs),(i)=>(xs{i}-mx)*(ys{i}-my))),xx=if n<30 then null else List.Sum(List.Transform(xs,each Number.Power(_-mx,2))),yy=if n<30 then null else List.Sum(List.Transform(ys,each Number.Power(_-my,2))),r=if n<30 or xx=0 or yy=0 then null else covariance/Number.Sqrt(xx*yy)
        in [Source=p[Source],X=p[X],Y=p[Y],Pair=p[Pair],Pairs=n,Correlation=r,Status=if n<30 then "Too few eligible pairs (<30)" else "Exploratory only"])),
    Selected=if output="Clean" then CleanSource(SourceContract(sourceName)) else if output="Profiles" then Profiles else if output="Validity" then Validity else if output="Histograms" then Histograms else if output="KeyGroups" then KeyGroups else if output="JoinGroups" then JoinGroups else if output="AttributionGroups" then AttributionGroups else if output="SystemTypes" then SystemTypes else if output="Pairs" then Pairs else error "Unknown cleaning/EDA output"
in Selected
