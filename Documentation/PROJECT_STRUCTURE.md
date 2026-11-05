# Project folder structure

Updated 5 November 2026. The agreed top-level structure remains unchanged.

| Location | Current purpose |
|---|---|
| `Data Source/Original/` | Canonical five raw CSVs, preserved byte for byte |
| `Data Source/In Progress/Health_System_Cleaning_EDA.xlsx` | Current native Excel cleaning and EDA deliverable |
| `Data Source/In Progress/Cleaned/` | Five provisional prepared CSVs with lineage and exception flags |
| `Data Source/Ready To Work/` | Reserved for validated later Power BI inputs; currently empty |
| `DataDNA Dataset Challenge - 2026- 11 - Health System Performance/` | Complete organizer package; data-copy contains reference duplicates |
| `Dashboard/` | Original empty PBIP seed with paired report/model folders and original assets |
| `Documentation/` | Maintained specification, status, findings, reproduction guide, decisions and historical winner research |
| `Exports/` | Finished shareable report exports; no contest submission produced |
| `_analyst_workspace/scripts/` | Analysis scripts, Power Query source and retained preparation scripts |
| `_analyst_workspace/outputs/excel_cleaning_eda/` | Local contract, expectations, native summaries, previews and verification receipts |
| `_analyst_workspace/outputs/project_cleanup/` | Removal manifest, receipts and one-time cleanup scripts |
| `_analyst_workspace/outputs/initial_review/` | Preserved initial full-file review |
| `_analyst_workspace/notes/` | Working notes and private Notion registry |

Keep source flow `Original -> In Progress -> Ready To Work`. Prepared tables have not been certified for health-system benchmarking. Do not double-load reference duplicates or silently infer dates, entity mappings, percentage scales or duplicate survivors.

Keep PBIP files together with their report and semantic-model folders. Assistant logs, calculations, intermediate outputs and draft previews belong in the analyst workspace. Raw data, data-bearing binaries, generated evidence, caches and private registries are excluded from public commits.

The former audit model/report, bulk releases, audit workbook, duplicate rebuilds and obsolete implementation scripts were removed on 5 November at the user's request. Historical blueprint and decision records remain as explicitly superseded context, not current dependencies.
