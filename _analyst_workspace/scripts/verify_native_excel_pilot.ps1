[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$pilotFolder = Join-Path $taskRoot '_analyst_workspace\outputs\capability\excel'
$pilotPath = Join-Path $pilotFolder 'native_excel_capability.xlsx'
$verificationPath = Join-Path $pilotFolder 'native_verification.json'
$excelInstance = $null
$workbook = $null
$result = [ordered]@{ method = 'Installed Excel COM API; user explicitly authorized 2026-11-03'; passed = $false; workbook = $pilotPath; checks = @() }

function Assert-Pilot([string]$Name, $Actual, $Expected) {
    $ok = $Actual -eq $Expected
    $script:result.checks += [ordered]@{ check = $Name; actual = $Actual; expected = $Expected; passed = $ok }
    if (-not $ok) { throw "Native Excel verification failed: $Name (actual=$Actual expected=$Expected)" }
}

try {
    if (-not (Test-Path -LiteralPath $pilotPath)) { throw 'Create the artifact-tool base pilot first.' }
    $excelInstance = New-Object -ComObject Excel.Application
    $excelInstance.Visible = $false
    $excelInstance.DisplayAlerts = $false
    $result.excel_version = [string]$excelInstance.Version
    $result.excel_build = [string]$excelInstance.Build
    $result.operating_system = [string]$excelInstance.OperatingSystem
    $workbook = $excelInstance.Workbooks.Open($pilotPath)
    $sourceSheet = $workbook.Worksheets.Item('Pilot Data')
    Assert-Pilot 'Source table records' $sourceSheet.ListObjects.Item('PilotRules').ListRows.Count 7
    if ($workbook.Queries.Count -ne 0) { throw 'Pilot contains native queries already; preserve it and run a read-only/reopen verification instead of rebuilding.' }

    $formula = @'
let
    Source = Excel.CurrentWorkbook(){[Name="PilotRules"]}[Content],
    Typed = Table.TransformColumnTypes(Source, {{"Family", type text}, {"Rule", type text}, {"Failed", Int64.Type}, {"Tested", Int64.Type}}, "en-GB")
in
    Typed
'@
    $query = $workbook.Queries.Add('PilotQuery', $formula, 'Native capability fixture using independently reconciled baseline counts; not final project EDA.')
    $querySheet = $workbook.Worksheets.Add()
    $querySheet.Name = 'Pilot Query'
    $connectionString = 'OLEDB;Provider=Microsoft.Mashup.OleDb.1;Data Source=$Workbook$;Location=PilotQuery;Extended Properties=""'
    $queryTable = $querySheet.ListObjects.Add(3, $connectionString, [Type]::Missing, 1, $querySheet.Range('A1'))
    $queryTable.Name = 'PilotQueryResult'
    $queryTable.QueryTable.CommandType = 2
    $queryTable.QueryTable.CommandText = 'SELECT * FROM [PilotQuery]'
    $queryTable.QueryTable.BackgroundQuery = $false
    $null = $queryTable.QueryTable.Refresh($false)
    Assert-Pilot 'Power Query output records' $queryTable.ListRows.Count 7

    $pivotSheet = $workbook.Worksheets.Add()
    $pivotSheet.Name = 'Pilot Pivot'
    $pivotSheet.Range('A1').Value2 = 'Native Excel capability pilot'
    $pivotSheet.Range('A1').Font.Size = 16
    $pivotSheet.Range('A2').Value2 = 'Totals count rule evaluations across the fixture, not distinct health records.'
    # Version 5 (Excel 2013) supports standalone PivotCharts; omitted defaults to Excel 2007.
    $cache = $workbook.PivotCaches().Create(1, 'PilotQueryResult', 5)
    $pivot = $cache.CreatePivotTable($pivotSheet.Range('A4'), 'PilotByFamily')
    $pivot.PivotFields('Family').Orientation = 1
    $null = $pivot.AddDataField($pivot.PivotFields('Failed'), 'Failed evaluations', -4157)
    $null = $pivot.AddDataField($pivot.PivotFields('Tested'), 'Tested evaluations', -4157)
    $pivot.DataBodyRange.NumberFormat = '#,##0'
    $null = $pivot.RefreshTable()
    Assert-Pilot 'PivotTable baseline failed evaluations' $pivot.GetPivotData('Failed evaluations').Value2 76468

    # Create the chart from the selected native PivotTable; verify PivotLayout rather than assuming.
    $pivotSheet.Activate()
    $null = $pivot.TableRange1.Select()
    $chartShape = $pivotSheet.Shapes.AddChart2(201, 51, 410, 35, 640, 330)
    $chart = $chartShape.Chart
    $chart.SetSourceData($pivot.TableRange1)
    $chartPivot = $chart.PivotLayout.PivotTable
    $chart.HasTitle = $true
    $chart.ChartTitle.Text = 'Rule evaluations by family (capability fixture)'
    $chart.HasLegend = $true
    Assert-Pilot 'Chart has a native PivotLayout' ($null -ne $chart.PivotLayout) $true

    # Edit a disposable fixture input, test the whole query/pivot chain, then restore.
    $original = $sourceSheet.Range('C8').Value2
    $sourceSheet.Range('C8').Value2 = [double]($original - 1)
    $null = $queryTable.QueryTable.Refresh($false)
    $null = $cache.Refresh()
    $null = $pivot.RefreshTable()
    Assert-Pilot 'Query/pivot reacts to changed fixture input' $pivot.GetPivotData('Failed evaluations').Value2 76467
    $sourceSheet.Range('C8').Value2 = [double]$original
    $null = $queryTable.QueryTable.Refresh($false)
    $null = $cache.Refresh()
    $null = $pivot.RefreshTable()
    $null = $chartPivot.PivotCache().Refresh()
    $null = $chartPivot.RefreshTable()
    Assert-Pilot 'Original fixture input restored' $pivot.GetPivotData('Failed evaluations').Value2 76468
    $querySheet.Columns.Item('A:D').AutoFit() | Out-Null
    $pivotSheet.Columns.Item('A:C').AutoFit() | Out-Null
    $pivotSheet.Activate()
    $workbook.Save()
    $exported = $chart.Export((Join-Path $pilotFolder 'native_pivot_chart.png'), 'PNG')
    Assert-Pilot 'Native PivotChart PNG export' $exported $true
    $workbook.Close($false)
    $workbook = $null

    $workbook = $excelInstance.Workbooks.Open($pilotPath)
    Assert-Pilot 'Power Query survives reopen' $workbook.Queries.Count 1
    $reopenedQuery = $workbook.Worksheets.Item('Pilot Query').ListObjects.Item('PilotQueryResult')
    $null = $reopenedQuery.QueryTable.Refresh($false)
    Assert-Pilot 'Reopened query refresh records' $reopenedQuery.ListRows.Count 7
    $reopenedPivot = $workbook.Worksheets.Item('Pilot Pivot').PivotTables('PilotByFamily')
    $null = $reopenedPivot.PivotCache().Refresh()
    $null = $reopenedPivot.RefreshTable()
    Assert-Pilot 'Reopened PivotTable result' $reopenedPivot.GetPivotData('Failed evaluations').Value2 76468
    $reopenedChart = $workbook.Worksheets.Item('Pilot Pivot').ChartObjects(1).Chart
    Assert-Pilot 'Native PivotChart survives reopen' ($null -ne $reopenedChart.PivotLayout) $true
    $workbook.Save()
    $result.passed = $true
    $result.native_pivot_chart_name = [string]$reopenedChart.PivotLayout.PivotTable.Name
}
catch {
    $result.error = $_.Exception.Message
    $result.failure_location = [string]$_.InvocationInfo.PositionMessage
    throw
}
finally {
    if ($null -ne $workbook) { try { $workbook.Close($false) } catch {} }
    if ($null -ne $excelInstance) { try { $excelInstance.Quit() } catch {} }
    $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $verificationPath -Encoding utf8NoBOM
    if ($null -ne $workbook) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($workbook) }
    if ($null -ne $excelInstance) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($excelInstance) }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
$result | ConvertTo-Json -Depth 8
