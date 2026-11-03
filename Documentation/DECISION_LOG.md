# Implementation decisions

## D-001 — Approved specification and progress ownership

Date: 3 November 2026. Source: user-approved Technical Specification v1.1.

The technical specification owns required behaviour and acceptance criteria. `PROJECT_STATUS.md` owns current progress and verified evidence. The winner blueprint remains the main analytical and design reference. Future sessions must load all three records before continuing.

## D-002 — Preserve current raw locations during canonical restoration

Date: 3 November 2026. Specification: sections 5.1 and 5.2.

Copy the five matching CSVs into the documented Original stage; verify byte hashes and preserve both the current root CSVs and organizer package. Load only the canonical copies. Historical evidence remains unchanged; new verification outputs receive a separate destination.

## D-003 — Initial report scope

Date: 3 November 2026. Blueprint: sections 6–8.

Deliver the evidence-readiness report using the supplied snapshot. Do not fabricate country attribution, date mappings, metric corrections, or historical workforce observations. Technical report completion does not establish health-benchmarking readiness.

## D-004 — Native Excel automation API authorized

Date: 3 November 2026. User explicitly selected "Use native Excel API (Recommended)" after the UI control runtime repeatedly rejected Excel modal dialogs as separate targets.

Use the installed Excel COM API to author and refresh Power Query, PivotTables, and PivotCharts, and verify them in Excel after save/reopen. This changes the control method, not the required native features. Use an owned Excel instance; do not close or alter unrelated user workbooks. The bundled spreadsheet runtime remains the base-workbook authoring tool where suitable; native-feature workbooks must not be round-tripped through a library that could strip features.
