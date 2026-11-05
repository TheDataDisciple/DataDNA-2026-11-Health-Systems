[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$taskRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$output=Join-Path $taskRoot '_analyst_workspace/outputs/excel_cleaning_eda'
$bookPath=Join-Path $taskRoot 'Data Source/In Progress/Health_System_Cleaning_EDA.xlsx'
$build=Get-Content -LiteralPath (Join-Path $output 'native_build.json') -Raw | ConvertFrom-Json
if(-not $build.Passed){throw 'Native cleaning build has not completed.'}
$contract=Get-Content -LiteralPath (Join-Path $output 'contract.json') -Raw | ConvertFrom-Json
$result=[ordered]@{Passed=$false;Started=[DateTimeOffset]::Now.ToString('o');Checks=@();Charts=@();Exports=@()}
$excelInstance=$null;$book=$null
Add-Type -Path (Join-Path $PSScriptRoot 'NativeCsvBridge.cs')
function Check([string]$name,$actual,$expected){$pass=$actual -eq $expected;$script:result.Checks+=,[ordered]@{Name=$name;Actual=$actual;Expected=$expected;Passed=$pass};if(-not $pass){throw ('Native verification failed: '+$name)}}
function Pivot([string]$name,[string]$source,[string]$row,[string]$column,[string]$page,[string]$selected,[string]$metric,[int]$start,[int]$aggregation=-4157){
 $targetSheet=if($name -in @('WorkforceDistribution','DeclaredKeys','SystemComposition')){'Workforce and structure'}else{'EDA'}
 $sheet=$book.Worksheets.Item($targetSheet);$pivot=$null
 foreach($candidate in $sheet.PivotTables()){if($candidate.Name -eq $name){$pivot=$candidate;break}}
 if($null -eq $pivot){
  $cache=$book.PivotCaches().Create(1,$source,5);$pivot=$cache.CreatePivotTable($sheet.Range('T'+$start),$name)
  $pivot.PivotFields($row).Orientation=1
  if($column){$pivot.PivotFields($column).Orientation=2}
  if($page){$pivot.PivotFields($page).Orientation=3;$pivot.PivotFields($page).CurrentPage=$selected}
  $pivot.RowGrand=$false;$pivot.ColumnGrand=$false;$pivot.TableStyle2='PivotStyleMedium9'
 }
 if($pivot.DataFields().Count -eq 0){$null=$pivot.AddDataField($pivot.PivotFields($metric),$(if($metric -eq 'Correlation'){'Pearson r'}else{'Record count'}),$aggregation)}
 $null=$pivot.RefreshTable();$pivot.DataBodyRange.NumberFormat=$(if($metric -eq 'Correlation'){'0.000'}else{'#,##0'})
 $pivot.RowAxisLayout(1)
 $pivot.HasAutoFormat=$false
 return ,$pivot
}
function Chart([string]$name,$pivot,[string]$sheetName,[int]$kind,[int]$left,[int]$top,[int]$width,[int]$height,[string]$title,[string]$pageField=''){
 $sourceSheet=$book.Worksheets.Item($sheetName);$sourceSheet.Activate();$null=$pivot.TableRange1.Select()
 $sheet=$book.Worksheets.Item($sheetName);$shape=$null
 foreach($candidate in $sheet.ChartObjects()){if($candidate.Name -eq $name){$shape=$candidate;break}}
 if($null -eq $shape){
  $native=$sourceSheet.Shapes.AddChart2(201,$kind,$left,$top,$width,$height)
  Write-Host ('Before source: '+$native.Chart.SeriesCollection().Count+' series; pivot '+$pivot.Name+' sum '+$excelInstance.WorksheetFunction.Sum($pivot.DataBodyRange)+'; range '+$pivot.TableRange1.Address())
  $native.Chart.SetSourceData($pivot.TableRange1)
  $shape=$sheet.ChartObjects().Item($sheet.ChartObjects().Count);$shape.Name=$name
 }
 $shape.Left=$left;$shape.Top=$top;$shape.Width=$width;$shape.Height=$height
 $chart=$shape.Chart;$chart.ChartType=$kind;$chart.HasTitle=$true;$chart.ChartTitle.Text=$title
 $sheet.Activate();$null=$shape.Activate();$chart.Refresh();$excelInstance.Calculate()
 Write-Host ($name+': '+$chart.SeriesCollection().Count+' native series; '+$pivot.DataFields().Count+' data fields; '+$pivot.DataBodyRange.Rows.Count+' rows')
 if($chart.SeriesCollection().Count -eq 0){Write-Host ('Chart-associated pivot '+$chart.PivotLayout.PivotTable.Name+'; chart pivot data fields '+$chart.PivotLayout.PivotTable.DataFields().Count);throw 'Native chart has no series; do not export an empty chart.'}
 $chart.ChartArea.Font.Name='Segoe UI';$chart.ChartArea.Font.Size=11;$chart.ChartTitle.Font.Name='Segoe UI';$chart.ChartTitle.Font.Size=15
 $chart.HasLegend=$kind -eq 59
 if($chart.HasLegend){$chart.Legend.Position=-4107;$chart.Legend.Font.Size=11}
 try{$chart.Axes(2).MinimumScale=0;$chart.Axes(2).TickLabels.NumberFormat='#,##0';$chart.Axes(1).TickLabels.Font.Size=10}catch{}
 if($kind -eq 51){$chart.ChartGroups(1).GapWidth=15;$chart.Axes(1).HasTitle=$true;$chart.Axes(1).AxisTitle.Text='Bin starting value';$chart.Axes(1).TickLabelSpacing=2}
 if($name -eq 'CorrelationChart'){$chart.Axes(2).MinimumScale=-1;$chart.Axes(2).MaximumScale=1;$chart.Axes(2).MajorUnit=.25;$chart.Axes(2).TickLabels.NumberFormat='0.00';$chart.Axes(1).TickLabelPosition=-4134;$chart.SeriesCollection(1).ApplyDataLabels();$chart.SeriesCollection(1).DataLabels().NumberFormat='0.000';$chart.SeriesCollection(1).DataLabels().Position=2}
 elseif($kind -eq 59){$chart.Axes(2).MinimumScale=0;$chart.Axes(2).MaximumScale=1;$chart.Axes(2).TickLabels.NumberFormat='0%';$chart.ShowAllFieldButtons=$true
  foreach($series in $chart.SeriesCollection()){$color=switch -Wildcard ($series.Name){'*Invalid*'{0x2F3CA6};'*Repeated*'{0x2F3CA6};'*Review*'{0x005B8A};'*Missing*'{0x756558};default{0x4F6623}};$series.Interior.Color=$color}
 }else{$chart.SeriesCollection(1).Interior.Color=0xA45723}
 if($pageField){
  $pageCell=$pivot.PageFields($pageField).DataRange.Cells.Item(1,1).Address($true,$true,1,$false)
  $titleCell=$sourceSheet.Range('AK'+$pivot.TableRange2.Row)
  $titleCell.Formula='="'+$title.Replace('"','""')+' | "&'+$pageCell
  if($name -in @('WaitingChart','SpendingChart','WorkforceChart')){
   $start=$pivot.TableRange1.Row;$end=$start+58
   $titleCell.Formula='='+$pageCell+'&" | eligible n="&TEXT(SUM($U$'+$start+':$U$'+$end+'),"#,##0")'
   $chart.ChartTitle.Font.Size=13
  }
  $chart.ChartTitle.Formula="='"+$sheetName+"'!"+$titleCell.Address($true,$true,1,$false)
 }
 Check ($name+' genuine PivotChart') ($null -ne $chart.PivotLayout) $true
 $script:result.Charts+=,[ordered]@{Name=$name;Sheet=$sheetName;PivotTable=[string]$chart.PivotLayout.PivotTable.Name;Title=[string]$chart.ChartTitle.Text}
 return ,$shape
}
function Export-Table($table,[string]$path){$rows=$table.ListRows.Count;$values=$null;if($rows -gt 0){$values=$table.DataBodyRange.Value2};[NativeCsvBridge]::Write($path,$table.HeaderRowRange.Value2,$values,$rows);$script:result.Exports+=,[ordered]@{Table=$table.Name;Rows=$rows;Path=$path;Sha256=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()}}
try{
 $excelInstance=New-Object -ComObject Excel.Application;$excelInstance.Visible=$false;$excelInstance.DisplayAlerts=$false;$excelInstance.ScreenUpdating=$true
 $book=$excelInstance.Workbooks.Open($bookPath)
 # Keep the embedded production function identical to the reviewed source.
 $m=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'powerquery/ExcelCleaningEDA.m'))
 if($book.Queries.Item('ExcelCleaningEDA').Formula -ne $m){
  $book.Queries.Item('ExcelCleaningEDA').Formula=$m
  $null=$book.Worksheets.Item('Prepared summaries').ListObjects.Item('Summary_Histograms').QueryTable.Refresh($false)
 }
 foreach($old in @($book.Worksheets.Item('PivotTables').PivotTables())){$old.TableRange2.Clear()}
 $metric=@{};foreach($source in $contract.Sources){foreach($f in $source.Fields){$metric[$f.Name]=$f.Label}}
 $wait=Pivot 'WaitingDistribution' 'Summary_Histograms' 'BinStart' '' 'Metric' $metric.ae_avg_wait_minutes 'Records' 6
 $spend=Pivot 'SpendingDistribution' 'Summary_Histograms' 'BinStart' '' 'Metric' $metric.health_spend_per_capita_usd 'Records' 66
 $workforce=Pivot 'WorkforceDistribution' 'Summary_Histograms' 'BinStart' '' 'Metric' $metric.burnout_index_score 'Records' 126
 $validity=Pivot 'MetricEligibility' 'Summary_Validity' 'Metric' 'Status' 'Source' 'fact_health_performance' 'Records' 186
 $keys=Pivot 'DeclaredKeys' 'Summary_KeyGroups' 'Source' 'Group' '' '' 'Records' 246
 $systems=Pivot 'SystemComposition' 'Summary_SystemTypes' 'SystemType' '' '' '' 'Records' 306
 $correlation=Pivot 'RowCorrelations' 'Summary_CorrelationChartData' 'PairLabel' '' '' '' 'Correlation' 366 -4136
 $book.Worksheets.Item('EDA').Columns.Item('T').ColumnWidth=64;$book.Worksheets.Item('EDA').Columns.Item('U').ColumnWidth=60
 $book.Worksheets.Item('Workforce and structure').Columns.Item('T').ColumnWidth=40;$book.Worksheets.Item('Workforce and structure').Columns.Item('U:V').ColumnWidth=36
 $null=Chart 'WaitingChart' $wait 'EDA' 51 10 90 570 330 'Distribution' 'Metric'
 $null=Chart 'SpendingChart' $spend 'EDA' 51 600 90 570 330 'Distribution' 'Metric'
 $null=Chart 'CorrelationChart' $correlation 'EDA' 57 10 440 1160 330 'Pairwise row correlations; coefficients shown only with at least 30 eligible pairs'
 $null=Chart 'EligibilityChart' $validity 'EDA' 59 10 790 1160 650 'Metric eligibility (see Profile for counts)' 'Source'
 $null=Chart 'WorkforceChart' $workforce 'Workforce and structure' 51 10 90 1160 330 'Distribution' 'Metric'
 $null=Chart 'SystemTypesChart' $systems 'Workforce and structure' 57 10 440 1160 520 'Health-system master records by supplied type; 220 records, not verified unique entities'
 $null=Chart 'DeclaredKeysChart' $keys 'Workforce and structure' 59 10 980 1160 370 'Share of source records by declared-key membership; repeated includes every occurrence'
 $book.Worksheets.Item('Workforce and structure').ChartObjects('DeclaredKeysChart').Chart.HasLegend=$true
 # Genuine filter changes must update the native PivotTable and linked chart title.
 $defaultWaitTotal=[double]$excelInstance.WorksheetFunction.Sum($wait.DataBodyRange)
 $defaultWaitFirstBin=[double]$wait.DataBodyRange.Cells.Item(1,1).Value2
 Check 'Default waiting distribution contains every eligible record' $defaultWaitTotal 40000
 $wait.PivotFields('Metric').CurrentPage=$metric.elective_wait_weeks;$null=$wait.RefreshTable();$excelInstance.CalculateFull()
 Check 'Native histogram filter changes' ([string]$wait.PivotFields('Metric').CurrentPage.Name) $metric.elective_wait_weeks
 Check 'Histogram filter changes displayed bin counts' ([double]$wait.DataBodyRange.Cells.Item(1,1).Value2 -ne $defaultWaitFirstBin) $true
 Check 'Linked chart title follows metric selection' ([string]$book.Worksheets.Item('EDA').ChartObjects('WaitingChart').Chart.ChartTitle.Text).Contains('Elective') $true
 $wait.PivotFields('Metric').CurrentPage=$metric.ae_avg_wait_minutes;$null=$wait.RefreshTable();$excelInstance.CalculateFull()
 $validity.PivotFields('Source').CurrentPage='dim_workforce';$null=$validity.RefreshTable()
 Check 'Native source filter changes eligibility population' ([string]$validity.PivotFields('Source').CurrentPage.Name) 'dim_workforce'
 Check 'Eligibility filter exposes eight workforce metrics' $validity.DataBodyRange.Rows.Count 8
 $validity.PivotFields('Source').CurrentPage='fact_health_performance';$null=$validity.RefreshTable()
 $book.Worksheets.Item('Profile').Range('F:J').NumberFormat='#,##0';$book.Worksheets.Item('Profile').Range('K:O').NumberFormat='0.00';$book.Worksheets.Item('Profile').Range('P:P').NumberFormat='#,##0'
 $book.Worksheets.Item('Correlations').Range('E:E').NumberFormat='#,##0';$book.Worksheets.Item('Correlations').Range('F:F').NumberFormat='0.000000'
 # A compact guide links to the seven real PivotTables next to their charts.
 $index=$book.Worksheets.Item('PivotTables');$index.Hyperlinks.Delete();$index.Range('A1:O2').UnMerge();$index.Range('A1:D2').Merge();$index.Range('A4:D4').Merge()
 $index.Range('A4').Value2='Click a PivotTable name. Use its dropdowns or the chart field buttons; totals describe eligible source records.';$index.Range('A4').WrapText=$true;$index.Rows.Item(4).RowHeight=44
 $index.Columns.Item('A').ColumnWidth=30;$index.Columns.Item('B').ColumnWidth=28;$index.Columns.Item('C').ColumnWidth=25;$index.Columns.Item('D').ColumnWidth=58
 $labels=@('PivotTable','Worksheet','Filter','Exploration question');for($c=1;$c -le 4;$c++){$index.Cells.Item(6,$c).Value2=$labels[$c-1]}
 $links=@(
  @($wait,'Metric','How are eligible waiting times distributed?'),@($spend,'Metric','What is the shape and range of spending records?'),
  @($workforce,'Metric','How much workforce data remains within each metric domain?'),@($validity,'Source','Which fields retain valid, missing, invalid or review-required records?'),
  @($keys,'None','What share of records belongs to a repeated declared key?'),@($systems,'None','How are master records distributed across supplied system types?'),
  @($correlation,'None','Do the eligible numeric pairs show a linear association?'))
 for($r=0;$r -lt $links.Count;$r++){$p=$links[$r][0];$row=$r+7;$null=$index.Hyperlinks.Add($index.Cells.Item($row,1),'',("'"+$p.Parent.Name+"'!"+$p.TableRange2.Cells.Item(1,1).Address()),[Type]::Missing,[string]$p.Name);$index.Cells.Item($row,2).Value2=$p.Parent.Name;$index.Cells.Item($row,3).Value2=$links[$r][1];$index.Cells.Item($row,4).Value2=$links[$r][2]}
 $index.Range('A6:D6').Interior.Color=0x4A3220;$index.Range('A6:D6').Font.Color=0xFFFFFF;$index.Range('A7:D13').WrapText=$true;$index.Range('A7:D13').RowHeight=48
 $guide=$book.Worksheets.Item('Read me');$guide.Range('A1:O2').UnMerge();$guide.Range('A1:B2').Merge();$guide.Columns.Item('C:O').ColumnWidth=15
 # Move hashes to a suitable three-column area so the guide's wide text column does not distort record counts.
 foreach($table in $guide.ListObjects){if($table.Name -eq 'SourceManifest'){$table.Range.Cut($book.Worksheets.Item('Profile').Range('A78'));break}}
 $book.Worksheets.Item('Profile').Range('A78:C83').WrapText=$true;$book.Worksheets.Item('Profile').Range('A79:C83').RowHeight=45;$book.Worksheets.Item('Profile').Range('C79:C83').Font.Size=9
 foreach($row in $guide.ListObjects.Item('WorkbookGuide').ListRows){$text=[string]$row.Range.Cells.Item(1,2).Value2;$text=$text.Replace('вЂ“','-');$row.Range.Cells.Item(1,2).Value2=$text}
 $guide.Hyperlinks.Delete();$guide.Range('A24').Value2='Explore the workbook';$guide.Range('A24:B24').Font.Bold=$true
 $nav=@(@('EDA','Distributions, eligibility and correlations'),@('Workforce and structure','Workforce distributions, system types and repeated keys'),@('PivotTables','Seven PivotTables: filters, questions and direct links'),@('Profile','All 65 field profiles and original source hashes at row 78'),@('Correlations','Six pair definitions, eligible n and coefficients'),@('Clean performance','40,000 prepared performance records with source ordinals and issue flags'))
 for($r=0;$r -lt $nav.Count;$r++){$row=$r+25;$null=$guide.Hyperlinks.Add($guide.Cells.Item($row,1),'',("'"+$nav[$r][0]+"'!A1"),[Type]::Missing,$nav[$r][0]);$guide.Cells.Item($row,2).Value2=$nav[$r][1]}
 $guide.Range('A25:B30').RowHeight=30;$guide.Range('A25:B30').WrapText=$true
 $guide.Range('A32:B33').Merge();$guide.Range('A32').Value2='Finding: spending/waiting correlations are near zero in these records. Calendar and entity defects prevent verified country comparisons or time trends.';$guide.Range('A32').WrapText=$true
 foreach($source in $contract.Sources){
  $sheet=$book.Worksheets.Item(@{dim_country='Clean country';dim_date='Clean calendar';dim_health_system='Clean systems';dim_workforce='Clean workforce';fact_health_performance='Clean performance'}[$source.Table])
  $table=$sheet.ListObjects.Item('Data_'+$source.Table)
  foreach($field in $source.Fields){$column=$table.ListColumns.Item($field.Name);$column.Range.ColumnWidth=28
   if($field.Kind -eq 'identifier'){$column.Range.ColumnWidth=14}
   elseif($field.Kind -in @('number','integer')){$column.DataBodyRange.NumberFormat=$(if($field.Kind -eq 'integer'){'#,##0'}else{'#,##0.00'})}
   elseif($field.Kind -in @('text','quarter_label')){$column.Range.ColumnWidth=40;$column.DataBodyRange.WrapText=$true}
  }
  $table.HeaderRowRange.RowHeight=50;$table.HeaderRowRange.VerticalAlignment=-4108
  if($source.Rows -le 220){$table.DataBodyRange.Rows.AutoFit()}
  $sheet.Range('A3').Value2='All source records retained. Blanks and _issues identify withheld values. Select an issue cell and expand the formula bar to read its full text; _source_row links to the unchanged CSV.'
 }
 Check 'PivotTable guide has seven direct links' $index.Hyperlinks.Count 7
 Check 'Histogram title includes eligible denominator' ([string]$book.Worksheets.Item('EDA').ChartObjects('WaitingChart').Chart.ChartTitle.Text).Contains('40,000') $true
 Check 'Key membership uses percentage bars' $book.Worksheets.Item('Workforce and structure').ChartObjects('DeclaredKeysChart').Chart.ChartType 59
 foreach($sheetName in @('Read me','EDA','Workforce and structure','Profile','Correlations')){$book.Worksheets.Item($sheetName).Activate();$excelInstance.ActiveWindow.DisplayGridlines=$false;$excelInstance.ActiveWindow.Zoom=85}
 $book.Worksheets.Item('Read me').Activate();$book.Save();$book.Close($false);$book=$excelInstance.Workbooks.Open($bookPath)
 Check 'Seven native pivots survive reopen' ($book.Worksheets.Item('EDA').PivotTables().Count+$book.Worksheets.Item('Workforce and structure').PivotTables().Count) 7
 Check 'Four primary EDA charts survive reopen' $book.Worksheets.Item('EDA').ChartObjects().Count 4
 Check 'Three secondary EDA charts survive reopen' $book.Worksheets.Item('Workforce and structure').ChartObjects().Count 3
 $images=Join-Path $output 'charts';$null=New-Item -ItemType Directory -Path $images -Force
 foreach($sheetName in @('EDA','Workforce and structure')){
  $sheet=$book.Worksheets.Item($sheetName);$sheet.Activate()
  foreach($object in $sheet.ChartObjects()){
   Check ($object.Name+' PivotLayout survives reopen') ($null -ne $object.Chart.PivotLayout) $true
   $null=$object.Activate();$object.Chart.Refresh();$path=Join-Path $images ($object.Name+'.png');$ok=$object.Chart.Export($path,'PNG');$bytes=[IO.File]::ReadAllBytes($path)
   Check ($object.Name+' native PNG signature') ($ok -and $bytes.Length -gt 1000 -and [BitConverter]::ToString($bytes[0..7]) -eq '89-50-4E-47-0D-0A-1A-0A') $true
  }
 }
 $cleanFolder=Join-Path $taskRoot 'Data Source/In Progress/Cleaned';$null=New-Item -ItemType Directory -Path $cleanFolder -Force
 $sheets=@{dim_country='Clean country';dim_date='Clean calendar';dim_health_system='Clean systems';dim_workforce='Clean workforce';fact_health_performance='Clean performance'}
 foreach($source in $contract.Sources){$table=$book.Worksheets.Item($sheets[$source.Table]).ListObjects.Item('Data_'+$source.Table);Export-Table $table (Join-Path $cleanFolder $source.File)}
 $native=Join-Path $output 'native_tables';$null=New-Item -ItemType Directory -Path $native -Force
 foreach($sheetName in @('Profile','Prepared summaries','Correlations')){foreach($table in $book.Worksheets.Item($sheetName).ListObjects){Export-Table $table (Join-Path $native ($table.Name+'.csv'))}}
 foreach($source in $contract.Sources){Check ('Original hash preserved: '+$source.File) (Get-FileHash -LiteralPath (Join-Path $contract.SourceFolder $source.File) -Algorithm SHA256).Hash.ToLowerInvariant() $source.Sha256}
 $book.Worksheets.Item('Read me').Activate();$book.Save();$result.Passed=$true
}catch{$result.Error=$_.Exception.Message;$result.Location=[string]$_.InvocationInfo.PositionMessage;throw}
finally{
 if($null -ne $book){try{$book.Close($false)}catch{}}
 if($null -ne $excelInstance){try{$excelInstance.Quit()}catch{}}
 $result.Finished=[DateTimeOffset]::Now.ToString('o');$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $output 'native_eda.json') -Encoding utf8NoBOM
 if($null -ne $book){[void][Runtime.InteropServices.Marshal]::ReleaseComObject($book)}
 if($null -ne $excelInstance){[void][Runtime.InteropServices.Marshal]::ReleaseComObject($excelInstance)}
 [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
$result | ConvertTo-Json -Depth 8
