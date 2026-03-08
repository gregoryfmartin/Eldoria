---
name: tui-programming
description: 'TUI (Text User Interface) programming expertise for Eldoria. USE FOR: writing or composing ANSI escape sequences (SGR, cursor positioning, 24-bit color); DEC Private Mode sequences (cursor hide/show, alternate screen buffer, mouse reporting); Sixel graphics protocol and Kitty Graphics Protocol output; quasi-windowing code — drawing borders, labels, menus, chevrons, and composite UI elements using ATString/ATStringComposite/WindowBase/UIEBase; dirty-flag lazy rendering; BufferManager area clearing; adding new scene images or map tile visuals. DO NOT USE FOR: game state machine design (use rpg-game-programming skill); save/load serialization; combat math or entity stats; Pester test authoring.'
argument-hint: 'What TUI task? (ansi-sequences | dec-private | sixel-kitty | window-borders | ui-controls | scene-images | color-system)'
---

# TUI Programming

## What This Skill Produces
Expert guidance for every layer of Eldoria's terminal rendering stack — from raw escape byte generation up through window borders, UI controls, and graphics protocol output.

| Domain | Reference |
|--------|-----------|
| ANSI escape sequences & 24-bit color | [ANSI Sequences](./references/ansi-sequences.md) |
| DEC Private Mode & terminal control | [DEC Private Modes](./references/dec-private-modes.md) |
| Quasi-windowing & UI controls | [Windowing & Controls](./references/windowing-controls.md) |
| Sixel & Kitty Graphics Protocol | [Graphics Protocols](./references/graphics-protocols.md) |

---

## When to Use This Skill

Invoke this skill (type `/tui-programming`) when the task involves:

- Writing or composing ANSI SGR, cursor positioning, or 24-bit color sequences
- Using or adding DEC Private Mode sequences (cursor visibility, mouse, alternate screen)
- Drawing window borders, title bars, labels, menus, or chevron indicators
- Adding a new scene image (map tile, background art) or expanding the color palette
- Outputting Sixel or Kitty protocol graphics in a terminal window
- Diagnosing rendering artifacts: flickering, misaligned elements, stale content

---

## Quick Decision Guide

```
What are you working on?
│
├─ "I need a specific escape code / color format / reset"
│   → Raw sequence reference                → see ansi-sequences.md
│
├─ "Hide cursor, enable mouse, alternate screen buffer"
│   → DEC private modes                     → see dec-private-modes.md
│
├─ "New window, border, label, menu, or chevron"
│   → Windowing & controls                  → see windowing-controls.md
│
├─ "New map tile art / scene background image"
│   → Scene image pipeline                  → see windowing-controls.md § Scene Images
│
└─ "Sixel profile image / Kitty inline graphic"
    → Graphics protocols                    → see graphics-protocols.md
```

---

## Eldoria TUI Layer Stack

```
┌──────────────────────────────────────────────────────┐
│  Game State Logic  (ScriptBlocks in Variables.ps1)   │
├──────────────────────────────────────────────────────┤
│  Window Layer  (WindowBase subclasses)                │
│    ├─ Border rendering (ATStringComposite)            │
│    └─ Content: UIELabel / UIEMenu / SceneImage        │
├──────────────────────────────────────────────────────┤
│  Control Layer  (UIEBase subclasses)                  │
│    ├─ Dirty-flag lazy rendering                       │
│    └─ ATString composition per element                │
├──────────────────────────────────────────────────────┤
│  ATString Layer  (ATString / ATStringComposite)       │
│    ├─ ATStringPrefix → Coords + Decorations + Colors  │
│    └─ ToAnsiControlSequenceString()                   │
├──────────────────────────────────────────────────────┤
│  Primitive Layer  (ATControlSequences)                │
│    ├─ 24-bit FG/BG color strings                      │
│    ├─ SGR decoration codes                            │
│    ├─ Cursor positioning (CUP)                        │
│    └─ DEC Private Mode sequences                      │
├──────────────────────────────────────────────────────┤
│  Color Layer  (ConsoleColor24 / CC*.ps1 palette)      │
│    └─ RGB value holders, 200+ named colors            │
└──────────────────────────────────────────────────────┘
        ↕ Write-Host to stdout
┌──────────────────────────────────────────────────────┐
│  Terminal Emulator  (Windows Terminal / iTerm2 / Kitty)│
└──────────────────────────────────────────────────────┘
```

---

## Procedure

### Step 1 — Identify the Layer
Use the stack diagram above or the quick decision guide to identify which layer the task operates in.

### Step 2 — Load the Reference File
Each reference file contains:
- Exact escape sequences with format descriptions
- Code patterns already established in the codebase
- Step-by-step procedures for common tasks
- Compatibility notes per terminal emulator
- Quality checklist

### Step 3 — Locate Existing Examples
Key entry points before writing new code:

| Task | Where to Look |
|------|--------------|
| Escape sequence constants | `Classes/ATStrings/ATControlSequences.ps1` |
| String/prefix composition | `Classes/ATStrings/ATString.ps1`, `ATStringComposite.ps1` |
| Color definitions | `Classes/ConsoleColor/ConsoleColor24.ps1`, `CC*.ps1` |
| Window border drawing | `Classes/UI/WindowBase.ps1` |
| UI controls | `Classes/UI/Controls/` |
| Scene image pipeline | `Classes/ATStrings/SceneImage.ps1`, `SIInternalBase.ps1` |
| Sixel output | `Resources/Sixel/Profiles.ps1` |
| DEC sequences in use | `ATControlSequences.ps1` → `$CursorHide`, `$CursorShow` |

### Step 4 — Follow Null-Object Pattern
Never use `$null` for optional formatting components. Use the `*None` variants instead:
- `[ATForegroundColorNone]::new()` instead of `$null` foreground
- `[ATBackgroundColorNone]::new()` instead of `$null` background
- `[ATCoordinatesNone]::new()` instead of `$null` coordinates
- `[ATDecorationNone]::new()` instead of `$null` decoration

### Step 5 — Mark Dirty on Change
After updating any UI element's content or color, set `$Element.Dirty = $true`. The element's `Draw()` call will only write to the terminal when dirty, preventing unnecessary I/O.

### Step 6 — Register New Assets
**New color class:** Add `CC[Name]24.ps1` to `Classes/ConsoleColor/`, inherit from `ConsoleColor24` or an existing palette class. Dot-source in `Eldoria.psm1`.

**New scene image:** Add JSON to `Resources/ImageData/`, create class inheriting `SIInternalBase`, register in `$Script:TheSceneImages` in `Variables.ps1`.

**New window:** Create class extending `WindowBase`, implement `Draw()`, declare global instance in `Variables.ps1`, dot-source in `Eldoria.psm1`.

---

## Terminal Compatibility Reference

| Feature | Windows Terminal | iTerm2 | Kitty | Alacritty | xterm |
|---------|-----------------|--------|-------|-----------|-------|
| 24-bit SGR color | ✅ | ✅ | ✅ | ✅ | ✅ |
| Cursor hide/show `?25` | ✅ | ✅ | ✅ | ✅ | ✅ |
| DEC Blink `\e[5m` | ✅ | ❌ | ❌ | ❌ | ✅ |
| Sixel graphics | ✅ (1.21+) | ✅ | ✅ | ❌ | ✅ |
| Kitty Graphics Protocol | ❌ | ❌ | ✅ | ❌ | ❌ |
| Alternate screen `?1049` | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mouse reporting `?1000` | ✅ | ✅ | ✅ | ✅ | ✅ |

**Minimum terminal size:** 90 columns × 40 rows
