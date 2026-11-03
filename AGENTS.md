# Project working conventions

- Work as a Senior Data Analyst supporting the November 2026 DataDNA Health System Performance challenge. Power BI is the visualization tool.
- Keep the agreed folder structure in `Documentation/PROJECT_STRUCTURE.md` stable. Update that document when a structural change is needed.
- Put assistant scripts, exploratory calculations, working notes, logs and intermediate outputs under `_analyst_workspace/`. Do not scatter these files through the project root, `Dashboard/`, or source folders.
- Use `Data Source/Original/` as the canonical raw CSV input. Preserve raw values and filenames.
- Preserve the organizer's complete supplied package at `DataDNA Dataset Challenge - 2026- 11 - Health System Performance/`. Its `data-copy/` files are reference duplicates; do not load both copies into Power BI.
- Keep the existing data flow: `Data Source/Original/` -> `Data Source/In Progress/` -> `Data Source/Ready To Work/`. Put provisional transformed tables in `In Progress/` and validated Power BI inputs in `Ready To Work/`. Record their inputs, transformations and limitations; do not silently repair dates, identifiers or metric scales.
- Put Power BI projects and report assets in `Dashboard/`. Keep a PBIP file and its generated report/semantic-model folders together.
- Put maintained project documentation in `Documentation/`, and shareable report exports in `Exports/`. Keep draft exports under `_analyst_workspace/outputs/`.
- Before using the current CSVs for business findings, consult `_analyst_workspace/outputs/initial_review/DATA_REVIEW.md`. The initial full-file review found repeated keys, invalid dates and values outside documented domains. The brief's proposed findings remain hypotheses.
- Before continuing project implementation, read `Documentation/PROJECT_TECHNICAL_SPEC.md`, `Documentation/PROJECT_STATUS.md`, and `Documentation/WINNER_REVIEW_AND_HEALTH_BLUEPRINT.md`. Resume the next unverified requirement; do not reconstruct status from chat alone.
- Update the project-status record after meaningful progress with artifact locations, checks actually performed, open limitations, and the next executable action. Keep technical delivery, analytical support, documentation synchronization, and external submission as separate statuses.
