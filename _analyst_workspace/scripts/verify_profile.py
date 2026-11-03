"""Independently reconcile consequential profiling results using in-memory SQLite."""

import csv
import hashlib
import json
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "_analyst_workspace" / "outputs" / "initial_review"


def main():
    report = json.loads((OUT / "evidence_report.json").read_text(encoding="utf-8"))
    connection = sqlite3.connect(":memory:")
    for table in report["tables"]:
        name = table["table"]
        path = ROOT / "Data Source" / "Original" / f"{name}.csv"
        with path.open(encoding="utf-8-sig", newline="") as source:
            reader = csv.reader(source)
            fields = next(reader)
            columns = ", ".join(f'"{field}" TEXT' for field in fields)
            connection.execute(f'CREATE TABLE "{name}" ({columns})')
            placeholders = ", ".join("?" for _ in fields)
            connection.executemany(f'INSERT INTO "{name}" VALUES ({placeholders})', reader)

    checks = []

    def check(name, sql, expected):
        actual = connection.execute(sql).fetchone()[0]
        checks.append({"name": name, "sql": sql, "expected": expected,
                       "actual": actual, "passed": actual == expected})

    for table in report["tables"]:
        name, pk = table["table"], table["primary_key"]
        check(f"{name}: row count", f'SELECT COUNT(*) FROM "{name}"', table["rows"])
        check(f"{name}: distinct PK", f'SELECT COUNT(DISTINCT "{pk}") FROM "{name}"', table["distinct_primary_keys"])
    for relation in report["relationships"]:
        child, fk = relation["child_table"], relation["foreign_key"]
        parent, pk = relation["parent_table"], relation["parent_key"]
        sql = f'SELECT COUNT(*) FROM "{child}" c WHERE NOT EXISTS (SELECT 1 FROM "{parent}" p WHERE p."{pk}" = c."{fk}")'
        check(f"{child}.{fk}: unmatched parent", sql, relation["orphan_rows"])
    check("four-dimension inner join rows", """
        SELECT COUNT(*) FROM fact_health_performance f
        JOIN dim_country c ON c.country_id = f.country_id
        JOIN dim_date d ON d.date_id = f.date_id
        JOIN dim_health_system s ON s.system_id = f.system_id
        JOIN dim_workforce w ON w.workforce_id = f.workforce_id
    """.strip(), report["join_coverage"]["predicted_four_inner_join_rows"])
    ae_check = next(d for d in report["domain_checks"] if d["column"] == "ae_4hr_target_pct")
    check("A&E target out of bounds", "SELECT COUNT(*) FROM fact_health_performance WHERE CAST(ae_4hr_target_pct AS REAL) < 0 OR CAST(ae_4hr_target_pct AS REAL) > 100", ae_check["failed"])
    quarter_check = next(d for d in report["domain_checks"] if d["table"] == "dim_date" and d["column"] == "quarter")
    check("invalid quarter values", "SELECT COUNT(*) FROM dim_date WHERE quarter NOT IN ('1','2','3','4')", quarter_check["failed"])
    for source in report["manifest"]:
        with (ROOT / source["source"]).open("rb") as stream:
            digest = hashlib.file_digest(stream, "sha256").hexdigest()
        checks.append({"name": f"{source['table']}: source hash unchanged", "passed": digest == source["sha256"]})
    summary = {"method": "Full-file independent SQLite reconciliation and source-hash verification",
               "checks": checks, "all_passed": all(c["passed"] for c in checks)}
    (OUT / "verification.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"checks": len(checks), "all_passed": summary["all_passed"]}))
    if not summary["all_passed"]:
        raise SystemExit("Reconciliation failed; inspect verification.json")


if __name__ == "__main__":
    main()
