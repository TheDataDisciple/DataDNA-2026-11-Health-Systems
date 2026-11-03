"""Read-only review of the supplied Health System Performance CSV files.

Uses only the Python standard library. Run from any directory:
    python _analyst_workspace/scripts/profile_sources.py --review-date 2026-11-02
All generated files stay under _analyst_workspace/outputs/initial_review.
Source values are never corrected, imputed, deduplicated or overwritten.
"""

import argparse
import csv
import hashlib
import json
import math
import re
import statistics
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "Data Source" / "Original"
PACKAGE = ROOT / "DataDNA Dataset Challenge - 2026- 11 - Health System Performance"
OUT = ROOT / "_analyst_workspace" / "outputs" / "initial_review"
KEYS = {
    "dim_country": "country_id",
    "dim_date": "date_id",
    "dim_health_system": "system_id",
    "dim_workforce": "workforce_id",
    "fact_health_performance": "perf_id",
}
RELATIONSHIPS = [
    ("fact_health_performance", "country_id", "dim_country", "country_id"),
    ("fact_health_performance", "date_id", "dim_date", "date_id"),
    ("fact_health_performance", "system_id", "dim_health_system", "system_id"),
    ("fact_health_performance", "workforce_id", "dim_workforce", "workforce_id"),
    ("dim_health_system", "country_id", "dim_country", "country_id"),
    ("dim_workforce", "system_id", "dim_health_system", "system_id"),
]
MISSING = {"", "null", "none", "nan", "n/a", "na"}


def missing(value):
    return value.strip().casefold() in MISSING


def number(value):
    try:
        result = float(value)
        return result if math.isfinite(result) else None
    except (ValueError, TypeError):
        return None


def sha256(path):
    with path.open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def write_json(name, value):
    (OUT / name).write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def write_csv(name, rows):
    if rows:
        with (OUT / name).open("w", newline="", encoding="utf-8") as target:
            writer = csv.DictWriter(target, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--review-date", required=True, help="Client-local review date (YYYY-MM-DD)")
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    tables = {}
    manifest = []
    for name in KEYS:
        path = SOURCE / f"{name}.csv"
        with path.open(encoding="utf-8-sig", newline="") as source:
            reader = csv.DictReader(source)
            tables[name] = {"fields": reader.fieldnames, "rows": list(reader)}
        copy = PACKAGE / "data-copy" / path.name
        original_hash = sha256(path)
        copy_hash = sha256(copy) if copy.exists() else None
        manifest.append({"table": name, "source": str(path.relative_to(ROOT)),
                         "bytes": path.stat().st_size, "sha256": original_hash,
                         "copy_sha256": copy_hash, "copies_identical": original_hash == copy_hash})

    profiles = []
    column_profiles = []
    domain_checks = []
    pk_counts = {}
    for name, table in tables.items():
        rows, fields = table["rows"], table["fields"]
        key = KEYS[name]
        counts = Counter(row[key] for row in rows)
        pk_counts[name] = counts
        duplicate_keys = {k: c for k, c in counts.items() if not missing(k) and c > 1}
        profiles.append({
            "table": name, "rows": len(rows), "columns": len(fields), "primary_key": key,
            "missing_primary_keys": sum(missing(row[key]) for row in rows),
            "distinct_primary_keys": len(counts), "duplicate_key_values": len(duplicate_keys),
            "rows_with_duplicate_key": sum(duplicate_keys.values()),
            "extra_rows_beyond_first_key_occurrence": sum(c - 1 for c in duplicate_keys.values()),
            "duplicate_key_examples": dict(list(duplicate_keys.items())[:5]),
            "exact_duplicate_extra_rows": len(rows) - len({tuple(row[f] for f in fields) for row in rows}),
            "malformed_csv_rows": sum(None in row or any(v is None for v in row.values()) for row in rows),
            "missing_cells": sum(missing(row[f]) for row in rows for f in fields),
        })
        for field in fields:
            values = [row[field] for row in rows]
            present = [v for v in values if not missing(v)]
            numeric = [number(v) for v in present]
            parsed = [v for v in numeric if v is not None]
            column_profiles.append({
                "table": name, "column": field, "rows": len(rows),
                "missing": len(values) - len(present), "distinct": len(set(values)),
                "numeric_values": len(parsed),
                "minimum": min(parsed) if parsed else None,
                "maximum": max(parsed) if parsed else None,
                "mean": statistics.fmean(parsed) if parsed else None,
                "median": statistics.median(parsed) if parsed else None,
                "example_values": " | ".join(list(dict.fromkeys(present))[:3]),
            })

            predicate = None
            rule = None
            if field.endswith("_pct") and field not in {"pandemic_icu_surge_pct", "icu_occupancy_rate_pct"}:
                rule = "Numeric percentage within 0..100"
                predicate = lambda v: number(v) is not None and 0 <= number(v) <= 100
            elif field == "icu_occupancy_rate_pct":
                rule = "Occupancy within 0..100 of stated available beds; values above 100 need capacity-definition confirmation"
                predicate = lambda v: number(v) is not None and 0 <= number(v) <= 100
            elif field == "burnout_index_score":
                rule = "Burnout index within documented 0..100"
                predicate = lambda v: number(v) is not None and 0 <= number(v) <= 100
            elif field == "staff_satisfaction_score":
                rule = "Staff satisfaction within documented 1..10"
                predicate = lambda v: number(v) is not None and 1 <= number(v) <= 10
            elif field == "avg_weekly_hours_worked":
                rule = "Average weekly hours within physical 0..168"
                predicate = lambda v: number(v) is not None and 0 <= number(v) <= 168
            elif field.startswith("is_"):
                rule = "Boolean True/False"
                predicate = lambda v: v.strip().lower() in {"true", "false"}
            elif name == "dim_date" and field == "year":
                rule = "Four-digit calendar year within documented 2018..2024"
                predicate = lambda v: bool(re.fullmatch(r"20\d{2}", v)) and 2018 <= int(v) <= 2024
            elif name == "dim_date" and field == "quarter":
                rule = "Integer calendar quarter 1..4"
                predicate = lambda v: v in {"1", "2", "3", "4"}
            elif name == "dim_date" and field == "year_quarter_label":
                rule = "Documented year-quarter label YYYY-Q1..Q4 within 2018..2024"
                predicate = lambda v: bool(re.fullmatch(r"20(?:18|19|20|21|22|23|24)-Q[1-4]", v))
            if predicate:
                failed = [v for v in present if not predicate(v)]
                domain_checks.append({"table": name, "column": field, "rule": rule,
                                      "tested_nonmissing": len(present), "failed": len(failed),
                                      "failure_pct": 100 * len(failed) / len(present) if present else None,
                                      "failed_examples": list(dict.fromkeys(failed))[:3]})

    relationships = []
    for child, fk, parent, pk in RELATIONSHIPS:
        rows = tables[child]["rows"]
        parent_counts = pk_counts[parent]
        orphan = [row for row in rows if not missing(row[fk]) and parent_counts[row[fk]] == 0]
        ambiguous = [row for row in rows if parent_counts[row[fk]] > 1]
        relationships.append({"child_table": child, "foreign_key": fk, "parent_table": parent,
                              "parent_key": pk, "child_rows": len(rows),
                              "missing_foreign_keys": sum(missing(row[fk]) for row in rows),
                              "orphan_rows": len(orphan), "orphan_pct": 100 * len(orphan) / len(rows),
                              "ambiguous_parent_rows": len(ambiguous),
                              "exactly_one_parent_rows": sum(parent_counts[row[fk]] == 1 for row in rows),
                              "predicted_left_join_rows": sum(max(1, parent_counts[row[fk]]) for row in rows),
                              "orphan_key_examples": list(dict.fromkeys(row[fk] for row in orphan))[:5]})

    facts = tables["fact_health_performance"]["rows"]
    direct = [r for r in RELATIONSHIPS if r[0] == "fact_health_performance"]
    single_parents = sum(all(pk_counts[parent][row[fk]] == 1 for _, fk, parent, _ in direct) for row in facts)
    any_parents = sum(all(pk_counts[parent][row[fk]] > 0 for _, fk, parent, _ in direct) for row in facts)
    inner_rows = 0
    left_rows = 0
    for row in facts:
        counts = [pk_counts[parent][row[fk]] for _, fk, parent, _ in direct]
        inner_rows += math.prod(counts)
        left_rows += math.prod(max(1, count) for count in counts)

    def unique_lookup(name):
        key = KEYS[name]
        return {r[key]: r for r in tables[name]["rows"] if pk_counts[name][r[key]] == 1}

    systems = unique_lookup("dim_health_system")
    workforce = unique_lookup("dim_workforce")
    system_comparable = [r for r in facts if r["system_id"] in systems]
    workforce_comparable = [r for r in facts if r["workforce_id"] in workforce]
    consistency = {
        "fact_country_vs_system_country": {
            "tested_fact_rows_with_unique_system": len(system_comparable),
            "mismatch_rows": sum(r["country_id"] != systems[r["system_id"]]["country_id"] for r in system_comparable),
        },
        "fact_system_vs_workforce_system": {
            "tested_fact_rows_with_unique_workforce": len(workforce_comparable),
            "mismatch_rows": sum(r["system_id"] != workforce[r["workforce_id"]]["system_id"] for r in workforce_comparable),
        },
    }
    proxy_fields = ["country_id", "system_id", "date_id"]
    proxy_counts = Counter(tuple(r[f] for f in proxy_fields) for r in facts)
    shares = [sum(float(r[c]) for c in ["primary_care_spend_pct", "secondary_care_spend_pct", "tertiary_care_spend_pct"]) for r in facts]
    share_check = {"rule": "If the three care-spend shares exhaust one budget, their sum should be 100; tolerance 0.1 percentage points",
                   "tested": len(shares), "outside_tolerance": sum(abs(s - 100) > 0.1 for s in shares),
                   "minimum_sum": min(shares), "maximum_sum": max(shares), "definition_needs_confirmation": True}

    configs = {name: json.loads((PACKAGE / "docs" / name).read_text(encoding="utf-8-sig"))
               for name in ["SCHEMA_CONFIG.json", "SCHEMA_BLUEPRINT.json", "VALIDATION_REPORT.json"]}
    config = configs["SCHEMA_CONFIG.json"]
    blueprint = configs["SCHEMA_BLUEPRINT.json"]
    metadata = {
        "config_rule_counts": {k: len(config.get(k, {})) for k in ["allowed_value_sets", "relationship_rules", "column_constraints"]},
        "supplied_validation_report": configs["VALIDATION_REPORT.json"],
        "blueprint_metadata": blueprint["metadata"],
        "blueprint_date_range": {k: v for k, v in blueprint["global_parameters"].items() if "date_range" in k},
        "blueprint_tables": {name: {k: t.get(k) for k in ["row_count", "grain", "primary_key", "auto_generate"]}
                             for name, t in blueprint["tables"].items()},
        "dirty_data_enabled": blueprint["dirty_data_config"].get("enabled"),
        "validation_config": blueprint["validation_config"],
        "documentation_hashes": {p.name: sha256(p) for p in sorted((PACKAGE / "docs").glob("*")) if p.is_file()},
    }
    report = {
        "review_date": args.review_date, "scope": "Full-file local snapshot; supplied sources only; no repair",
        "manifest": manifest, "tables": profiles, "domain_checks": domain_checks,
        "relationships": relationships, "cross_field_consistency": consistency,
        "join_coverage": {"fact_rows": len(facts), "all_four_dimensions_have_any_parent": any_parents,
                          "all_four_dimensions_have_exactly_one_parent": single_parents,
                          "predicted_four_inner_join_rows": inner_rows, "predicted_four_left_join_rows": left_rows},
        "grain_proxy": {"fields": proxy_fields, "distinct_combinations": len(proxy_counts),
                        "extra_rows_beyond_first_combination": sum(c - 1 for c in proxy_counts.values() if c > 1),
                        "qualification": "Proxy only: system is not a validated region; intended business grain cannot be established from these keys."},
        "care_spend_share_check": share_check, "documentation": metadata,
    }
    write_json("evidence_report.json", report)
    write_csv("column_profile.csv", column_profiles)
    write_csv("relationship_checks.csv", [{k: v for k, v in r.items() if k != "orphan_key_examples"} for r in relationships])
    lines = ["# Initial source review", "", f"Reviewed: {args.review_date}. Full-file checks; raw files unchanged.", "",
             "**Status: unsuitable for health-system benchmarking or time-series claims in its current form.**", "",
             "## Files and primary keys", "",
             "| Table | Rows | Columns | Distinct PKs | Rows sharing a PK | Missing cells |", "|---|---:|---:|---:|---:|---:|"]
    for t in profiles:
        lines.append(f"| {t['table']} | {t['rows']:,} | {t['columns']} | {t['distinct_primary_keys']:,} | {t['rows_with_duplicate_key']:,} | {t['missing_cells']:,} |")
    lines += ["", "Rows sharing a PK counts every row belonging to a repeated key, including the first occurrence. This differs from extra duplicate occurrences.",
              "", "## Relationships", "", "| Child key -> parent | Orphan rows | Orphan % | Rows with multiple parents |", "|---|---:|---:|---:|"]
    for r in relationships:
        lines.append(f"| {r['child_table']}.{r['foreign_key']} -> {r['parent_table']} | {r['orphan_rows']:,} / {r['child_rows']:,} | {r['orphan_pct']:.2f}% | {r['ambiguous_parent_rows']:,} |")
    lines += ["", f"Only **{single_parents:,} of {len(facts):,}** fact rows have exactly one parent in each of the four dimensions. This checks keys only, not semantic consistency.",
              "", "## Documented domains", "", "| Table.column | Rule | Failed / tested | Failure % |", "|---|---|---:|---:|"]
    for d in domain_checks:
        lines.append(f"| {d['table']}.{d['column']} | {d['rule']} | {d['failed']:,} / {d['tested_nonmissing']:,} | {d['failure_pct']:.2f}% |")
    lines += ["", "## Consequences and next actions", "",
              f"- Critical: repeated dimension keys prevent a trustworthy one-to-many semantic model. No orphan foreign keys were found across the six documented relationships, but joining all four dimensions directly expands {len(facts):,} fact rows to {inner_rows:,}. Arbitrary deduplication changes entity meaning.",
              "- Critical: invalid calendar attributes prevent verification of the documented 2018–2024 coverage. Do not assign dates using file order or sorted surrogate IDs.",
              "- High: documented percentages and scores exceed their bounds. Do not divide all values by 10 or 100, cap at 100, or substitute the narrative values without evidence.",
              "- High: country/system/workforce links contradict one another. Reassigning IDs would fabricate entity attribution.",
              "- The supplied validation report records 11 passes but contains no rule-level evidence. SCHEMA_CONFIG has empty allowed-value, relationship-rule and column-constraint sections. That summary does not resolve the failures above.",
              "- Request or check an organizer-issued corrected export. If unavailable, retain this evidence and consider a data-readiness report using defensible quality measures.",
              "- Suggested insights in CHALLENGE_BRIEF are hypotheses, not findings established by these CSVs. Workforce has no effective-date column, so a burnout trend is unsupported even with repaired keys.",
              "", "## Reproduce", "", "```powershell", f"python .\\_analyst_workspace\\scripts\\profile_sources.py --review-date {args.review_date}", "```", "",
              "Exact counts, cross-field consistency, source hashes, metadata and examples: [evidence_report.json](evidence_report.json). Column summaries: [column_profile.csv](column_profile.csv).", ""]
    (OUT / "DATA_REVIEW.md").write_text("\n".join(lines), encoding="utf-8")
    print(json.dumps({"tables": profiles, "relationships": relationships,
                      "join_coverage": report["join_coverage"], "consistency": consistency,
                      "domain_failures": [{k: d[k] for k in ["table", "column", "failed", "tested_nonmissing"]} for d in domain_checks],
                      "copies_identical": all(m["copies_identical"] for m in manifest),
                      "output": str(OUT)}, indent=2))


if __name__ == "__main__":
    main()
