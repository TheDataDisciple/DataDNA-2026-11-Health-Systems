# DataDNA Health System Performance — Technical Specification v1.1

**Status:** Approved specification; implementation in progress

**Project date:** 3 November 2026

**Internal completion target:** 20 November 2026

**Contest deadline:** 24 November 2026

**Primary deliverable:** One polished dashboard image, supported by a complete working project.

**Persistent specification:**

`C:\Users\Klymchuk Dmytriy\OneDrive\Lessons\Power BI Lessons\Contests\DataDNA-Dataset-Challenge-2026-11-Health-System-Performance\Documentation\PROJECT_TECHNICAL_SPEC.md`

Saved from the user-approved v1.1 specification on 3 November 2026. Implementation progress, artifact locations, verified checks, and next actions are maintained in PROJECT_STATUS.md.

## 1. Corrections introduced by this review

The previous plan covered the intended outcome well. This revision closes several implementation gaps:

| Gap | Required correction |
|---|---|
| Native application availability was assumed | Verify Excel functionality and Power BI Desktop availability before the main build. |
| Excel outputs lacked an explicit export mechanism | Export saved, bounded query-result tables through a deterministic CSV bridge. |
| A source hash did not identify the validation logic used | Add audit-run, rule-version, transformation-version, and release identifiers. |
| Passing automated checks could imply analytical support | Require separate evidence for semantics, populations, aggregation, and study design. |
| Slicer reset and drill-through behaviour were underspecified | Define bookmark responsibilities and separate unrestricted browsing from inherited drill-through context. |
| A 3200 × 1800 file was treated as guaranteed export quality | Test effective resolution and export fidelity early; avoid presenting an enlarged raster as higher-quality source output. |
| Existing validation depended partly on field-name suffixes | Establish an explicit rule catalog covering every supplied field and documented constraint. |
| Multi-file promotion could leave mixed or partial inputs | Publish complete, versioned audit releases with manifests. |
| Public documentation could contain inaccessible local images | Check repository links and replace local-only image embeds with credited public references where necessary. |
| Reproducibility stopped short of a fresh environment | Add a clean-folder rebuild and refresh test. |

These corrections are part of the project requirements.

## 2. Finished-project contract

The project is complete when the following artifacts exist and their applicable checks have passed.

| Deliverable | Finished state |
|---|---|
| Technical specification | Saved, linked from project instructions, and consistent with implementation. |
| Project-status record | Identifies the current snapshot, completed work, open issues, artifact locations, and next action. |
| Source manifest | Records filenames, actual locations, hashes, schemas, counts, and documentation versions. |
| Excel workbook | Refreshable preparation and validation queries, genuine PivotTables, genuine PivotCharts, and transformation records. |
| Audit release | Complete, versioned analytical inputs reconciled to the source and Excel outputs. |
| Power BI project | Refreshable model, three main pages, working evidence navigation, and tested measures. |
| Native report package | PBIP project and a PBIX saved through Power BI Desktop. |
| Final image | One readable PNG of Executive Readiness, below the submission size limit. |
| Notion project | Accurate task tracking, decisions, findings, scorecard, evidence links, and completion record. |
| GitHub repository | Deliberate commits containing eligible original work and usable reproduction instructions. |
| Submission package | Final image, description, proposed LinkedIn text, and entry checklist. |
| Verification record | Documents actual tests, results, limitations, and artifact identifiers. |

Track four independent completion states:

1. **Technical delivery:** whether the project functions.
2. **Analytical support:** which health questions the evidence supports.
3. **Documentation synchronization:** whether local records, Notion, and GitHub agree.
4. **External submission:** whether posting and entry submission actually occurred.

Unresolved source problems must remain visible. They must not be closed simply because the readiness report is finished.

## 3. Governing blueprint and contest rubric

Use [WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md](WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md) as the main design and analytical reference.

| Blueprint content | Mandatory implementation use |
|---|---|
| Winner reviews | Borrow the decision journey, interpretations, consistent interface, and tested exploration patterns. |
| Comparison matrix | Guide hierarchy, meaningful denominators, accessibility, and action-oriented conclusions. |
| Current-source assessment | Establish the initial supportable questions and evidence baseline. |
| Three-page blueprint | Define the main report pages, audit measures, visual system, and recovery policy. |
| Acceptance scenarios | Become executable verification cases and release evidence. |

Each substantial Notion task must reference the applicable blueprint section. Record deviations and their reasons.

### Internal scorecard

Retain the supplied category maxima. Sub-point allocations below are internal review choices.

| Category | Internal allocation | Maximum |
|---|---|---:|
| Understanding | Concise explanations 2; meaningful colour 3; coherent story 5 | 10 |
| Usability | Cross-filtering 4; response time 3; drill-down 4; help 3 | 14 |
| Design and purpose | Consistency 2; simplicity 2; usability 2; challenge relevance 3; typography 1 | 10 |

Target **31/34**. Record actual evidence and deductions.

A readiness-only report must receive an honest challenge-relevance assessment. Visual polish cannot establish that the health-performance questions have been answered.

## 4. Startup verification and persistent memory

### 4.1 Capability check before the main build

Excel is present. Native Power BI availability remains unverified: no running Desktop instance was found, and it did not appear in the inspected application inventory. This does not establish that it is absent.

At implementation start:

1. Locate and open the intended Power BI Desktop installation.
2. Record application versions and Excel architecture.
3. Verify Excel Power Query and native PivotTable/PivotChart functionality.
4. Save and reopen a small PBIP and PBIX.
5. Verify model-connector access to that project.
6. Test native report authoring and the image-export route.
7. Confirm Notion creation/update access and GitHub repository access.

Keep capability-test artifacts in the analyst workspace.

If a capability fails, record the specific failure and resolve it before dependent work. Do not describe native features as completed from library previews alone.

### 4.2 Persistent records

Maintain:

- **Technical specification:** requirements, interfaces, definitions, behaviour, and acceptance criteria.
- **Project-status record:** actual progress, artifacts, source version, latest checks, and next action.
- **Decision log:** consequential implementation choices and departures from the blueprint.

Add a short pointer to these records and the blueprint in project instructions.

### 4.3 Resume protocol

Every future session must:

1. Read the specification, status record, blueprint, and project instructions.
2. Inspect Git status and actual artifacts.
3. Check whether input hashes or rule versions changed.
4. Identify the last verified checkpoint.
5. Resume the next incomplete task.
6. Update the status record after meaningful progress.

Store created Notion identifiers and repository references so future work can fetch known records directly.

## 5. Source preservation, validation scope, and identifiers

### 5.1 Reconcile source locations

The five CSVs currently sit directly inside the data-source folder.

Establish the documented Original → In Progress → Ready To Work flow using byte-identical copies and hash verification. Preserve the existing files and organizer package.

Update the folder guide to distinguish actual state from intended structure. Configure refresh only after the canonical locations are established.

### 5.2 Baseline expectations

For the matching reviewed snapshot:

| Diagnostic | Expected result |
|---|---:|
| Performance source records | 40,000 |
| Distinct `perf_id` values | 1,001 |
| Fact records sharing repeated keys | 40,000 |
| Excess key occurrences | 38,999 |
| Exact duplicate excess fact records | 0 |
| Fact records with one parent in every direct dimension | 29,000 |
| Fact records ambiguous in at least one direct dimension | 11,000 |
| Predicted four-dimension inner-join records | 54,858 |
| Join expansion | 37.145% |
| Valid calendar fields under each existing year/quarter/label rule | 0 of 28 |
| Invalid A&E four-hour percentage values | 35,995 of 40,000 |

Reproduce the existing 98 reconciliation checks. Preserve their historical results and definitions.

### 5.3 Explicit rule catalog

Do not derive the complete validation policy from column suffixes.

The existing profile contains 23 domain checks. Fields such as `health_spend_pct_gdp` need explicit coverage rather than relying on `_pct` detection.

Each rule must record:

- Stable Rule ID.
- Source table and field.
- Rule family.
- Expected type or domain.
- Documentary authority.
- Eligibility and denominator.
- Missing-value treatment.
- Interpretation and severity.
- Whether the constraint is confirmed or requires clarification.

Distinguish a documented-domain failure from an impossible clinical value.

Examples requiring special treatment:

- ICU occupancy above 100 requires capacity-definition clarification.
- Pandemic surge percentages must not inherit a generic 0–100 limit.
- Care-spend shares summing to 100 require confirmation that the categories exhaust the same budget.
- Spending relative to GDP needs its own definition and applicable constraints.
- Country names inside a purported Boolean field must not be converted into membership flags by assumption.

### 5.4 Version identifiers

Use separate identifiers for:

| Identifier | Meaning |
|---|---|
| Snapshot ID | The immutable set of raw source files. |
| Rule version | The validation definitions used. |
| Transformation version | The preparation and correction logic used. |
| Audit Run ID | Snapshot, rule version, transformation version, and evaluated stage. |
| Release ID | A complete validated set of exported inputs. |

Changing rules or transformations creates a new audit run even if raw hashes remain unchanged.

The initial report evaluates the **raw supplied snapshot**. Prepared-stage results must be explicitly labelled and must not silently replace raw-source diagnostics.

## 6. Excel preparation, validation, EDA, and export

### 6.1 Workbook structure

Create one consolidated workbook with:

| Component | Purpose |
|---|---|
| Readiness EDA | Main PivotTable/PivotChart exploration. |
| Rule Detail | Rule-specific counts, denominators, distributions, and examples. |
| Question Impact | Analytical questions, prerequisites, and support status. |
| Corrections | Evidence-supported transformation records. |
| Rule Catalog | Validation definitions and interpretation. |
| Exceptions | Inspectable failed-record examples. |
| Prepared tables | Necessary worksheet outputs from the preparation queries. |
| Checks | Independent reconciliation and conversion checks. |
| Export control | Release identifiers, selected partition, chunk, and export metadata. |

Raw imports may remain connection-only. Original CSVs preserve exact source values.

Use summary tables for ordinary PivotTables where they answer the EDA question. Use the Data Model where justified by the tested environment.

### 6.2 Preparation policy

- Parse CSV structure explicitly, including quoted delimiters and multiline fields.
- Use explicit culture settings rather than the machine’s automatic interpretation.
- Preserve identifiers and malformed dates as text.
- Preserve original values before conversion.
- Separate numeric conversion from business correction.
- Record precision changes.
- Do not cap, impute, reassign, or rescale values without supporting evidence.

A source percentage stored on a 0–100 scale and a calculated failure rate stored on a 0–1 scale must use different formatting policies. Formatting must not multiply displayed values by 100 accidentally.

### 6.3 Outcome accounting

Within each rule’s defined scope:

> Pass + Fail + NotTestable = records in scope.

Tested records equal Pass + Fail.

Use explicit reasons for NotTestable, including missing required inputs or ambiguous parents. Mandatory missing values also fail their applicable completeness rules.

Keep referential coverage and parent uniqueness separate. A matching key can have multiple parents and still be unsuitable for attribution.

### 6.4 EDA requirements

Build genuine native PivotTables and PivotCharts for:

- Missingness and type failures.
- Repeated keys and exact duplicates.
- Zero/one/multiple parent matches.
- Rule-specific failure rates.
- Raw numeric distributions against documented domains.
- Analytical questions and their blockers.
- Recovery priorities and dependencies.

Use quantiles and distributions to investigate values. Do not remove outliers automatically.

Do not pool repeated workforce attributes across thousands of fact records to manufacture correlation evidence.

### 6.5 Concrete export bridge

A query loaded only into the Data Model is not treated as a CSV file.

Implement this export path:

1. Refresh the preparation and validation queries.
2. Materialize export partitions into a bounded worksheet query table.
3. Limit each export chunk to **100,000 data records**.
4. Save the workbook.
5. Read the saved output-table values through the export helper.
6. Serialize UTF-8, comma-delimited CSV with explicit quoting and invariant numeric handling.
7. Reconcile exported headers, record counts, identifiers, values, and partition boundaries.
8. Repeat for the remaining chunks.
9. Write the complete release manifest.

The helper exports Excel’s calculated results; it must not independently reimplement the production validation rules.

Validate totals independently against the raw CSVs using the existing Python verification approach.

### 6.6 Release promotion

Build exports in staging first.

Promote a complete release only after verification. Store versioned release folders beneath Ready To Work and update the folder guide accordingly.

Each release manifest records:

- Release and Audit Run IDs.
- Input hashes.
- Rule and transformation versions.
- Exported files, schemas, record counts, and hashes.
- Verification results.
- Completion state.

Power BI loads one explicitly selected complete release. It must not combine files from different runs or consume an incomplete export.

These are validated **audit inputs about the source data**. Their promotion does not certify the underlying health observations.

## 7. Audit model and analytical support

### 7.1 Model tables

| Table | Grain and purpose |
|---|---|
| Snapshot | One immutable source snapshot. |
| AuditRun | One versioned evaluation run and its global diagnostics. |
| Rule | One validation rule. |
| SourceRecord | One original record with lineage reference and original identifiers. |
| Evaluation | One Audit Run × Rule × Source Record. |
| AnalysisQuestion | One analytical question. |
| QuestionRule | Required automated rules for a question. |
| QuestionEvidence | Required semantic, population, aggregation, or study-design evidence. |
| RecoveryAction | One corrective action and closure condition. |
| ActionRule | Actions linked to supporting rules. |

Use internal audit keys for efficient joins. They must never be presented as repaired country, system, workforce, or performance identifiers.

Preserve exact original-value evidence without repeating unnecessary large text payloads throughout the model.

### 7.2 Relationship policy

- Use single-direction relationships for the core audit model.
- Keep invalid raw business relationships outside trusted analytical joins.
- Apply question-to-rule and action-to-rule selection explicitly.
- Avoid ambiguous bidirectional paths.
- Keep global cards scoped to the selected audit run.
- Ensure all report inputs belong to one complete release.

### 7.3 Required measures

Implement and document:

- Failed evaluations.
- Tested evaluations.
- Not-testable evaluations.
- Failure rate for a single rule.
- Rows sharing a declared key.
- Excess key occurrences.
- Exact duplicate excess records.
- Distinct ambiguously linked fact records.
- Structural single-parent coverage.
- Valid calendar records.
- Predicted join records and join expansion.
- Question status.
- Recovery-action status.

Return blank rates with explanatory text when the denominator is zero.

Never add overlapping failure counts and label the result distinct affected records.

### 7.4 Question-support policy

Automated validation is necessary but not sufficient.

A descriptive health question becomes Supported only when:

1. Its mandatory automated requirements pass.
2. Entity meaning and attribution are documented.
3. The observation grain is confirmed.
4. Aggregation and denominator rules are justified.
5. Relevant populations and periods are comparable.
6. Required semantic evidence is verified.

Causal questions remain Not established without an appropriate study design.

Static population attributes do not automatically provide historical weights. USD values do not establish inflation-adjusted or purchasing-power-adjusted comparisons.

The initial supported story remains:

> What prevents trustworthy comparison, what are the consequences, and what evidence would unlock the intended health analysis?

## 8. Power BI pages and interaction contract

### 8.1 Design system

Follow the blueprint’s 1600 × 900 canvas, navigation rail, margins, gutters, Segoe UI typography, light panels, and semantic palette.

Use at least 14-pixel body and axis text on supporting pages. Start with **16-pixel essential text on the submission page**, reducing content before reducing readability.

Use consistent count, percentage, unit, and status formatting. No maps, country rankings, or healthcare-year slicers belong in the initial readiness report.

### 8.2 Main pages

| Page | Required content |
|---|---|
| Executive Readiness | Evidence-derived headline; four global cards; question-readiness matrix; blockers; recovery strip. |
| Evidence and Consequences | Rule browser; scoped counts; independent comparison bars; definitions; conditional populations; failed-record examples. |
| Recovery Priorities | Dependency path; selected-action explanation; prioritized action register; evidence navigation. |

The four main cards reconcile to 40,000 records, 11,000 ambiguous records, 0/28 valid calendar records, and 37.1% join expansion for the reviewed run.

### 8.3 Hidden technical detail page

Add one hidden **Rule Detail** page for native drill-through.

This is a justified refinement of the blueprint:

- It prevents inherited drill-through filters from colliding with the unrestricted rule browser’s slicers.
- It receives a stable Rule ID.
- It contains no unrelated family or table filters.
- Its measures, definition, and record details share the same rule context.
- Its Back action returns to the originating page.
- It is excluded from the final image.

The report still has three main navigation pages.

For a selected repeated key, show all group members on this technical page. The ordinary first-20-example limit must not hide members of that selected group.

### 8.4 Explicit interaction map

| Action | Required result |
|---|---|
| Select a question on Page 1 | Filter its blockers; retain clearly labelled global cards. |
| Select a rule | Align counts, definition, examples, and narrative. |
| Open rule evidence | Pass Rule ID to the hidden detail page. |
| Change table or family | Narrow available rules; incompatible selection produces a clear prompt rather than stale evidence. |
| Open or close Help | Change overlay visibility without changing data selections. |
| Reset current page | Restore that page’s documented default filters and close Help. |
| Use page navigation | Change pages without unexpectedly restoring old data selections. |
| Select one record or key | Apply a clearly labelled record scope and preserve complete narrative text. |

Do not promise automatic incompatible-slicer clearing unless it is actually implemented and tested.

### 8.5 Bookmark responsibilities

Use separate bookmark groups:

- **Help:** display state only, scoped to overlay objects.
- **Page reset:** defined data and display defaults.
- **Export:** deterministic submission-page state.
- **Navigation:** native page navigation where possible.

Power BI bookmarks can capture both filter and display state, so those responsibilities must be configured deliberately. [Microsoft bookmark documentation](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-bookmarks)

## 9. Export quality and submission package

### 9.1 Export feasibility test

Test the image route during startup rather than after the dashboard is finished.

Power BI PDF export has documented fidelity limits and can reset drilled or scrolled visual states. Therefore, the final page must be understandable in its intended default state, and the exported artifact must be inspected independently. [Microsoft export documentation](https://learn.microsoft.com/en-us/power-bi/collaborate-share/end-user-pdf)

Test:

1. Native PDF export and rendering of the Executive page.
2. Actual effective resolution and text clarity.
3. Canvas boundaries and unwanted margins.
4. Fonts, backgrounds, legends, and status labels.
5. Agreement between visible report values and exported values.

If PDF fidelity is inadequate, use a verified native canvas capture.

Prefer a genuinely useful 3200 × 1800 output where supported. Do not enlarge a low-resolution raster and describe the result as higher-resolution source quality. Record the actual dimensions and export method.

### 9.2 Final image acceptance

The single PNG must:

- Be below 10 MB.
- Show Executive Readiness only.
- Communicate problem, evidence, consequence, and next action.
- Require no hover, scrolling, or supporting page to interpret its main claims.
- Remain readable at approximately 1200 pixels wide.
- Contain no accidental selection, help overlay, tooltip, or clipped text.
- Match the released audit run.

### 9.3 Native package acceptance

Target a PBIX size below **45 MB**, leaving headroom under the stated 50 MB upload limit.

If necessary, reduce unused columns and repeated payloads while preserving the evidence contract. Do not silently sample the headline audit population to reduce file size.

A public report link is optional and requires explicit publication authorization. The plan must not depend on unverified Power BI Service access.

Prepare the final description, proposed LinkedIn text, required mentions, and entry checklist. Recheck contest requirements before submission because only one entry is permitted.

## 10. Notion, GitHub, and reproducibility

### 10.1 Notion

Use the existing Data Analyst Projects hub.

Maintain tasks, deliverables, blueprint references, decisions, findings, scorecard evidence, and release status.

Each task includes:

- Stable task key.
- Phase and priority.
- Status.
- Dependency.
- Completion condition.
- Blueprint reference.
- Target date.
- Evidence reference.
- Specific blocking issue.

Use board, milestone-table, blocked-work, and review views.

Current database and view operations are available. Do not depend on unrestricted advanced queries; retain known page identifiers in the status record.

After an uncertain write, fetch the created or updated object before retrying. Prevent duplicate project pages and duplicate task creation.

### 10.2 GitHub

Use the existing repository and a `codex/` branch.

Preserve current uncommitted changes. Commit coherent milestones and stage deliberate files.

Eligible public content includes original scripts, query definitions, technical documentation, report definitions, original assets, and permitted final materials.

Exclude raw data, data-bearing workbooks, PBIX binaries, caches, credentials, and intermediate outputs.

Check public documentation links. Where the blueprint references local-only third-party images, retain the research material locally and use credited public references in the published documentation.

Document local source-folder configuration and tested application/runtime versions.

### 10.3 Clean-folder reproduction test

Before final release:

1. Start from a separate clean project copy.
2. Provide the organizer source files through documented setup.
3. Configure the source location.
4. Rebuild preparation outputs and the audit release.
5. Refresh the Power BI project.
6. Reconcile data, measures, scope, and default view.
7. Confirm that no dependency points silently into the original working checkout.

Compare data and behaviour rather than requiring Excel or PBIX binary files to be byte-identical after recalculation.

## 11. Verification matrix

| Test group | Required result |
|---|---|
| Source preservation | Raw hashes remain unchanged. |
| Parsing | Quoting, delimiters, missing values, types, and culture are handled explicitly. |
| Rule accounting | Pass + Fail + NotTestable reconciles to rule scope. |
| Baseline | Expected diagnostics reproduce for the matching snapshot. |
| Duplicate terminology | Repeated keys, excess occurrences, and exact duplicates remain distinct. |
| Conditional tests | Eligible and excluded populations are visible. |
| Overlap | Combined distinct counts are computed from record references. |
| Excel | Native queries, PivotTables, and PivotCharts refresh and survive reopening. |
| Export bridge | Chunk boundaries, counts, values, headers, and hashes reconcile. |
| Release integrity | Power BI rejects incomplete or mixed-run input sets. |
| Model | Relationships preserve the intended audit grain. |
| Semantics | Question support requires automated and semantic evidence. |
| Interaction | Selection, reset, Help, navigation, and drill-through follow the interaction map. |
| Narrative | Zero, blank, untested, single-record, and empty states remain accurate. |
| Performance | Record cold-load behaviour separately; time representative interactions over repeated warm runs. |
| Accessibility | Keyboard order, focus, contrast, meaningful labels, and non-colour interpretation are checked. |
| Image | Export matches the released model and remains legible outside Power BI. |
| PBIX | Opens correctly and meets the upload size requirement. |
| Repository | Intended content is committed; excluded data remains excluded. |
| Notion | Statuses and links match actual artifacts and verification. |
| Reproduction | Clean-folder rebuild and refresh succeed. |

Use a two-second internal target for typical warm interactions. Record actual measurements and the test machine. Do not infer whole-report performance from one DAX query.

No unresolved implementation defect may remain if it changes displayed results or breaks a required flow. Source-quality problems remain explicit report content.

## 12. Execution sequence and final handoff

| Work package | Target | Exit evidence |
|---|---|---|
| Save specification and resume records | 3 Nov | Persistent files and instruction pointers. |
| Capability and export pilot | 3–4 Nov | Native feature checks, Power BI availability, working export route. |
| Source reconciliation and rule catalog | 3–5 Nov | Canonical manifest, explicit rule coverage, version identifiers. |
| Excel preparation and export bridge | 4–8 Nov | Refreshable workbook, genuine pivots/charts, reconciled partitions. |
| EDA and question-support review | 8–10 Nov | Findings, blocked questions, semantic requirements, narrative. |
| Audit release and model | 11–14 Nov | Complete release, refreshing model, verified measures. |
| Report and interactions | 15–18 Nov | Three main pages, hidden detail page, tested interaction map. |
| Reproduction and release verification | 19–20 Nov | Clean rebuild, final image, native package, scorecard, documentation. |
| Contingency | 21–23 Nov | Fixes and affected retesting. |

Each checkpoint records the Audit Run ID, Release ID, artifact locations, checks performed, Git reference, Notion state, remaining issues, and next concrete action.

The final handoff contains:

- One canonical dashboard image.
- The completed Excel workbook.
- The Power BI project and native PBIX.
- Reproduction and refresh instructions.
- Completed Notion project records.
- GitHub changes and commit references.
- The actual internal scorecard.
- Submission-ready text and checklist.
- A clear statement of unresolved analytical limits.

Public posting, organizer messages, and contest-form submission remain separate actions requiring explicit instruction. The project must never describe them as completed merely because the submission package is ready.
