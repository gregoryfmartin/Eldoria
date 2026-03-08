# State Management

Eldoria uses an **enum-keyed scriptblock dispatch table** for all game states. Every screen and sub-screen is modeled as a state in an enum, and each state maps to a `[ScriptBlock]` that is invoked once per game loop tick.

---

## Core Concepts

### Primary State Enum
`Enums/GameStatePrimary.ps1` defines the top-level game states:

```powershell
Enum GameStatePrimary {
    SplashScreenA         # Decorative intro
    SplashScreenB         # Decorative intro
    TitleScreen           # Animated title with SSAFiglet
    PlayerSetupScreen     # Character creation flow
    GamePlayScreen        # World navigation
    InventoryScreen       # Item management (legacy)
    BattleScreen          # Turn-based combat
    PlayerStatusScreen    # Stats, equipment, techniques
    Cleanup               # Resource shutdown
}
```

### Sub-State Enums
Complex screens own their own sub-state enum:

| Screen | Enum File | Sub-states |
|--------|-----------|-----------|
| Player Setup | `Enums/PlayerSetupScreenStates.ps1` | `PlayerSetupSetup`, `PlayerSetupNameEntry`, `PlayerSetupGenderSelection`, `PlayerSetupPointAllocate`, `PlayerSetupAffinitySelect`, `PlayerSetupProfileSelect`, `PlayerSetupConfirmation` |
| Status Screen | `Enums/StatusScreenState.ps1` | `Setup`, `MainMenu`, `Status`, `Items`, `ItemDropConfirm`, `Equip`, `Magic`, `Save`, `Quit` |
| Battle Manager | `Enums/BattleManagerState.ps1` | `HealthCheck`, `TurnIncrement`, `PhaseOrdering`, `PhaseAExecution`, `PhaseBExecution`, `Calculation`, `BattleWon`, `BattleLost` |

---

## Dispatch Table Pattern

The main loop in `Classes/GameCore.ps1` simply looks up and invokes the current state's scriptblock:

```powershell
[Void]Logic() {
    Invoke-Command $Script:TheGlobalStateBlockTable[$Script:TheGlobalGameState]
    $Script:Rui.FlushInputBuffer()   # Prevent input queue overflow
}
```

The table is a `[Hashtable]` defined in `Private/Variables.ps1`:

```powershell
$Script:TheGlobalStateBlockTable = @{
    [GameStatePrimary]::SplashScreenA      = $Script:TheSplashScreenAState
    [GameStatePrimary]::SplashScreenB      = $Script:TheSplashScreenBState
    [GameStatePrimary]::TitleScreen        = $Script:TheTitleScreenState
    [GameStatePrimary]::PlayerSetupScreen  = $Script:ThePlayerSetupState
    [GameStatePrimary]::GamePlayScreen     = $Script:TheGamePlayScreenState
    [GameStatePrimary]::BattleScreen       = $Script:TheBattleScreenState
    [GameStatePrimary]::PlayerStatusScreen = $Script:ThePlayerStatusScreenState
    [GameStatePrimary]::Cleanup            = $Script:TheCleanupState
}
```

Each value (`$Script:The*State`) is itself a `[ScriptBlock]` defined earlier in `Variables.ps1`.

---

## Non-Blocking Frame Design

State scriptblocks are **non-blocking**: each invocation handles one frame, then returns. There is no `while` loop inside a state block. This keeps the game loop responsive.

Pattern within a state block:
```powershell
$Script:TheGamePlayScreenState = {
    # 1. Initialize on first entry (guarded by .IsActive flag)
    If(-Not $Script:TheMapWalkerWindow.IsActive) {
        $Script:TheMapWalkerWindow.Activate()
    }

    # 2. Handle input for this frame
    $Script:TheMapWalkerWindow.HandleInput()

    # 3. Draw for this frame
    $Script:TheMapWalkerWindow.Draw()
}
```

### `IsActive` Initialization Guard
Windows track whether they have been initialized with a `[Boolean]$IsActive` property. Check this at the start of a state block to avoid re-running setup logic every frame:

```powershell
If(-Not $Script:SomeWindow.IsActive) {
    $Script:SomeWindow.Activate()   # Run once on entry
}
```

---

## State Transitions

### Primary Transition
Change `$Script:TheGlobalGameState` directly. The game loop picks up the new state on the next tick.

```powershell
# Entering battle from world map
$Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
$Script:TheGlobalGameState = [GameStatePrimary]::BattleScreen
```

### Returning to the Previous State
`$Script:ThePreviousGlobalGameState` tracks the last state so sub-screens (inventory, status) can return cleanly:

```powershell
# Returning from status screen to wherever we came from
$Script:TheGlobalGameState = $Script:ThePreviousGlobalGameState
```

### Sub-State Transitions
Within a complex screen, switch on the sub-state enum variable:

```powershell
$Script:ThePssSubstate = {
    Switch($Script:ThePssSubstate) {
        ([PlayerSetupScreenStates]::PlayerSetupNameEntry) {
            # Draw name entry window and handle input
            If($nameConfirmed) {
                $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupGenderSelection
            }
        }
        ([PlayerSetupScreenStates]::PlayerSetupGenderSelection) {
            # ...
        }
    }
}
```

---

## Adding a New Game Screen

### Step 1 — Add to the Primary Enum (if top-level)
```powershell
# Enums/GameStatePrimary.ps1
Enum GameStatePrimary {
    # ... existing values ...
    ShopScreen    # New
}
```

### Step 2 — Define the State ScriptBlock in Variables.ps1
```powershell
[ScriptBlock]$Script:TheShopScreenState = {
    If(-Not $Script:TheShopWindow.IsActive) {
        $Script:TheShopWindow.Activate()
    }
    $Script:TheShopWindow.HandleInput()
    $Script:TheShopWindow.Draw()
}
```

### Step 3 — Register in the Dispatch Table
```powershell
$Script:TheGlobalStateBlockTable = @{
    # ... existing entries ...
    [GameStatePrimary]::ShopScreen = $Script:TheShopScreenState
}
```

### Step 4 — Declare the Window Global
```powershell
[ShopWindow]$Script:TheShopWindow = [ShopWindow]::new()
```

### Step 5 — Trigger Entry from Another State
```powershell
$Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
$Script:TheGlobalGameState = [GameStatePrimary]::ShopScreen
```

---

## Sub-State Screen: Adding a New Step to an Existing Flow

Example: adding a new step to Player Setup:

1. Add enum value to `PlayerSetupScreenStates`
2. Create a new window class (or reuse an existing one)
3. Add a case to the Switch in the Player Setup state scriptblock
4. Transition to the new sub-state from the preceding step
5. Transition away from the new sub-state to the next step

---

## Quality Checklist

- [ ] New enum value added (primary or sub-state as appropriate)
- [ ] State scriptblock defined in `Variables.ps1` before the dispatch table assignment
- [ ] Entry registered in `$Script:TheGlobalStateBlockTable`
- [ ] Window `IsActive` guard in place to prevent repeated initialization
- [ ] Previous state saved before transitioning away, if return navigation is needed
- [ ] `FlushInputBuffer()` is handled by the game loop — no need to call it inside state blocks
