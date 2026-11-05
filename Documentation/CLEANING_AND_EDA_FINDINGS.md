# Cleaning and exploratory analysis findings

Completed 5 November 2026 in native Excel. The workbook and provisional CSVs are ready for exploration. The supplied data cannot substantiate the brief's proposed health-system trends or rankings.

## Sources and preservation

All five user-supplied paths match canonical Original CSVs byte for byte. Power Query reads only canonical copies. All 40,524 records are retained:

| Table | Records | Distinct declared keys | Records belonging to repeated keys |
|---|---:|---:|---:|
| Country | 56 | 54 | 4 |
| Calendar | 28 | 27 | 2 |
| Health system | 220 | 197 | 44 |
| Workforce | 220 | 193 | 51 |
| Performance | 40,000 | 1,001 | 40,000 |

Repeated-key membership includes the first occurrence. Repeated IDs do not prove complete duplicate observations; the intended grain needs clarification.

## Cleaning decisions

- Trim outer whitespace, parse finite numbers and explicit booleans, and uppercase ISO3 format. Format validity does not verify the country mapping.
- Preserve IDs and records. Add source-row, key and exception flags. Diagnose parent ambiguity without multiplying fact records through dimension joins.
- Withhold invalid dates/types and values outside explicit proportion, score or hours domains as blank analysis cells with reasons. Raw values remain in original CSVs.
- Review ICU occupancy above 100 pending capacity definition. Do not impose a 100 ceiling on GDP share or percentage-change fields. Allow negative excess mortality and surge changes.
- Retain IQR outliers. Do not assume percentage scale factors, cap, impute, invent dates or choose arbitrary duplicate survivors.

Exact rules are in embedded Power Query metadata and maintained sources. They establish analysis eligibility, not clinical or entity validity.

## Exploratory results

Seven genuine PivotTables and linked PivotCharts cover waiting-time distributions, spending, workforce, eligibility, supplied system types, repeated-key structure and correlations. Histogram filters change native chart data and metric/unit titles; distributions show eligible n. The PivotTables guide links directly to native tables.

Waiting and spending histograms are broadly flat across supplied approximately 0–1,000 ranges. Medians are 500.81 minutes for A&E wait, 498.81 weeks for elective wait and USD 501.54 per person for spending, each with 40,000 eligible records. These are file summaries, not estimates for real health systems.

| Field | Eligible | Source records | Withheld |
|---|---:|---:|---:|
| A&E four-hour target | 4,005 | 40,000 | 35,995 outside 0–100 |
| Hospital mortality percentage | 4,025 | 40,000 | 35,975 outside 0–100 |
| 30-day readmission percentage | 3,963 | 40,000 | 36,037 outside 0–100 |
| ICU occupancy | 4,042 | 40,000 | 35,958 need capacity-definition review |
| Workforce vacancy | 23 | 220 | 197 outside 0–100 |
| Workforce burnout | 28 | 220 | 192 outside 0–100 |
| Staff satisfaction | 2 | 220 | 218 outside 1–10 |
| Year, quarter and quarter label | 0 each | 28 | 28 invalid in each field |

Surviving bounded values do not represent the excluded population.

### Associations

Pairwise complete cleaned records, without dimension joins:

| Pair | Eligible pairs | Pearson r |
|---|---:|---:|
| Spending vs A&E wait | 40,000 | 0.002959 |
| Spending vs elective wait | 40,000 | 0.006183 |
| ICU occupancy vs A&E target | 396 | -0.003269 |
| Hospital mortality vs readmissions | 417 | -0.057690 |
| Vacancy vs burnout | 4 | Withheld |
| Burnout vs staff satisfaction | 0 | Withheld |

The four displayed coefficients show little linear association in eligible file records. Coefficients below 30 pairs are withheld as a display rule, not a statistical sufficiency guarantee. Unknown grain, repeated IDs and selective exclusions limit interpretation. No causal, national or population inference follows. The brief's proposed vacancy/burnout r=0.81 is not established.

### Structure and attribution

The system-type chart counts 220 master records across 12 supplied types, not verified unique entities.

29,000 performance records have one direct parent in every dimension; 11,000 have at least one ambiguous parent. Comparing performance country with its single system's country and performance system with its single workforce record's system gives 31,280 Conflict, 8,716 Not testable and 4 Agrees. This conditional check does not certify four health observations or resolve country/date conflicts.

## Best way to continue

Use this workbook for source-level distributions, exceptions and hypothesis checks. Keep tables separate and CSVs provisional in **In Progress**. Geographic rankings, pandemic/recovery timelines and investment recommendations need corrected mappings first.

Obtain an authoritative date-key-to-quarter map, unique dimension definitions, the performance observation grain, consistent country/system/workforce links and confirmed percentage/score units. Cleaning cannot supply these missing source facts. Then rerun the native pipeline and verification before the Power BI business report.

## Verification and artifacts

- Workbook: `Data Source/In Progress/Health_System_Cleaning_EDA.xlsx`.
- Five CSVs: `Data Source/In Progress/Cleaned/`.
- Independent verification: 1,177 checks passed, comparing all 1,367,308 prepared values and flags, profiles, eligibility counts, bins, groups and correlations.
- Native checks passed for PivotLayouts, seven charts, filters/titles, save/reopen and original hashes. Cell-error scan found none.
- Local evidence: `_analyst_workspace/outputs/excel_cleaning_eda/`, including native summaries, chart exports, sheet views and receipts.
- Removal receipts: `_analyst_workspace/outputs/project_cleanup/`; 57 superseded targets removed with original data and user work protected.

Technical reconciliation does not validate health-system meaning. No external contest submission has been made.
