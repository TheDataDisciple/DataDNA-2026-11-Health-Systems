# Winner review: research and verification record

Review date: 2026-11-03, Europe/Paris. Maintained deliverable: `Documentation/WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md`.

## Scope and agreed choices

- Review July, August and September 2026 first-place entries; apply lessons to November Health rather than the closed October Coffee contest.
- Audience: health leaders. Deliver a Markdown guide and chat summary.
- Immediate concept: data readiness. No PBIP implementation, publication, organizer contact, or submission.
- New assistant evidence remains under `_analyst_workspace/`. Existing source locations and contents were not changed.

## Source register

| ID | Source | Use and evidence boundary |
|---|---|---|
| J1 | https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-july-2026-activity-7488883807488585728-zEsD | Organizer confirms Gabriele Toscano, judge Gus Bavia, and narrative/investment rationale. No full score sheet |
| J2 | https://datadna.onyxdata.co.uk/portfolios/the-ai-reskilling-gap/ | Browser-verified author Gabriele Toscano. One collage contains four pages and six view states |
| J3 | https://www.linkedin.com/posts/gabriele-toscano-928188234_onyxdata-datavisualization-powerbi-activity-7482716776112373760-W44k | Author explains four pages, tutorial, country drill-through, toggles and scenario model. No live report link exposed in inspected post |
| J4 | https://www.linkedin.com/posts/gabriele-toscano-928188234_datadna-datadna-powerbi-activity-7487909655021699073-6TOp | Follow-up post confirms four-page story; no report link exposed |
| A1 | https://www.linkedin.com/posts/onyxdata_onyx-data-datadna-challenge-august-2026-activity-7500096906250092545-FrSk | Organizer confirms Brian Sule, Cindy Jamaeca Balbag, and consistency/insight/contrast rationale |
| A2 | https://datadna.onyxdata.co.uk/portfolios/african-gig-economy-and-digital-wallet-risk-report/ | Author and four original full-page views; three main analysis stages with two driver states |
| A3 | https://www.linkedin.com/posts/brian-sule-109293197_datadna-onyxdata-powerbi-activity-7496584323047870465-wAtN | Author's intended decision progression |
| S1 | https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-onyxdata-powerbi-activity-7511097792983986178-f3AF | Author's first-place and badge account, naming judge John Johnson. Primary author text read in browser; organizer's own September result post was not retrieved |
| S2 | https://www.linkedin.com/posts/ugochukwu-nwasuruba-35928a7a_datadna-powerbi-dataanalytics-activity-7508448464968716288-f3ma | Author submission, public live URL, intended journey, author-reported quality decisions and tooltips |
| S3 | https://datadna.onyxdata.co.uk/portfolios/golden-wok-food-delivery-network-intelligence/ | Same report URL embedded; author appears as ugo nwasuruba. Original collage downloaded and visually inspected |
| S4 | https://app.powerbi.com/view?r=eyJrIjoiM2IyMzk3M2MtNTQ4Ni00ODViLTliNDctZDNlZWNlNWE2ODhlIiwidCI6IjUwOWU3OGY0LTQ0MTctNDkyNi05MzFjLTQ3YzVjNWQwMThlZCIsImMiOjF9 | Live UI checks below; no underlying model/DAX or raw-data audit |
| R1 | https://datadna.onyxdata.co.uk/challenges/september-2026-datadna-golden-wok-food-delivery-analytics-challenge/ | Power BI rubric 10/14/10 and separate 1–5 AI feedback dimensions; no direct results section found |
| N1 | https://datadna.onyxdata.co.uk/challenges/november-2026-datadna-health-system-performance-analytics-challenge/ | Challenge scope and timeline. Entry date 24 November; announcement 30 November. Ignore transient countdown/template submission text as proof of state |

No invented winner scores. No private accounts were signed into. LinkedIn overlays limited some images and older organizer content. Searches and public source navigation did not retrieve the original September organizer result, so the maintained document carries this unresolved provenance limit. The organizer's public company feed exposed recent October results, which were outside the agreed three-entry analysis and were not analyzed.

## Original image provenance

Images are original third-party reference assets, copied into the task evidence folder for inspection. They are not new assistant artwork or Power BI exports.

| Local file under `outputs/winner_review/images/` | Original URL |
|---|---|
| july_01_reskilling_gap.jpg | https://datadna.onyxdata.co.uk/wp-content/uploads/2026/07/5719_1784046443.jpg |
| august_01_overview.png | https://datadna.onyxdata.co.uk/wp-content/uploads/2026/08/Screenshot-2026-08-17-213459-1.png |
| august_02_drivers_transaction.png | https://datadna.onyxdata.co.uk/wp-content/uploads/2026/08/Screenshot-2026-08-17-213607-1.png |
| august_03_drivers_risk.png | https://datadna.onyxdata.co.uk/wp-content/uploads/2026/08/Screenshot-2026-08-17-213640-1.png |
| august_04_intervention.png | https://datadna.onyxdata.co.uk/wp-content/uploads/2026/08/Screenshot-2026-08-17-213704-1.png |
| september_network_intelligence.jpg | https://datadna.onyxdata.co.uk/wp-content/uploads/2026/09/131_1790153890.jpg |

The August browser asset manifest is preserved as `outputs/winner_review/august_asset_manifest.json`. July and September were saved through the browser's observed media download control and copied to the task output directory. Local hashes are in `asset_hashes.json`. Live UI screenshots were visually inspected in the browser tool; the persisted September reference is the creator's portfolio collage, not a fabricated screenshot of our test state.

## Live report checks: September

Tests were sampled UI checks, not a complete functional, performance, or accessibility audit. Rendering was asynchronous; observations below were taken after the relevant measures appeared. No latency benchmark is claimed.

| Action / state | Observed result |
|---|---|
| Intro; native next-page navigation | Four public pages: Intro, Network, Reliability, Optimization |
| Custom analysis buttons | Reliability and Optimization loaded and the selected navigation state changed |
| Network, All kitchens, 2024 | Orders 2,500; SLA achievement 49.32%; distance 17.27; traffic friction 5.40; average delivery time 52.57; average order profit ₦494.40 |
| Network, Yaba Central, 2024 | Orders 633; SLA achievement 49.76%; distance 17.41; friction 5.35; delivery time 53.81; average profit ₦507.53 |
| Dynamic takeaway after kitchen selection | Leading zone changed from Tier 3 to Tier 2; weather changed from Heavy Rain to Overcast; comparison changed to friction lower by 0.12 |
| Reset | All kitchens and 2024 restored; later full-scope optimization cards showed 60 corridors and 13 priority corridors |
| Reliability page | Breach 50.68%; average rating 2.98; time 52.57; >90min orders 14.24%; low-rated orders 38.32%. Donut compares group-average durations, which is not part-to-whole |
| Optimization default | Average profit ₦494.40, comparison −1.3%; cost ₦6,147.20; 60 corridors; 13 Priority, 15 Economic, 16 Service, 16 Protect |
| ABC/action matrix A × Priority selected | Selection indicator appeared; sampled headline totals remained full-scope. Do not claim all visuals cross-filter each other |
| A bubble selected around efficiency 1.03 / breach 73.33% | Selection eventually narrowed report to one corridor, 30 orders, profit ₦15.31K, average profit ₦510.40, C/Service matrix state. Other intervention classes displayed blanks |
| Filtered narrative | Several recommended-action counts were blank inside the sentence; grammatical/plural handling also did not adapt to one corridor. Screenshot/AX evidence was observed live; document quotes only a short fragment |
| Point diagnostic / context menu | Identified Golden Wok Ikeja GRA → Magodo, efficiency 1.03, breach 73.33%, orders 30. Menu: Clear selections, Include, Exclude, Show as a table. No drill-through option observed for that sampled point |
| Help overlay | Open and close both worked; visible instructions explained navigation, filters, reset, KPI area and Home. Content largely appeared as images in accessibility tree |
| Final reset | Default 60 corridors/13 Priority restored; no changes persisted to the report |

Same-label comparison discrepancy: Network's average-order-profit card displayed ₦494.40 and 0.0% vs 2023; Optimization displayed ₦494.40 and −1.3% under the same visible All/2024 scope. This is a displayed discrepancy; no underlying calculation defect is diagnosed without DAX.

Dedicated custom tooltip pages were not fully verified. A context-menu point diagnostic is not evidence of all author-described tooltip contents. No drill-through destination was inferred from the four visible page count.

## Rejected live-link candidates

- `https://lnkd.in/ePYAtBsn`, found in public/mirrored profile material, resolved to a Power BI B2B Sales Performance report. Its title, metrics and context did not match the wallet entry, so it was excluded. Its behavior was not evaluated as August's work.
- `https://lnkd.in/dfmw4Wdy` resolved to A1, the organizer's award announcement, not a live report.
- July's original and follow-up posts and portfolio contained no matching public live URL in the inspected content. Tutorial and country drill-through remain author-reported.

## Local evidence

Run from project root:

```powershell
python _analyst_workspace/scripts/verify_winner_review_evidence.py
```

Output: `outputs/winner_review/local_evidence_verification.json`.

The five source CSVs currently reside directly in `Data Source`, while the original manifest points to `Data Source/Original`. The script explicitly records both paths and confirms all original and package-copy hashes. It independently recomputes key statistics, relationships, domain checks, conditional inconsistencies and join multiplication, then verifies the four supplied-document hashes. All 98 assertions passed. The initial review itself was not overwritten.

This verifies the review's statistics, not health-data fitness. It does not mean an unchanged source became suitable for health benchmarking. No date, identifier, scale, entity attribute or raw file was repaired.
