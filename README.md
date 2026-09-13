# W-Corne / DH747 Keyboard Configuration

Declarative multi-layer configuration and automated keymap drawer for **DH747 W-Corne (46 keys)** split wireless keyboard.

![Keymap Layers](keymap.svg)

---

## Key Features

1. **46 Physical Keys Layout**:
   * 36 main alphas/mods (3 rows x 6 cols per half).
   * 6 thumb keys (3 per half).
   * 4 vertical macro side keys:
     * **Left**: `Caps Lock` (top), `Left Alt` (bottom).
     * **Right**: `F24` (Language switch, top), `Right Alt` (bottom).

2. **Hold / Tap Layer Switching**:
   * **Fn (Lower Layer 1 - Num & Ru: Х Ъ Ё)**:
     * **Hold**: Temporarily activates Lower layer (while held).
     * **Tap**: Locks into Layer 1 (TapDance `TG(1)`). Tap again to return to Base (`TO(0)`).
   * **Del (Raise Layer 2 - Nav, Function & Media)**:
     * **Hold**: Temporarily activates Raise layer (while held).
     * **Tap**: Locks into Layer 2 (TapDance `TG(2)`). Tap again to return to Base (`TO(0)`).

3. **Dedicated Language Switch (`F24`)**:
   * Right half top macro key is mapped to `KC_F24`, while the middle outer key (next to semicolon) is `Right Ctrl`.
   * Bind in `hyprland.conf`:
     ```ini
     bind = , F24, exec, hyprctl switchxkblayout all next
     ```

4. **Layer Status Signaling for Waybar / Hyprland (`F13`, `F14`, `F15`, `F16`)**:
   * `F13`: Base layer active (Default)
   * `F14`: Lower layer active (Numbers / Ru extra letters)
   * `F15`: Raise layer active (Arrows / Navigation / Media)
   * `F16`: Adjust layer active

---

## Flashing / Applying Layout to Keyboard

Prerequisites:
- `vitaly` CLI (`cargo install vitaly`)
- `jq` (`nix-shell -p jq` or package manager)

Run:
```bash
./apply_layout.sh
```
