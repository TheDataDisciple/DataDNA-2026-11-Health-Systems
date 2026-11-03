# Analyst working area

Keep assistant-created working material here, separate from Power BI files and source data.

- `scripts/`: reproducible analysis and validation code.
- `notes/`: provisional findings, assumptions and decision notes.
- `outputs/<task_name>/`: generated evidence, logs and draft exports.

Maintained project documentation belongs in `Documentation/`. Provisional transformed data belongs in `Data Source/In Progress/`; validated Power BI inputs belong in `Data Source/Ready To Work/`.

Reproduce the initial full-file review from the project root:

```powershell
python '.\_analyst_workspace\scripts\profile_sources.py' --review-date 2026-11-02
python '.\_analyst_workspace\scripts\verify_profile.py'
```

The scripts use the Python standard library and leave source files unchanged. Review results are in `outputs/initial_review/`. `verification.json` records independent SQLite reconciliation and source-hash checks. Verification passes mean the review's counts reconcile; they do not mean the source data passes its quality checks.

## Excel working copies

`scripts/prepare_excel_working_copies.mjs` converts one table per invocation to `Data Source/In Progress/<table>.xlsx` using the bundled `@oai/artifact-tool` runtime. Pass the table's base filename, for example `dim_country`; existing workbooks are preserved unless `--replace` is explicitly supplied. Use a fresh Node process per table. The local `node_modules` junction points to the bundled dependencies and contains no project-authored code.

`scripts/review_excel_working_copies.py --review` reproduces the full-file quality assessment in `outputs/data_preparation/`, preserving the initial review. Its `--verify` mode independently opens every XLSX archive and reconciles every cell, the table/filter definitions, row banding, frozen panes, explicit numeric formats and original-file hashes.

Read `outputs/data_preparation/DATA_IMPROVEMENT_REVIEW.md` before using the workbooks for findings. The issue register is a review snapshot with representative source-record references; it does not automatically update after manual Excel edits. Numeric conversion uses 15 significant digits for Excel and records precision changes. No business-value correction or promotion to `Ready To Work/` is included.
