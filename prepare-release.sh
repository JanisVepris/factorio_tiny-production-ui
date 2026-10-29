#!/usr/bin/env bash
set -euo pipefail

# Save the ZIP next to the project folder so it cannot include itself.
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

python3 - "$project_dir" <<'PY'
import json
import os
import re
import sys
import tempfile
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

project = Path(sys.argv[1])
info = json.loads((project / "info.json").read_text(encoding="utf-8"))
name = info["name"]
version = info["version"]
if not re.fullmatch(r"[A-Za-z0-9_-]+", name):
    raise SystemExit("Invalid mod name in info.json")
if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit("Expected an x.x.x version in info.json")

folder = f"{name}_{version}"
destination = project.parent / f"{folder}.zip"
temporary = None
try:
    with tempfile.NamedTemporaryFile(dir=project.parent, suffix=".zip", delete=False) as file:
        temporary = Path(file.name)
    with ZipFile(temporary, "w", compression=ZIP_DEFLATED, compresslevel=9) as archive:
        for directory, subdirectories, filenames in os.walk(project):
            subdirectories[:] = sorted(d for d in subdirectories if d != ".git")
            for filename in sorted(filenames):
                if filename == ".git":
                    continue
                source = Path(directory) / filename
                relative = source.relative_to(project)
                archive.write(source, (Path(folder) / relative).as_posix())
    os.replace(temporary, destination)
    print(f"Release prepared: {destination}")
finally:
    if temporary is not None and temporary.exists():
        temporary.unlink()
PY
