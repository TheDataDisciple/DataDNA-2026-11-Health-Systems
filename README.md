# DataDNA — Health System Performance

Power BI project for the November 2026 DataDNA challenge, exploring UK and global health system performance.

## Data quality and provenance

> The organizer-supplied CSV files contain data-quality errors identified during the initial full-file review: repeated primary keys, invalid calendar attributes, and values outside documented metric ranges. These issues exist in the supplied files. Raw inputs are preserved unchanged, and health-system comparisons remain unvalidated.

The initial review was completed on 2 November 2026. The challenge brief's suggested insights are hypotheses, not findings established by the supplied CSVs. Corrections or exclusions must be documented with supporting evidence and must preserve the original files. Dates, identifiers, and metric scales must not be silently repaired.

The detailed review is currently a local working file at `_analyst_workspace/outputs/initial_review/DATA_REVIEW.md`; it is not included in this setup commit.

## Purpose and current status

The project is implementing a Health System Evidence Readiness report in Power BI, supported by native Excel preparation, validation and PivotTable/PivotChart EDA. The final presentation is one readable dashboard image, with a working native report behind it. Health-system comparisons and trends remain unsupported until their source requirements are resolved.

Implementation is governed by the [technical specification](Documentation/PROJECT_TECHNICAL_SPEC.md), [current status and resume record](Documentation/PROJECT_STATUS.md), [winner review and health blueprint](Documentation/WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md), and [decision log](Documentation/DECISION_LOG.md). These records distinguish technical delivery, analytical support, documentation synchronization and external submission.

## Workflow

`Original → In Progress → Ready To Work → Power BI → Exports`

1. Preserve the organizer's CSVs in `Data Source/Original/` and review their quality before analysis.
2. Create provisional transformations in `Data Source/In Progress/`, recording their inputs, changes, and limitations.
3. Promote validated Power BI inputs to `Data Source/Ready To Work/`.
4. Build the Power BI project in `Dashboard/`, keeping the `.pbip` file with its report and semantic-model folders.
5. Publish finished report images and submission materials in `Exports/`.

Load only the canonical CSVs, not the reference duplicates in the supplied package's `data-copy/` folder. Source data and the organizer's package are kept locally and are not distributed in this repository. Obtain the supplied files from the challenge organizer before reproducing the analysis.

## Project layout

The local folder map and file-placement rules are in [Project structure](Documentation/PROJECT_STRUCTURE.md). Source data, generated evidence and data-bearing binaries remain local. Original implementation code, maintained documentation and Power BI project definitions are eligible for deliberate inclusion.

| Folder | Purpose |
|---|---|
| `Dashboard/` | Power BI project files and visual assets |
| `Data Source/` | Original data, transformations in progress and validated Power BI inputs |
| `Documentation/` | Maintained project documentation |
| `Exports/` | Finished images and submission files |
| `_analyst_workspace/` | Assistant scripts, exploratory notes and intermediate results |
| `DataDNA Dataset Challenge - 2026- 11 - Health System Performance/` | Preserved supplied reference package |

## License

Original project contributions are licensed under the [MIT License](LICENSE), copyright 2026 Dmytro Klymchuk.

The organizer-supplied datasets, challenge brief, dictionaries, schemas, validation files, and other third-party materials are explicitly excluded from this license. Their rights and any applicable terms remain with their respective owners; this repository does not grant permission to redistribute or relicense them.
