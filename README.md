# Corne Wireless (W-Corne / DH747) Keyboard Setup & Notes

Documentation and declarative multi-layer configuration for the **W-Corne (DH747)** split ergonomic keyboard.

![Keymap Visualization](./keymap.svg)

---

## 1. Dual EN / RU Layout Architecture (Windows Standard)

On Linux/Wayland with `kb_layout = "us,ru"`, the key scan-codes correspond directly to standard Windows/QWERTY positions:

* **Layer 0 (Base - QWERTY & ЙЦУКЕН):**
  * `Q..P` -> `Й..З`
  * `A..L, ;` -> `Ф..Д, Ж`
  * `Z..M, ,, ., /` -> `Я..Ь, Б, Ю, .` (стандартная точка в русской раскладке Windows)
  * Dedicated outer key on Row 2 -> **`F24`** (Language toggle for Hyprland).

* **Layer 1 (Lower - Numbers & Russian Extra Letters: Х, Ъ, Ё):**
  * Top row: `` ` `` (**`Ё`** in Russian), `1..0`, `Del`.
  * Middle row: `[` (**`Х`** in Russian), `]` (**`Ъ`** in Russian), `=`, `-`, `\`.
  * Activated by holding the right-hand **`Fn`** thumb key (`MO(1)`).

* **Layer 2 (Raise - Navigation, F1-F12 & Media):**
  * Top row: `F1..F12`.
  * Middle row: Arrow keys (`Left`, `Down`, `Up`, `Right`), `Home`, `PageUp`.
  * Bottom row: Media keys (`Mute`, `Vol-`, `Vol+`, `End`, `PageDown`, `Prev`, `Play`, `Next`).
  * Activated by holding the right-hand **`Ctrl`** thumb key (`MO(2)`).

---

## 2. Language Switching (RU / EN)

The right-half Row 2 outer key is mapped to **`F24`** (`KC_F24`), avoiding any desktop modifier collisions.

### Hyprland Configuration:
Add to `hyprland.lua`:
```lua
hl.bind("", "F24", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))
```

---

## 3. Applying Multi-Layer Layout via CLI

Run from the repository root:
```bash
nix-shell -p jq --run ./apply_layout.sh
```
The script programs Layer 0 (Base), Layer 1 (Lower/Numbers/Х/Ъ/Ё), and Layer 2 (Raise/Nav/Media) directly into the keyboard via `vitaly`.
