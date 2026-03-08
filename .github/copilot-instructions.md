# Eldoria Game AI Assistant Instructions

## Project Overview
Eldoria is a cross-platform terminal-based RPG game written in PowerShell Core 7.3+. It features:
- Structured turn-based combat system
- World map navigation with tile-based movement and multi-map warp support
- Comprehensive inventory management (items, equipment, and battle techniques)
- Character creation and customization (name, gender, affinity, appearance)
- Dynamic battle action system with 100+ unique techniques across multiple elemental types
- Sound effects and background music support (SoundPlayer and MediaPlayer)
- Color-rich terminal UI with ANSI escape sequences and 24-bit true color

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
1. Load loading-string resources (`Private/LoadStrings.ps1`)
2. Load all enums from `Enums/`
3. Load console color system (`ConsoleColor24` and all `CC*.ps1` palettes)
4. Load FastNoiseLite for procedural generation (`Classes/Mapping/FastNoiseLite/`)
5. Load ANSI/terminal string support (`ATStrings` classes, scene images, enemy images, map scene images)
6. Load mapping system (tile objects, warpables, tiles, maps)
7. Load combat engine primitives (battle properties, actions, entities, inventories)
8. Load battle actions (all `BA*.ps1` from `BattleActions/`)
9. Load enemy entities (all `EE*.ps1` from `EnemyEntities/`)
10. Load equipment base classes (`BattleEquipment`, `BEArmor`, `BEBoots`, etc.)
    - Note: Individual equipment item subdirectories (Armors, Boots, etc.) are currently commented out
11. Load UI/buffer system (`BufferManager`, `InputManager`, `UIEBase`, `UIELabel`, `UIEMenuItem`, `UIEMenu`, `WindowBase`, `BattlePhaseIndicator`, SSA classes)
12. Load all game windows (all `*.ps1` from `Classes/UI/Windows/`)
13. Load battle manager and game core
14. Initialize global state and variables (`Private/Variables.ps1`)

## Core Systems

### Game State Management
**File:** `Enums/GameStatePrimary.ps1`

Primary game states:
- `SplashScreenA` / `SplashScreenB` - Decorative splash screens
- `TitleScreen` - Main title screen with animation (SSAFiglet, SSASubtitle, SSAPressEnterPrompt)
- `PlayerSetupScreen` - Character creation flow
- `GamePlayScreen` - World navigation and exploration
- `InventoryScreen` - Item management interface
- `BattleScreen` - Combat encounters
- `PlayerStatusScreen` - Player stats, equipment, and technique management
- `Cleanup` - Resource cleanup and shutdown

State transitions are managed via `$Script:TheGlobalStateBlockTable` scriptblock hashtable. The previous state is tracked in `$Script:ThePreviousGlobalGameState` to support returning from sub-screens.

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
- **Stats:** HP, MP, Attack, Defense, Speed, Luck, Elemental affinities (Fire, Water, Wind, Earth, Light, Dark, Ice)
- **BattleEntityProperty objects:** Wrapper classes for stats with base and modified values (`BattleEntityProperty.ps1`)
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
- 7 distinct enemy types with unique visual representations:
  - `EEBat`, `EENightwing`, `EEWingblight`, `EEDarkfang`, `EENocturna`, `EEBloodswoop`, `EEDuskbane`
  - Enemy image classes in `Classes/ATStrings/EnemyEntityImages/` (EEI prefix)
- Encounter tables defined per region in `$Script:BattleEncounterRegionTable`

#### Battle Actions
**Base Class:** `Classes/CombatEnginePrimitives/BattleAction.ps1`

All combat moves inherit from `BattleAction`:
- `Name` - Display name of the action
- `Type` - `BattleActionType` enum (see full list below)
- `MpCost` - Magic points required
- `EffectValue` - Damage/healing amount base value
- `Chance` - Success probability (0.0-1.0)
- `Description` - Flavor text for player
- `Effect` - ScriptBlock for custom damage calculation
- `PreCalc` / `PostCalc` - Optional scriptblocks for pre/post-action logic

**BattleActionType enum** (`Enums/BattleActionType.ps1`):
- `Physical` - Non-elemental physical attacks
- `ElementalFire`, `ElementalWater`, `ElementalEarth`, `ElementalWind` - Elemental damage
- `ElementalLight`, `ElementalDark`, `ElementalIce` - Additional elemental types
- `MagicPoison`, `MagicConfuse`, `MagicSleep`, `MagicAging` - Status-inflicting magic
- `MagicHealing` - Restorative magic
- `MagicStatAugment` - Temporary stat buff magic
- `None` - Placeholder for base-case evaluations

Each type has a display character and color defined in `$Script:BATAdornmentCharTable`.

**Individual Actions:** `Classes/CombatEnginePrimitives/BattleActions/`
Over 100 unique battle actions (e.g., `BAFireball.ps1`, `BAIceBolt.ps1`, `BAAxeSlash.ps1`, `BATsunami.ps1`)

#### Battle Manager
**File:** `Classes/BattleManager.ps1`

Orchestrates turn-based combat:
- **Turn Order:** Determined by Speed + Luck stats with random variance
- **Turn Phases:** Two-phase system (Phase A and Phase B per turn)
  - Phase A: Higher speed entity acts
  - Phase B: Lower speed entity acts
- **State Machine:** `BattleManagerState` enum manages battle phases
  - `HealthCheck` - Initial health/state validation before each turn
  - `TurnIncrement` - Increment turn counter
  - `PhaseOrdering` - Calculate turn order
  - `PhaseAExecution` / `PhaseBExecution` - Execute entity actions
  - `Calculation` - Resolve damage and status changes
  - `BattleWon` / `BattleLost` - Battle conclusion

**BattleAction Result:** `Classes/CombatEnginePrimitives/BattleActionResult.ps1`
- Result type: Hit, Miss, Critical, Immune, etc.
- Actual damage dealt
- Status effect application

Affinity multipliers:
- `$Script:AffinityMultNeg` = `-0.75` (resisted element)
- `$Script:AffinityMultPos` = `1.6` (weakness/bonus element)

### Mapping System

#### Map Structure
**File:** `Classes/Mapping/Map.ps1`

Grid-based world maps:
- `MapWidth` / `MapHeight` - Tile dimensions
- `Name` - Map identifier
- `BoundaryWrap` - Whether map edges wrap around
- `Tiles[,]` - 2D array of `MapTile` objects
- JSON-based map configuration (`Resources/MapData/`)
- Currently defined maps: `SampleMap.json`, `MapWarpTest01.json`, `MapWarpTest02.json`

**MapTile Class:** `Classes/Mapping/MapTile.ps1`
- `BackgroundImage` - `SceneImage` for visual rendering
- `Exits` - Cardinal direction availability (N/S/E/W)
- `Objects` - Collection of `MapTileObject` instances on the tile
- `BattleStep()` - Triggers random encounter logic

**Map Warp System:**
- `$Script:MapWarpHandler` - ScriptBlock that handles cross-map transitions
- `$Script:PreviousMap` - Tracks the map player came from
- `$Script:CurrentMap` - Currently active map
- Multiple maps instantiated: `$Script:SampleMap`, `$Script:SampleWarpMap01`, `$Script:SampleWarpMap02`

#### Map Tile Objects
**Base Class:** `Classes/Mapping/MapTileObject.ps1`

Interactive objects on tiles:
- `Name` / `Description` - Display text
- `CanPickUp` - Whether item is collectible
- `IsKeyItem` - Cannot be dropped if true
- `CanUseOnSelf` / `CanDropItem` / etc. - Interaction flags
- `OnPickup()` / `OnUse()` / `OnExamine()` - Custom interaction handlers

**Concrete Objects:** `Classes/Mapping/MapTileObjects/`
- Items: Apple, Bacon, Milk, Yogurt, Rope, Pencil, Rock, Stick
- Furniture: Tree, Ladder, Stairs, Pole, Computer, Guitar
- Warpables: `MTOWarpable.ps1` (base), `Warpables/MTODoor.ps1` (base door), `MTODoor00001.ps1`, `MTODoor00002.ps1`

### UI and Rendering System

#### ANSI Terminal Strings
**Core Classes:** `Classes/ATStrings/`

Comprehensive ANSI escape sequence abstraction:
- `ATControlSequences.ps1` - Base ANSI codes
- `ATForegroundColor.ps1` / `ATForegroundColorNone.ps1` - Foreground color (with/without color)
- `ATBackgroundColor.ps1` / `ATBackgroundColorNone.ps1` - Background color (with/without color)
- `ATDecoration.ps1` / `ATDecorationNone.ps1` - Text attributes (bold, underline, blink)
- `ATCoordinates.ps1` / `ATCoordinatesNone.ps1` / `ATCoordinatesDefault.ps1` - Cursor positioning
- `ATStringPrefix.ps1` / `ATStringPrefixNone.ps1` - Optional string prefix handling
- `ATString.ps1` / `ATStringNone.ps1` - Composite ANSI string with formatting (and no-op variant)
- `ATStringComposite.ps1` - Multiple ATStrings combined
- `ATSceneImageString.ps1` - ANSI art image rendering

**Scene Images:**
- `SceneImage.ps1` - Base class for drawable scenes
- `SIInternalBase.ps1` - Internal base for scene image implementations
- `SIRandomNoise.ps1` - Procedurally generated noise background
- `SIEmpty.ps1` - Blank/transparent scene
- `SIMaps/` - Specific map visual definitions
  - Plains road variants: No road, N, S, E, W, NE, NW, NS, EW, NSE, NSW, NSEW
  - River tile variants: Extensive set covering all directional combinations (30+ tiles)
  - Road+river samples: `SIRiverRoadSample`, `SIRiverRoadEWNSSample`, `SIRiverRoadEWSSSample`
  - Scene images registered in `$Script:TheSceneImages` hashtable in `Variables.ps1`

**Enemy Entity Images:**
- `EnemyEntityImage.ps1` - Base class
- `EEIInternalBase.ps1` - Internal base for enemy image implementations
- `EEIEmpty.ps1` - Empty/placeholder enemy image
- `EnemyEntityImages/` - One `EEI*.ps1` per enemy type (Bat, Wingblight, Darkfang, Nocturna, Bloodswoop, Duskbane)
- Enemy image globals: `$Script:EeiBat`, `$Script:EeiNightwing`, `$Script:EeiWingblight`, etc.

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
- `UIEContainer.ps1` - Container for nested UI elements (stack-based)

**Controls:** `Classes/UI/Controls/`
- `UIELabel.ps1` - Text label UI element
- `UIEMenuItem.ps1` - Individual menu item
- `UIEMenu.ps1` - Menu container managing a list of `UIEMenuItem`
- `UIEChevron.ps1` - Chevron (cursor arrow) indicator control
- `UIEChevronTable.ps1` - Table of chevron indicators

**Splash Screen / Animation Classes:** `Classes/UI/`
- `SSAFiglet.ps1` - Figlet-style ASCII art title (used on title screen)
- `SSASubtitle.ps1` - Subtitle text below the figlet
- `SSAPressEnterPrompt.ps1` - Animated "Press Enter" prompt with blink/timeout logic
- `BattlePhaseIndicator.ps1` - Visual indicator for current battle turn phase

**Input Management:** `Classes/UI/InputManager.ps1`
- Keyboard input handling
- Command parsing
- Chord detection (multi-key combinations)
- Global instance: `$Script:TheInputManager`

**Gameplay (GPS) Windows:** `Classes/UI/Windows/Gps*.ps1`
- `GpsHorizontalStatusWindow.ps1` - Horizontal status bar during world navigation
- `GpsMapWalkerWindow.ps1` - Renders the tile-based map view during gameplay
- `GpsGameInstructionsWindow.ps1` - In-game control/help instructions overlay

**Battle Windows:** `Classes/UI/Windows/`
- `BattleEntityStatusWindow.ps1` - Player/enemy stats display
- `BattlePlayerActionWindow.ps1` - Available battle moves
- `BattleStatusMessageWindow.ps1` - Combat log
- `BattleEnemyImageWindow.ps1` - Enemy sprite display

**Exploration Windows:**
- `CommandWindow.ps1` - Navigation command history/suggestions
- `SceneWindow.ps1` - Main game world/map view (tile background rendering)
- `MessageWindow.ps1` - Story/event messages
- `InventoryWindow.ps1` - Legacy item management window
- `VerticalInventoryWindow.ps1` - Paged vertical inventory list
- `StatusWindow.ps1` - Player stats overview (legacy)
- `StatusHudWindow.ps1` - HUD-style status overlay

**Player Status Screen Windows:**
- `PlayerStatusMainMenu.ps1` - Top-level status screen menu
- `PlayerStatusSummaryWindow.ps1` - Summary of player stats and equipment
- `StatusItemInventoryWindow.ps1` - Full item inventory view
- `StatusItemHeaderWindow.ps1` - Header bar for item inventory
- `StatusItemDropConfirmDialog.ps1` - Confirmation dialog for dropping items
- `StatusItemInventoryContextDialog.ps1` - Context action dialog for selected item
- `StatusTechniqueInventoryWindow.ps1` - Full technique/spell inventory view
- `StatusTechniqueSelectionWindow.ps1` - Technique equip/selection sub-window

**Player Setup Windows:** `Classes/UI/Windows/PS*.ps1`
- `PSNameEntryWindow.ps1` - Character name input
- `PSGenderSelectionWindow.ps1` - Gender selection (Elf/Human)
- `PSBonusPointAllocWindow.ps1` - Stat customization (10 bonus points to allocate)
- `PSAffinitySelectWindow.ps1` - Elemental affinity choice
- `PSProfileSelectWindow.ps1` - Profile image selection
- `PSConfirmDialog.ps1` - Final confirmation dialog

**Status Screen State Machine:**
- `StatusScreenState` enum: `Setup`, `MainMenu`, `Status`, `Items`, `ItemDropConfirm`, `Equip`, `Magic`, `Save`, `Quit`
- `StatusScreenMode` enum: `EquippedTechSelection`, `TechInventorySelection`
- Current state tracked via `$Script:TheStatusScreenState` and `$Script:StatusScreenMode`

#### Console Color System
**File:** `Classes/ConsoleColor/ConsoleColor24.ps1`

24-bit true color support:
- `ConsoleColor24` - Base class for RGB colors
- `CC*.ps1` - Large predefined palette library including:
  - Apple HIG colors (both Light/Dark variants): Blue, Brown, Cyan, Green, Grey1-6, Indigo, Mint, Orange, Pink, Purple, Red, Teal, Yellow
  - Apple N-variants (additional shades with A sub-variants)
  - Apple V-variants (vibrant/vivid shades with A sub-variants)
  - Basic terminal colors: Black, White, Red, Green, Blue, Yellow, DarkCyan, DarkGrey, DarkYellow
  - Game-specific colors: `CCTextDefault`, `CCWindowBorderDefault`, `CCListItemCurrentHighlight`
  - Map-specific colors: `CCPixenGrassDarkGreen`, `CCPixenGrassLightGreen`, `CCPixenRoadDarkBrown`, `CCPixenSkyBlue`
  - Pantone accents: `CCPantoneLightGrassGreen`, `CCPantonePottingSoil`, `CCPantoneSkyBlue`
  - Utility: `CCRandom` (random color generator)

### Equipment System
**Location:** `Classes/CombatEnginePrimitives/Equipment/`

Base equipment class hierarchy:
- `BattleEquipment.ps1` - Root base class for all equipment
- Individual slot base classes: `BEWeapon`, `BEArmor`, `BEHelmet`, `BEGauntlets`, `BEGreaves`, `BEBoots`, `BECape`, `BEPauldron`, `BEJewelry`
- Subdirectory structure for each slot type: `Weapons/`, `Armors/`, `Helmets/`, `Gauntlets/`, `Greaves/`, `Boots/`, `Capes/`, `Pauldrons/`, `Jewelry/`
- Individual items within each subdirectory are currently stubbed (loading is commented out in module pipeline — future work)

### Game Resources

#### Sound System
Two audio backends are available:
- `$Script:TheSfxMachine` / `$Script:TheBgmMachine` - `System.Media.SoundPlayer` instances
- `$Script:TheSfxMPlayer` / `$Script:TheBgmMPlayer` - `System.Windows.Media.MediaPlayer` instances

Sound file path globals (in `Private/Variables.ps1`):
- `$Script:SfxUiChevronMove` / `$Script:SfxUiSelectionValid` / `$Script:SfxBattleNem` - UI interaction
- `$Script:SfxBaPhysicalStrikeA` / `$Script:SfxBaFireStrikeA` / `$Script:SfxBaMissFail` / `$Script:SfxBaActionDisabled` - Battle action sounds
- `$Script:SfxBattleIntro` / `$Script:SfxBattlePlayerWin` / `$Script:SfxBattlePlayerLose` - Battle events
- `$Script:BgmBattleThemeA` - Battle background music
- `$Script:BgmTitleThemeA` / `$Script:BgmTitleThemeB` - Title screen music
- `$Script:BgmPlayerSetupThemeA` - Character creation music

#### Image Assets
**Resources/ImageData/** - Sixel-encoded profile images
- Female characters (Elf A-E, Human A-E)
- Male characters (Elf A-C, Human A-C)

**Resources/Sixel/** - Terminal sixel profile configurations

**Resources/MapData/** - JSON map definitions
- `SampleMap.json` - Primary exploration map
- `MapWarpTest01.json` / `MapWarpTest02.json` - Multi-map warp test maps

## Development Patterns

### Adding a New Battle Action
1. Create new class file in `Classes/CombatEnginePrimitives/BattleActions/`
   - File naming: `BA[ActionName].ps1`
2. Inherit from `BattleAction`
3. Set properties in constructor: `Name`, `Type`, `MpCost`, `EffectValue`, `Chance`, `Description`
4. Use the correct `BattleActionType` enum value (e.g., `[BattleActionType]::ElementalFire`, not the old `::Fire`)
5. Define `Effect` scriptblock for damage calculation (can use default `$Script:BaCalc`)
6. Optionally define `PreCalc` / `PostCalc` for special behavior

Example:
```powershell
Class BAMyFireSpell : BattleAction {
    BAMyFireSpell() : base() {
        $this.Name        = 'Blazing Inferno'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.MpCost      = 25
        $this.EffectValue = 45
        $this.Chance      = 0.95
        $this.Description = 'A powerful fire spell'
    }
}
```

### Adding a New Enemy Type
1. Create class file in `Classes/CombatEnginePrimitives/EnemyEntities/` (`EE[Name].ps1`)
2. Create image class in `Classes/ATStrings/EnemyEntityImages/` (`EEI[Name].ps1`), inheriting from `EEIInternalBase`
3. Inherit enemy from `EnemyBattleEntity`
4. Define `BaseStats` hashtable with initial values
5. Add enemy image global variable in `Private/Variables.ps1`
6. Add enemy class name string to the relevant region array in `$Script:BattleEncounterRegionTable`

### Adding UI Elements
1. Create window class extending `WindowBase`
2. Implement `Draw()` method for rendering
3. Use `ATString`/`ATStringComposite` for ANSI formatting. `UIEBase`, `UIELabel`, or `UIEMenu` controls may be used for more structured layouts with drawing control.
4. Register in `Private/Variables.ps1` as a typed global
5. Add state handler in game state block table if needed

### Adding Map Tiles and Objects
1. For new map: Create JSON config in `Resources/MapData/`
   - Define `MapName`, `MapWidth`, `MapHeight`, `BoundaryWrap`
   - Define tile grid with background image keys matching `$Script:TheSceneImages` hashtable
2. For new object: Create class in `Classes/Mapping/MapTileObjects/`
   - Inherit from `MapTileObject`
   - Implement interaction methods (`OnPickup`, `OnUse`, `OnExamine`)
3. For warp objects: Inherit from `MTOWarpable` and place under `MapTileObjects/Warpables/`
4. Instantiate maps in `Variables.ps1` via `[Map]::new(path)` and add instance to `$Script:TheSceneImages` if new scene image types are required

## Key Global Variables
**Location:** `Private/Variables.ps1`

Critical globals:
- `$Script:TheGameCore` - Main game loop controller
- `$Script:ThePlayer` - Player instance
- `$Script:TheCurrentEnemy` - Active enemy in battle
- `$Script:TheBattleManager` - Combat orchestration
- `$Script:CurrentMap` / `$Script:PreviousMap` - Active and previously visited game world
- `$Script:SampleMap`, `$Script:SampleWarpMap01`, `$Script:SampleWarpMap02` - Map instances
- `$Script:MapWarpHandler` - ScriptBlock for cross-map warp transitions
- `$Script:TheGlobalGameState` / `$Script:ThePreviousGlobalGameState` - Current and previous state enums
- `$Script:TheGlobalStateBlockTable` - State transition scriptblocks
- `$Script:TheSfxMachine` / `$Script:TheBgmMachine` - SoundPlayer audio instances
- `$Script:TheSfxMPlayer` / `$Script:TheBgmMPlayer` - MediaPlayer audio instances
- `$Script:TheInputManager` - Centralized keyboard/input handler
- `$Script:TheBufferManager` - Terminal output buffer
- `$Script:TheSceneImages` - Hashtable of all loaded `SceneImage` instances
- `$Script:BattleEncounterRegionTable` - Region-keyed hashtable of enemy class names for random encounters
- `$Script:BATAdornmentCharTable` - Display character and color per `BattleActionType`
- `$Script:AffinityMultNeg` / `$Script:AffinityMultPos` - Elemental affinity damage multipliers
- `$Script:TheStatusScreenState` / `$Script:StatusScreenMode` - Status screen sub-state tracking
- `$Script:StatusEsSelectedSlot` / `$Script:StatusIsSelected` - Currently selected technique/slot in status screen
- `$Script:TeletypeSpeed` - TTY output speed (`TtySpeed` enum)
- `$Script:TheItemToDrop` - Staged item pending drop confirmation
- `$Script:GpsRestoredFromInvBackup` / `$Script:GpsRestoredFromBatBackup` / `$Script:GpsRestoredFromStaBackup` - GPS re-entry flags
- Various battle audio state booleans: `$Script:IsBattleBgmPlaying`, `$Script:HasBattleIntroPlayed`, etc.
- Various window instances for each screen state

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
1. Add new enum value to `StatId` enum (if needed)
2. Add `BattleEntityProperty` in `BattleEntity` constructor
3. Update stat display windows to render new stat
4. Update character creation bonus point allocation

### To change UI colors:
1. Find or create the appropriate `CC*.ps1` in `Classes/ConsoleColor/`
2. Update window `BorderDrawColors` array
3. Change text `ForegroundColor` in string compositions

### To add a new map:
1. Create JSON in `Resources/MapData/` with `MapName`, `MapWidth`, `MapHeight`, `BoundaryWrap`, and tile definitions using scene image key names from `$Script:TheSceneImages`
2. Instantiate in `Private/Variables.ps1` with `[Map]::new(path)`
3. Set as `$Script:CurrentMap` or wire up via `$Script:MapWarpHandler` from a warp tile

## Module Loading Notes
- Module initialization can take 1-2 minutes due to large amount of code (100+ battle actions, 30+ scene images, multiple UI windows)
- All code is loaded into memory at startup for performance
- No lazy-loading currently implemented (potential optimization opportunity)
- Individual equipment item files (under each equipment slot subdirectory) are currently commented out — only the base equipment type classes are loaded
- Global state is initialized in `Variables.ps1` after all classes are loaded
