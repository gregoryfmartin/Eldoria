# Eldoria Game AI Assistant Instructions

## Project Overview
Eldoria is a cross-platform terminal-based RPG game written in PowerShell Core 7.3+. It features:
- Structured turn-based combat system
- World map navigation with tile-based movement
- Comprehensive inventory management (items and battle actions)
- Character creation and customization (name, gender, affinity, appearance)
- Dynamic battle action system with 100+ unique techniques
- Sound effects and background music support
- Color-rich terminal UI with ANSI escape sequences

## Project Architecture

### Module Structure
The project uses a PowerShell Module layout (`.psm1`/`.psd1`) for organization:
- **Enums/** - Game state types and enumeration definitions
- **Classes/** - Core game logic organized by system
- **Private/** - Internal module functions and global variables
- **Public/** - Exported cmdlets (currently just `Start-Eldoria`)
- **Resources/** - Game assets (images, maps, sounds, sixel profiles)
- **Tests/** - Pester test suite

### Loading Pipeline
Module initialization (`Eldoria.psm1`) follows this sequence:
1. Load all enums from `Enums/`
2. Load console color system (`ConsoleColor24` and color palettes)
3. Load FastNoiseLite for procedural generation
4. Load ANSI/terminal string support (`ATStrings` classes)
5. Load mapping system (tiles, maps, map tile objects)
6. Load combat engine primitives
7. Load battle actions
8. Load enemy entities
9. Load equipment system
10. Load UI/buffer system
11. Load game windows
12. Load battle manager
13. Load game core
14. Initialize global state and variables

## Core Systems

### Game State Management
**File:** `Enums/GameStatePrimary.ps1`

Primary game states:
- `SplashScreenA` / `SplashScreenB` - Decorative splash screens
- `TitleScreen` - Main title screen with animation
- `PlayerSetupScreen` - Character creation flow
- `GamePlayScreen` - World navigation and exploration
- `InventoryScreen` - Item management interface
- `BattleScreen` - Combat encounters
- `PlayerStatusScreen` - Player stats and equipment management
- `Cleanup` - Resource cleanup and shutdown

State transitions are managed via `$Script:TheGlobalStateBlockTable` scriptblock hashtable, allowing flexible screen flow control.

### Game Core Loop
**File:** `Classes/GameCore.ps1`

The main game loop runs in `GameCore.Run()`:
1. Continuously invokes state blocks based on `$Script:TheGlobalGameState`
2. Each iteration calls the current state's scriptblock logic
3. Flushes input buffer to prevent input queue overflow
4. Runs until `GameRunning` is set to `$false`

### Combat Engine System

#### Battle Entities
**Base Class:** `Classes/CombatEnginePrimitives/BattleEntity.ps1`

All combatants inherit from `BattleEntity`:
- **Stats:** HP, MP, Attack, Defense, Speed, Luck, Elemental affinities (Fire, Water, Wind, Earth, Light, Dark)
- **BattleEntityProperty objects:** Wrapper classes for stats with base and modified values
- **Profile:** Name, level, gender, profile image
- **Inventory:** Action and item inventories

**Player Class:** `Classes/CombatEnginePrimitives/Player.ps1`
- Extends `BattleEntity` with player-specific features
- `PlayerActionInventory` - Up to 4 equipped battle actions
- `PlayerItemInventory` - Consumable and key items
- `EquipmentListing` - 10 equipment slots (weapon, armor, helmet, gauntlets, greaves, boots, cape, pauldron, 2x jewelry)
- `MapCoordinates` - Current position on world map
- `CurrentGold` - Currency for purchases/trades

**Enemy Class:** `Classes/CombatEnginePrimitives/EnemyBattleEntity.ps1`
- Random enemy generation with procedural stats
- Random action selection during combat
- 7 distinct enemy types with unique visual representations (Bat, Nightwing, Wingblight, Darkfang, Nocturna, Bloodswoop, Duskbane)

#### Battle Actions
**Base Class:** `Classes/CombatEnginePrimitives/BattleAction.ps1`

All combat moves inherit from `BattleAction`:
- `Name` - Display name of the action
- `Type` - `BattleActionType` enum (Physical, Fire, Water, Wind, Earth, Light, Dark, Heal, Status)
- `MpCost` - Magic points required
- `EffectValue` - Damage/healing amount base value
- `Chance` - Success probability (0.0-1.0)
- `Description` - Flavor text for player
- `Effect` - ScriptBlock for custom damage calculation
- `PreCalc` / `PostCalc` - Optional scriptblocks for pre/post-action logic

**Individual Actions:** `Classes/CombatEnginePrimitives/BattleActions/`
Over 100 unique battle actions available (e.g., `BAFireball.ps1`, `BAIceBolt.ps1`, `BAAxeSlash.ps1`)

#### Battle Manager
**File:** `Classes/BattleManager.ps1`

Orchestrates turn-based combat:
- **Turn Order:** Determined by Speed + Luck stats with random variance
- **Turn Phases:** Two-phase system (Phase A and Phase B per turn)
  - Phase A: Higher speed entity acts
  - Phase B: Lower speed entity acts
- **State Machine:** `BattleManagerState` enum manages battle phases
  - `TurnIncrement` - Increment turn counter
  - `PhaseOrdering` - Calculate turn order
  - `PhaseAExecution` / `PhaseBExecution` - Execute entity actions
  - `Calculation` - Resolve damage and status changes
  - `BattleWon` / `BattleLost` - Battle conclusion

**BattleAction Result:** `Classes/CombatEnginePrimitives/BattleActionResult.ps1`
- Result type: Hit, Miss, Critical, Immune, etc.
- Actual damage dealt
- Status effect application

### Mapping System

#### Map Structure
**File:** `Classes/Mapping/Map.ps1`

Grid-based world maps:
- `MapWidth` / `MapHeight` - Tile dimensions
- `Name` - Map identifier
- `BoundaryWrap` - Whether map edges wrap around
- `Tiles[,]` - 2D array of `MapTile` objects
- JSON-based map configuration for easy creation

**MapTile Class:** `Classes/Mapping/MapTile.ps1`
- `BackgroundImage` - `SceneImage` for visual rendering
- `Exits` - Cardinal direction availability (N/S/E/W)
- `Objects` - Collection of `MapTileObject` instances on the tile
- `BattleStep()` - Triggers random encounter logic

#### Map Tile Objects
**Base Class:** `Classes/Mapping/MapTileObject.ps1`

Interactive objects on tiles:
- `Name` / `Description` - Display text
- `CanPickUp` - Whether item is collectible
- `IsKeyItem` - Cannot be dropped if true
- `CanUseOnSelf` / `CanDropItem` / etc. - Interaction flags
- `OnPickup()` / `OnUse()` / `OnExamine()` - Custom interaction handlers

**Concrete Objects:** `Classes/Mapping/MapTileObjects/`
- Items: Apple, Bacon, Milk, Yogurt, Rope, etc.
- Furniture: Tree, Ladder, Stairs, Pole, Computer, Guitar
- Warpables: Doors and portals for map transitions

### UI and Rendering System

#### ANSI Terminal Strings
**Core Classes:** `Classes/ATStrings/`

Comprehensive ANSI escape sequence abstraction:
- `ATControlSequences.ps1` - Base ANSI codes
- `ATForegroundColor.ps1` / `ATBackgroundColor.ps1` - Color support
- `ATDecoration.ps1` - Text attributes (bold, underline, blink)
- `ATCoordinates.ps1` - Cursor positioning
- `ATString.ps1` - Composite ANSI string with formatting
- `ATStringComposite.ps1` - Multiple ATStrings combined
- `ATSceneImageString.ps1` - ANSI art image rendering

**Scene Images:**
- `SceneImage.ps1` - Base class for drawable scenes
- `SIRandomNoise.ps1` - Procedurally generated noise background
- `SIEmpty.ps1` - Blank/transparent scene
- `SIMaps/` - Specific map visual definitions
- `EnemyEntityImage.ps1` / `EnemyEntityImages/` - Enemy sprite graphics

#### Buffer Manager
**File:** `Classes/BufferManager.ps1`

Manages terminal output:
- Double-buffering for flicker-free rendering
- Common buffer (shared between states)
- Character-by-character output control
- Screen clearing and positioning

#### UI Components
**Base Classes:**
- `UIEBase.ps1` - Base UI element (extends ATString)
- `WindowBase.ps1` - Base window with borders, titles, and corners
- `UIEContainer.ps1` - Container for nested UI elements

**Input Management:** `Classes/UI/InputManager.ps1`
- Keyboard input handling
- Command parsing
- Chord detection (multi-key combinations)

**Common Windows:** `Classes/UI/Windows/`
- `BattleEntityStatusWindow.ps1` - Player/enemy stats display
- `BattlePlayerActionWindow.ps1` - Available battle moves
- `BattleStatusMessageWindow.ps1` - Combat log
- `BattleEnemyImageWindow.ps1` - Enemy sprite display
- `CommandWindow.ps1` - Navigation command history/suggestions
- `SceneWindow.ps1` - Main game world/map view
- `MessageWindow.ps1` - Story/event messages
- `InventoryWindow.ps1` - Item management
- `StatusWindow.ps1` - Player stats overview
- `PlayerStatusMainMenu.ps1` / `PlayerStatusSummaryWindow.ps1` - Equipment and ability management

**Player Setup Windows:** `Classes/UI/Windows/PS*.ps1`
- `PSNameEntryWindow.ps1` - Character name input
- `PSGenderSelectionWindow.ps1` - Gender selection (Elf/Human)
- `PSBonusPointAllocWindow.ps1` - Stat customization (10 points to allocate)
- `PSAffinitySelectWindow.ps1` - Elemental affinity choice
- `PSProfileSelectWindow.ps1` - Profile image selection
- `PSConfirmDialog.ps1` - Final confirmation dialog

#### Console Color System
**File:** `Classes/ConsoleColor/ConsoleColor24.ps1`

24-bit true color support:
- `ConsoleColor24` - Base class for RGB colors
- `CC*.ps1` - Predefined color palettes (Apple colors: Blue, Brown, Cyan, Green, Grey1-6, Indigo, Mint, etc.)
- Colors used for text, backgrounds, UI elements, and borders

### Game Resources

#### Sound System
Global sound players:
- `$Script:TheSfxMachine` - SoundPlayer for sound effects
- `$Script:TheBgmMachine` - SoundPlayer for background music
- Resources in `Resources/SFX/` and `Resources/BGM/`

Sound types:
- UI sounds (chevron movement, selection)
- Battle actions (physical strikes, magic)
- Battle events (intro, win, lose)
- Background music (title, player setup, battle)

#### Image Assets
**Resources/ImageData/** - Sixel-encoded profile images
- Female characters (Elf A-E, Human A-E)
- Male characters (Elf A-C, Human A-C)

**Resources/Sixel/** - Terminal sixel profile configurations

**Resources/MapData/** - JSON map definitions

## Development Patterns

### Adding a New Battle Action
1. Create new class file in `Classes/CombatEnginePrimitives/BattleActions/`
   - File naming: `BA[ActionName].ps1`
2. Inherit from `BattleAction`
3. Set properties in constructor: `Name`, `Type`, `MpCost`, `EffectValue`, `Chance`, `Description`
4. Define `Effect` scriptblock for damage calculation (can use default `$Script:BaCalc`)
5. Optionally define `PreCalc` / `PostCalc` for special behavior

Example:
```powershell
Class BAMyFireSpell : BattleAction {
    BAMyFireSpell() : base() {
        $this.Name        = 'Blazing Inferno'
        $this.Type        = [BattleActionType]::Fire
        $this.MpCost      = 25
        $this.EffectValue = 45
        $this.Chance      = 0.95
        $this.Description = 'A powerful fire spell'
    }
}
```

### Adding a New Enemy Type
1. Create class file in `Classes/CombatEnginePrimitives/EnemyEntities/`
2. Create image class in `Classes/ATStrings/EnemyEntityImages/`
3. Inherit from `EnemyBattleEntity`
4. Define `BaseStats` hashtable with initial values
5. Define unique visual representation and battle actions

### Adding UI Elements
1. Create window class extending `WindowBase`
2. Implement `Draw()` method for rendering
3. Use `ATString`/`ATStringComposite` for ANSI formatting. It's also possible to use `UIEBase` or `UIELabel` in lieu of `ATString` due to inheritance. It's suitable to use the latter in newer contexts where drawing control is required.
4. Register in `Private/Variables.ps1` as global
5. Add state handler in game state block table if needed

### Adding Map Tiles and Objects
1. For new map: Create JSON config in `Resources/MapData/`
   - Define `MapName`, `MapWidth`, `MapHeight`, `BoundaryWrap`
   - Define tile grid with background image indices
2. For new object: Create class in `Classes/Mapping/MapTileObjects/`
   - Inherit from `MapTileObject`
   - Implement interaction methods (`OnPickup`, `OnUse`, `OnExamine`)
3. Instantiate in player setup or map initialization

## Key Global Variables
**Location:** `Private/Variables.ps1`

Critical globals:
- `$Script:TheGameCore` - Main game loop controller
- `$Script:ThePlayer` - Player instance
- `$Script:TheCurrentEnemy` - Active enemy in battle
- `$Script:TheBattleManager` - Combat orchestration
- `$Script:CurrentMap` - Active game world
- `$Script:TheGlobalGameState` - Current state enum
- `$Script:TheGlobalStateBlockTable` - State transition scriptblocks
- `$Script:TheSfxMachine` / `$Script:TheBgmMachine` - Audio players
- Various window instances for each screen

## Prerequisites and Setup

### Operating Systems
- Windows 10+ or Windows Server 2019+
- macOS (latest, with .NET Core and PowerShell)
- Linux (with .NET Core and PowerShell, tested on RHEL 8+, Rocky 8+, Alma 8+, Oracle 8+)

### Required Software
- PowerShell Core 7.3.0 or greater
- .NET Core/Framework (comes with PowerShell)
- Terminal emulator support:
  - Windows: Windows Terminal 1.21.x+
  - macOS: iTerm2 (latest)
  - Linux: Alacritty, Kitty, or GNOME Terminal

### Terminal Requirements
- Minimum size: 90 columns × 40 rows
- ANSI escape sequence support
- 24-bit true color support (optional but recommended)
- Note: DEC Blink SGRs not supported on macOS iTerm2 or Linux Alacritty/Kitty (but doesn't impact gameplay)

### Installation
1. Clone or download the repository
2. Navigate to the directory
3. Import the module: `Import-Module .\Eldoria.psm1 -Force`
4. Start the game: `Start-Eldoria`

## Testing
**Location:** `Tests/`

Comprehensive test suite using Pester:
- ANSI sequence generation tests
- Color system tests
- Coordinate system tests
- String formatting tests
- Run tests with: `Invoke-Pester`

## Code Style and Conventions
- All classes use `Set-StrictMode -Version Latest`
- Classes use proper PowerShell class syntax (PS 5+)
- Uses namespace declarations for .NET interop
- Comprehensive inline comments in complex logic
- CamelCase for variables and methods
- PascalCase for classes and enums
- Descriptive variable names for maintainability

## Common Development Tasks

### To debug a battle action:
1. Check `Classes/CombatEnginePrimitives/BattleAction.ps1` for `Effect` scriptblock
2. Review damage calculation in `BattleManager.ps1` Phase execution
3. Check `BattleActionResult.ps1` for result type logic

### To modify combat difficulty:
1. Adjust enemy stat generation in `Classes/CombatEnginePrimitives/EnemyBattleEntity.ps1`
2. Modify action selection weights in enemy action inventory
3. Adjust turn limit in `BattleManager` state machine

### To add new player stats:
1. Add new enum value to a `StatId` enum (if needed)
2. Add `BattleEntityProperty` in `BattleEntity` constructor
3. Update stat display windows to render new stat
4. Update character creation bonus point allocation

### To change UI colors:
1. Modify `ConsoleColor24` palette classes in `Classes/ConsoleColor/`
2. Update window `BorderDrawColors` array
3. Change text `ForegroundColor` in string compositions

## Module Loading Notes
- Module initialization can take 1-2 minutes due to large amount of code (100+ battle actions, multiple UI windows)
- All code is loaded into memory at startup for performance
- No lazy-loading currently implemented (potential optimization opportunity)
- Global state is initialized in `Variables.ps1` after all classes are loaded
