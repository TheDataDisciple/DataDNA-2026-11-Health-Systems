# Project folder structure

Agreed on 2 November 2026. This scheme organizes files; it is not a data-model design. The local project folder name stays unchanged; the GitHub repository is named `DataDNA-2026-11-Health-Systems`.

```text
DataDNA-Dataset-Challenge-2026-11-Health-System-Performance/
│
├── README.md                         Project entry point
├── LICENSE                           MIT license for original contributions
├── .gitignore                        Local data, outputs, secrets and caches
├── AGENTS.md                         Working conventions for the assistant
│
├── Dashboard/                        Power BI deliverables
│   ├── Assets/                       Report themes, icons and backgrounds
│   └── [Power BI project files]      Create here when report work begins
│
├── Data Source/
│   ├── Original/                     Canonical raw CSVs; preserve unchanged
│   │   ├── dim_country.csv
│   │   ├── dim_date.csv
│   │   ├── dim_health_system.csv
│   │   ├── dim_workforce.csv
│   │   └── fact_health_performance.csv
│   ├── In Progress/                  Provisional preparation and EDA work
│   └── Ready To Work/                Complete versioned audit releases when built
│
├── DataDNA Dataset Challenge - 2026- 11 - Health System Performance/
│   ├── CHALLENGE_BRIEF.md             Preserved supplied reference package
│   ├── data-copy/                    Reference duplicates of Original CSVs
│   └── docs/                         Supplied dictionary, schema and validation
│
├── Documentation/
│   ├── PROJECT_STRUCTURE.md          This folder map and placement rules
│   ├── PROJECT_TECHNICAL_SPEC.md     Approved v1.1 implementation contract
│   ├── PROJECT_STATUS.md             Verified checkpoint and next executable action
│   ├── DECISION_LOG.md               Implementation choices and blueprint deviations
│   └── WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md  Winner lessons and readiness blueprint
│
├── Exports/
│   ├── Images/                       Finished dashboard screenshots
│   └── Submission/                   Final entry materials
│
└── _analyst_workspace/               Assistant working area
    ├── README.md                     How to use and reproduce working files
    ├── scripts/                      Python, PowerShell and SQL scripts
    ├── notes/                        Investigation notes and decision records
    └── outputs/
        ├── initial_review/           Initial source profiling and verification evidence
        ├── data_preparation/         Excel conversion, quality review and verification
        └── winner_review/            Reference images, provenance and readiness reconciliation
```

On 3 November, the user created `Health System Perfomance Dashboard.pbip` with its matching `.Report` and `.SemanticModel` folders in `Dashboard/`. Preserve that active project's supplied filename and keep its components together.

Canonical Original copies have now been restored and hash-verified. Existing CSVs directly under `Data Source/` are preserved legacy copies; do not load them as additional inputs. Earlier conversion evidence describes five per-table Excel workbooks, but those workbook artifacts were absent at implementation startup. `In Progress/` and `Ready To Work/` are currently empty; native workbook and audit-release creation remain pending.

Versioned audit releases will use `Data Source/Ready To Work/<release_id>/` and include a complete manifest. Promotion validates the audit inputs and their lineage; it does not certify the source health observations. Prepared-stage results must be labelled separately from raw-snapshot diagnostics.

## GitHub publication

The initial setup commit includes exactly `README.md`, `LICENSE`, `.gitignore`, and `Documentation/PROJECT_STRUCTURE.md`. The other files and folders shown above describe the local workspace; existing scripts, working notes, data, and assistant instructions are not part of that commit. Git does not publish empty folders.

Source data, the organizer's supplied package, generated working outputs, credentials, temporary files, and Power BI local caches are excluded through `.gitignore`. Original scripts and Power BI project definitions remain eligible for deliberate inclusion in future commits. The MIT license applies to original project contributions only and explicitly excludes organizer-supplied data and materials, as stated in the README.

The initial full-file review found errors in the organizer-supplied CSVs. Preserve the raw inputs unchanged; document evidence for every derived correction or exclusion. The brief's suggested insights remain hypotheses until supported by validated inputs.

## Where new files belong

| File | Location |
|---|---|
| `.pbip` / `.pbix` and generated Power BI project folders | `Dashboard/` |
| Theme JSON, SVG icons, backgrounds used by the report | `Dashboard/Assets/` |
| Original organizer CSVs | `Data Source/Original/` |
| Excel working copies (`.xlsx`); provisional transformed data | `Data Source/In Progress/` |
| Validated tables that will actually feed Power BI | `Data Source/Ready To Work/` |
| Supplied briefs, dictionaries and schemas | The preserved supplied package at the project root |
| Agreed KPI definitions, model notes and project decisions | `Documentation/` |
| Scripts, experiments, provisional measures and analysis notes | `_analyst_workspace/scripts/` or `_analyst_workspace/notes/` |
| Profiling tables, logs and draft screenshots | `_analyst_workspace/outputs/<task_name>/` |
| Finished screenshots | `Exports/Images/` |
| Final submission image and accompanying entry text | `Exports/Submission/` |

## Rules that keep the project steady

1. Keep existing source and Power BI paths stable. Use a Power Query folder parameter when the report is built.
2. Preserve raw data. Build transformations with a reproducible script or Power Query, and document any exclusion or correction.
3. Load one canonical copy of each table. The package's `data-copy/` files are preserved for provenance, not additional model inputs.
4. Keep a `.pbip` file beside its generated `.Report` and `.SemanticModel` folders. Avoid moving those components independently.
5. Use descriptive working filenames, such as `profile_sources.py` and `quarter_validation.csv`. Group outputs by task rather than leaving them in the root.
6. Use date suffixes only for snapshots or finished exports, for example `health_system_overview_2026-11-20.png`. Keep one clearly identified active Power BI project.
7. Promote only maintained conclusions into `Documentation/` and finished deliverables into `Exports/`. Keep exploratory material in `_analyst_workspace/`.

The data flow is **Original → In Progress → Ready To Work → Power BI → Exports**. Promotion creates or updates a derived file in the next stage; it never removes the raw original. Transformation scripts stay in `_analyst_workspace/scripts/`, even when their data outputs belong in a staging folder.

## Initial organization performed

- Kept the five raw CSVs at their original paths under `Data Source/Original/`.
- Preserved the supplied `DataDNA Dataset Challenge - 2026- 11 - Health System Performance` folder in its current location. Windows reported that another process was using the directory when relocation was attempted; the folder remains available as the reference package.
- Kept the source-review scripts and evidence together under `_analyst_workspace/`.
- Retained your existing `In Progress/` and `Ready To Work/` folders, and created destinations for Power BI assets and finished exports.

The local relocation record is at `_analyst_workspace/outputs/folder_organization.json`. The initial source review is at `_analyst_workspace/outputs/initial_review/DATA_REVIEW.md`. These working evidence files are not published in the initial commit.

The Excel preparation review is at `_analyst_workspace/outputs/data_preparation/DATA_IMPROVEMENT_REVIEW.md`. That folder also holds the issue register, conversion manifests, preview images and independent verification. The converter and reviewer stay under `_analyst_workspace/scripts/`; no assistant logs or intermediate files belong in `In Progress/`.

## Winner review and observed source locations — 3 November 2026

The maintained winner comparison and three-page Power BI readiness specification are in `Documentation/WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md`. Research notes are in `_analyst_workspace/notes/winner_review_research.md`; reference images and hash/count verification are in `_analyst_workspace/outputs/winner_review/`. Reproduce this task's local evidence check with `_analyst_workspace/scripts/verify_winner_review_evidence.py`.

The folder map above remains the agreed target structure. At this review, the five raw CSVs were found directly under `Data Source/`; their documented `Data Source/Original/` paths were absent. Their hashes exactly match the initial review and the preserved package copies. The discrepancy is recorded in `winner_review/local_evidence_verification.json`; this review did not move the files, change their contents, or approve a structural migration. Resolve the source-location discrepancy before configuring a Power BI refresh.
