"""Build the Play Console translation import file from play-listings.md.

Parses store-listing/translations/play-listings.md, enforces Play's character
limits, and writes play-listing-translations.csv next to it.

Usage:
    python scripts/build_store_listings.py          # validate + write CSV
    python scripts/build_store_listings.py --check  # validate only

Exits non-zero if any field is over its limit, so this can gate a listing update.
"""

import argparse
import csv
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SOURCE = REPO / "store-listing" / "translations" / "play-listings.md"
CSV_OUT = REPO / "store-listing" / "translations" / "play-listing-translations.csv"

LIMITS = {"title": 30, "short_description": 80, "full_description": 4000}

MARKER = re.compile(r"^### (LOCALE|TITLE|SHORT|FULL)(?::\s*(.*))?$")
FIELD_OF = {"TITLE": "title", "SHORT": "short_description", "FULL": "full_description"}


def parse(text):
    """Return [{locale, title, short_description, full_description}, ...]."""
    entries = []
    current = None
    field = None
    buffer = []

    def flush():
        if current is not None and field is not None:
            current[FIELD_OF[field]] = "\n".join(buffer).strip()

    for line in text.splitlines():
        m = MARKER.match(line)
        if not m:
            if field is not None:
                buffer.append(line)
            continue
        kind, inline = m.group(1), (m.group(2) or "").strip()
        flush()
        buffer = []
        if kind == "LOCALE":
            current = {"locale": inline}
            entries.append(current)
            field = None
        else:
            if current is None:
                raise SystemExit(f"'### {kind}' appears before any '### LOCALE:'")
            field = kind
    flush()

    for e in entries:
        missing = [f for f in LIMITS if not e.get(f)]
        if missing:
            raise SystemExit(f"{e['locale']}: missing {', '.join(missing)}")
    return entries


def validate(entries):
    """Print a length report. Return True if every field is within its limit."""
    ok = True
    width = max(len(e["locale"]) for e in entries)
    for e in entries:
        parts = []
        for f, limit in LIMITS.items():
            n = len(e[f])
            over = n > limit
            ok &= not over
            parts.append(f"{f.split('_')[0]} {n}/{limit}{'  ** OVER **' if over else ''}")
        print(f"  {e['locale']:<{width}}  " + " | ".join(parts))
    return ok


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="validate without writing")
    args = ap.parse_args()

    entries = parse(SOURCE.read_text(encoding="utf-8"))
    print(f"Parsed {len(entries)} locales from {SOURCE.relative_to(REPO)}\n")
    ok = validate(entries)

    if not ok:
        print("\nOver limit - shorten the offending fields before importing.")
        return 1

    if args.check:
        print("\nAll fields within limits.")
        return 0

    # utf-8-sig: Play's importer and Excel both need the BOM to detect UTF-8,
    # otherwise diacritics and Japanese arrive mangled.
    with CSV_OUT.open("w", encoding="utf-8-sig", newline="") as fh:
        w = csv.writer(fh, quoting=csv.QUOTE_ALL, lineterminator="\r\n")
        w.writerow(["locale", "title", "short_description", "full_description"])
        for e in entries:
            w.writerow([e["locale"], e["title"], e["short_description"], e["full_description"]])

    print(f"\nAll fields within limits.\nWrote {CSV_OUT.relative_to(REPO)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
