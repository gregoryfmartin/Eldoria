# DEC Private Modes & Terminal Control Sequences

DEC Private Mode sequences use the form `\e[?{Ps}h` (enable) and `\e[?{Ps}l` (disable). These are distinct from standard ANSI SGR sequences and must be used deliberately — misfires can leave the terminal in an unrecoverable state for the user.

---

## Sequences in Active Use

### Cursor Visibility — DECTCEM (`?25`)

The only DEC Private sequences currently implemented in `ATControlSequences.ps1`:

```powershell
Static [String]$CursorHide = "`e[?25l"   # DECTCEM off — hide text cursor
Static [String]$CursorShow = "`e[?25h"   # DECTCEM on  — show text cursor
```

**Usage pattern:**
```powershell
# At the start of any rendering-heavy or animated state
Write-Host "$([ATControlSequences]::CursorHide)"

# When text input is required (e.g., name entry)
Write-Host "$([ATControlSequences]::CursorShow)"
```

**Where used in Eldoria:**

| Screen | Cursor State |
|--------|-------------|
| Title screen (animation) | Hidden |
| Battle screen | Hidden |
| Player setup — name entry | **Shown** |
| Inventory / status menus | Hidden |
| Cleanup | Shown (restore before exit) |

> **Critical:** Always restore cursor visibility (`$CursorShow`) in the `Cleanup` state or on any early exit path. If the process exits while the cursor is hidden, the user's terminal session is degraded.

---

## Important Sequences Not Yet Implemented

These are not in the codebase yet but are relevant for future work:

### Alternate Screen Buffer (`?1049`)

Saves the user's terminal content, switches to a clean screen, and restores on exit. This is the standard pattern for full-screen terminal applications.

```
Enter alternate screen:  \e[?1049h
Exit alternate screen:   \e[?1049l
```

PowerShell snippet:
```powershell
# On game start
Write-Host "`e[?1049h"

# On game end (Cleanup state)
Write-Host "`e[?1049l"
```

Without this, the game's output scrolls the user's existing terminal history. With it, the terminal is cleanly restored when the game exits.

### Mouse Reporting (`?1000`, `?1002`, `?1003`)

Enable/disable mouse button and motion events sent to stdin:

```
Enable normal mouse tracking (button press/release):   \e[?1000h
Disable:                                               \e[?1000l

Enable button-event tracking (drag):                   \e[?1002h
Disable:                                               \e[?1002l

Enable any-event tracking (all motion):                \e[?1003h
Disable:                                               \e[?1003l
```

Mouse events arrive on stdin as: `\e[M{button}{col}{row}` (classic encoding) or `\e[<{params}M` (SGR extended encoding, preferred).

Enable SGR extended encoding: `\e[?1006h`

> Mouse reporting is not yet used in Eldoria's `InputManager`, which uses `[Console]::ReadKey()`. Adding mouse support would require reading raw stdin bytes and parsing the escape sequences.

### Bracketed Paste Mode (`?2004`)

Wraps pasted text in `\e[200~` ... `\e[201~` markers, distinguishing it from typed input. Useful if any text-entry windows accept paste.

```
Enable:   \e[?2004h
Disable:  \e[?2004l
```

### Focus Reporting (`?1004`)

Sends `\e[I` (focus gained) and `\e[O` (focus lost) events. Useful for pausing audio or halting animation when the terminal loses focus.

```
Enable:   \e[?1004h
Disable:  \e[?1004l
```

---

## Implementing a New DEC Private Sequence

### Step 1 — Add the Constant
`Classes/ATStrings/ATControlSequences.ps1`:

```powershell
Class ATControlSequences {
    # ... existing ...
    Static [String]$AlternateScreenEnter = "`e[?1049h"
    Static [String]$AlternateScreenExit  = "`e[?1049l"
    Static [String]$MouseEnableNormal    = "`e[?1000h"
    Static [String]$MouseDisableNormal   = "`e[?1000l"
}
```

### Step 2 — Use in the Appropriate State

For alternate screen (enter/exit in `GameCore`):
```powershell
# At game start, before first draw
Write-Host "$([ATControlSequences]::AlternateScreenEnter)"

# In Cleanup state scriptblock
Write-Host "$([ATControlSequences]::AlternateScreenExit)"
Write-Host "$([ATControlSequences]::CursorShow)"
```

For mouse (enable in TitleScreen, disable in Cleanup):
```powershell
Write-Host "$([ATControlSequences]::MouseEnableNormal)"
```

### Step 3 — Pair Every Enable with a Disable

Every `?{n}h` must have a guaranteed matching `?{n}l` on exit. Put the disable in the `Cleanup` state scriptblock, not in individual screen teardown logic.

---

## Other Standard (Non-DEC) Control Sequences

### Erase Line (`\e[K` variants)

```
\e[0K   Erase from cursor to end of line
\e[1K   Erase from start of line to cursor
\e[2K   Erase entire line
```

Useful for clearing a menu row before redrawing without using `BufferManager`:
```powershell
Write-Host "`e[$($Row);$($Col)H`e[2K"
```

### Erase Display (`\e[J` variants)

```
\e[0J   Erase from cursor to end of screen
\e[1J   Erase from start of screen to cursor
\e[2J   Erase entire display (cursor unchanged)
\e[3J   Erase scrollback buffer
```

`\e[2J` combined with `\e[H` (home cursor) is a full-screen clear:
```powershell
Write-Host "`e[2J`e[H"
```

> Prefer `BufferManager.ClearArea()` for targeted clears within Eldoria's windowing system, as it respects the layout bounds of the 90×40 game area.

### Save / Restore Cursor Position

```
Save cursor:    \e[s   (or DEC: \e 7)
Restore cursor: \e[u   (or DEC: \e 8)
```

Useful when a draw operation must temporarily move the cursor and return:
```powershell
Write-Host "`e[s"        # Save position
# ... draw title bar ...
Write-Host "`e[u"        # Restore position
```

---

## Compatibility Matrix for DEC Sequences

| Sequence | Windows Terminal | iTerm2 | Kitty | Alacritty | xterm |
|----------|-----------------|--------|-------|-----------|-------|
| `?25l/h` Cursor hide/show | ✅ | ✅ | ✅ | ✅ | ✅ |
| `?1049h/l` Alt screen | ✅ | ✅ | ✅ | ✅ | ✅ |
| `?1000h/l` Mouse normal | ✅ | ✅ | ✅ | ✅ | ✅ |
| `?1002h/l` Mouse button | ✅ | ✅ | ✅ | ✅ | ✅ |
| `?1006h/l` SGR mouse ext | ✅ | ✅ | ✅ | ✅ | ✅ |
| `?2004h/l` Bracketed paste | ✅ | ✅ | ✅ | ✅ | ✅ |
| `?1004h/l` Focus reports | ✅ | ✅ | ✅ | ✅ | ✅ |
| `\e[5m` Blink SGR | ✅ | ❌ | ❌ | ❌ | ✅ |

---

## Quality Checklist

- [ ] Every `?{n}h` enable has a guaranteed `?{n}l` disable in the `Cleanup` state
- [ ] Cursor is always shown (`?25h`) before process exit or on any error path
- [ ] New DEC constants added to `ATControlSequences.ps1` as `Static [String]` properties
- [ ] Alternate screen enter/exit added to `GameCore` start and `Cleanup` state (if implementing `?1049`)
- [ ] Blink SGR (`\e[5m`) not used for critical game feedback — falls back gracefully on macOS / Linux
- [ ] Mouse reporting disabled (`?1000l` + `?1006l`) in `Cleanup` if it was enabled during the session
