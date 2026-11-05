# Excel cleaning and exploratory analysis specification

Updated 5 November 2026. The user replaced the audit-dashboard approach with a focused Excel cleaning and EDA task. This specification supersedes the former readiness-report implementation contract; Git history retains the earlier document.

## Deliverables

- One native Excel workbook, `Data Source/In Progress/Health_System_Cleaning_EDA.xlsx`, containing refreshable Power Query cleaning, five prepared source tables, column profiles, actual PivotTables and actual PivotCharts.
- Five prepared CSVs beside the workbook in `Data Source/In Progress/Cleaned/`, with source-row lineage and explicit exception flags. These are provisional analysis inputs; they are not a certified health-performance star schema.
- A concise cleaning and EDA findings document, reproducible original scripts, independently reconciled native results, and updated Notion/GitHub project records.
- Remove the superseded assistant-built audit model, report, bulk rule exports, duplicate rebuilds and obsolete implementation scripts. Preserve original sources, the complete supplied package, pre-existing user work and the original empty PBIP seed. Do not create a replacement audit dashboard.

## Source and cleaning decisions

The five explicitly supplied data-copy CSVs match the canonical `Data Source/Original/` files byte for byte. Native Power Query reads the canonical copies once per source; it does not combine reference duplicates. Preserve every source record and original identifier. `_source_row` identifies its parsed CSV data-record ordinal.

Trim surrounding text, parse finite numeric values with en-GB culture, standardize explicit booleans and ISO3 code casing. Keep original values in the immutable CSVs. Invalid calendar attributes, invalid types, and values outside explicit proportion/score/hour domains become blank analysis cells with field-specific reasons in `_issues`. Do not infer calendar quarters from row order, substitute country attributes, divide percentages by an assumed factor, cap, impute, or deduplicate differing records.

ICU occupancy above 100 is withheld from analysis pending capacity-definition confirmation and counted separately as Review. GDP share, percentage changes and excess mortality do not receive an assumed 0–100 bound. IQR outliers are reported and retained. A domain-valid cell is not proof of clinical meaning or correct entity attribution.

Retain repeated dimension and fact identifiers with flags. Derive parent-count and attribution diagnostics without joining duplicate raw dimensions into the fact table. No join may multiply the 40,000 performance records.

## EDA in Excel

Use separate source scopes and explicit denominators. Native PivotCharts cover waiting-time and spending distributions, workforce distributions, supplied system-type composition, metric eligibility, repeated-key structure and row-level correlations. Histograms have numeric ascending bins and metric/unit labels. Metric selectors must change both chart values and titles.

Correlations use pairwise complete cleaned numeric records. Display coefficients only with at least 30 eligible pairs, show pair counts and describe them as exploratory file-level associations. This threshold is a display rule, not a claim of statistical sufficiency. Do not treat association as causality.

The invalid calendar cannot establish COVID, recovery or seasonal trends. Conflicting country/system/workforce attributes prevent verified geographic rankings. The Challenge Brief's suggested numerical patterns remain hypotheses. Continue useful distributional and structural EDA without inventing these missing facts.

Borrow concise explanations, consistent formatting, visible units, zero-based count axes and traceable takeaways from the winner review. Its former three-page readiness design is historical and no longer directs implementation.

## Acceptance

Verify source hashes; preserve all five row populations; compare every prepared cell and exception flag to an independent evaluator; reconcile profiles, histogram totals and pair counts. Verify native queries, genuine PivotLayouts/PivotCharts and chart filter changes after save/reopen. Inspect every final chart export and meaningful workbook view. Keep independent checks terminal: they cannot feed production cleaning or displayed summaries.

Use owned Excel instances only. Do not attach to or close unrelated user workbooks. Keep scripts and intermediate evidence under the analyst workspace. Retain project structure, local-data exclusions, and clear separate statuses for delivery, analytical support, synchronization and external submission. Power BI business-report development resumes only after the EDA establishes defensible content.
