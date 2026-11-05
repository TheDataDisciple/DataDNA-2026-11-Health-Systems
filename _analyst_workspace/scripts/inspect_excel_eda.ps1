[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$taskRoot=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$output=Join-Path $taskRoot '_analyst_workspace/outputs/excel_cleaning_eda'
$images=Join-Path $output 'sheets';$null=New-Item -ItemType Directory -Path $images -Force
$result=[ordered]@{Passed=$false;FormulaErrors=@();Views=@()};$app=$null;$book=$null
try{
 $app=New-Object -ComObject Excel.Application;$app.Visible=$false;$app.DisplayAlerts=$false;$app.ScreenUpdating=$true
 $book=$app.Workbooks.Open((Join-Path $taskRoot 'Data Source/In Progress/Health_System_Cleaning_EDA.xlsx'))
 foreach($sheet in $book.Worksheets){
  foreach($type in @(-4123,2)){
   $errors=$null;try{$errors=$sheet.UsedRange.SpecialCells($type,16)}catch{if($_.Exception.Message -notmatch 'No cells|0x800A03EC|1004'){throw}}
   if($null -ne $errors){$result.FormulaErrors+=($sheet.Name+'!'+$errors.Address())}
  }
 }
 if($result.FormulaErrors.Count){throw 'Unexpected native Excel cell errors.'}
 $views=@(
  @('Read me','A1:B21','Readme'),@('Read me','A24:B33','Navigation'),
  @('EDA','T4:U17','PivotSample'),@('Workforce and structure','T244:W253','KeyPivot'),
  @('PivotTables','A1:D13','PivotGuide'),@('Profile','A1:E18','Profile'),@('Profile','F6:P18','ProfileStats'),@('Profile','A77:C83','SourceHashes'),
  @('Correlations','A1:G12','Correlations'),@('Prepared summaries','A176:D193','PreparedSummary'),
  @('Clean country','A1:H14','Country'),@('Clean calendar','A1:K14','Calendar'),@('Clean systems','A1:H14','Systems'),
  @('Clean workforce','A1:H14','Workforce'),@('Clean performance','A1:H14','Performance'),@('Clean performance','AC6:AH14','IssueFlags'))
 foreach($view in $views){
  $sheet=$book.Worksheets.Item($view[0]);$sheet.Activate();$app.ActiveWindow.DisplayGridlines=$false;$app.ActiveWindow.Zoom=100
  $range=$sheet.Range($view[1]);$null=$range.Select();$range.CopyPicture(1,-4147)
  # An empty selection prevents Excel from auto-plotting the selected PivotTable behind the pasted picture.
  $null=$sheet.Range('AZ1').Select()
  $temporary=$sheet.ChartObjects().Add(0,0,$range.Width,$range.Height)
  try{$null=$temporary.Activate();$temporary.Chart.Paste();$path=Join-Path $images ($view[2]+'.png');$ok=$temporary.Chart.Export($path,'PNG');if(-not $ok -or (Get-Item -LiteralPath $path).Length -lt 1000){throw ('Empty native view: '+$view[2])};$result.Views+=,[ordered]@{Sheet=$view[0];Range=$view[1];Path=$path}}finally{$temporary.Delete()}
 }
 $result.Passed=$true
}catch{$result.Error=$_.Exception.Message;$result.Location=[string]$_.InvocationInfo.PositionMessage;throw}
finally{
 if($null -ne $book){$book.Close($false)};if($null -ne $app){$app.Quit()}
 $result | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $output 'native_views.json') -Encoding utf8NoBOM
 if($null -ne $book){[void][Runtime.InteropServices.Marshal]::ReleaseComObject($book)};if($null -ne $app){[void][Runtime.InteropServices.Marshal]::ReleaseComObject($app)}
 [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
$result | ConvertTo-Json -Depth 6
