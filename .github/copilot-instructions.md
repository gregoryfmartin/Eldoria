# Eldoria Game AI Assistant Instructions

## Project Overview
Eldoria is a terminal-based RPG game written in PowerShell Core, featuring:
- Turn-based combat system
- World map navigation
- Inventory management
- Character creation and progression
- Sound effects and background music

## Architecture and Key Components

### Core Game Structure
- `GameCore.ps1` - Main entry point and game loop
- `BattleManager.ps1` - Handles combat system state machine
- State management via `GameStatePrimary` enum (Title, Battle, Inventory screens etc.)
- Global state blocks table for screen/state transitions

### Combat System
- Located in `Classes/CombatEnginePrimitives/`
- Key classes:
  - `BattleEntity.ps1` - Base class for combat participants
  - `Player.ps1` - Player-specific battle entity implementation
  - `EnemyBattleEntity.ps1` - Enemy implementation
  - `BattleAction.ps1` - Combat moves/abilities
- Battle state machine phases:
  1. Turn order determined by speed stats
  2. Phase A/B execution for each entity
  3. Action selection (player input or enemy random)
  4. Damage calculation with affinity bonuses
  5. Status updates and turn progression

### Player Systems
- Character creation flow:
  1. Name entry
  2. Gender selection (affects stat bonuses)
  3. Bonus point allocation
  4. Elemental affinity selection
  5. Profile image selection
- Inventory system with paginated display
- Equipment slots and stats
- Battle action inventory for combat abilities

### UI and Rendering
- Uses terminal-based rendering with color support
- Buffer management for screen updates
- ASCII/Unicode art for visuals
- Message windows for game feedback

## Development Patterns

### State Management
- States defined in `Enums/` directory
- State transitions handled via scriptblock table
- Each major screen (battle, inventory etc.) has own state machine

### Battle Actions
- Defined in `Classes/CombatEnginePrimitives/BattleActions/`
- Inherit from `BattleAction` base class
- Properties:
  ```powershell
  [String]$Name
  [BattleActionType]$Type  # Physical, Elemental, etc.
  [Int]$MpCost
  [Int]$EffectValue
  [Single]$Chance
  [String]$Description
  ```

### Map System
- Grid-based navigation with cardinal directions
- Tile system with battle encounter rates
- Region-based enemy spawning

## Key Files for Common˝ Tasks
- Adding new battle actions: Create new class in `Classes/CombatEnginePrimitives/BattleActions/`
- Modifying enemy behavior: Edit `EnemyBattleEntity.ps1`
- Adding UI elements: See `Classes/BufferManager.ps1` for drawing
- Changing game states: Update `GameStatePrimary.ps1` enum and state blocks

## Prerequisites
- PowerShell Core 7.3.0+
- Windows Terminal 1.21.X+
- Windows 10/Server 2019 or newer

## Getting Started
1. Import module: `Import-Module .\Eldoria.psm1 -Force`
2. Start game: `Start-Eldoria`
