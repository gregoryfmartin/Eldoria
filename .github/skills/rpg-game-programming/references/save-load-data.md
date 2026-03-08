# Save & Load Data

Eldoria's save system is **partially designed but not yet implemented** for player data. Map data deserialization (JSON → `[Map]` objects) is fully working and serves as the reference model for adding full save/load support.

---

## What Already Works: Map JSON Deserialization

`Classes/Mapping/Map.ps1` reads a JSON file at construction time:

```powershell
Map([String]$JsonConfigPath) {
    [Hashtable]$JsonData = @{}

    If($(Test-Path $JsonConfigPath) -EQ $true) {
        $JsonData = Get-Content -Raw $JsonConfigPath | ConvertFrom-Json -AsHashtable
    }

    $this.Name         = $JsonData['MapName']
    $this.MapWidth     = $JsonData['MapWidth']
    $this.MapHeight    = $JsonData['MapHeight']
    $this.BoundaryWrap = $JsonData['BoundaryWrap']
    $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth

    For([Int]$Y = 0; $Y -LT $this.MapHeight; $Y++) {
        For([Int]$X = 0; $X -LT $this.MapWidth; $X++) {
            $this.Tiles[$Y, $X] = [MapTile]::new($JsonData['Tiles'][$Y][$X])
        }
    }
}
```

### Map JSON Format (canonical reference)

```json
{
  "MapName"      : "SampleMap",
  "MapWidth"     : 2,
  "MapHeight"    : 2,
  "BoundaryWrap" : false,
  "Tiles": [
    [
      {
        "BackgroundImage" : "FieldNorthEastRoad",
        "ObjectListing"   : ["MTOApple", "MTOTree"],
        "Exits"           : [true, false, true, false],
        "BattleAllowed"   : false,
        "EncounterRate"   : 0.5,
        "RegionCode"      : 0
      }
    ]
  ]
}
```

---

## What Needs to Be Built: Player Save Data

The `StatusScreenState::Save` enum value already exists. The infrastructure needed:

### Serializable Player Data Inventory

Everything that must survive a save:

| Category | Fields |
|----------|--------|
| Identity | `Name`, `Gender`, `Affinity`, `ProfileImageIndex` |
| Currency | `CurrentGold` |
| Position | `MapCoordinates` (Row, Column), current `MapName` |
| Stats | All `BattleEntityProperty` values: `HitPoints`, `MagicPoints`, `Attack`, `Defense`, `Speed`, `Luck`, elemental affinities |
| Items | `PlayerItemInventory`: list of `(ItemName, Quantity)` tuples |
| Actions | `PlayerActionInventory`: list of equipped action names |
| Equipment | `EquipmentListing`: 10 slots → class name of equipped item (or `null`) |

---

## Recommended Save File Format

```json
{
  "SaveVersion"  : 1,
  "PlayerName"   : "Lyra",
  "Gender"       : "Female",
  "Affinity"     : "ElementalFire",
  "ProfileIndex" : 3,
  "CurrentGold"  : 1500,
  "CurrentMap"   : "SampleMap",
  "MapRow"       : 5,
  "MapColumn"    : 8,
  "Stats": {
    "HitPoints"   : { "Base": 850, "Max": 1000 },
    "MagicPoints" : { "Base": 420, "Max":  500 },
    "Attack"      : { "Base":  28, "Max":   28 },
    "Defense"     : { "Base":  15, "Max":   15 },
    "Speed"       : { "Base":  22, "Max":   22 },
    "Luck"        : { "Base":  18, "Max":   18 }
  },
  "Items": [
    { "ItemClass": "MTOApple", "Quantity": 15 },
    { "ItemClass": "MTORope",  "Quantity":  8 }
  ],
  "EquippedActions": [
    "BASwordSlash",
    "BAFireball",
    null,
    null
  ],
  "Equipment": {
    "Weapon"    : "BESteelSword",
    "Armor"     : "BELeatherArmor",
    "Helmet"    : null,
    "Gauntlets" : null,
    "Greaves"   : null,
    "Boots"     : null,
    "Cape"      : null,
    "Pauldron"  : null,
    "JewelryA"  : null,
    "JewelryB"  : null
  }
}
```

---

## Implementing the Save Method

Add a `Save([String]$FilePath)` method to `Player` or a dedicated `SaveManager` class:

```powershell
[Void]Save([String]$FilePath) {
    [Hashtable]$SaveData = @{
        SaveVersion  = 1
        PlayerName   = $this.Name
        Gender       = $this.Gen.ToString()
        Affinity     = $this.Affinity.ToString()
        ProfileIndex = $this.ProfileImageIndex
        CurrentGold  = $this.CurrentGold
        CurrentMap   = $Script:CurrentMap.Name
        MapRow       = $this.MapCoordinates.Row
        MapColumn    = $this.MapCoordinates.Column
        Stats        = @{}
        Items        = @()
        EquippedActions = @(
            $null, $null, $null, $null
        )
        Equipment    = @{}
    }

    # Serialize stats
    ForEach($StatKey in $this.Stats.Keys) {
        $Prop = $this.Stats[$StatKey]
        $SaveData['Stats'][$StatKey.ToString()] = @{
            Base = $Prop.Base
            Max  = $Prop.Max
        }
    }

    # Serialize item inventory
    ForEach($Entry in $this.ItemInventory) {
        $SaveData['Items'] += @{
            ItemClass = $Entry.Item1.GetType().Name
            Quantity  = $Entry.Item2
        }
    }

    # Serialize equipped actions
    For([Int]$i = 0; $i -LT $this.ActionInventory.Listing.Count; $i++) {
        $SaveData['EquippedActions'][$i] = $this.ActionInventory.Listing[$i].GetType().Name
    }

    # Serialize equipment
    ForEach($Slot in $this.EquipmentListing.Keys) {
        $Item = $this.EquipmentListing[$Slot]
        $SaveData['Equipment'][$Slot.ToString()] = $Item ? $Item.GetType().Name : $null
    }

    $SaveData | ConvertTo-Json -Depth 10 | Set-Content -Path $FilePath -Encoding UTF8
}
```

---

## Implementing the Load Method

```powershell
[Void]Load([String]$FilePath) {
    If(-Not (Test-Path $FilePath)) { Return }

    [Hashtable]$Data = Get-Content -Raw $FilePath | ConvertFrom-Json -AsHashtable

    $this.Name               = $Data['PlayerName']
    $this.Gen                = [Gender]($Data['Gender'])
    $this.Affinity           = [BattleActionType]($Data['Affinity'])
    $this.ProfileImageIndex  = $Data['ProfileIndex']
    $this.CurrentGold        = $Data['CurrentGold']

    # Restore map position — map itself must be set externally via $Script:CurrentMap
    $this.MapCoordinates.Row    = $Data['MapRow']
    $this.MapCoordinates.Column = $Data['MapColumn']

    # Restore stats
    ForEach($StatName in $Data['Stats'].Keys) {
        $StatId = [StatId]$StatName
        $Prop   = $this.Stats[$StatId]
        $Prop.Base = $Data['Stats'][$StatName]['Base']
        $Prop.Max  = $Data['Stats'][$StatName]['Max']
    }

    # Restore items (instantiate by class name)
    $this.ItemInventory.Clear()
    ForEach($Entry in $Data['Items']) {
        $ItemInstance = New-Object -TypeName $Entry['ItemClass']
        $this.ItemInventory.AddItem($ItemInstance, $Entry['Quantity'])
    }

    # Restore equipped actions
    $this.ActionInventory.Listing.Clear()
    ForEach($ActionName in $Data['EquippedActions']) {
        If($null -NE $ActionName) {
            $this.ActionInventory.Add((New-Object -TypeName $ActionName))
        }
    }

    # Restore equipment
    ForEach($SlotName in $Data['Equipment'].Keys) {
        $Slot = [EquipmentSlot]$SlotName
        $ClassName = $Data['Equipment'][$SlotName]
        $this.EquipmentListing[$Slot] = $ClassName ? (New-Object -TypeName $ClassName) : $null
    }
}
```

---

## Save File Location Best Practices
- Store saves in a dedicated subfolder: `Resources/SaveData/`
- Name files with a slot index or player name: `Save_Slot01.json`
- Always write `SaveVersion` to support future migration logic
- Validate `SaveVersion` on load and gracefully handle missing keys

---

## Version Migration Pattern

```powershell
Switch($Data['SaveVersion']) {
    1 {
        # Current format — load normally
        $this.LoadV1($Data)
    }
    Default {
        Write-Warning "Unknown save version $($Data['SaveVersion']). Cannot load."
    }
}
```

---

## Quality Checklist

- [ ] Save file path validation with `Test-Path` before reading
- [ ] `SaveVersion` field written and checked on load
- [ ] All stat `Base` and `Max` values serialized (not just `Base`)
- [ ] Item/action/equipment class names stored as strings and reconstructed with `New-Object`
- [ ] Equipment slot `$null` values serialized explicitly (not omitted)
- [ ] Current map name stored; map reload handled in the calling code
- [ ] Augmentation state (`AugmentTurnDuration`, `BaseAugmentActive`) not saved — resets to baseline on load is intentional
