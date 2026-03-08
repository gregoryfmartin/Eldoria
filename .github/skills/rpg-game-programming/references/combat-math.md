# Combat Mathematics

This reference documents every mathematical system in Eldoria's turn-based combat engine: damage formulas, elemental affinity tables, critical hits, evasion, turn ordering, and MP systems.

---

## Overview of the Damage Pipeline

Every combat action runs a multi-phase calculation pipeline defined in `$Script:BaCalc` (`Private/Variables.ps1`). All phases run sequentially; a failure at any phase short-circuits to a failure result.

```
Phase 1: MP Sufficiency Check
Phase 2: MP Deduction
Phase 3: Action Chance Roll (miss)
Phase 4: Target Evasion Roll
Phase 5: Base Damage Calculation
Phase 6: Critical Hit Factor
Phase 7: Elemental Affinity Factor (LUT lookup)
Phase 8: Final Damage = Base × Crit × Affinity
Phase 9: HP Decrement on Target
Phase 10: Result Type Classification
```

---

## Phase 1–2: MP System

**Sufficiency check:**
```powershell
If($SelfAction.MpCost -GT 0) {
    $CanExecute = $Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost
} Else {
    $CanExecute = $true   # Free actions always proceed
}
```

**MP deduction (before damage, so failed executions still cost MP if checked):**
```powershell
$Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
```

---

## Phase 3: Action Chance

Each `BattleAction` has a `[Single]$Chance` property in `[0.0, 1.0]`. A random roll above the chance causes an immediate miss.

```powershell
$ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
If($ExecuteChance -GT $SelfAction.Chance) {
    Return [BattleActionResult]@{ Type = [BattleActionResultType]::FailedAttackFailed }
}
```

| Chance Value | Meaning |
|---|---|
| `1.0` | Always hits (if other checks pass) |
| `0.95` | 5% base miss rate |
| `0.7` | 30% base miss rate |
| `0.1` | 90% base miss rate (high-risk, high-reward) |

---

## Phase 4: Evasion

Evasion is computed from the **target's Speed**, adding a small scaling factor with randomness:

$$\text{EffectiveEvasion} = \left\lfloor\left(0.1 + \text{Speed}_\text{target} \times \text{RNG}(0.001, 0.003)\right) \times 100\right\rfloor$$

Then a roll from 1–100 is compared:
```powershell
$TargetEffectiveEvasion = [Math]::Round(
    (0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100
)
$EvRandFactor = Get-Random -Minimum 1 -Maximum 100
If($EvRandFactor -LE $TargetEffectiveEvasion) {
    Return [BattleActionResult]@{ Type = [BattleActionResultType]::FailedAttackMissed }
}
```

**Approximate evasion rate by Speed:**

| Speed | Avg Evasion% |
|-------|-------------|
| 10    | ~12%        |
| 20    | ~14%        |
| 50    | ~20%        |
| 100   | ~30%        |

The `0.1` base ensures every entity has a minimum ~10% evasion floor.

---

## Phase 5: Base Damage Formula

$$\text{BaseDamage} = \left|\text{EffectValue} \times \left[(\text{ATK}_\text{self} - \text{DEF}_\text{target}) \times \left(1 + \text{Luck}_\text{self} - \text{Luck}_\text{target}\right)\right] \times \text{RNG}(0.07, 0.15)\right|$$

```powershell
$EffectiveDamageP1 = [Math]::Round([Math]::Abs(
    $SelfAction.EffectValue * (
        ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
        (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
    ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
))
```

### Key Behavior Notes

- `[Math]::Abs()` is applied — a high-defense target never results in negative (healing) damage; it floors at 0
- The `EffectValue` on a `BattleAction` is the **primary tuning knob** for ability power balance
- The random multiplier `RNG(0.07, 0.15)` provides ~8.5% variance (min–max spread) on every hit
- `Luck` differential acts as a secondary ATK/DEF modifier — high-luck attackers deal more; high-luck defenders take less

---

## Phase 6: Critical Hit Factor

A critical multiplies the base damage by **1.5×**. Crit chance scales with attacker `Luck`:

$$P(\text{crit}) = \frac{\text{Luck}_\text{self}}{1000}$$

```powershell
$CriticalChance = Get-Random -Minimum 1 -Maximum 1000
If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
    $EffectiveDamageCritFactor = 1.5
}
```

| Luck Value | Approx. Crit Rate |
|------------|------------------|
| 5          | 0.5%             |
| 20         | 2.0%             |
| 50         | 5.0%             |
| 100        | 10.0%            |
| 200        | 20.0%            |

---

## Phase 7: Elemental Affinity Factor

The affinity lookup table (`$Script:BATLut`) is an **8×8 matrix** indexed by `[AttackType, TargetAffinity]`:

```
Rows    = Attack BattleActionType  (Physical, Fire, Water, Earth, Wind, Light, Dark, Ice)
Columns = Target Affinity          (Physical, Fire, Water, Earth, Wind, Light, Dark, Ice)
```

| Multiplier | Meaning |
|---|---|
| `1.75` | Weakness — attacker's element counters defender's |
| `1.0` | Neutral |
| `0.5` | Partial resistance |
| `-0.75` | Full resistance — attacker and defender share the same element |

### Full Affinity Matrix (row = attack type, column = target affinity)

|          | Phys | Fire | Water | Earth | Wind | Light | Dark | Ice   |
|----------|------|------|-------|-------|------|-------|------|-------|
| Physical | 1.0  | 1.0  | 1.0   | 1.0   | 1.0  | 1.0   | 1.0  | 1.0   |
| Fire     | 1.0  | −0.75| 0.5   | 0.5   | 0.5  | 1.0   | 1.0  | **1.75**|
| Water    | 1.0  | **1.75**|−0.75|1.0   | 0.5  | 1.0   | 1.0  | 0.5   |
| Earth    | 1.0  | 0.5  | 1.0   | −0.75 | 0.5  | 1.0   | 1.0  | **1.75**|
| Wind     | 1.0  | 1.0  | 1.0   | **1.75**|−0.75|1.0  | 1.0  | 0.5   |
| Light    | 1.0  | 1.0  | 1.0   | 1.0   | 1.0  | −0.75 |**1.75**|1.0  |
| Dark     | 1.0  | 1.0  | 1.0   | 1.0   | 1.0  | **1.75**|−0.75|1.0  |
| Ice      | 1.0  | 0.5  | **1.75**|**1.75**|1.0| 1.0   | 1.0  | −0.75 |

**Code lookup:**
```powershell
$EffectiveDamageAffinityFactor = $Script:BATLut[$SelfAction.Type][$Target.Affinity]
```

### Design Notes
- Physical always deals neutral damage regardless of target affinity
- Fire and Ice are counters (Fire melts Ice; Ice quenches Water/Earth moisture)
- Light and Dark directly counter each other
- **Known Bug:** The `−0.75` self-resistance multiplier is applied *after* `[Math]::Abs()` in Phase 5, so same-element attacks never deal zero or negative damage — they always produce a small positive value. The intended behavior is true immunity (0 damage). This needs to be fixed by either applying `[Math]::Abs()` only after the affinity factor, or clamping `FinalDamage` to 0 when the affinity multiplier is negative.

---

## Phase 8: Final Damage Calculation

$$\text{FinalDamage} = \text{BaseDamage} \times \text{CritFactor} \times \text{AffinityFactor}$$

```powershell
$FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
```

The multipliers are **multiplicative**, not additive. A crit + weakness hit = `1.5 × 1.75 = 2.625×` base damage.

---

## Phase 10: Result Type Classification

| Result Type | Conditions |
|---|---|
| `Success` | Hit, no crit, neutral affinity |
| `SuccessWithCritical` | Crit only |
| `SuccessWithAffinityBonus` | Affinity bonus only |
| `SuccessWithCritAndAffinityBonus` | Both crit and affinity bonus |
| `FailedAttackMissed` | Evasion roll succeeded |
| `FailedAttackFailed` | Chance roll below threshold |
| `FailedNoUsesRemaining` | MP insufficient |

The result type is used by the `BattleStatusMessageWindow` to display the correct feedback string.

---

## Turn Order System

Turn order is recalculated each turn in the `PhaseOrdering` state of `BattleManager`:

$$\text{EffectiveSpeed} = \text{Speed}_\text{base} + \text{RNG}(0.0, 1.0) \times \text{Luck}_\text{base}$$

```powershell
[Single]$PlayerEffSpeed = $Script:ThePlayer.Stats[[StatId]::Speed].Base +
    ($(Get-Random -Minimum 0.0 -Maximum 1.0) * $Script:ThePlayer.Stats[[StatId]::Luck].Base)

[Single]$EnemyEffSpeed = $Script:TheCurrentEnemy.Stats[[StatId]::Speed].Base +
    ($(Get-Random -Minimum 0.0 -Maximum 1.0) * $Script:TheCurrentEnemy.Stats[[StatId]::Luck].Base)

If($PlayerEffSpeed -GE $EnemyEffSpeed) {
    $this.PhaseOneEntity = $Script:ThePlayer
    $this.PhaseTwoEntity = $Script:TheCurrentEnemy
} Else {
    $this.PhaseOneEntity = $Script:TheCurrentEnemy
    $this.PhaseTwoEntity = $Script:ThePlayer
}
```

**Implications:**
- A high-Luck entity has more variance, making it harder to predict turn order but allowing upset victories
- A pure Speed difference guarantees most turns but never guarantees every turn
- For balance: Speed determines average turn priority; Luck determines consistency

---

## Stat Augmentation (MagicStatAugment Actions)

Actions with type `BattleActionType::MagicStatAugment` modify `BattleEntityProperty` augmentation fields:

```powershell
# Example buff action effect scriptblock
$this.Effect = {
    Param([BattleEntity]$Self, [BattleEntity]$Target, [BattleAction]$SelfAction)
    $Self.Stats[[StatId]::Attack].BaseAugmentValue  = 20
    $Self.Stats[[StatId]::Attack].AugmentTurnDuration = 3
}
```

The `BattleEntityProperty.Update()` applies the buff on next tick and tracks remaining duration. After `AugmentTurnDuration` reaches 0, the original value is restored.

---

## Adding a New Battle Action

### Step 1 — Create the Class
`Classes/CombatEnginePrimitives/BattleActions/BA[Name].ps1`:

```powershell
Class BAThunderStrike : BattleAction {
    BAThunderStrike() : base() {
        $this.Name        = 'Thunder Strike'
        $this.Description = 'A bolt from the sky.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.MpCost      = 35
        $this.EffectValue = 180
        $this.Chance      = 0.85
        # Uses default $Script:BaCalc — no custom Effect needed
    }
}
```

### Step 2 — Override Effect (Optional)
For non-standard behavior (e.g., healing, multi-hit, status effects):

```powershell
$this.Effect = {
    Param([BattleEntity]$Self, [BattleEntity]$Target, [BattleAction]$SelfAction)
    # Custom logic here — must return [BattleActionResult]
}
```

### Step 3 — Wire Up
- Add dot-source to `Eldoria.psm1` in the `BattleActions` loading block
- Assign to a player action inventory slot or enemy action listing

---

## Tuning Guide

### Making an Action Feel Powerful
- Increase `EffectValue` (this is the strongest lever)
- Pair with an `ElementalType` that targets a common enemy affinity
- Keep `Chance` near 1.0 for reliability

### Making an Action High-Risk / High-Reward
- Large `EffectValue` (200+) with `Chance` ≤ 0.5
- High `MpCost` to gate frequency of use

### Making a Support / Status Action
- Set `EffectValue = 0`
- Use `BattleActionType::MagicStatAugment` or status types
- Write a custom `Effect` scriptblock

### Balancing Enemy Difficulty
- **Easier:** Reduce enemy `Attack` / increase `Defense`, lower `Speed`, reduce `Luck`
- **Harder:** Increase stats, give enemy elemental affinity that counters player's, add high-`Chance` high-damage actions to marble bag

---

## Quality Checklist

- [ ] `BattleActionType` set to the correct enum value (use `::ElementalFire` not `::Fire`)
- [ ] `EffectValue` set to a non-zero value for damage actions
- [ ] `Chance` set to a value in `[0.0, 1.0]`; `1.0` = always hits
- [ ] Custom `Effect` scriptblock returns a `[BattleActionResult]` with all required fields
- [ ] For healing actions: target `HitPoints.IncrementBase()`, not `DecrementBase()`
- [ ] For augment actions: set `BaseAugmentValue` and `AugmentTurnDuration`, not `Base` directly
- [ ] New affinity matrix row/column needed if adding a new element type (update `$Script:BATLut`)
- [ ] Turn order formula implicitly handles new stats — no changes needed unless `Speed` or `Luck` itself is reshaped
