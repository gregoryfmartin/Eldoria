---
name: rpg-game-programming
description: 'RPG game programming expertise for Eldoria. USE FOR: designing or implementing state machines, game state transitions, sub-screen state stacking; save and load systems, player data serialization, JSON map data; entity component system (ECS) design, property wrappers, stat composition, inventory slots, equipment hierarchies; RPG combat math including damage formulas, affinity lookup tables, evasion, critical hits, turn order, MP systems, stat augmentation, and elemental weakness/resistance. DO NOT USE FOR: general PowerShell syntax questions; UI rendering or ANSI escape logic; audio engine integration; Pester test authoring.'
argument-hint: 'What RPG system are you designing or debugging? (state-machine | save-load | entities | combat-math)'
---

# RPG Game Programming

## What This Skill Produces
Expert guidance and implementation patterns for the four core RPG engineering disciplines used in Eldoria:

| Domain | Reference |
|--------|-----------|
| State machine architecture | [State Management](./references/state-management.md) |
| Save / load data systems | [Save & Load Data](./references/save-load-data.md) |
| Entity composition & components | [Entity Component Systems](./references/entity-component-systems.md) |
| Combat mathematics & formulas | [Combat Math](./references/combat-math.md) |

---

## When to Use This Skill

Invoke this skill (type `/rpg-game-programming`) when the task involves:

- Designing a new game screen, sub-state flow, or state transition
- Adding a save or load system, serializing player or world data
- Creating a new entity type, stat, equipment slot, or inventory kind
- Writing or tuning damage formulas, elemental tables, turn order, or status effects
- Auditing or refactoring any of the above systems for correctness or balance

---

## Quick Decision Guide

```
What are you working on?
│
├─ "Adding a new screen / menu flow"
│   → State machine pattern           → see state-management.md
│
├─ "Persisting player progress to disk"
│   → Save/load system design         → see save-load-data.md
│
├─ "New enemy type / stat / equipment"
│   → Entity composition pattern      → see entity-component-systems.md
│
└─ "Damage formula / affinity / crit / turn order"
    → Combat math model               → see combat-math.md
```

---

## Procedure

### Step 1 — Identify the Domain
Determine which of the four domains the task falls into based on the decision guide above. A single task may span two domains (e.g., a new entity type that resists certain elements touches ECS *and* combat math).

### Step 2 — Load the Reference File
Read the appropriate reference file listed in the table at the top of this SKILL.md. Each reference contains:
- Core concepts and terminology used in Eldoria
- Canonical patterns with code examples
- Step-by-step procedures for common tasks
- Quality criteria and completion checklist

### Step 3 — Explore the Codebase
Before writing code, use tools to verify the current state of the relevant subsystem. Key entry points:

| Domain | Start Here |
|--------|-----------|
| State management | `Private/Variables.ps1` → `$Script:TheGlobalStateBlockTable` |
| Save / load | `Classes/Mapping/Map.ps1` → constructor; `Classes/CombatEnginePrimitives/Player.ps1` |
| Entities | `Classes/CombatEnginePrimitives/BattleEntity.ps1` |
| Combat math | `Private/Variables.ps1` → `$Script:BaCalc`, `$Script:BATLut` |

### Step 4 — Implement Following Established Patterns
Match naming conventions, inheritance chains, and coding style already present in the codebase. See each reference for specific conventions.

### Step 5 — Wire Up in Module Pipeline
Most new files must be registered in:
- `Eldoria.psm1` — add a dot-source line in the correct loading order
- `Private/Variables.ps1` — declare global instance variables and initialize them

### Step 6 — Validate
- Check for compile errors (`Get-Errors` or load the module with `-Force`)
- Verify the new system reaches the correct state in the game loop
- For combat changes: walk through the damage formula manually with test values

---

## Eldoria Module Loading Order (Summary)

When adding new files, respect this sequence in `Eldoria.psm1`:

1. Enums
2. ConsoleColor palettes
3. FastNoiseLite / ATStrings / Scene images
4. Mapping system
5. Combat engine primitives (BattleEntity, BattleEntityProperty, Player, Enemy)
6. Battle actions (`BA*.ps1`)
7. Enemy entities (`EE*.ps1`)
8. Equipment base classes
9. UI system (BufferManager, InputManager, Windows)
10. BattleManager + GameCore
11. Global variables (`Private/Variables.ps1`) — **always last**
