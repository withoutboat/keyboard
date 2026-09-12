#!/usr/bin/env bash
set -euo pipefail

# apply_layout.sh - Apply layout.json to Vial/VIA keyboard using 'vitaly' and 'jq'

if ! command -v vitaly >/dev/null 2>&1; then
  echo "Error: 'vitaly' CLI is not installed or not in PATH."
  echo "Install via cargo: cargo install vitaly"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: 'jq' is required to parse layout.json."
  echo "Run with: nix-shell -p jq --run ./apply_layout.sh"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAYOUT_FILE="${SCRIPT_DIR}/layout.json"

if [ ! -f "$LAYOUT_FILE" ]; then
  echo "Error: $LAYOUT_FILE not found."
  exit 1
fi

echo "==> Connected keyboards:"
vitaly devices || true

echo ""
echo "==> Applying layout from layout.json to Layer 0..."

row_count=$(jq '.layout | length' "$LAYOUT_FILE")

for ((row = 0; row < row_count; row++)); do
  col_count=$(jq ".layout[$row] | length" "$LAYOUT_FILE")
  for ((col = 0; col < col_count; col++)); do
    keycode=$(jq -r ".layout[$row][$col]" "$LAYOUT_FILE")
    echo "Setting R${row}C${col} -> ${keycode}"
    vitaly set-key --layer 0 --row "$row" --col "$col" "$keycode" || {
      echo "Warning: failed to set R${row}C${col} to $keycode"
    }
  done
done

echo ""
echo "==> Done! Layout applied successfully."
