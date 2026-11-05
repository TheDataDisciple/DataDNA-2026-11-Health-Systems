[CmdletBinding()]
param([switch]$Resume)
$ErrorActionPreference='Stop'
$taskRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$output=Join-Path $taskRoot '_analyst_workspace/outputs/excel_cleaning_eda'
$contract=Get-Content -LiteralPath (Join-Path $output 'contract.json') -Raw | ConvertFrom-Json
$bookPath=Join-Path $taskRoot 'Data Source/In Progress/Health_System_Cleaning_EDA.xlsx'
$result=[ordered]@{Passed=$false;Workbook=$bookPath;Started=[DateTimeOffset]::Now.ToString('o');Steps=@()}
$excelInstance=$null;$book=$null
function Save-Progress { $script:result | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath (Join-Path $output 'native_build.json') -Encoding utf8NoBOM }
function Note([string]$message){Write-Host $message;Save-Progress}
function Load-Query([string]$name,[string]$sheetName,[string]$tableName,[string]$cell='A6'){
 $sheet=$book.Worksheets.Item($sheetName);$table=$null
 foreach($existing in $sheet.ListObjects){if($existing.Name -eq $tableName){$table=$existing;break}}
 if($null -eq $table){
  $connection='OLEDB;Provider=Microsoft.Mashup.OleDb.1;Data Source=$Workbook$;Location='+$name+';Extended Properties=""'
  $table=$sheet.ListObjects.Add(3,$connection,[Type]::Missing,1,$sheet.Range($cell));$table.Name=$tableName
  $table.QueryTable.CommandType=2;$table.QueryTable.CommandText='SELECT * FROM ['+$name+']'
 }
 $table.QueryTable.BackgroundQuery=$false;$watch=[Diagnostics.Stopwatch]::StartNew();Note ('Refreshing '+$name)
 $null=$table.QueryTable.Refresh($false);$watch.Stop();$table.TableStyle='TableStyleMedium2'
 $table.HeaderRowRange.WrapText=$true;$table.HeaderRowRange.RowHeight=36
 $script:result.Steps+=,[ordered]@{Query=$name;Rows=$table.ListRows.Count;Seconds=$watch.Elapsed.TotalSeconds};Save-Progress
 return ,$table
}
function Put-Table([string]$sheetName,[string]$cell,[string]$name,[string[]]$headers,[object[]]$rows){
 $sheet=$book.Worksheets.Item($sheetName)
 foreach($existing in $sheet.ListObjects){if($existing.Name -eq $name){return ,$existing}}
 $values=New-Object 'object[,]' ($rows.Count+1),$headers.Count
 for($c=0;$c -lt $headers.Count;$c++){$values[0,$c]=$headers[$c]}
 for($r=0;$r -lt $rows.Count;$r++){for($c=0;$c -lt $headers.Count;$c++){$v=$rows[$r][$c];if($v -is [ValueType] -and $v -isnot [bool]){$v=[double]$v};$values[($r+1),$c]=$v}}
 $range=$sheet.Range($cell).Resize($rows.Count+1,$headers.Count);$range.Value2=$values
 $table=$sheet.ListObjects.Add(1,$range,[Type]::Missing,1);$table.Name=$name;$table.TableStyle='TableStyleMedium2';return ,$table
}
try{
 foreach($s in $contract.Sources){$path=Join-Path $contract.SourceFolder $s.File;if($path.Length -ge 260){throw 'Native Excel source path exceeds 259 characters'};if((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() -ne $s.Sha256){throw ('Source changed: '+$s.File)}}
 $excelInstance=New-Object -ComObject Excel.Application;$excelInstance.Visible=$false;$excelInstance.DisplayAlerts=$false;$excelInstance.ScreenUpdating=$true
 $result.ExcelVersion=[string]$excelInstance.Version;$result.ExcelBuild=[string]$excelInstance.Build
 Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public class ExcelTaskWindow { [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr window,out uint process); }'
 [uint32]$ownedProcessId=0;$null=[ExcelTaskWindow]::GetWindowThreadProcessId([IntPtr]$excelInstance.Hwnd,[ref]$ownedProcessId);$result.OwnedExcelProcessId=$ownedProcessId
 if(Test-Path -LiteralPath $bookPath){if(-not $Resume){throw 'Focused workbook already exists; inspect and use -Resume.'};$book=$excelInstance.Workbooks.Open($bookPath)}
 else{
  $book=$excelInstance.Workbooks.Add();while($book.Worksheets.Count -gt 1){$book.Worksheets.Item($book.Worksheets.Count).Delete()};$book.Worksheets.Item(1).Name='Read me'
  foreach($name in @('EDA','Workforce and structure','Profile','Clean country','Clean calendar','Clean systems','Clean workforce','Clean performance','PivotTables','Prepared summaries','Correlations')){$newSheet=$book.Worksheets.Add([Type]::Missing,$book.Worksheets.Item($book.Worksheets.Count));$newSheet.Name=$name}
  foreach($sheet in $book.Worksheets){$sheet.Cells.Font.Name='Segoe UI';$sheet.Cells.Font.Size=11;$sheet.Range('A1:O2').Merge();$sheet.Range('A1').Value2=$sheet.Name;$sheet.Range('A1:O2').Interior.Color=0x4A3220;$sheet.Range('A1:O2').Font.Color=0xFFFFFF;$sheet.Range('A1:O2').Font.Size=22;$sheet.Columns.Item('A:O').ColumnWidth=15}
  try{$book.SaveAs($bookPath,51)}catch{if(-not (Test-Path -LiteralPath $bookPath) -or -not $book.Saved){throw};$result.SaveNote='OneDrive SaveAs reported a COM return error after the native workbook was successfully saved.'}
 }
 $existing=@{};foreach($q in $book.Queries){$existing[$q.Name]=$q}
 $metadata=[IO.File]::ReadAllText((Join-Path $output 'contract.json')).Replace('"','""')
 $formulas=[ordered]@{pSourceFolder='"'+$contract.SourceFolder.Replace('"','""')+'" meta [IsParameterQuery=true,Type="Text",IsParameterQueryRequired=true]';CleaningMetadata='Json.Document("'+$metadata+'")';ExcelCleaningEDA=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'powerquery/ExcelCleaningEDA.m'))}
 foreach($source in $contract.Sources){$formulas['Clean_'+$source.Table]='ExcelCleaningEDA("Clean","'+$source.Table+'")'}
 foreach($name in @('Profiles','Validity','Histograms','KeyGroups','JoinGroups','AttributionGroups','SystemTypes','Pairs')){$formulas[$name]='ExcelCleaningEDA("'+$name+'")'}
 $formulas.CorrelationChartData='let P=Table.SelectRows(ExcelCleaningEDA("Pairs"),each [Correlation]<>null) in Table.AddColumn(P,"PairLabel",each [Pair] & " | n=" & Number.ToText([Pairs],"#,##0","en-GB"),type text)'
 foreach($name in $formulas.Keys){if($existing.ContainsKey($name)){$existing[$name].Formula=$formulas[$name]}else{$null=$book.Queries.Add($name,$formulas[$name])}}
 $sheetNames=@{dim_country='Clean country';dim_date='Clean calendar';dim_health_system='Clean systems';dim_workforce='Clean workforce';fact_health_performance='Clean performance'}
 foreach($name in @('dim_country','dim_date','dim_health_system','dim_workforce','fact_health_performance')){
  $table=Load-Query ('Clean_'+$name) $sheetNames[$name] ('Data_'+$name)
  $expected=($contract.Sources | Where-Object {$_.Table -eq $name}).Rows
  if($table.ListRows.Count -ne $expected){throw ('Row preservation failed: '+$name)}
  $sheet=$book.Worksheets.Item($sheetNames[$name]);$sheet.Range('A3:O4').Merge();$sheet.Range('A3').Value2='All source records retained. Blank analysis cells and _issues identify invalid or review-required inputs. Original values remain in the canonical CSV files.';$sheet.Range('A3:O4').WrapText=$true
  $sheet.Columns.ColumnWidth=18
  foreach($col in $table.ListColumns){if($col.Name -like '_*'){$col.Range.ColumnWidth=26};if($col.Name -eq '_issues'){$col.Range.ColumnWidth=65}}
  $sheet.Activate();$excelInstance.ActiveWindow.SplitRow=6;$excelInstance.ActiveWindow.FreezePanes=$true
  $book.Save()
 }
 $null=Load-Query 'Profiles' 'Profile' 'ColumnProfiles'
 $positions=[ordered]@{Validity='A6';Histograms='A180';KeyGroups='A390';JoinGroups='A410';AttributionGroups='A420';SystemTypes='A430';CorrelationChartData='A460'}
 foreach($name in $positions.Keys){$null=Load-Query $name 'Prepared summaries' ('Summary_'+$name) $positions[$name]}
 $null=Load-Query 'Pairs' 'Correlations' 'PairStatistics'
 $notes=@(
  @('Purpose','Clean the supplied generated dataset and explore its records using native Excel Power Query, PivotTables and PivotCharts.'),
  @('Source','Five organizer CSVs; canonical copies match data-copy byte for byte. No source file is modified.'),
  @('Rows','All 40,524 records retained, including 40,000 performance records. Repeated IDs are flagged, not arbitrarily deduplicated.'),
  @('Cleaning','Trim outer whitespace, parse explicit types and finite numbers, standardize boolean/code format. Invalid dates and explicitly bounded metric values become blank analysis cells.'),
  @('Traceability','_source_row is the parsed CSV data-record ordinal, excluding the header. _issues records reasons. Follow that ordinal in the unchanged source CSV for original values.'),
  @('Review ranges','ICU occupancy above 100 is withheld from analysis pending capacity-definition confirmation. GDP share, percentage change and excess mortality are not forced into a 0 to 100 domain.'),
  @('Outliers','IQR outliers are reported in Profile and retained. No capping, rescaling, imputation, reassigned IDs or invented dates.'),
  @('Entity joins','No raw dimension merge is performed. _join_status and _attribution_status expose ambiguous or contradictory links without multiplying the fact records.'),
  @('EDA meaning','Distributions and correlations describe eligible file records. Passing a domain rule does not verify clinical meaning, population, country attribution or observation grain.'),
  @('Missing timelines','Calendar fields cannot establish a trusted 2018 to 2024 sequence. Do not infer COVID, recovery or seasonal trends from file order.'),
  @('Correlations','Pairwise complete numeric records after cleaning; coefficients shown only with at least 30 pairs. This is a display threshold, not a statistical sufficiency guarantee or causal claim.'),
  @('Histograms','PivotTable bins use ascending numeric starts. Bins are left-closed and right-open; a declared hard maximum belongs to the final bin.'),
  @('Using pivots','Open PivotTables for native filters and the underlying summaries. Metric dropdowns on histogram PivotCharts change the metric; chart titles follow the selected metric.'),
  @('Refresh','After replacing source files, rerun prepare_excel_eda.py to review the contract, then rebuild/refresh. Source path is pSourceFolder in Power Query.'),
  @('Limits','Country rankings, workforce trends and health investment recommendations require corrected calendar/entity mappings and metric definitions. Brief narratives are hypotheses.'),
  @('Validation','Independent Python comparisons are terminal checks; they never supply production cleaned values or PivotChart calculations.')
 )
 $null=Put-Table 'Read me' 'A5' 'WorkbookGuide' @('Topic','Method and interpretation') $notes
 $guide=$book.Worksheets.Item('Read me');$guide.Columns.Item('A').ColumnWidth=23;$guide.Columns.Item('B').ColumnWidth=118;$guide.Range('A5:B21').Rows.RowHeight=44;$guide.Range('A5:B21').WrapText=$true
 $sourceRows=@();foreach($s in $contract.Sources){$sourceRows+=,@($s.File,[double]$s.Rows,$s.Sha256)}
 $null=Put-Table 'Read me' 'A25' 'SourceManifest' @('File','Records','SHA256') $sourceRows;$guide.Columns.Item('C').ColumnWidth=72
 $book.Worksheets.Item('Profile').Columns.Item('A:D').ColumnWidth=24;$book.Worksheets.Item('Profile').Columns.Item('C').ColumnWidth=56
 $book.Worksheets.Item('Correlations').Columns.Item('D').ColumnWidth=40;$book.Worksheets.Item('Correlations').Columns.Item('G').ColumnWidth=40
 foreach($sheetName in @('EDA','Workforce and structure')){$sheet=$book.Worksheets.Item($sheetName);$sheet.Range('A3:O4').Merge();$sheet.Range('A3').Value2='Exploratory summaries of supplied file records. Invalid/review-required cells are excluded per metric; see Profile for denominators. No verified time or country comparisons.';$sheet.Range('A3:O4').WrapText=$true}
 $book.Worksheets.Item('Read me').Activate();$book.Save();$result.Passed=$true
}catch{$result.Error=$_.Exception.Message;$result.Location=[string]$_.InvocationInfo.PositionMessage;throw}
finally{
 if($null -ne $book){try{$book.Close($false)}catch{}}
 if($null -ne $excelInstance){try{$excelInstance.Quit()}catch{}}
 $result.Finished=[DateTimeOffset]::Now.ToString('o');Save-Progress
 if($null -ne $book){[void][Runtime.InteropServices.Marshal]::ReleaseComObject($book)}
 if($null -ne $excelInstance){[void][Runtime.InteropServices.Marshal]::ReleaseComObject($excelInstance)}
 [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
$result | ConvertTo-Json -Depth 7
