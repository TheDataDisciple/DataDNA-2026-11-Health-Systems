# Winning dashboards lead to a decision: lessons for November Health

> Current scope (5 November 2026): presentation lessons remain useful. The former readiness/audit design below is historical and superseded by the Excel cleaning and EDA specification. Do not restart the removed audit implementation.

## Executive summary

The strongest transferable feature is a **complete decision journey**: establish the problem, explain the important differences, and end with a justified priority. Visual polish makes that journey easier to follow; it does not establish that the analysis is correct.

- **July — Gabriele Toscano:** four connected chapters turn workforce disruption into a funding-allocation question. The organizer's judge explicitly praised the narrative and investment direction. [July results](https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-july-2026-activity-7488883807488585728-zEsD)
- **August — Brian Sule:** a consistent interface pairs charts with interpretations and carries the reader into an intervention table. The judge explicitly recognized consistency, insight pairing, color, and contrast. [August results](https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-august-2026-activity-7500096906250092545-FrSk)
- **September — Ugochukwu Nwasuruba:** the accessible live report connects operating conditions, service reliability, and corridor priorities. His winner post attributes recognition to flow, presentation, storytelling, and accessibility. **The original organizer announcement was not retrieved; September's award attribution and reported feedback therefore rely on the author's primary post.** [Author's winner post](https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-onyxdata-powerbi-activity-7511097792983986178-f3AF)

For November, use **Executive Readiness → Evidence and Consequences → Recovery Priorities**. The immediate decision is which analyses health leaders can trust and what must be corrected before investing on their basis. A readiness report is an honest interim response, but it does not fully answer the contest's health-performance questions. Corrected data would allow a stronger direct fit before submission.

Reviewed on **3 November 2026**, Europe/Paris. This guide specifies the report; it does not create a PBIP or publish a submission.

## 1. What the evidence can establish

Use the following distinctions throughout this review:

- **Published judging evidence:** the organizer's stated selection and explanation, where retrieved.
- **Observed:** features visible in the original images or behavior tested in the public report.
- **Author-reported:** explanations and capabilities described by the creator but not independently exercised.
- **Assessment:** my interpretation of why a feature helps, or where it creates a weakness.

The three entries are examples of selected winners, not a controlled study of winning. Different judges and competitors were involved. Their strengths cannot establish a causal formula for first place, and no complete score sheets or underlying models were available.

### Coverage and access

| Entry | Public material inspected | Live behavior covered | Important limit |
|---|---|---|---|
| July | Portfolio collage containing all four main pages, including two alternate views on pages 2 and 3; original author submission and follow-up post; organizer results | No matching live URL exposed in the inspected portfolio or author posts | Tutorial and country drill-through are author-reported; the collage is not an interactive test |
| August | Overview, transaction-driver view, risk-driver view, and intervention page; portfolio explanation; author submission; organizer results | No matching wallet report located | A report short link discovered in profile material opened a B2B sales report and was excluded; another led to the award announcement |
| September | Portfolio collage; Intro and all three live analysis pages; user-guide overlay; author submission and winner post | Page navigation, kitchen slicer, dynamic takeaway, reset, matrix and bubble selection, point context menu | No drill-through option in the sampled bubble menu; a point diagnostic was exposed, but a full audit of custom tooltip pages was unavailable |

The images and live numbers are evidence of **presentation and displayed behavior**. They are not independently validated historical business results. Source records, interaction observations, and local image references are retained in the [research notes](../_analyst_workspace/notes/winner_review_research.md).

### Judging criteria: usability deserves substantial attention

The published Power BI rubric allocates **10 points to understanding, 14 to ease of use, and 10 to appropriate design**: 34 points altogether. Usability is 14/34, or 41.2%, of those published maxima. This is a planning guide, not proof that those exact weights determined each award. The platform separately describes four AI feedback dimensions scored 1–5; these must not be treated as the judges' scorecards. [Power BI criteria](https://datadna.onyxdata.co.uk/challenges/september-2026-datadna-golden-wok-food-delivery-analytics-challenge/)

| Rubric area | What to learn from these entries | November acceptance evidence |
|---|---|---|
| Understanding, maximum 10 | One question per page; context beside a number; a useful interpretation rather than chart titles alone | A reader can explain what is blocked and why without an analyst narrating |
| Ease of use, maximum 14 | Visible navigation, relevant filters, reset, guided help, exploration into supporting detail | A documented filter-and-reset test; selection changes compatible figures and narrative; details are reachable |
| Purpose and design, maximum 10 | Stable hierarchy and meaningful chart choices; the report addresses the actual decision | Legible at fit-to-page and in the submission image; readiness limitations do not disappear behind decoration |

## 2. July: an argument about where funding should go

**Winner:** Gabriele Toscano. **Report:** [The AI Reskilling Gap](https://datadna.onyxdata.co.uk/portfolios/the-ai-reskilling-gap/). **Judge:** Gus Bavia, confirmed in the organizer's results.

**Published reason:** the judge said the report “Turns the dashboard into a real narrative” and praised its progression toward investment decisions and its ability to stand on its own. [Organizer announcement](https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-july-2026-activity-7488883807488585728-zEsD)

### What is visible

| Page | Analytical job | Concrete design evidence | Lesson |
|---|---|---|---|
| Generative AI Shift | Establish the disruption and the comparison period | An annotated quarterly line and aligned net-job bars; before/after context; displaced-worker counts beside normalized measures | Define the problem before asking the reader to explore it |
| The Paradox | Contrast exposure with investment | Funding per displaced worker beside skill-level replaceability and augmentation; an alternate view compares jobs created and displaced | Place the mismatch in the same view; use a relevant denominator |
| The Unprepared | Reveal geographic and industry differences | A globe, country table, economy-type comparisons, and country/industry view states | Give the audience both an overview and exact comparisons |
| The Allocation | Turn analysis into a priority | Actual-versus-proposed funding dumbbells and a funding-gap/reskilling-speed bubble chart | End with a decision rule and identifiable targets |

The collage uses a stable blue-and-gold system, a recurring left navigation rail, large chapter titles, and a consistent card hierarchy. Actual and comparison values are labeled, reducing dependence on hover. These are visible interface qualities; the source does not expose the DAX behind them.

The creator describes guided onboarding, country drill-through, view toggles, and a custom allocation model. The alternate states are visible in the collage; tutorial and drill-through operation remain untested. [Author's explanation](https://www.linkedin.com/posts/gabriele-toscano-928188234_onyxdata-datavisualization-powerbi-activity-7482716776112373760-W44k)

[July report collage, credited to Gabriele Toscano — original portfolio](https://datadna.onyxdata.co.uk/portfolios/the-ai-reskilling-gap/). The inspected reference image is retained locally in the winner-review evidence folder.

### Why this is persuasive—and what to improve

**Assessment:** the pages form an argument with a destination. Ratios and funding per displaced worker make the story more decision-relevant than totals alone. The final page gives the preceding exploration a purpose.

Do not copy the following without scrutiny:

- **A normative allocation is a scenario.** A risk-based funding allocation is not automatically optimal, causal, or guaranteed to improve employment. Its assumptions and sensitivity need explanation.
- **A large globe is weak for exact ranking.** Retain the readable table and let geography earn its space. November's unresolved entity attribution does not support a country map at all.
- **The presentation collage reduces reading size.** Six views and decorative space make a striking portfolio image but require zoom for detail. Use one legible primary page for November's submission image.
- **Coverage and uncertainty need meaning.** The footer includes confidence/coverage statistics and the trend has an uncertainty band. Their presence is useful; their calculations were not available to audit. Do not add similar statistics to Health without defined inputs.

**Transfer:** borrow the progression from problem to allocation. For readiness, the destination becomes the correction that unlocks a particular health decision—not an invented funding recommendation.

## 3. August: consistent explanations, then interventions

**Winner:** Brian Sule. **Report:** [African Gig Economy and Digital Wallet Risk Report](https://datadna.onyxdata.co.uk/portfolios/african-gig-economy-and-digital-wallet-risk-report/). **Judge:** Cindy Jamaeca Balbag, confirmed in the organizer's announcement.

**Published reason:** “Consistent from start to finish. Every chart pairs with an insight, and the color and contrast hold together.” [Organizer announcement](https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-august-2026-activity-7500096906250092545-FrSk)

### What is visible

| View | Analytical job | Concrete evidence | Lesson |
|---|---|---|---|
| Overview | Establish platform performance and risk concentration | Six KPI cards with prior-year context; applied-filter text; interpretations above a trend, market comparison, and channel ranking | Explain the selected metric and scope wherever the reader looks |
| Drivers: transaction | Compare processing efficiency with success | Processing-time context, market/channel comparisons, and a labeled quadrant scatter | Connect an outcome to a plausible diagnostic; retain volume context |
| Drivers: risk | Examine behavioral segments | Dimension and metric selectors; velocity/fraud scatter; a priority-segment summary | Reuse one comparison area across related dimensions |
| Intervention plan | Specify what to do | Tables link a focus entity to priority, recommended action, and expected outcome | Finish with an action traceable to evidence |

The screenshots retain the same dark header, white panels, purple encoding, selected-tab underline, and top-level navigation. This repetition reduces the effort of learning each new page. [Portfolio and explanation](https://datadna.onyxdata.co.uk/portfolios/african-gig-economy-and-digital-wallet-risk-report/)

[August overview, credited to Brian Sule — original portfolio](https://datadna.onyxdata.co.uk/portfolios/african-gig-economy-and-digital-wallet-risk-report/). The inspected reference image is retained locally.

The other inspected views are transaction drivers, risk drivers, and interventions, available through the [credited portfolio source](https://datadna.onyxdata.co.uk/portfolios/african-gig-economy-and-digital-wallet-risk-report/). Their review screenshots remain local reference material.

### Why this is persuasive—and what to improve

**Assessment:** the reader is not left to infer the meaning of every chart. The design stays coherent as the analytical task changes, and the final tables connect findings to actions. The creator's stated decision-oriented progression agrees with the visible page structure. [Author submission](https://www.linkedin.com/posts/brian-sule-109293197_datadna-onyxdata-powerbi-activity-7496584323047870465-wAtN)

The entry also contains choices to improve on:

- **Average processing time is not a part-to-whole measure.** The transaction-driver donut compares market averages; a dot plot with labeled milliseconds would be more faithful and easier to compare.
- **Several absolute bars start above zero.** In the driver screenshots, processing and velocity rankings use narrow ranges around roughly 500. This exaggerates small absolute differences. Use zero-based bars, or a clearly labeled dot/difference plot when a focused scale matters.
- **The scatter axes show fractional rates while cards show percentages.** Align both to percentages, especially for a broad leadership audience.
- **The weighted Vulnerability Index is not transparent in the images.** The portfolio identifies its ingredients, but weights, normalization, and thresholds were not audited. Do not import an opaque composite score into Health.
- **Expected outcomes are aspirations.** The intervention table provides useful direction but does not establish measured financial benefits. Do not relabel expected reductions as demonstrated impact.

**Transfer:** keep a short interpretation beside every important quality finding, plus a recovery table that ties an issue to the analysis it unlocks. Replace decorative/nonadditive encodings with clear comparisons.

## 4. September: operating evidence becomes a corridor decision

**Reviewed entry:** Ugochukwu Nwasuruba, published on DataDNA as “ugo nwasuruba.” The portfolio embeds the same Power BI URL linked in his submission. [Portfolio](https://datadna.onyxdata.co.uk/portfolios/golden-wok-food-delivery-network-intelligence/), [original submission](https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-powerbi-dataanalytics-activity-7508448464968716288-f3ma)

**Award evidence:** his primary winner post identifies first place and the Storyteller and Accessibility badges, and attributes feedback to John Johnson, Nina Ikpe, and Mariska van Kan. This is the creator's account of judging, not a retrieved organizer score sheet. Do not turn it into an independently certified WCAG claim. [Winner post](https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-onyxdata-powerbi-activity-7511097792983986178-f3AF)

### What is visible and tested

| Page | Analytical job | Concrete evidence | Lesson |
|---|---|---|---|
| Intro | Set the route through the report | Three named analysis stages and scope information | A short orientation helps when exploration is complex |
| Network | Diagnose operating conditions | Zone-tier comparison, weather matrix, traffic/delivery scatter, and a takeaway | Each visual has a question connected to network performance |
| Reliability | Explain service differences | SLA breach by delivery-time band; ratings by the same bands; kitchen comparison | Align dimensions so the reader can compare related outcomes |
| Optimization | Prioritize corridors | Value/reliability quadrants, intervention counts, ABC/action matrix, and a named priority corridor | Convert an analytical position into a recognizable decision category |

[September portfolio collage, credited to Ugochukwu Nwasuruba — original portfolio](https://datadna.onyxdata.co.uk/portfolios/golden-wok-food-delivery-network-intelligence/). The inspected reference image is retained locally.

The [live report](https://app.powerbi.com/view?r=eyJrIjoiM2IyMzk3M2MtNTQ4Ni00ODViLTliNDctZDNlZWNlNWE2ODhlIiwidCI6IjUwOWU3OGY0LTQ0MTctNDkyNi05MzFjLTQ3YzVjNWQwMThlZCIsImMiOjF9) allowed the following sampled checks:

- **Navigation:** the native page controls and the report's named analysis buttons reached all four public pages.
- **Filtering:** on Network, All kitchens/2024 showed 2,500 orders, 49.32% SLA achievement, and 52.57 average delivery time. Selecting Yaba Central changed these to 633, 49.76%, and 53.81, and changed the takeaway's leading zone and weather category.
- **Reset:** the reset control restored All kitchens/2024; subsequent pages displayed the full-scope results.
- **Help:** the overlay opened and closed and pointed out navigation, filters, KPI areas, reset, and Home.
- **Selection:** selecting one optimization bubble filtered the headline to one corridor and the supporting matrix to one C-class/service corridor. Selecting an ABC/action matrix cell showed selection but did not visibly narrow the headline cards in that sample; behavior differs by visual.
- **Diagnostics:** the sampled point exposed corridor name, efficiency, breach rate, and order count. Its context menu offered selection, include/exclude, and table options; it did not expose drill-through. Dedicated tooltip-page contents were not comprehensively verified.

### Why this is persuasive—and what to improve

**Assessment:** the final categories distinguish a valuable but unreliable route from an economically weak route. That is a more useful decision than a simple worst-to-best ranking. The creator also explicitly describes testing challenge assumptions before adopting them, a relevant habit for November. [Author explanation](https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-powerbi-dataanalytics-activity-7508448464968716288-f3ma)

The live checks exposed important limits:

- **A filtered recommendation broke grammatically.** The single-corridor state left blanks in the A-class and C-class recommendation clauses. Zero/blank cases need explicit sentences rather than concatenated fragments.
- **Same-label comparisons need reconciliation.** With All kitchens/2024, Network showed average order profit of ₦494.40 with a 0.0% year-over-year comparison, while Optimization showed the same value with −1.3%. This is a visible inconsistency to investigate; its underlying DAX cause was not available.
- **Average SLA-met and SLA-breached durations appear as donut segments.** These are separate group averages, not shares of one duration total. A two-point comparison with a labeled gap is clearer.
- **Ratings occupy a very tight axis range.** The line can make a small difference look large despite the stability headline. Show exact values, a meaningful scale, and group counts.
- **Help is visually useful but largely image-based in the inspected accessibility tree.** Readable appearance alone does not establish keyboard or screen-reader conformance.

**Transfer:** borrow the decision categories and the usable navigation. Improve narrative edge cases, metric consistency, and discoverability of supporting definitions.

## 5. Comparison matrix: what to carry into November

This is a qualitative synthesis, not an invented scorecard. Screenshot capabilities remain untested unless noted above.

| Dimension | July | August | September | November decision |
|---|---|---|---|---|
| Narrative | Disruption → mismatch → exposure → allocation | Performance → drivers → intervention | Conditions → reliability → corridor action | Readiness → evidence → recovery |
| KPI definitions | Ratios and funding per affected worker add context | Prior-year cards make levels interpretable; index method needs detail | Period comparisons and service/economic measures; same-label comparison needs review | Show numerator, denominator, eligibility, and scope; no overall quality score |
| Analytical depth | Compares risk and investment; proposes a scenario | Compares processing and behavior with risk outcomes | Combines economics, reliability, and ABC class | Connect each defect to the health question it blocks |
| Visual hierarchy | Strong chapters and selected metrics | Consistent panels and predictable tabs | Stable sidebar, filters, and takeaways | One headline, four focused cards, two evidence areas, one decision strip |
| Accessibility | Labels help; collage and pale elements need close inspection | Strong overall contrast; small text and fractional axes reduce clarity | Help and redundant labels help; image-based help and low-contrast details remain limits | Text labels, readable type, keyboard order, textual help, tested contrast |
| Interaction | Alternate views visible; tutorial/drill-through author-reported | Selectors and drill labels visible; live behavior unverified | Filters, reset, navigation, and sampled cross-filtering tested | Publish an explicit interaction map and test each narrative state |
| Recommendations | Funding proposal gives the story a destination | Action table links entities to interventions | Named decision groups and a concrete corridor | Every correction must unlock a named analytical question |
| Submission | Cohesive collage, detail shrinks | First page is coherent without an explanation | Clear product route; supporting pages contain the decision | Submit a legible Executive Readiness page plus a working report link |

**Build priority:** a trustworthy central question and defensible measures first; coherent page flow second; reliable interaction third; visual refinement throughout. Expensive decoration and unusual chart types have no demonstrated necessity in these examples.

## 6. November: what the current sources support

### Verified snapshot and path discrepancy

All five raw CSV hashes and all four documentation hashes match the 2 November review. Independent recomputation passed **98 checks**. The current CSVs are directly under `Data Source/`; the documented `Data Source/Original/` files are absent. This task read the existing files explicitly, recorded the actual paths, and made no relocation, repair, or promotion. The preserved package copies also match.

The reproducible verification is the local file `_analyst_workspace/outputs/winner_review/local_evidence_verification.json`. Original findings remain in the local `_analyst_workspace/outputs/initial_review/DATA_REVIEW.md`; definitions are in the organizer-supplied `docs/DATA_DICTIONARY.md`. Generated evidence and organizer materials are deliberately not redistributed in the public repository.

| Evidence | Verified value | Correct interpretation |
|---|---:|---|
| Performance source rows | 40,000 | Records in a file, not patients, valid observations, or distinct health systems |
| Distinct `perf_id` values | 1,001 | A declared-primary-key problem; not evidence that only 1,001 rows should remain |
| Fact rows with exactly one parent in all four dimensions | 29,000 / 40,000 = 72.5% | Structural coverage only; scales, dates, grain, and entity consistency still fail |
| Fact rows ambiguous in at least one direct dimension | 11,000 / 40,000 = 27.5% | Union across four dimension-match checks; do not sum their individual counts |
| Predicted rows after four direct dimension joins | 54,858 | 14,858 extra rows, or 37.145% expansion; a join diagnostic, not additional observations |
| Valid year, quarter, and year-quarter-label fields | 0 / 28 for each rule | No verified calendar row for timeline or pandemic comparisons |
| Invalid A&E four-hour percentage values | 35,995 / 40,000 = 89.9875% | Failures against the documented percentage domain, not a clinical service result |
| Country mismatch where system parent is unique | 35,030 / 35,677 = 98.19% | Conditional eligible population; unrelated to orphan coverage |
| System mismatch where workforce parent is unique | 34,875 / 35,069 = 99.45% | A different conditional population; counts overlap other failures |

For repeated-key reporting, distinguish **rows sharing a key**, **excess key occurrences**, and **exact duplicate rows**. The fact table has 40,000 rows sharing repeated `perf_id` values and 38,999 excess occurrences. Its exact-duplicate excess-row count is zero. Deleting the excess key occurrences would discard differing records without a justified business rule.

### Supportable question matrix

| Intended question | Current state | Reason and route to unlock |
|---|---|---|
| What is wrong with this supplied snapshot? | Supported | Raw-row counts, parent multiplicity, documented-domain tests, and evidenced examples |
| Which countries or healthcare models perform best? | Blocked | Correct identities, unique dimension keys, consistent mappings, verified grain, and metric aggregation |
| How did COVID affect capacity and recovery? | Blocked | Valid calendar mapping, confirmed periods, comparable measures and baseline |
| Are workforce pressures associated with outcomes? | Blocked | Correct workforce/system links and metric scales; effective dates for temporal claims |
| Where should health investment go? | Blocked | Valid measures, justified populations and peer comparisons, explicit decision criteria |
| Does lower spending cause worse outcomes? | Not established | Even repaired cross-sectional correlations would not by themselves establish causality |

The supplied dictionary has no workforce effective-date field. A burnout trend must not be created by repeating a static workforce value across fact dates. The supplied narrative's correlations and recovery claims remain hypotheses.

## 7. Three-page Power BI implementation blueprint

### Shared design and behavior

**Working title:** Health System Evidence Readiness. **Audience:** health leaders evaluating whether evidence is fit for investment and service decisions. The UK remains an eventual analytical anchor; current flags and attribution cannot support a UK-specific filter.

- **Canvas:** 1600 × 900, fixed 16:9; 24-pixel outer margins and 16-pixel gutters. Use a 184-pixel navigation rail; keep a 1344-pixel content area. No separate landing page: the first page must show evidence immediately.
- **Hierarchy:** Segoe UI; 28-pixel page title, 16-pixel explanatory line, 16-pixel chart title, 14-pixel minimum table/body/axis text, and 32-pixel KPI values. Reduce visual count before shrinking text.
- **Palette:** background `#F4F6F8`, white panels, text `#172B4D`, muted text `#425466`, blue selection `#2357A4`, blocked `#A63C2F`, needs clarification `#8A5B00`, supported `#23664F`, untested gray `#586575`. Pair every state with words or an icon; verify actual contrast in Power BI.
- **Navigation:** persistent numbered page names; selected state; Back to Overview on pages 2–3; Reset selections and Help on every page. The help overlay must contain real text and an explicit Close control.
- **Scope:** show review date, source-snapshot identifier, and active evidence filters. A review date is metadata, not a valid date in the healthcare data. Do not add a healthcare-year slicer, country map, or country ranking.
- **Precision:** counts as whole numbers, headline rates to one decimal, detail rates to two. Tooltip shows exact numerator and denominator. Format rates consistently as percentages.
- **States:** keep “not tested,” “blocked,” and “no matching evidence” separate from zero failures. Single-value and no-result selections require complete sentences. Do not show a green pass just because a test could not run.

The specifications below are the subsequent build contract; no model or visuals are created by this review task.

### Page 1 — Executive Readiness

**Decision question:** Which health decisions can this snapshot safely support?

**Headline at the reviewed snapshot:** “Health comparisons are blocked by identity, calendar, and metric errors.” Use this only while the mapped blocking rules fail; derive the status from the selected snapshot, not hard-coded prose.

| Area | Content and visual | Measures and interaction |
|---|---|---|
| Header, y=24–112 | Title, one-sentence purpose, snapshot metadata; no source-table slicer | Snapshot fixed to the reviewed version initially; global scope explicit |
| Cards, y=128–264 | 40,000 performance records; 11,000 ambiguously linked records; 0/28 valid calendar rows; +37.1% potential join expansion | Explicit units. Cards do not filter other visuals. Tooltips explain structural versus business validity |
| Left evidence, y=280–688 | Decision-readiness matrix: question, Supported/Blocked/Not established, and main missing evidence | One row per question in the supportable-question matrix. Selecting a question filters its blocker list, not the global cards |
| Right evidence, y=280–688 | Blocker list grouped into identity, calendar, and metric meaning | Show each blocking rule's own affected/tested count; no stacked sum across overlapping defects. Button opens Page 2 with that rule selected |
| Decision strip, y=704–876 | Three recovery steps and the immediate leadership implication | Link to Page 3. Explain that country investment priorities require corrected data |

**Tooltips:** source-row unit; rule definition; numerator; denominator; missing/not-testable count; affected health question; hash-verification date. Explain why 72.5% structural coverage is not “72.5% ready.”

**Takeaway:** leaders can trust the measured readiness problems; they cannot yet trust the proposed health comparisons. Global cards stay snapshot-wide and must be labeled that way after a question selection.

### Page 2 — Evidence and Consequences

**Decision question:** What precisely blocks the selected health question, and where is the evidence?

| Area | Content and visual | Measures and interaction |
|---|---|---|
| Header and selectors, y=24–128 | Source table and rule family; single-select rule selector | Defaults: all tables, Identity, first blocking rule. Table changes reset incompatible rule selections |
| Metric row, y=144–264 | Failed records; tested records; failure rate; not-testable records | All describe the same rule. Multiple/no rules selected shows “Select one rule” instead of a combined quality percentage |
| Left evidence, y=280–584 | Zero-based horizontal bars comparing rules in the chosen family | Display failed/tested labels. Clicking one bar selects the rule; show that failure sets may overlap |
| Right evidence, y=280–584 | Selected rule definition and affected decision | Expected domain, observed example, precise consequence, evidence status, and correction needed |
| Lower evidence, y=600–876 | Source-record table | Table name, source record ordinal, original key/value, matched-parent count where relevant, expected rule, and result. Default to 20 failed examples; label sample versus full-file count |

**Aggregation:** ratios use failed/tested evaluations for one selected rule; never average rule percentages. A family comparison shows one independent bar per rule. A separate unique affected-record total may be used only when recomputed from source-record identifiers within a single source table.

**Special rule views:** repeated-key detail shows all members and occurrence count; relationship detail distinguishes zero, one, and multiple parents; consistency detail shows child FK, unique parent key, and conflicting parent attribute; calendar detail preserves original malformed strings.

**Tooltips:** rule ID, documented expectation, eligible population, count semantics, source location, and record details. Implement these as text-backed report tooltips. Core rules and counts remain visible without hover.

**Takeaway:** the selected defect has an inspectable basis and a specific analytical consequence. A drill-through/detail path from the rule to its records can remain on this page; do not add another main report page for a sample table.

### Page 3 — Recovery Priorities

**Decision question:** What must be corrected or clarified to unlock useful health analysis?

| Area | Content and visual | Measures and interaction |
|---|---|---|
| Header, y=24–128 | Analytical question and recovery status filters | Default all questions, Open. Status values must reflect documented evidence; no assumed owner acceptance |
| Left area, y=144–424 | Ordered dependency path | Identity/grain → calendar → metric meaning → workforce timing → controlled release. This shows dependencies, not estimated duration |
| Right area, y=144–424 | Selected action and analysis unlocked | Required input, acceptance evidence, proposed responsible role, and blocker state. Never invented cost savings or deadlines |
| Action register, y=440–876 | Prioritized table | Priority, defect, blocked question, action, acceptance criterion, proposed role, status. Selecting a row updates the detail panel; View evidence opens Page 2 with the linked rule |

**Priority policy:** prerequisites and integrity first; then validated decision impact; then reproducible affected/tested counts to distinguish comparable issues. Do not rank dissimilar rules solely by failure count or hide tradeoffs in weighted scoring.

| Priority | Required action | Acceptance evidence | What it unlocks |
|---|---|---|---|
| P0 | Obtain corrected keys/entity mappings and confirmed fact grain | Nonmissing unique declared dimension PKs; intended fact PK/grain confirmed; no unexplained one-to-many multiplication; cross-field contradictions resolved | Attributable country/system comparisons |
| P0 | Obtain the real date mapping | Valid 2018–2024 years, quarters and labels; unique date keys; fact-date joins and period coverage checked | COVID and recovery comparisons |
| P1 | Confirm metric units, scales, populations and exceptions | Domain rules pass or each justified exception is documented; denominators/weights and care-spend share meaning confirmed | Access, outcomes, disease and spending measures |
| P1 | Establish workforce temporal meaning | Organizer supplies effective dates or confirms a strictly static scope; no inferred historical trend | Workforce linkage; trends only if time support exists |
| P2 | Validate a derived release | Source manifest, transformation log, reconciliation, intended grain, metric definitions, and approved exclusions | Promotion through staging to validated Power BI inputs |

Proposed roles are organizer/data provider for source corrections and the project analyst for validation. They are responsibilities to agree, not assigned tasks or messages sent by this work.

**Tooltips:** supporting rule IDs, overlapping populations warning, requested clarification, evidence required to close the action. **Takeaway:** release is conditional on evidence, with clear next steps rather than a vague request to clean the data.

### Data model and measure contract for the later build

Keep raw business tables out of invalid one-to-many relationships. Build a separate audit model from rule results; do not present generated record ordinals as repaired business IDs.

| Internal table | Grain / minimum fields | Behavior |
|---|---|---|
| Snapshot | One version; ID, review date, file hashes and resolved paths | A new file hash creates a new version; no fabricated quality history |
| Rule | One rule; ID, source table/field, family, expectation, eligibility, severity | Single-direction one-to-many filtering of evaluations |
| Evaluation | One snapshot × rule × source record in rule scope; outcome, raw value, source-record reference, parent match count if applicable | Pass, Fail, or NotTestable; preserve missingness separately. Record reference is table + hash + row ordinal |
| AnalysisQuestion and QuestionRule | One question; mapping to its blocking rules | Use explicit selection propagation to relevant rule details; avoid ambiguous bidirectional paths |
| RecoveryAction and ActionRule | One action; proposed role, evidence-based state and closure criterion; mapping to rules | Drives the action table and evidence navigation; no live write-back required |

Cross-field tests are NotTestable when their needed parent is ambiguous. Report that population, not just the conditional failure rate. Missing mandatory values fail a separate completeness rule; nonmissing domain denominators remain explicit.

Define the following measures before drawing visuals:

- **Failed evaluations:** evaluation rows marked Fail in current rule context.
- **Tested evaluations:** Pass + Fail; excludes NotTestable. **Failure rate:** failed/tested, blank with “Not tested” when tested is zero. Publish a percentage only for a single selected rule on Page 2.
- **Rows sharing a key:** all source rows whose declared key occurs more than once. **Excess occurrences:** row count minus distinct key count, with a documented missing-key policy. **Exact duplicates:** a separate full-row test.
- **Ambiguous-dimension fact rows:** distinct source-record references where at least one of the four direct parent counts exceeds one. **Single-parent coverage:** distinct fact records with all four parent counts exactly one divided by all fact records; explicitly structural.
- **Join expansion:** sum of the product of the four parent-match counts minus fact rows, divided by fact rows. The current source has no orphans; if later sources do, separately define inner-join exclusion and left-join multiplicity rather than reusing the same formula silently.
- **Valid calendar rows:** date records passing year, quarter, label, and consistency rules. At the reviewed snapshot, even the three individual domain rules have zero passes.
- **Question status:** Blocked if any mandatory mapped rule fails; Not tested if none fail but any prerequisite lacks evidence; Supported only when every mapped requirement has passed and semantic meaning is documented. This is a decision status, not a percentage score.

The first readiness version has one source snapshot and no time-intelligence calculations. Any later business measure needs its own confirmed grain, aggregation policy, population, comparison period, and units. Rates need valid denominators/weights; a mean of medians is not an aggregate median.

## 8. Contest strategy and prioritized build checklist

### Fit to the actual challenge

The November brief seeks health-system comparisons and priorities, including pandemic recovery and workforce pressures. A readiness-only entry will leave those substantive questions unanswered. That is a genuine contest-fit disadvantage even if its quality analysis is excellent. The published timeline sets the entry deadline at **24 November 2026**. [November challenge](https://datadna.onyxdata.co.uk/challenges/november-2026-datadna-health-system-performance-analytics-challenge/)

Proceed with the readiness report as the immediate defensible product. Before submission, check for a corrected organizer export. If it resolves the blockers, move the main story toward **where performance diverges → what evidence explains the differences → what leaders should investigate or prioritize**, retaining readiness as supporting detail. Do not promise a winner or claim that identifying data defects compensates automatically for missing the main analytical brief.

If the source remains unsuitable, submit an explicitly scoped readiness report rather than unsupported country rankings. External clinical benchmarks would be a separate scope and require confirmed contest suitability; this guide does not substitute them for the challenge data.

### Build in this order

1. **Freeze evidence:** retain source hashes and the raw snapshot; reconcile the documented versus actual source paths before configuring refresh. Do not load the preserved duplicate package as extra data.
2. **Write the semantic contract:** record each question, required rules, numerator/denominator, eligible population, and closure evidence. Mark the unsupported business questions visibly.
3. **Create reproducible audit inputs:** use source-record references and long-form evaluations. Keep scripts in the analyst workspace; provisional tables in staging and validated inputs in the agreed validated-data folder.
4. **Build Page 1 first:** make the evidence and leadership consequence understandable before expanding to supporting pages.
5. **Build Page 2 and evidence navigation:** test repeated keys, conditional populations, and overlapping failures. Verify that selected rule details match the displayed counts.
6. **Build Page 3:** connect recovery actions to the evidence and questions they unlock. Avoid arbitrary composite scoring, invented financial effects, and fictitious commitments.
7. **Wire navigation and help:** visible filter context, reset, text-based guide, tooltips, and a clear return path. Keep necessary definitions outside hover-only controls.
8. **Check the cases below; then refine presentation:** align panels and labels, use one type system, and remove visual elements that do not help the decision.
9. **Prepare the entry:** export one readable Executive Readiness image, provide the working report link, and write a concise explanation of the decision, evidence, and unresolved scope. Test the public viewing route before sending anything.

### Acceptance scenarios for the later Power BI build

| Scenario | Required result |
|---|---|
| Baseline snapshot | Exact counts reconcile to the evidence table above; rates derive from counts; 98 reconciliation checks remain green for this hash set |
| Key terminology | 40,000 fact rows sharing a repeated PK is never labeled 40,000 exact duplicates; 38,999 excess occurrences remains a separate quantity |
| Source-table/rule selection | Cards, bars, records, definitions and takeaway share the same rule and eligible population; incompatible selectors reset |
| Multiple rules or source tables | No unqualified overall failure percentage; any combined evaluation total is labeled evaluations, not distinct records |
| Conditional cross-field check | Unique-parent denominator and excluded ambiguous records are both shown |
| Missing, untested, no matches | Distinct text states; no misleading zero or green pass |
| Single failed record / no failures | Complete grammatical narrative, explicit singular/plural handling, and no missing recommendation fragments |
| Question navigation and reset | Rule selection passes to evidence; Back is predictable; Reset returns the stated snapshot defaults |
| Refresh with changed hashes | Old counts are not reused as current; new version is validated and limitations follow through to every page |
| Accessibility | Keyboard traversal and focus work; core content is text-backed; contrast, grayscale interpretation and meaningful labels are checked in the actual report |
| Submission image | At ordinary viewing size, title, denominators, main blocker and next action can be read without opening tiny collage panels |
| Final claim check | No invented health trend, geography, causal mechanism, corrected scale, benefit estimate, or validated-data claim |

### After corrected data arrives

Confirm corrected files and definitions → rerun all integrity and domain checks → resolve true fact grain and valid weighting → validate time coverage and workforce temporal scope → publish maintained KPI definitions → build the health-performance story → reconcile totals and filtered narratives → export the final submission.

Keep the source correction trail. A corrected-looking chart without a defensible correction trail would repeat the problem this readiness report is meant to solve.

## Evidence index

| Reference | What it supports |
|---|---|
| [July organizer results](https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-july-2026-activity-7488883807488585728-zEsD) | Winner, judge, published rationale |
| [July portfolio](https://datadna.onyxdata.co.uk/portfolios/the-ai-reskilling-gap/) and [author explanation](https://www.linkedin.com/posts/gabriele-toscano-928188234_onyxdata-datavisualization-powerbi-activity-7482716776112373760-W44k) | Original collage, four-page concept, author-reported capabilities |
| [August organizer results](https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-august-2026-activity-7500096906250092545-FrSk) | Winner, judge, published rationale |
| [August portfolio](https://datadna.onyxdata.co.uk/portfolios/african-gig-economy-and-digital-wallet-risk-report/) and [author submission](https://www.linkedin.com/posts/brian-sule-109293197_datadna-onyxdata-powerbi-activity-7496584323047870465-wAtN) | Four original views and intended analytical flow |
| [September author winner post](https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-onyxdata-powerbi-activity-7511097792983986178-f3AF) | Creator's award and feedback account; original organizer post remains unverified |
| [September portfolio](https://datadna.onyxdata.co.uk/portfolios/golden-wok-food-delivery-network-intelligence/) and [submission](https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-powerbi-dataanalytics-activity-7508448464968716288-f3ma) | Attribution, report URL, original collage, author's design explanation |
| [September challenge](https://datadna.onyxdata.co.uk/challenges/september-2026-datadna-golden-wok-food-delivery-analytics-challenge/) | Published Power BI rubric and separate AI-feedback description |
| [November challenge](https://datadna.onyxdata.co.uk/challenges/november-2026-datadna-health-system-performance-analytics-challenge/) | Challenge purpose and published entry date |
| Local initial review and independent reconciliation (paths above) | Local readiness evidence, definitions, hashes, and reproducible counts; obtain source files from the organizer before reproducing |

Original dashboard images remain credited third-party reference material, retained locally for this review. The blueprint and critique are original project documentation. No public artifact or third-party message was created.
