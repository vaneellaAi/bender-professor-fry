from __future__ import annotations

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
FILES = [
    ROOT / "marge_simpson" / "tasklist.md",
    ROOT / "marge_simpson" / "assessment.md",
]
PLACEHOLDERS = [
    "MS-000X",
    "YYYY-MM-DD",
    "(Area / subsystem name)",
    "(list “must never regress” behaviors)",
    "(instruction)",
    "…",
    "...",
]

failures: list[str] = []
for path in FILES:
    if not path.exists():
        failures.append(f"Missing file: {path}")
        continue
    text = path.read_text(encoding="utf-8")
    for token in PLACEHOLDERS:
        if token in text:
            failures.append(f"Found '{token}' in {path}")

if failures:
    for item in failures:
        print(item)
    sys.exit(1)

print("OK: no tracking placeholders found.")
