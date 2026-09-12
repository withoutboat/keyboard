#!/usr/bin/env python3
"""
apply_layout.py - Apply layout.json to a Vial/VIA keyboard using 'vitaly' CLI.
Usage:
  ./apply_layout.py
"""

import json
import subprocess
import sys
import shutil

def check_vitaly():
    if not shutil.which("vitaly"):
        print("Error: 'vitaly' CLI is not found in PATH.")
        print("Install via cargo: cargo install vitaly")
        print("Or nix-shell: nix-shell -p vitaly (or build from GitHub)")
        sys.exit(1)

def main():
    check_vitaly()
    with open("layout.json", "r") as f:
        data = json.load(f)

    layout = data.get("layout", [])
    print(f"Applying layout ({len(layout)} rows) to connected keyboard via vitaly...")

    for row_idx, row in enumerate(layout):
        for col_idx, keycode in enumerate(row):
            cmd = [
                "vitaly", "set-key",
                "--layer", "0",
                "--row", str(row_idx),
                "--col", str(col_idx),
                keycode
            ]
            print(f"Setting R{row_idx}C{col_idx} -> {keycode}")
            res = subprocess.run(cmd, capture_output=True, text=True)
            if res.returncode != 0:
                print(f"Warning: failed for R{row_idx}C{col_idx}: {res.stderr.strip()}")

    print("Layout application complete!")

if __name__ == "__main__":
    main()
