# Reproduce the native Excel analysis

Use Windows, 64-bit Excel with Power Query, PowerShell 7 and Python 3 standard library. Verified with Excel 16.0 build 20527. Native Excel automation creates the queries, tables, PivotTables and PivotCharts. No library round-trip replaces native features.

Run from the project root:

1. Obtain the complete organizer package separately. Put its five matching CSVs in `Data Source/Original/`; preserve the package and raw bytes.
2. Run `python _analyst_workspace/scripts/prepare_excel_eda.py`. It writes the contract and independent expectations in `outputs/excel_cleaning_eda/`. Review source/schema changes first.
3. Run `pwsh -NoProfile -File _analyst_workspace/scripts/build_excel_cleaning_eda.ps1`. Append `-Resume` only for the matching existing workbook. Native Power Query performs production cleaning and aggregation. A full refresh takes several minutes.
4. Run `pwsh -NoProfile -File _analyst_workspace/scripts/finish_excel_eda.ps1`. It creates/updates seven native PivotTables and charts, tests filters/titles, saves/reopens and exports prepared CSVs and native summaries.
5. Run `python _analyst_workspace/scripts/verify_excel_eda.py`. It independently compares every prepared cell and flag, profiles, eligibility counts, bins, groups and correlations with the unchanged raw files.
6. Run `pwsh -NoProfile -File _analyst_workspace/scripts/inspect_excel_eda.ps1`. It checks native cell errors and captures workbook views. Visually inspect `outputs/excel_cleaning_eda/sheets/` and `charts/`. PNG export alone is not visual verification.

The workbook is `Data Source/In Progress/Health_System_Cleaning_EDA.xlsx`; CSVs are in `In Progress/Cleaned/`. Receipts are `native_build.json`, `native_eda.json`, `native_views.json` and `verification.json`. Independent expectations never feed production queries or displayed values.

Power Query's `pSourceFolder` points to canonical originals; compact metadata is embedded. The M source is `scripts/powerquery/ExcelCleaningEDA.m`. Keep paths below 260 characters. Changed schema/counts fail the contract check. After source replacement, review the regenerated contract, rebuild with `-Resume` and repeat all following steps; previous findings no longer apply automatically.

For unchanged sources, Excel **Data > Refresh All** refreshes native queries and pivots. Run the finish step afterward to refresh/export controlled results consistently. Full source scans can take minutes.

Cleaning retains records and IDs. Blanks identify invalid, missing or review-required inputs through flags and Profile. IQR outliers remain. No unsupported date reconstruction, scale conversion or entity deduplication occurs. `_source_row` is the one-based parsed CSV data-record ordinal, excluding the header. Select an issue cell and expand Excel's formula bar for full text.

Keep raw data, workbooks, generated evidence, caches, credentials and the private registry local. One-time removal scripts are retained with local cleanup receipts. External posting/submission is separate from Excel delivery.
