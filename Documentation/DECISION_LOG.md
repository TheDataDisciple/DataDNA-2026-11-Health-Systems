# Implementation decisions

Current scope is D009 below. D-001 through D008 preserve historical decisions; their audit-dashboard requirements are superseded and must not restart removed work.

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

## D-005 — Question prerequisites and audit evidence

Date: 3 November 2026. Blueprint sections 6–7; specification sections 5–7.

`RULE_CATALOG.json` covers all 65 supplied fields and provides explicit rule-to-question associations. Only relevant fields may block a question. For the source-audit question, `AccountedFor` requires complete, independently reconciled outcome accounting; source failures are evidence rather than a requirement to make the data clean. Business questions require passing prerequisites and verified semantic evidence. Nullable fields use `PassForEligible` only with tested observations and separately verified population coverage; all-null observations cannot silently pass. Causal support retains its study-design requirement.

The catalog is definitions only. Its static verification is not production Excel execution, an audit release, or a certificate of valid health observations.

## D-006 — Public checkpoint approval

Date: 3 November 2026.

Initial push of local checkpoint `634284d` was rejected by automatic approval review for lack of explicit destination/payload authorization. Repository identity, public visibility, and admin/push access were rechecked. The user explicitly approved that commit's public push to `TheDataDisciple/DataDNA-2026-11-Health-Systems` on `codex/health-system-readiness`; the same push then succeeded. Raw CSVs, workbooks, PBIX binaries, caches, and the private Notion registry were excluded.

## D-007 — Controlled native Power Query input folder

Date: 4 November 2026. Specification sections 5–6.

Create one versioned `In Progress/AuditInputs/<audit_run_id>/` bundle containing the five unchanged CSVs, the catalog and run metadata. Verify exact filenames, schemas, counts and hashes against canonical Original inputs. Native M reads only this folder; no privacy settings are weakened. The export bridge must recheck input hashes and serialize native saved query outputs. Independent Python validation supplies comparison evidence, never replacement production results.

## D008 — Native report interaction refinements

The Evidence page uses a rule-bar selection and native label-to-Rule-ID hierarchy. A separate single-rule slicer was removed because it competed with bar selections. Defaults are performance / Identity with a visible selection prompt. Native drill-through to Rule Detail was tested through both the Executive context menu and the Evidence button after drilling to Rule ID.

Recovery actions pass a stable hidden Action ID to Evidence through native drill-through. The action context remains visible; incompatible source/family selections give a clearing prompt. Reset restores the unrestricted default browser. Native tests for this new action route remain pending.

Native table virtualization initially exposed 20 accessible rows. A captured Desktop-generated DAX query returned all 39 members for original key 1. Standard wheel scrolling exposed the final source ordinal 38,938, matching the raw CSV. No change to the group-limit calculation was needed.

The user explicitly authorized Windows native UI Automation for report controls and embedded dialogs after the standard control tool blocked them. UIA plus bounded native input operates only the identified project window, using exact observed controls or a recent geometry-checked screenshot. Evidence stays in the analyst workspace.

## D009 — Remove audit implementation; return to Excel cleaning and EDA

On 5 November 2026 the user rejected the audit-dashboard direction, explicitly chose removal of that implementation, and supplied the five organizer CSV paths again. They match the existing canonical source hashes. Preserve useful initial profiling and original files, remove the assistant-built audit model/report/pipeline, and deliver focused native Excel cleaning with real PivotTables and PivotCharts. The old technical contract and readiness-design requirements are superseded. Treat the brief’s suggested patterns as hypotheses; do not invent repairs to satisfy them.
