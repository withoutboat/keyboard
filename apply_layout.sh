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

echo "==> Configuring settings (Permissive Hold for fast Tap/Hold resolution)..."
vitaly settings -q 8.0 -v true || true

echo "==> Configuring TapDance slots for Layer switching..."
vitaly tapdances -n 0 -v "TG(1) + MO(1) + KC_NO + KC_NO ~ 200" || true
vitaly tapdances -n 1 -v "TG(2) + MO(2) + KC_NO + KC_NO ~ 200" || true

layer_count=$(jq '.layers | length' "$LAYOUT_FILE")

echo ""
echo "==> Found $layer_count layers to apply from layout.json..."

failed_count=0

for ((layer = 0; layer < layer_count; layer++)); do
  layer_name=$(jq -r ".layers[$layer].name" "$LAYOUT_FILE")
  echo ""
  echo "--- Programming Layer $layer: $layer_name ---"
  
  row_count=$(jq ".layers[$layer].matrix | length" "$LAYOUT_FILE")
  for ((row = 0; row < row_count; row++)); do
    col_count=$(jq ".layers[$layer].matrix[$row] | length" "$LAYOUT_FILE")
    for ((col = 0; col < col_count; col++)); do
      keycode=$(jq -r ".layers[$layer].matrix[$row][$col]" "$LAYOUT_FILE")
      vitaly keys --layer "$layer" --position "${row},${col}" --value "$keycode" || {
        echo "Warning: failed setting Layer $layer R${row}C${col} -> $keycode"
        failed_count=$((failed_count + 1))
      }
    done
  done
done

echo ""
if [ "$failed_count" -gt 0 ]; then
  echo "==> Completed with $failed_count error(s)."
  exit 1
fi

echo "==> Done! All layers applied successfully."
