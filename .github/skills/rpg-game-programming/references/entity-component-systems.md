# Entity Component Systems

Eldoria uses **class inheritance with property composition** rather than a pure ECS, but the patterns are close. Game entities are built from:
- A common base class (`BattleEntity`) that aggregates components via hashtables
- Property wrapper objects (`BattleEntityProperty`) that encapsulate a single numeric stat
- Slot-keyed hashtables for stats, actions, and equipment

---

## Core Class Hierarchy

```
BattleEntity
├── Player
│   ├── PlayerItemInventory      (List<ValueTuple<MapTileObject, Int>>)
│   ├── PlayerActionInventory    (List<BattleAction>)
│   └── EquipmentListing         (Hashtable<EquipmentSlot, BattleEquipment>)
└── EnemyBattleEntity
    ├── Image                    (EnemyEntityImage)
    ├── SpoilsItems              (MapTileObject[])
    └── SpoilsEffect             (ScriptBlock)

MapTileObject
└── BattleEquipment
    ├── BEWeapon
    ├── BEArmor
    ├── BEHelmet
    ├── BEGauntlets
    ├── BEGreaves
    ├── BEBoots
    ├── BECape
    ├── BEPauldron
    └── BEJewelry
```

---

## BattleEntityProperty — The Property Wrapper Pattern

Every numeric stat on an entity is wrapped in a `BattleEntityProperty` object. This separates raw value management from the entity class and enables:

- **Augmentation** (temporary buffs with auto-expiry)
- **Threshold-based state** (Normal → Caution → Danger) for UI color coding
- **Validation callbacks** via a `ScriptBlock`

```powershell
Class BattleEntityProperty {
    [Int]$Base                      # Current value
    [Int]$BasePre                   # Snapshot before augmentation
    [Int]$BaseAugmentValue          # Buff/debuff amount
    [Int]$Max                       # Maximum value
    [Int]$AugmentTurnDuration       # Turns remaining on buff
    [Boolean]$BaseAugmentActive
    [StatNumberState]$State         # Normal / Caution / Danger

    Static [Single]$StatNumThresholdCaution = 0.6   # 60% of max
    Static [Single]$StatNumThresholdDanger  = 0.3   # 30% of max
}
```

### Augmentation Lifecycle

1. Set `BaseAugmentValue` (positive for buff, negative for debuff)
2. Set `AugmentTurnDuration` to the number of turns it should last
3. Call `Update()` each turn — it applies the buff on first tick and restores `BasePre` when duration expires

```powershell
[Void]Update() {
    If($this.AugmentTurnDuration -GT 0) {
        $this.AugmentTurnDuration--
        If($this.BaseAugmentActive -EQ $false) {
            $this.Base = [Math]::Clamp($this.Base + $this.BaseAugmentValue, 0, [Int]::MaxValue)
            $this.BasePre = $this.Base - $this.BaseAugmentValue   # Store pre-aug value
            $this.BaseAugmentActive = $true
        }
    } Else {
        If($this.BaseAugmentActive -EQ $true) {
            $this.Base = $this.BasePre   # Restore on expiry
            $this.BaseAugmentActive = $false
        }
    }
    Invoke-Command $this.ValidateFunction -ArgumentList $this
}
```

---

## BattleEntity — Stat Aggregation

Stats are stored as a `[Hashtable]` keyed by `[StatId]` enum values. This means all stat access is O(1) by enum key:

```powershell
# Access a stat
$HpProp = $Entity.Stats[[StatId]::HitPoints]

# Decrement HP by damage amount
$HpProp.DecrementBase($Damage * -1)

# Check if alive
$IsAlive = $Entity.Stats[[StatId]::HitPoints].Base -GT 0
```

### StatId Enum (key reference)
```powershell
Enum StatId {
    HitPoints
    MagicPoints
    Attack
    Defense
    Speed
    Luck
    AffinityFire
    AffinityWater
    AffinityEarth
    AffinityWind
    AffinityLight
    AffinityDark
    AffinityIce
}
```

---

## Player — Composition on Top of BattleEntity

`Classes/CombatEnginePrimitives/Player.ps1` adds:

```powershell
Class Player : BattleEntity {
    [Int]$CurrentGold
    [Int]$ProfileImageIndex
    [ATCoordinates]$MapCoordinates        # World position

    [PlayerActionInventory]$ActionInventory    # Up to 4 equipped actions
    [PlayerItemInventory]$ItemInventory        # Consumables and key items

    [Hashtable]$EquipmentListing = @{         # 10 slots
        [EquipmentSlot]::Weapon    = $null
        [EquipmentSlot]::Armor     = $null
        [EquipmentSlot]::Helmet    = $null
        [EquipmentSlot]::Gauntlets = $null
        [EquipmentSlot]::Greaves   = $null
        [EquipmentSlot]::Boots     = $null
        [EquipmentSlot]::Cape      = $null
        [EquipmentSlot]::Pauldron  = $null
        [EquipmentSlot]::JewelryA  = $null
        [EquipmentSlot]::JewelryB  = $null
    }
}
```

---

## PlayerItemInventory — Stacking Inventory

Items stack up to `QuantityMax = 99`. Uses `ValueTuple<MapTileObject, Int>` where `Item1` is the item object and `Item2` is quantity.

```powershell
# Add an item (auto-stacks if already present)
$Script:ThePlayer.ItemInventory.AddItem($AppleInstance, 5)

# Remove items (decrements quantity, removes entry at 0)
$Script:ThePlayer.ItemInventory.RemoveItem($AppleInstance, 1)
```

---

## Enemy Entity

`Classes/CombatEnginePrimitives/EnemyBattleEntity.ps1`:

```powershell
Class EnemyBattleEntity : BattleEntity {
    [EnemyEntityImage]$Image         # ANSI art sprite
    [Int]$SpoilsGold                 # Gold dropped on defeat
    [MapTileObject[]]$SpoilsItems    # Items dropped on defeat
    [ScriptBlock]$SpoilsEffect       # Custom post-battle callback
}
```

Enemy action selection uses `$this.ActionMarbleBag` — an array of `[ActionSlot]` values where slots can be repeated to weight probabilities:

```powershell
# Enemy picks a random action from its marble bag
$SelectedSlot = $this.ActionMarbleBag | Get-Random
$SelectedAction = $this.ActionListing[$SelectedSlot]
```

---

## Adding a New Entity Type

### Step 1 — Create the Enemy Class
`Classes/CombatEnginePrimitives/EnemyEntities/EE[Name].ps1`:

```powershell
Class EEGoblin : EnemyBattleEntity {
    EEGoblin() : base() {
        $this.Name    = 'Goblin'
        $this.Image   = $Script:EeiGoblin
        $this.SpoilsGold = 30

        $this.Stats[[StatId]::HitPoints].Base  = 180
        $this.Stats[[StatId]::HitPoints].Max   = 180
        $this.Stats[[StatId]::Attack].Base     = 14
        $this.Stats[[StatId]::Defense].Base    = 8
        $this.Stats[[StatId]::Speed].Base      = 18
        $this.Stats[[StatId]::Luck].Base       = 5
        $this.Affinity = [BattleActionType]::ElementalEarth

        # Load actions
        $this.ActionListing[[ActionSlot]::SlotA] = [BAAxeSlash]::new()
        $this.ActionListing[[ActionSlot]::SlotB] = [BARockThrow]::new()

        # Weight action bag: 70% SlotA, 30% SlotB
        $this.ActionMarbleBag = @(
            [ActionSlot]::SlotA, [ActionSlot]::SlotA, [ActionSlot]::SlotA,
            [ActionSlot]::SlotA, [ActionSlot]::SlotA, [ActionSlot]::SlotA,
            [ActionSlot]::SlotA, [ActionSlot]::SlotB, [ActionSlot]::SlotB,
            [ActionSlot]::SlotB
        )
    }
}
```

### Step 2 — Create the Enemy Image Class
`Classes/ATStrings/EnemyEntityImages/EEIGoblin.ps1`:

```powershell
Class EEIGoblin : EEIInternalBase {
    EEIGoblin() : base() {
        # Define ANSI art rows using ATString objects
        $this.ImageLines = @(
            [ATString]::new(' (o_o) ', [CCAppleGreenLight24]::new(), $null, $null, $null, $null),
            # ... more rows
        )
    }
}
```

### Step 3 — Register Image Global in Variables.ps1
```powershell
[EEIGoblin]$Script:EeiGoblin = [EEIGoblin]::new()
```

### Step 4 — Add to Encounter Region Table
```powershell
$Script:BattleEncounterRegionTable = @{
    0 = @('EEBat', 'EENightwing', 'EEGoblin')   # Add new name here
    1 = @('EEWingblight', 'EEDarkfang')
}
```

### Step 5 — Wire Up in Module Pipeline
Add dot-source lines to `Eldoria.psm1` in the correct order (enemy entities after combat primitives, before battle manager).

---

## Adding a New Stat

### Step 1 — Add to StatId Enum
```powershell
# Enums/StatId.ps1
Enum StatId {
    # ... existing ...
    Charisma   # New stat
}
```

### Step 2 — Initialize in BattleEntity Constructor
```powershell
$this.Stats[[StatId]::Charisma] = [BattleEntityProperty]::new()
$this.Stats[[StatId]::Charisma].Base = 10
$this.Stats[[StatId]::Charisma].Max  = 50
```

### Step 3 — Display in Status Windows
Update `PlayerStatusSummaryWindow.ps1` (or relevant display window) to render the new stat.

---

## Equipment: Adding a New Item

Individual equipment items live under slot subdirectories (currently stubbed). To add one:

1. Create `Classes/CombatEnginePrimitives/Equipment/Weapons/BESteelSword.ps1`
2. Inherit from the slot base class:
   ```powershell
   Class BESteelSword : BEWeapon {
       BESteelSword() : base() {
           $this.Name           = 'Steel Sword'
           $this.Description    = 'A reliable steel blade.'
           $this.PurchasePrice  = 300
           $this.SellPrice      = 150
           $this.TargetGender   = [Gender]::Any
           $this.TargetStats    = @{ [StatId]::Attack = 12 }
           $this.RequiredStats  = @{ [StatId]::Attack = 5 }
       }
   }
   ```
3. Un-comment or add the dot-source line in `Eldoria.psm1` under the equipment loading section

---

## Quality Checklist

- [ ] New enemy class inherits from `EnemyBattleEntity`
- [ ] All relevant stats initialized with `Base` and `Max`
- [ ] `Affinity` set to the appropriate `BattleActionType` (drives the affinity LUT)
- [ ] `ActionMarbleBag` populated with weighted slot distribution
- [ ] Enemy image class created and global declared in `Variables.ps1`
- [ ] Enemy class name string added to the correct region array in `$Script:BattleEncounterRegionTable`
- [ ] Dot-source added to `Eldoria.psm1` in the correct load order position
- [ ] New stat added to both base class constructor and all display windows
