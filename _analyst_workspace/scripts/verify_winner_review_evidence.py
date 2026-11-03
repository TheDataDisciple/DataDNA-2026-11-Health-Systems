"""Reconcile the readiness blueprint with immutable raw-source evidence.

Reads the canonical path when present; otherwise explicitly records the current
Data Source root location. No input is changed and no data is promoted.
"""
import argparse
import csv
import hashlib
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "_analyst_workspace/outputs/winner_review"
BASE = ROOT / "_analyst_workspace/outputs/initial_review/evidence_report.json"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    global OUT
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir', type=Path, default=OUT,
                        help='Verification output folder; use a new folder to preserve historical evidence')
    OUT = parser.parse_args().output_dir.resolve()
    baseline = json.loads(BASE.read_text(encoding="utf-8"))
    tables, manifests, checks = {}, [], []

    def check(label, actual, expected):
        checks.append(dict(check=label, actual=actual, expected=expected,
                           passed=actual == expected))

    for entry in baseline["manifest"]:
        canonical = ROOT / entry["source"]
        actual = canonical if canonical.exists() else ROOT / "Data Source" / (entry["table"] + ".csv")
        found_hash = digest(actual)
        package = ROOT / "DataDNA Dataset Challenge - 2026- 11 - Health System Performance/data-copy" / actual.name
        manifests.append(dict(table=entry["table"], expected_path=entry["source"],
                              expected_path_exists=canonical.exists(),
                              actual_path=str(actual.relative_to(ROOT)), sha256=found_hash,
                              baseline_sha256=entry["sha256"],
                              matches_baseline=found_hash == entry["sha256"],
                              package_copy_matches=digest(package) == found_hash))
        check(entry["table"] + " source hash", found_hash, entry["sha256"])
        with actual.open(encoding="utf-8-sig", newline="") as handle:
            tables[entry["table"]] = list(csv.DictReader(handle))

    counters = {}
    for entry in baseline["tables"]:
        name, pk = entry["table"], entry["primary_key"]
        records = tables[name]
        counts = counters[name] = Counter(r[pk] for r in records)
        check(name + " rows", len(records), entry["rows"])
        check(name + " distinct primary keys", len(counts), entry["distinct_primary_keys"])
        check(name + " rows sharing a primary key", sum(n for n in counts.values() if n > 1), entry["rows_with_duplicate_key"])
        check(name + " excess primary-key occurrences", len(records) - len(counts), entry["extra_rows_beyond_first_key_occurrence"])
        exact_extra = len(records) - len({tuple(r.items()) for r in records})
        check(name + " exact duplicate excess rows", exact_extra, entry["exact_duplicate_extra_rows"])

    facts = tables["fact_health_performance"]
    bindings = [("country_id", "dim_country"), ("date_id", "dim_date"),
                ("system_id", "dim_health_system"), ("workforce_id", "dim_workforce")]
    one_parent = sum(all(counters[t][r[f]] == 1 for f, t in bindings) for r in facts)
    check("fact rows with one parent in all four dimensions", one_parent,
          baseline["join_coverage"]["all_four_dimensions_have_exactly_one_parent"])
    joined = 0
    for r in facts:
        multiplicity = 1
        for fk, table in bindings:
            multiplicity *= counters[table][r[fk]]
        joined += multiplicity
    check("predicted four-dimension inner join rows", joined,
          baseline["join_coverage"]["predicted_four_inner_join_rows"])

    for rel in baseline["relationships"]:
        records, parent = tables[rel["child_table"]], counters[rel["parent_table"]]
        fk = rel["foreign_key"]
        prefix = rel["child_table"] + "." + fk
        check(prefix + " orphans", sum(parent[r[fk]] == 0 for r in records), rel["orphan_rows"])
        check(prefix + " multiple parent rows", sum(parent[r[fk]] > 1 for r in records), rel["ambiguous_parent_rows"])

    numeric_bounds = {
        "vacancy_rate_pct": (0, 100), "burnout_index_score": (0, 100),
        "avg_weekly_hours_worked": (0, 168), "staff_satisfaction_score": (1, 10),
        "international_recruit_pct": (0, 100),
    }
    for entry in baseline["domain_checks"]:
        name, field = entry["table"], entry["column"]
        vals = [r[field] for r in tables[name] if r[field].strip()]
        check(name + "." + field + " tested nonmissing", len(vals), entry["tested_nonmissing"])
        if field in ("is_oecd_member", "is_eu_member", "is_uk_nation", "is_pandemic_period"):
            invalid = sum(v.strip().casefold() not in ("true", "false") for v in vals)
        elif field == "year":
            invalid = sum(not (re.fullmatch(r"\d{4}", v) and 2018 <= int(v) <= 2024) for v in vals)
        elif field == "quarter":
            invalid = sum(v not in ("1", "2", "3", "4") for v in vals)
        elif field == "year_quarter_label":
            invalid = sum(not re.fullmatch(r"20(?:18|19|2[0-4])-Q[1-4]", v) for v in vals)
        else:
            low, high = numeric_bounds.get(field, (0, 100))
            invalid = sum(not low <= float(v) <= high for v in vals)
        check(name + "." + field + " domain failures", invalid, entry["failed"])

    for label, parent_table, parent_key, fk, child_value, parent_value, test_key in [
        ("fact_country_vs_system_country", "dim_health_system", "system_id", "system_id", "country_id", "country_id", "tested_fact_rows_with_unique_system"),
        ("fact_system_vs_workforce_system", "dim_workforce", "workforce_id", "workforce_id", "system_id", "system_id", "tested_fact_rows_with_unique_workforce"),
    ]:
        unique = {r[parent_key]: r for r in tables[parent_table] if counters[parent_table][r[parent_key]] == 1}
        eligible = [r for r in facts if r[fk] in unique]
        mismatch = sum(r[child_value] != unique[r[fk]][parent_value] for r in eligible)
        check(label + " eligible", len(eligible), baseline["cross_field_consistency"][label][test_key])
        check(label + " mismatches", mismatch, baseline["cross_field_consistency"][label]["mismatch_rows"])

    docs = ROOT / "DataDNA Dataset Challenge - 2026- 11 - Health System Performance/docs"
    for filename, expected_hash in baseline["documentation"]["documentation_hashes"].items():
        check(filename + " documentation hash", digest(docs / filename), expected_hash)

    result = dict(review_date="2026-11-03", baseline_review_date=baseline["review_date"],
                  method="Independent standard-library recomputation; no input modifications",
                  manifest=manifests, checks=checks,
                  all_checks_passed=all(c["passed"] for c in checks),
                  metrics=dict(fact_rows=len(facts), one_parent_in_all_dimensions=one_parent,
                               one_parent_pct=one_parent / len(facts) * 100,
                               at_least_one_ambiguous_dimension=len(facts) - one_parent,
                               predicted_join_rows=joined, join_extra_rows=joined - len(facts),
                               join_expansion_pct=(joined / len(facts) - 1) * 100),
                  limitations=["One-parent coverage is structural only, not business-valid coverage.",
                               "Failure counts across rules overlap and must not be added as distinct rows.",
                               "Observed source paths differ from the documented canonical paths."])
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "local_evidence_verification.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"passed": result["all_checks_passed"], "checks": len(checks),
                      "metrics": result["metrics"], "source_paths_differ": any(not m["expected_path_exists"] for m in manifests)}, indent=2))
    if not result["all_checks_passed"]:
        raise SystemExit("Evidence differs; inspect local_evidence_verification.json before reusing counts")


if __name__ == "__main__":
    main()
