#!/usr/bin/env bash
set -euo pipefail

# apply_layout.sh - Apply layout.json layers to Vial/VIA keyboard using 'vitaly' and 'jq'

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

layer_count=$(jq '.layers | length' "$LAYOUT_FILE")

echo ""
echo "==> Found $layer_count layers to apply from layout.json..."

for ((layer = 0; layer < layer_count; layer++)); do
  layer_name=$(jq -r ".layers[$layer].name" "$LAYOUT_FILE")
  echo ""
  echo "--- Programming Layer $layer: $layer_name ---"
  
  row_count=$(jq ".layers[$layer].matrix | length" "$LAYOUT_FILE")
  for ((row = 0; row < row_count; row++)); do
    col_count=$(jq ".layers[$layer].matrix[$row] | length" "$LAYOUT_FILE")
    for ((col = 0; col < col_count; col++)); do
      keycode=$(jq -r ".layers[$layer].matrix[$row][$col]" "$LAYOUT_FILE")
      vitaly set-key --layer "$layer" --row "$row" --col "$col" "$keycode" || {
        echo "Warning: failed setting Layer $layer R${row}C${col} -> $keycode"
      }
    done
  done
done

echo ""
echo "==> Done! All layers applied successfully."
