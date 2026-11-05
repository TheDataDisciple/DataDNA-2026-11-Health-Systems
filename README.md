# DataDNA Health System Performance

The current deliverable is native Excel cleaning and exploratory analysis of the five November 2026 organizer CSVs. The superseded audit dashboard and bulk rule pipeline were removed at the user's request.

Local workbook: `Data Source/In Progress/Health_System_Cleaning_EDA.xlsx`. Start at **Read me**, then **EDA**, **Workforce and structure**, or the linked **PivotTables** guide. It contains refreshable Power Query cleaning, five prepared tables, 65 field profiles, seven genuine PivotTables and seven linked PivotCharts. Five provisional CSV exports are in `Data Source/In Progress/Cleaned/`.

All 40,524 source records are retained. Invalid or review-required cells are blank in analysis columns with reasons and source-row lineage. Repeated IDs are flagged; differing records are not arbitrarily deduplicated. Original CSVs are unchanged.

Spending/waiting correlations are near zero in these records. Invalid calendar attributes and conflicting entity links prevent verified geographic or temporal findings. Numeric domain checks do not establish clinical validity. The brief's proposed patterns remain hypotheses.

Read [Findings](Documentation/CLEANING_AND_EDA_FINDINGS.md), [Reproduction](Documentation/REPRODUCTION_GUIDE.md), [Current status](Documentation/PROJECT_STATUS.md), [Technical specification](Documentation/PROJECT_TECHNICAL_SPEC.md), and [Folder structure](Documentation/PROJECT_STRUCTURE.md).

Obtain the organizer package separately. Keep canonical raw CSVs in `Data Source/Original/` and preserve the complete package; its data-copy files are reference duplicates. Prepared data remains in **In Progress** until calendar, grain, metric definitions and attribution are resolved. **Ready To Work** is reserved for validated later Power BI inputs. **Dashboard** retains the original empty PBIP seed and assets.

Public commits contain original scripts and maintained documentation. Raw data, workbooks, generated evidence, caches and the private Notion registry stay local. External contest submission has not been performed. The MIT license covers original contributions, not organizer materials.
