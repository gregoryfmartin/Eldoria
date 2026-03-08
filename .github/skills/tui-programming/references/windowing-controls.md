# Windowing & UI Controls

Eldoria implements a custom quasi-windowing system entirely in ANSI escape sequences. There is no OS windowing API — borders, labels, menus, and all UI chrome are rendered by writing escape sequences to stdout at absolute terminal positions.

---

## Class Hierarchy

```
ATString
    └─ UIEBase
        │   [Boolean]$Dirty       — lazy render guard
        │   [String]$Blank        — blank-padding string for erase-in-place
        │   Draw()                — writes only when Dirty=true
        │
        ├─ UIELabel               — static text label
        │
        ├─ UIEMenuItem            — interactive menu item with ScriptBlock action
        │   [Boolean]$Selected
        │   [ScriptBlock]$Action
        │   ToggleSelected()
        │
        └─ UIEChevron             — cursor/arrow indicator
            UIEChevronTable       — collection of UIEChevron instances

WindowBase                        — window frame (borders + optional title)
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[8]]$BorderDrawColors   — per-corner/edge color
    [Boolean[4]]$BorderDrawDirty          — top/bottom/left/right dirty flags
    [Boolean]$IsActive
    Draw()        — renders dirty border segments + title
    Activate()    — sets IsActive, marks all dirty
    Deactivate()  — clears IsActive

UIEMenu : List[UIEMenuItem]
    [Int]$ActiveIndex
    InitializeMenuItems()
    MoveActiveIndexUp() / MoveActiveIndexDown()
    InvokeItemAction()
    SetAllDirty()
    Draw()
```

---

## WindowBase Border System

### Coordinate Model

A window is defined by two corners:

```
(LeftTop.Row, LeftTop.Column)
        ╭─────────────────╮
        │                 │
        │    content      │
        │                 │
        ╰─────────────────╯
               (RightBottom.Row, RightBottom.Column)
```

Width and height are derived:
```powershell
$Width  = $this.RightBottom.Column - $this.LeftTop.Column
$Height = $this.RightBottom.Row    - $this.LeftTop.Row
```

### Border Character Sets

Border characters are selected from `$Script:CurrentWindowDesign` (a hashtable keyed by `[WindowBorderPart]`):

```powershell
$Script:CurrentWindowDesign = @{
    [WindowBorderPart]::LeftTop     = '╭'
    [WindowBorderPart]::Top         = '─'
    [WindowBorderPart]::RightTop    = '╮'
    [WindowBorderPart]::Left        = '│'
    [WindowBorderPart]::Right       = '│'
    [WindowBorderPart]::LeftBottom  = '╰'
    [WindowBorderPart]::Bottom      = '─'
    [WindowBorderPart]::RightBottom = '╯'
}
```

To use a sharper style, swap characters:
```powershell
$Script:CurrentWindowDesign[[WindowBorderPart]::LeftTop]     = '┌'
$Script:CurrentWindowDesign[[WindowBorderPart]::RightTop]    = '┐'
$Script:CurrentWindowDesign[[WindowBorderPart]::LeftBottom]  = '└'
$Script:CurrentWindowDesign[[WindowBorderPart]::RightBottom] = '┘'
```

### Border Color Array

Each of the 8 positions has an independent `ConsoleColor24`:

```powershell
# WindowBorderPart index order: LeftTop=0, Top=1, RightTop=2, Left=3, Right=4, LeftBottom=5, Bottom=6, RightBottom=7
$Window.BorderDrawColors = [ConsoleColor24[]](
    [CCWindowBorderDefault24]::new(),   # 0: LeftTop
    [CCWindowBorderDefault24]::new(),   # 1: Top
    [CCWindowBorderDefault24]::new(),   # 2: RightTop
    [CCWindowBorderDefault24]::new(),   # 3: Left
    [CCWindowBorderDefault24]::new(),   # 4: Right
    [CCWindowBorderDefault24]::new(),   # 5: LeftBottom
    [CCWindowBorderDefault24]::new(),   # 6: Bottom
    [CCWindowBorderDefault24]::new()    # 7: RightBottom
)
```

To highlight a window (e.g., focus state), change specific indices:
```powershell
$Window.BorderDrawColors[0] = [CCAppleYellowLight24]::new()
$Window.BorderDrawColors[1] = [CCAppleYellowLight24]::new()
$Window.BorderDrawColors[2] = [CCAppleYellowLight24]::new()
$Window.BorderDrawDirty[0]  = $true   # top border dirty
```

`BorderDrawDirty` indices: `0` = top, `1` = bottom, `2` = left, `3` = right.

---

## Adding a New Window

### Step 1 — Create the Class
`Classes/UI/Windows/[Name]Window.ps1`:

```powershell
Class MyStatusWindow : WindowBase {
    [Boolean]$ContentDirty

    MyStatusWindow() : base() {
        $this.LeftTop        = [ATCoordinates]::new(2, 2)
        $this.RightBottom    = [ATCoordinates]::new(12, 40)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new(),
            [CCWindowBorderDefault24]::new()
        )
        $this.ContentDirty = $true
    }

    [Void]Draw() {
        # 1. Draw the window frame (handles border dirty flags internally)
        ([WindowBase]$this).Draw()

        # 2. Draw content only when needed
        If($this.ContentDirty -EQ $true) {
            [ATString]$Line = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates     = [ATCoordinates]::new(4, 4)
                    ForegroundColor = [ATForegroundColor24]::new([CCTextDefault24]::new())
                }
                UserData   = 'Player Status'
                UseATReset = $true
            }
            Write-Host $Line.ToAnsiControlSequenceString()
            $this.ContentDirty = $false
        }
    }
}
```

### Step 2 — Declare Global in Variables.ps1
```powershell
[MyStatusWindow]$Script:TheMyStatusWindow = [MyStatusWindow]::new()
```

### Step 3 — Dot-Source in Eldoria.psm1
Add in the Windows loading block (step 12) in the correct order.

### Step 4 — Call from State ScriptBlock
```powershell
$Script:TheSomeScreenState = {
    If(-Not $Script:TheMyStatusWindow.IsActive) {
        $Script:TheMyStatusWindow.Activate()
    }
    $Script:TheMyStatusWindow.Draw()
}
```

---

## UIELabel — Text Label

Simple positioned text element. Set `Dirty = $true` to schedule a redraw.

```powershell
[UIELabel]$Label = [UIELabel]@{
    Prefix = [ATStringPrefix]@{
        Coordinates     = [ATCoordinates]::new(5, 10)
        ForegroundColor = [ATForegroundColor24]::new([CCAppleGreenLight24]::new())
    }
    UserData   = 'HP: 850'
    UseATReset = $true
}
$Label.Dirty = $true

# In Draw():
$Label.Draw()   # Only writes to terminal when Dirty=true
```

To update content without a full redraw of the parent window:
```powershell
$Label.SetUserData("HP: 600")
$Label.Dirty = $true
$Label.Draw()
```

---

## UIEMenu — Interactive Menu

### Initialization
```powershell
[UIEMenu]$Menu = [UIEMenu]::new()
$Menu.InitializeMenuItems(@(
    @{ Label = 'Attack';   Action = { $Script:ThePlayer.SelectAction(0) } },
    @{ Label = 'Defend';   Action = { $Script:ThePlayer.SelectAction(1) } },
    @{ Label = 'Use Item'; Action = { $Script:TheGlobalGameState = [GameStatePrimary]::InventoryScreen } },
    @{ Label = 'Flee';     Action = { $Script:TheBattleManager.Flee() } }
), [ATCoordinates]::new(10, 5))   # Draw origin: top-left of the menu list
```

### Input Handling
```powershell
Switch($Key.Key) {
    ([ConsoleKey]::UpArrow)   { $Menu.MoveActiveIndexUp();   $Menu.Draw() }
    ([ConsoleKey]::DownArrow) { $Menu.MoveActiveIndexDown(); $Menu.Draw() }
    ([ConsoleKey]::Enter)     { $Menu.InvokeItemAction() }
}
```

### Forcing Full Redraw
```powershell
$Menu.SetAllDirty()
$Menu.Draw()
```

---

## Dirty Flag Model — Preventing Redundant Writes

The most important performance discipline in a TUI. Terminal I/O is expensive; write only what has changed.

**Rules:**
1. After changing any label text, color, or prefix → `$Element.Dirty = $true`
2. After a state transition where a window was previously hidden → `$Window.Activate()` (sets all borders dirty)
3. For a scene image that hasn't changed between turns → do **not** re-render it
4. The `Draw()` method checks `Dirty` and no-ops if false — rely on this, don't bypass it

**WindowBase border dirty flags** (`BorderDrawDirty[4]`):
- Only the borders tagged dirty are redrawn, allowing selective border color changes without redrawing the whole frame.

---

## Scene Image Pipeline

Scene images are **48×18 background-color grids** rendered as `ATSceneImageString` cells. Each cell is one terminal character position painted with a background color.

### Adding a New Scene Image

#### Step 1 — Create the JSON Color Map
`Resources/ImageData/[MySI].json`:

```json
{
  "ColorData": [
    "PixenSkyBlue", "PixenSkyBlue", "PixenSkyBlue",
    [76, 110, 54], [76, 110, 54],
    "PixenGrassLightGreen"
  ]
}
```

The array must have exactly **864 entries** (48 × 18). Each entry is either:
- A string: `"ColorName"` → maps to `CC{ColorName}24` class
- An array: `[R, G, B]` → inline `ConsoleColor24`

#### Step 2 — Create the Class
`Classes/ATStrings/SIMaps/SIMySI.ps1`:

```powershell
Class SIMySI : SIInternalBase {
    SIMySI() : base("$PSScriptRoot\..\..\..\Resources\ImageData\SIMySI.json") {}
}
```

#### Step 3 — Register in Variables.ps1
```powershell
$Script:TheSceneImages['MySI'] = [SIMySI]::new()
```

#### Step 4 — Reference in Map JSON
`Resources/MapData/SomeMap.json`:
```json
{ "BackgroundImage": "MySI", ... }
```

#### Step 5 — Dot-Source in Eldoria.psm1
Add to the SIMaps loading block, after `SIInternalBase` is loaded.

---

## BufferManager — Area Clearing

Use `BufferManager.ClearArea()` to erase a rectangular region before redrawing content. This prevents visual artifacts from old content showing through.

```powershell
$Script:TheBufferManager.ClearArea(
    [ATCoordinates]::new(2, 2),    # LeftTop of area
    [ATCoordinates]::new(12, 40),  # RightBottom of area
    1                               # Column adjustment (usually 1)
)
```

Do not use `\e[2J` (full screen clear) for partial updates — it causes a full-screen flash. Reserve it for major state transitions only.

---

## Quality Checklist

- [ ] Window class inherits from `WindowBase`; constructor sets `LeftTop`, `RightBottom`, and all 8 `BorderDrawColors`
- [ ] `Draw()` calls `([WindowBase]$this).Draw()` before drawing content
- [ ] Content is guarded by a `ContentDirty` flag; not re-rendered every frame
- [ ] `IsActive` guard in state scriptblock prevents re-initialization on every tick
- [ ] `UIEMenu.InitializeMenuItems()` called only once on activation, not every frame
- [ ] `BufferManager.ClearArea()` called before first content draw to erase stale output
- [ ] Scene image JSON has exactly 864 entries
- [ ] Scene image class registered in `$Script:TheSceneImages` before any map that references it is loaded
- [ ] New files dot-sourced in `Eldoria.psm1` in the correct loading order position
