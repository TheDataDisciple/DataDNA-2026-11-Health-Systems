"""Restore canonical raw copies without moving or overwriting existing data."""

import csv
import hashlib
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE_ROOT = ROOT / 'Data Source'
CANONICAL = SOURCE_ROOT / 'Original'
PACKAGE = ROOT / 'DataDNA Dataset Challenge - 2026- 11 - Health System Performance'
OUT = ROOT / '_analyst_workspace/outputs/source_bootstrap'


def sha256(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def main():
    baseline = json.loads((ROOT / '_analyst_workspace/outputs/initial_review/evidence_report.json').read_text(encoding='utf-8'))
    expected = {entry['table']: entry for entry in baseline['manifest']}
    checked = []
    # Check every available input before creating any canonical copy.
    for name in sorted(expected):
        current = SOURCE_ROOT / (name + '.csv')
        canonical = CANONICAL / current.name
        source = current if current.exists() else canonical
        reference = PACKAGE / 'data-copy' / current.name
        wanted = expected[name]['sha256']
        for candidate in (source, reference):
            if not candidate.is_file() or sha256(candidate) != wanted:
                raise RuntimeError(f'Input missing or changed; do not copy: {candidate}')
        if canonical.exists() and sha256(canonical) != wanted:
            raise RuntimeError(f'Canonical file differs; preserve and investigate: {canonical}')
        with source.open(encoding='utf-8-sig', newline='') as stream:
            reader = csv.reader(stream)
            headers = next(reader)
            row_count = sum(1 for row in reader)
        checked.append((name, source, canonical, reference, wanted, headers, row_count))

    for directory in (CANONICAL, SOURCE_ROOT / 'In Progress', SOURCE_ROOT / 'Ready To Work', OUT):
        directory.mkdir(parents=True, exist_ok=True)
    manifest = []
    for name, source, canonical, reference, wanted, headers, row_count in checked:
        copied = not canonical.exists()
        if copied:
            shutil.copyfile(source, canonical)
        if sha256(source) != wanted or sha256(canonical) != wanted or sha256(reference) != wanted:
            raise RuntimeError(f'Hash verification failed after copying {name}')
        manifest.append({
            'table': name, 'existing_source': source.relative_to(ROOT).as_posix(),
            'canonical_source': canonical.relative_to(ROOT).as_posix(),
            'reference_copy': reference.relative_to(ROOT).as_posix(),
            'sha256': wanted, 'bytes': canonical.stat().st_size,
            'rows': row_count, 'columns': headers, 'copied_this_run': copied,
            'source_preserved': True, 'all_three_hashes_match': True,
        })
    identity = '\n'.join(f"{entry['table']}:{entry['sha256']}" for entry in manifest)
    snapshot_id = 'src-' + hashlib.sha256(identity.encode('utf-8')).hexdigest()[:16]
    documents = []
    for relative in ('CHALLENGE_BRIEF.md', 'docs/DATA_DICTIONARY.md', 'docs/SCHEMA_BLUEPRINT.json', 'docs/SCHEMA_CONFIG.json', 'docs/VALIDATION_REPORT.json'):
        path = PACKAGE / relative
        documents.append({'path': path.relative_to(ROOT).as_posix(), 'sha256': sha256(path)})
    result = {
        'schema_version': '1.0', 'review_date': '2026-11-03', 'snapshot_id': snapshot_id,
        'snapshot_id_policy': 'First 16 SHA-256 hex characters of newline-separated sorted table:raw-file-sha256 entries, prefixed src-',
        'operation': 'Copy only; preserve root files and organizer package',
        'sources': manifest, 'documentation': documents,
        'all_hashes_verified': True,
        'limitations': ['Hash verification establishes preservation, not health-data validity.', 'Load canonical copies only; root and package copies are not additional observations.'],
    }
    (OUT / 'source_manifest.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'snapshot_id': snapshot_id, 'files': len(manifest), 'copied': sum(e['copied_this_run'] for e in manifest), 'rows': sum(e['rows'] for e in manifest), 'all_hashes_verified': True}))


if __name__ == '__main__':
    main()
