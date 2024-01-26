using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

[Boolean]$Script:Debug  = $true
[String]$Script:LogFile = 'BattleTesterResults.txt'

Enum BattleManagerState {
    HealthCheck
    TurnIncrement
    PhaseOrdering
    PhaseAExecution
    PhaseBExecution
    Calculation
    BattleWon
    BattleLost
}

Enum StatId {
    HitPoints
    MagicPoints
    Attack
    Defense
    MagicAttack
    MagicDefense
    Speed
    Luck
    Accuracy
}

Enum ActionSlot {
    A
    B
    C
    D
    None
}

Enum BattleActionType {
    Physical
    ElementalFire
    ElementalWater
    ElementalEarth
    ElementalWind
    ElementalLight
    ElementalDark
    ElementalIce
    MagicPoison
    MagicConfuse
    MagicSleep
    MagicAging
    MagicHealing
    MagicStatAugment
    None
}

Enum BattleActionResultType {
    Success
    SuccessWithCritical
    SuccessWithAffinityBonus
    SuccessWithCritAndAffinityBonus
    FailedAttackMissed
    FailedAttackFailed
    FailedElementalMatch
    FailedNoUsesRemaining
    FailedNotEnoughMp
}

Enum StatNumberState {
    Normal
    Caution
    Danger
}

[ScriptBlock]$Script:BaPhysicalCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    If($Script:Debug) { 'Entered BaPhysicalCalc Function' >> $Script:LogFile }

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($Script:Debug) { 'Checking if SelfAction.MpCost is GREATER THAN zero...' >> $Script:LogFile }
    If($SelfAction.MpCost -GT 0) {
        If($Script:Debug) { '... It is. Checking to see if the Base value of the Magic Points stat is GREATER THAN OR EQUAL TO SelfAction.MpCost...' >> $Script:LogFile }
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            If($Script:Debug) { '... It is. Setting CanExecute and ReduceSelfMp flags to true.' >> $Script:LogFile }
            $CanExecute   = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        If($Script:Debug) { '... It isn''t. SelfAction.MpCost is LESS THAN OR EQUAL TO zero. Setting CanExecute flag to true.' >> $Script:LogFile }
        $CanExecute = $true
    }

    If($Script:Debug) { 'Checking if CanExecute is EQUAL TO true...' >> $Script:LogFile }
    If($CanExecute -EQ $true) {
        If($Script:Debug) { '... CanExecute is true. Checking if ReduceSelfMp is EQUAL TO true...' >> $Script:LogFile }
        If($ReduceSelfMp -EQ $true) {
            If($Script:Debug) { "... It is. Attempting to reduce the Magic Point Stat's Base value by $($SelfAction.MpCost * -1)" >> $Script:LogFile }
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Script:Debug) { "The result of the operation is $($DecRes)." >> $Script:LogFile }
        }

        If($Script:Debug) { 'Calculating ExecuteChance' >> $Script:LogFile }
        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($Script:Debug) { "ExecuteChance was calculated to be $($ExecuteChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if ExecuteChance ($($ExecuteChance)) is GREATER THAN SelfAction.Chance ($($SelfAction.Chance))..." >> $Script:LogFile }
        If($ExecuteChance -GT $SelfAction.Chance) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating TargetEffectiveEvasion' >> $Script:LogFile }
        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        If($Script:Debug) { "TargetEffectiveEvasion was calculated to be $($TargetEffectiveEvasion)." >> $Script:LogFile }
        If($Script:Debug) { 'Calculating EvRandFactor' >> $Script:LogFile }
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($Script:Debug) { "EvRandFactor was calculated to be $($EvRandFactor)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if EvRandFactor ($($EvRandFactor)) is LESS THAN OR EQUAL TO ($($TargetEffectiveEvasion))..." >> $Script:LogFile }
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            If($Script:Debug) { '... It is. The attack missed. Returning a BattleActionResult of type FailedAttackMissed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating EffectiveDamageP1' >> $Script:LogFile }
        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        If($Script:Debug) { "EffectiveDamageP1 was calculated to be $($EffectiveDamageP1)." >> $Script:LogFile }
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        If($Script:Debug) { 'Calculating CriticalChance' >> $Script:LogFile }
        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($Script:Debug) { "CriticalChance was calculated to be $($CriticalChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if CriticalChance ($($CriticalChance)) is LESS THAN OR EQUAL TO Self.Stats[Luck].Base ($($Self.Stats[[StatId]::Luck].Base))..." >> $Script:LogFile }
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            If($Script:Debug) { '... It is. A Critical hit has occurred. Set the EffectiveDamageCritFactor to 1.5.' }
            $EffectiveDamageCritFactor = 1.5
        }
        If($Script:Debug) { '... It isn''t. EffectiveDamageCritFactor remains at 1.0.' >> $Script:LogFile }

        If($Script:Debug) { 'Calculating FinalDamage' >> $Script:LogFile }
        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
        If($Script:Debug) { "FinalDamage was calculated to be $($FinalDamage)." >> $Script:LogFile }

        If($Script:Debug) { 'Calculating DecRes' >> $Script:LogFile }
        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))
        If($Script:Debug) { "DecRes was calculated to be $($DecRes)." >> $Script:LogFile }

        If($Script:Debug) { "Checking if DecRes ($($DecRes)) is NOT EQUAL TO zero..." >> $Script:LogFile }
        If(0 -NE $DecRes) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Script:Debug) { '... It isn''t. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { "Checking if EffectiveDamageCritFactor ($($EffectiveDamageCritFactor)) is GREATER THAN 1.0 AND if EffectiveDamageAffinityFactor ($($EffectiveDamageAffinityFactor)) is EQUAL TO 1.0..." >> $Script:LogFile }
            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                If($Script:Debug) { '... It is. Returning a BattleActionResult of type SuccessWithCritical.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor EQUALS 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor is GREATER THAN 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithCritAndAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }
            If($Script:Debug) { '... No cases have been satisfied. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { 'Returning a BattleActionResult of type Success.' >> $Script:LogFile }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        If($Script:Debug) { '... It isn''t. The entity doesn''t have enough MP to use this technique. Return a BattleActionResult of type FailedNotEnoughMp.' >> $Script:LogFile }
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNotEnoughMp,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalFireCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    If($Script:Debug) { 'Entered BaElementalFireCalc Function' >> $Script:LogFile }

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($Script:Debug) { 'Checking if SelfAction.MpCost is GREATER THAN zero...' >> $Script:LogFile }
    If($SelfAction.MpCost -GT 0) {
        If($Script:Debug) { '... It is. Checking to see if the Base value of the Magic Points stat is GREATER THAN OR EQUAL TO SelfAction.MpCost...' >> $Script:LogFile }
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            If($Script:Debug) { '... It is. Setting CanExecute and ReduceSelfMp flags to true.' >> $Script:LogFile }
            $CanExecute   = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        If($Script:Debug) { '... It isn''t. SelfAction.MpCost is LESS THAN OR EQUAL TO zero. Setting CanExecute flag to true.' >> $Script:LogFile }
        $CanExecute = $true
    }

    If($Script:Debug) { 'Checking if CanExecute is EQUAL TO true...' >> $Script:LogFile }
    If($CanExecute -EQ $true) {
        If($Script:Debug) { '... CanExecute is true. Checking if ReduceSelfMp is EQUAL TO true...' >> $Script:LogFile }
        If($ReduceSelfMp -EQ $true) {
            If($Script:Debug) { "... It is. Attempting to reduce the Magic Point Stat's Base value by $($SelfAction.MpCost * -1)" >> $Script:LogFile }
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Script:Debug) { "The result of the operation is $($DecRes)." >> $Script:LogFile }
        }

        If($Script:Debug) { 'Calculating ExecuteChance' >> $Script:LogFile }
        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($Script:Debug) { "ExecuteChance was calculated to be $($ExecuteChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if ExecuteChance ($($ExecuteChance)) is GREATER THAN SelfAction.Chance ($($SelfAction.Chance))..." >> $Script:LogFile }
        If($ExecuteChance -GT $SelfAction.Chance) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating TargetEffectiveEvasion' >> $Script:LogFile }
        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        If($Script:Debug) { "TargetEffectiveEvasion was calculated to be $($TargetEffectiveEvasion)." >> $Script:LogFile }
        If($Script:Debug) { 'Calculating EvRandFactor' >> $Script:LogFile }
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($Script:Debug) { "EvRandFactor was calculated to be $($EvRandFactor)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if EvRandFactor ($($EvRandFactor)) is LESS THAN OR EQUAL TO ($($TargetEffectiveEvasion))..." >> $Script:LogFile }
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            If($Script:Debug) { '... It is. The attack missed. Returning a BattleActionResult of type FailedAttackMissed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating EffectiveDamageP1' >> $Script:LogFile }
        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        If($Script:Debug) { "EffectiveDamageP1 was calculated to be $($EffectiveDamageP1)." >> $Script:LogFile }
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        If($Script:Debug) { 'Calculating CriticalChance' >> $Script:LogFile }
        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($Script:Debug) { "CriticalChance was calculated to be $($CriticalChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if CriticalChance ($($CriticalChance)) is LESS THAN OR EQUAL TO Self.Stats[Luck].Base ($($Self.Stats[[StatId]::Luck].Base))..." >> $Script:LogFile }
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            If($Script:Debug) { '... It is. A Critical hit has occurred. Set the EffectiveDamageCritFactor to 1.5.' }
            $EffectiveDamageCritFactor = 1.5
        }
        If($Script:Debug) { '... It isn''t. EffectiveDamageCritFactor remains at 1.0.' >> $Script:LogFile }

        If($Script:Debug) { 'Checking the current value of Target.Affinity to determine Affinity Factor.' >> $Script:LogFile }
        Switch($Target.Affinity) {
            { $_ -EQ $SelfAction.Type } {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO SelfAction.Type; set the scalar to -0.75.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = -0.75
                Break
            }

            ([BattleActionType]::ElementalIce) {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO ElementalIce; set the scalar to 1.6.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = 1.6
                Break
            }
        }

        If($Script:Debug) { 'Calculating FinalDamage' >> $Script:LogFile }
        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
        If($Script:Debug) { "FinalDamage was calculated to be $($FinalDamage)." >> $Script:LogFile }

        If($Script:Debug) { 'Calculating DecRes' >> $Script:LogFile }
        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))
        If($Script:Debug) { "DecRes was calculated to be $($DecRes)." >> $Script:LogFile }

        If($Script:Debug) { "Checking if DecRes ($($DecRes)) is NOT EQUAL TO zero..." >> $Script:LogFile }
        If(0 -NE $DecRes) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Script:Debug) { '... It isn''t. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { "Checking if EffectiveDamageCritFactor ($($EffectiveDamageCritFactor)) is GREATER THAN 1.0 AND if EffectiveDamageAffinityFactor ($($EffectiveDamageAffinityFactor)) is EQUAL TO 1.0..." >> $Script:LogFile }
            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                If($Script:Debug) { '... It is. Returning a BattleActionResult of type SuccessWithCritical.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor EQUALS 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor is GREATER THAN 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithCritAndAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }
            If($Script:Debug) { '... No cases have been satisfied. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { 'Returning a BattleActionResult of type Success.' >> $Script:LogFile }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        If($Script:Debug) { '... It isn''t. The entity doesn''t have enough MP to use this technique. Return a BattleActionResult of type FailedNotEnoughMp.' >> $Script:LogFile }
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNoUsesRemaining,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalWaterCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    If($Script:Debug) { 'Entered BaElementalWaterCalc Function' >> $Script:LogFile }

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($Script:Debug) { 'Checking if SelfAction.MpCost is GREATER THAN zero...' >> $Script:LogFile }
    If($SelfAction.MpCost -GT 0) {
        If($Script:Debug) { '... It is. Checking to see if the Base value of the Magic Points stat is GREATER THAN OR EQUAL TO SelfAction.MpCost...' >> $Script:LogFile }
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            If($Script:Debug) { '... It is. Setting CanExecute and ReduceSelfMp flags to true.' >> $Script:LogFile }
            $CanExecute   = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        If($Script:Debug) { '... It isn''t. SelfAction.MpCost is LESS THAN OR EQUAL TO zero. Setting CanExecute flag to true.' >> $Script:LogFile }
        $CanExecute = $true
    }

    If($Script:Debug) { 'Checking if CanExecute is EQUAL TO true...' >> $Script:LogFile }
    If($CanExecute -EQ $true) {
        If($Script:Debug) { '... CanExecute is true. Checking if ReduceSelfMp is EQUAL TO true...' >> $Script:LogFile }
        If($ReduceSelfMp -EQ $true) {
            If($Script:Debug) { "... It is. Attempting to reduce the Magic Point Stat's Base value by $($SelfAction.MpCost * -1)" >> $Script:LogFile }
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Script:Debug) { "The result of the operation is $($DecRes)." >> $Script:LogFile }
        }

        If($Script:Debug) { 'Calculating ExecuteChance' >> $Script:LogFile }
        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($Script:Debug) { "ExecuteChance was calculated to be $($ExecuteChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if ExecuteChance ($($ExecuteChance)) is GREATER THAN SelfAction.Chance ($($SelfAction.Chance))..." >> $Script:LogFile }
        If($ExecuteChance -GT $SelfAction.Chance) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating TargetEffectiveEvasion' >> $Script:LogFile }
        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        If($Script:Debug) { "TargetEffectiveEvasion was calculated to be $($TargetEffectiveEvasion)." >> $Script:LogFile }
        If($Script:Debug) { 'Calculating EvRandFactor' >> $Script:LogFile }
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($Script:Debug) { "EvRandFactor was calculated to be $($EvRandFactor)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if EvRandFactor ($($EvRandFactor)) is LESS THAN OR EQUAL TO ($($TargetEffectiveEvasion))..." >> $Script:LogFile }
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            If($Script:Debug) { '... It is. The attack missed. Returning a BattleActionResult of type FailedAttackMissed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating EffectiveDamageP1' >> $Script:LogFile }
        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        If($Script:Debug) { "EffectiveDamageP1 was calculated to be $($EffectiveDamageP1)." >> $Script:LogFile }
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        If($Script:Debug) { 'Calculating CriticalChance' >> $Script:LogFile }
        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($Script:Debug) { "CriticalChance was calculated to be $($CriticalChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if CriticalChance ($($CriticalChance)) is LESS THAN OR EQUAL TO Self.Stats[Luck].Base ($($Self.Stats[[StatId]::Luck].Base))..." >> $Script:LogFile }
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            If($Script:Debug) { '... It is. A Critical hit has occurred. Set the EffectiveDamageCritFactor to 1.5.' }
            $EffectiveDamageCritFactor = 1.5
        }
        If($Script:Debug) { '... It isn''t. EffectiveDamageCritFactor remains at 1.0.' >> $Script:LogFile }

        If($Script:Debug) { 'Checking the current value of Target.Affinity to determine Affinity Factor.' >> $Script:LogFile }
        Switch($Target.Affinity) {
            { $_ -EQ $SelfAction.Type } {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO SelfAction.Type; set the scalar to -0.75.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = -0.75
                Break
            }

            ([BattleActionType]::ElementalFire) {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO ElementalFire; set the scalar to 1.6.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = 1.6
                Break
            }
        }

        If($Script:Debug) { 'Calculating FinalDamage' >> $Script:LogFile }
        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
        If($Script:Debug) { "FinalDamage was calculated to be $($FinalDamage)." >> $Script:LogFile }

        If($Script:Debug) { 'Calculating DecRes' >> $Script:LogFile }
        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))
        If($Script:Debug) { "DecRes was calculated to be $($DecRes)." >> $Script:LogFile }

        If($Script:Debug) { "Checking if DecRes ($($DecRes)) is NOT EQUAL TO zero..." >> $Script:LogFile }
        If(0 -NE $DecRes) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Script:Debug) { '... It isn''t. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { "Checking if EffectiveDamageCritFactor ($($EffectiveDamageCritFactor)) is GREATER THAN 1.0 AND if EffectiveDamageAffinityFactor ($($EffectiveDamageAffinityFactor)) is EQUAL TO 1.0..." >> $Script:LogFile }
            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                If($Script:Debug) { '... It is. Returning a BattleActionResult of type SuccessWithCritical.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor EQUALS 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor is GREATER THAN 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithCritAndAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }
            If($Script:Debug) { '... No cases have been satisfied. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { 'Returning a BattleActionResult of type Success.' >> $Script:LogFile }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        If($Script:Debug) { '... It isn''t. The entity doesn''t have enough MP to use this technique. Return a BattleActionResult of type FailedNotEnoughMp.' >> $Script:LogFile }
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNoUsesRemaining,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalEarthCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    If($Script:Debug) { 'Entered BaElementalFireCalc Function' >> $Script:LogFile }

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($Script:Debug) { 'Checking if SelfAction.MpCost is GREATER THAN zero...' >> $Script:LogFile }
    If($SelfAction.MpCost -GT 0) {
        If($Script:Debug) { '... It is. Checking to see if the Base value of the Magic Points stat is GREATER THAN OR EQUAL TO SelfAction.MpCost...' >> $Script:LogFile }
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            If($Script:Debug) { '... It is. Setting CanExecute and ReduceSelfMp flags to true.' >> $Script:LogFile }
            $CanExecute = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        If($Script:Debug) { '... It isn''t. SelfAction.MpCost is LESS THAN OR EQUAL TO zero. Setting CanExecute flag to true.' >> $Script:LogFile }
        $CanExecute = $true
    }

    If($Script:Debug) { 'Checking if CanExecute is EQUAL TO true...' >> $Script:LogFile }
    If($CanExecute -EQ $true) {
        If($Script:Debug) { '... CanExecute is true. Checking if ReduceSelfMp is EQUAL TO true...' >> $Script:LogFile }
        If($ReduceSelfMp -EQ $true) {
            If($Script:Debug) { "... It is. Attempting to reduce the Magic Point Stat's Base value by $($SelfAction.MpCost * -1)" >> $Script:LogFile }
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Script:Debug) { "The result of the operation is $($DecRes)." >> $Script:LogFile }
        }

        If($Script:Debug) { 'Calculating ExecuteChance' >> $Script:LogFile }
        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($Script:Debug) { "ExecuteChance was calculated to be $($ExecuteChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if ExecuteChance ($($ExecuteChance)) is GREATER THAN SelfAction.Chance ($($SelfAction.Chance))..." >> $Script:LogFile }
        If($ExecuteChance -GT $SelfAction.Chance) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating TargetEffectiveEvasion' >> $Script:LogFile }
        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        If($Script:Debug) { "TargetEffectiveEvasion was calculated to be $($TargetEffectiveEvasion)." >> $Script:LogFile }
        If($Script:Debug) { 'Calculating EvRandFactor' >> $Script:LogFile }
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($Script:Debug) { "EvRandFactor was calculated to be $($EvRandFactor)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if EvRandFactor ($($EvRandFactor)) is LESS THAN OR EQUAL TO ($($TargetEffectiveEvasion))..." >> $Script:LogFile }
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            If($Script:Debug) { '... It is. The attack missed. Returning a BattleActionResult of type FailedAttackMissed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating EffectiveDamageP1' >> $Script:LogFile }
        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        If($Script:Debug) { "EffectiveDamageP1 was calculated to be $($EffectiveDamageP1)." >> $Script:LogFile }
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        If($Script:Debug) { 'Calculating CriticalChance' >> $Script:LogFile }
        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($Script:Debug) { "CriticalChance was calculated to be $($CriticalChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if CriticalChance ($($CriticalChance)) is LESS THAN OR EQUAL TO Self.Stats[Luck].Base ($($Self.Stats[[StatId]::Luck].Base))..." >> $Script:LogFile }
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            If($Script:Debug) { '... It is. A Critical hit has occurred. Set the EffectiveDamageCritFactor to 1.5.' }
            $EffectiveDamageCritFactor = 1.5
        }
        If($Script:Debug) { '... It isn''t. EffectiveDamageCritFactor remains at 1.0.' >> $Script:LogFile }

        If($Script:Debug) { 'Checking the current value of Target.Affinity to determine Affinity Factor.' >> $Script:LogFile }
        Switch($Target.Affinity) {
            { $_ -EQ $SelfAction.Type } {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO SelfAction.Type; set the scalar to -0.75.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = -0.75
                Break
            }

            ([BattleActionType]::ElementalWind) {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO ElementalIce; set the scalar to 1.6.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = 1.6
                Break
            }
        }

        If($Script:Debug) { 'Calculating FinalDamage' >> $Script:LogFile }
        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
        If($Script:Debug) { "FinalDamage was calculated to be $($FinalDamage)." >> $Script:LogFile }

        If($Script:Debug) { 'Calculating DecRes' >> $Script:LogFile }
        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))
        If($Script:Debug) { "DecRes was calculated to be $($DecRes)." >> $Script:LogFile }

        If($Script:Debug) { "Checking if DecRes ($($DecRes)) is NOT EQUAL TO zero..." >> $Script:LogFile }
        If(0 -NE $DecRes) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Script:Debug) { '... It isn''t. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { "Checking if EffectiveDamageCritFactor ($($EffectiveDamageCritFactor)) is GREATER THAN 1.0 AND if EffectiveDamageAffinityFactor ($($EffectiveDamageAffinityFactor)) is EQUAL TO 1.0..." >> $Script:LogFile }
            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                If($Script:Debug) { '... It is. Returning a BattleActionResult of type SuccessWithCritical.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor EQUALS 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor is GREATER THAN 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithCritAndAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }
            If($Script:Debug) { '... No cases have been satisfied. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { 'Returning a BattleActionResult of type Success.' >> $Script:LogFile }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        If($Script:Debug) { '... It isn''t. The entity doesn''t have enough MP to use this technique. Return a BattleActionResult of type FailedNotEnoughMp.' >> $Script:LogFile }
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNoUsesRemaining,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalWindCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    If($Script:Debug) { 'Entered BaElementalFireCalc Function' >> $Script:LogFile }

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($Script:Debug) { 'Checking if SelfAction.MpCost is GREATER THAN zero...' >> $Script:LogFile }
    If($SelfAction.MpCost -GT 0) {
        If($Script:Debug) { '... It is. Checking to see if the Base value of the Magic Points stat is GREATER THAN OR EQUAL TO SelfAction.MpCost...' >> $Script:LogFile }
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            If($Script:Debug) { '... It is. Setting CanExecute and ReduceSelfMp flags to true.' >> $Script:LogFile }
            $CanExecute   = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        If($Script:Debug) { '... It isn''t. SelfAction.MpCost is LESS THAN OR EQUAL TO zero. Setting CanExecute flag to true.' >> $Script:LogFile }
        $CanExecute = $true
    }

    If($Script:Debug) { 'Checking if CanExecute is EQUAL TO true...' >> $Script:LogFile }
    If($CanExecute -EQ $true) {
        If($Script:Debug) { '... CanExecute is true. Checking if ReduceSelfMp is EQUAL TO true...' >> $Script:LogFile }
        If($ReduceSelfMp -EQ $true) {
            If($Script:Debug) { "... It is. Attempting to reduce the Magic Point Stat's Base value by $($SelfAction.MpCost * -1)" >> $Script:LogFile }
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Script:Debug) { "The result of the operation is $($DecRes)." >> $Script:LogFile }
        }

        If($Script:Debug) { 'Calculating ExecuteChance' >> $Script:LogFile }
        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($Script:Debug) { "ExecuteChance was calculated to be $($ExecuteChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if ExecuteChance ($($ExecuteChance)) is GREATER THAN SelfAction.Chance ($($SelfAction.Chance))..." >> $Script:LogFile }
        If($ExecuteChance -GT $SelfAction.Chance) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating TargetEffectiveEvasion' >> $Script:LogFile }
        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        If($Script:Debug) { "TargetEffectiveEvasion was calculated to be $($TargetEffectiveEvasion)." >> $Script:LogFile }
        If($Script:Debug) { 'Calculating EvRandFactor' >> $Script:LogFile }
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($Script:Debug) { "EvRandFactor was calculated to be $($EvRandFactor)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if EvRandFactor ($($EvRandFactor)) is LESS THAN OR EQUAL TO ($($TargetEffectiveEvasion))..." >> $Script:LogFile }
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            If($Script:Debug) { '... It is. The attack missed. Returning a BattleActionResult of type FailedAttackMissed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating EffectiveDamageP1' >> $Script:LogFile }
        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        If($Script:Debug) { "EffectiveDamageP1 was calculated to be $($EffectiveDamageP1)." >> $Script:LogFile }
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        If($Script:Debug) { 'Calculating CriticalChance' >> $Script:LogFile }
        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($Script:Debug) { "CriticalChance was calculated to be $($CriticalChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if CriticalChance ($($CriticalChance)) is LESS THAN OR EQUAL TO Self.Stats[Luck].Base ($($Self.Stats[[StatId]::Luck].Base))..." >> $Script:LogFile }
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            If($Script:Debug) { '... It is. A Critical hit has occurred. Set the EffectiveDamageCritFactor to 1.5.' }
            $EffectiveDamageCritFactor = 1.5
        }
        If($Script:Debug) { '... It isn''t. EffectiveDamageCritFactor remains at 1.0.' >> $Script:LogFile }

        If($Script:Debug) { 'Checking the current value of Target.Affinity to determine Affinity Factor.' >> $Script:LogFile }
        Switch($Target.Affinity) {
            { $_ -EQ $SelfAction.Type } {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO SelfAction.Type; set the scalar to -0.75.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = -0.75
                Break
            }

            ([BattleActionType]::ElementalEarth) {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO ElementalIce; set the scalar to 1.6.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = 1.6
                Break
            }
        }

        If($Script:Debug) { 'Calculating FinalDamage' >> $Script:LogFile }
        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
        If($Script:Debug) { "FinalDamage was calculated to be $($FinalDamage)." >> $Script:LogFile }

        If($Script:Debug) { 'Calculating DecRes' >> $Script:LogFile }
        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))
        If($Script:Debug) { "DecRes was calculated to be $($DecRes)." >> $Script:LogFile }

        If($Script:Debug) { "Checking if DecRes ($($DecRes)) is NOT EQUAL TO zero..." >> $Script:LogFile }
        If(0 -NE $DecRes) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Script:Debug) { '... It isn''t. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { "Checking if EffectiveDamageCritFactor ($($EffectiveDamageCritFactor)) is GREATER THAN 1.0 AND if EffectiveDamageAffinityFactor ($($EffectiveDamageAffinityFactor)) is EQUAL TO 1.0..." >> $Script:LogFile }
            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                If($Script:Debug) { '... It is. Returning a BattleActionResult of type SuccessWithCritical.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor EQUALS 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor is GREATER THAN 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithCritAndAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }
            If($Script:Debug) { '... No cases have been satisfied. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { 'Returning a BattleActionResult of type Success.' >> $Script:LogFile }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        If($Script:Debug) { '... It isn''t. The entity doesn''t have enough MP to use this technique. Return a BattleActionResult of type FailedNotEnoughMp.' >> $Script:LogFile }
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNoUsesRemaining,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalLightCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    If($Script:Debug) { 'Entered BaElementalFireCalc Function' >> $Script:LogFile }

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($Script:Debug) { 'Checking if SelfAction.MpCost is GREATER THAN zero...' >> $Script:LogFile }
    If($SelfAction.MpCost -GT 0) {
        If($Script:Debug) { '... It is. Checking to see if the Base value of the Magic Points stat is GREATER THAN OR EQUAL TO SelfAction.MpCost...' >> $Script:LogFile }
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            If($Script:Debug) { '... It is. Setting CanExecute and ReduceSelfMp flags to true.' >> $Script:LogFile }
            $CanExecute   = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        If($Script:Debug) { '... It isn''t. SelfAction.MpCost is LESS THAN OR EQUAL TO zero. Setting CanExecute flag to true.' >> $Script:LogFile }
        $CanExecute = $true
    }

    If($Script:Debug) { 'Checking if CanExecute is EQUAL TO true...' >> $Script:LogFile }
    If($CanExecute -EQ $true) {
        If($Script:Debug) { '... CanExecute is true. Checking if ReduceSelfMp is EQUAL TO true...' >> $Script:LogFile }
        If($ReduceSelfMp -EQ $true) {
            If($Script:Debug) { "... It is. Attempting to reduce the Magic Point Stat's Base value by $($SelfAction.MpCost * -1)" >> $Script:LogFile }
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Script:Debug) { "The result of the operation is $($DecRes)." >> $Script:LogFile }
        }

        If($Script:Debug) { 'Calculating ExecuteChance' >> $Script:LogFile }
        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($Script:Debug) { "ExecuteChance was calculated to be $($ExecuteChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if ExecuteChance ($($ExecuteChance)) is GREATER THAN SelfAction.Chance ($($SelfAction.Chance))..." >> $Script:LogFile }
        If($ExecuteChance -GT $SelfAction.Chance) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating TargetEffectiveEvasion' >> $Script:LogFile }
        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        If($Script:Debug) { "TargetEffectiveEvasion was calculated to be $($TargetEffectiveEvasion)." >> $Script:LogFile }
        If($Script:Debug) { 'Calculating EvRandFactor' >> $Script:LogFile }
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($Script:Debug) { "EvRandFactor was calculated to be $($EvRandFactor)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if EvRandFactor ($($EvRandFactor)) is LESS THAN OR EQUAL TO ($($TargetEffectiveEvasion))..." >> $Script:LogFile }
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            If($Script:Debug) { '... It is. The attack missed. Returning a BattleActionResult of type FailedAttackMissed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }
        If($Script:Debug) { '... It isn''t. Carrying on.' }

        If($Script:Debug) { 'Calculating EffectiveDamageP1' >> $Script:LogFile }
        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        If($Script:Debug) { "EffectiveDamageP1 was calculated to be $($EffectiveDamageP1)." >> $Script:LogFile }
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        If($Script:Debug) { 'Calculating CriticalChance' >> $Script:LogFile }
        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($Script:Debug) { "CriticalChance was calculated to be $($CriticalChance)." >> $Script:LogFile }
        If($Script:Debug) { "Checking if CriticalChance ($($CriticalChance)) is LESS THAN OR EQUAL TO Self.Stats[Luck].Base ($($Self.Stats[[StatId]::Luck].Base))..." >> $Script:LogFile }
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            If($Script:Debug) { '... It is. A Critical hit has occurred. Set the EffectiveDamageCritFactor to 1.5.' }
            $EffectiveDamageCritFactor = 1.5
        }
        If($Script:Debug) { '... It isn''t. EffectiveDamageCritFactor remains at 1.0.' >> $Script:LogFile }

        If($Script:Debug) { 'Checking the current value of Target.Affinity to determine Affinity Factor.' >> $Script:LogFile }
        Switch($Target.Affinity) {
            { $_ -EQ $SelfAction.Type } {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO SelfAction.Type; set the scalar to -0.75.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = -0.75
                Break
            }

            ([BattleActionType]::ElementalDark) {
                If($Script:Debug) { 'Target.Affinity is EQUAL TO ElementalDark; set the scalar to 1.6.' >> $Script:LogFile }
                $EffectiveDamageAffinityFactor = 1.6
                Break
            }
        }

        If($Script:Debug) { 'Calculating FinalDamage' >> $Script:LogFile }
        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)
        If($Script:Debug) { "FinalDamage was calculated to be $($FinalDamage)." >> $Script:LogFile }

        If($Script:Debug) { 'Calculating DecRes' >> $Script:LogFile }
        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))
        If($Script:Debug) { "DecRes was calculated to be $($DecRes)." >> $Script:LogFile }

        If($Script:Debug) { "Checking if DecRes ($($DecRes)) is NOT EQUAL TO zero..." >> $Script:LogFile }
        If(0 -NE $DecRes) {
            If($Script:Debug) { '... It is. The attack failed. Returning a BattleActionResult of type FailedAttackFailed.' >> $Script:LogFile }
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Script:Debug) { '... It isn''t. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { "Checking if EffectiveDamageCritFactor ($($EffectiveDamageCritFactor)) is GREATER THAN 1.0 AND if EffectiveDamageAffinityFactor ($($EffectiveDamageAffinityFactor)) is EQUAL TO 1.0..." >> $Script:LogFile }
            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                If($Script:Debug) { '... It is. Returning a BattleActionResult of type SuccessWithCritical.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor EQUALS 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                If($Script:Debug) { '... It isn''t. However, EffectiveDamageCritFactor is GREATER THAN 1.0 AND EffectiveDamageAffinityFactor is GREATER THAN 1.0. Returning a BattleActionResult of type SuccessWithCritAndAffinityBonus.' >> $Script:LogFile }
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }
            If($Script:Debug) { '... No cases have been satisfied. Carrying on.' >> $Script:LogFile }
            If($Script:Debug) { 'Returning a BattleActionResult of type Success.' >> $Script:LogFile }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        If($Script:Debug) { '... It isn''t. The entity doesn''t have enough MP to use this technique. Return a BattleActionResult of type FailedNotEnoughMp.' >> $Script:LogFile }
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNoUsesRemaining,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalDarkCalc = {
    Param(
        [BattleEntity]$Self,
        [BattleEntity]$Target,
        [BattleAction]$SelfAction
    )

    [Boolean]$CanExecute   = $false
    [Boolean]$ReduceSelfMp = $false

    If($SelfAction.MpCost -GT 0) {
        If($Self.Stats[[StatId]::MagicPoints].Base -GE $SelfAction.MpCost) {
            $CanExecute   = $true
            $ReduceSelfMp = $true
        }
    } Elseif($SelfAction.MpCost -LE 0) {
        $CanExecute = $true
    }

    If($CanExecute -EQ $true) {
        If($ReduceSelfMp -EQ $true) {
            [Int]$DecRes = $Self.Stats[[StatId]::MagicPoints].DecrementBase($SelfAction.MpCost * -1)
            If($Self -IS [Player]) {
                $Script:ThePlayerBattleStatWindow.MpDrawDirty = $true
            } Else {
                $Script:TheEnemyBattleStatWindow.MpDrawDirty = $true
            }
        }

        $ExecuteChance = Get-Random -Minimum 0.0 -Maximum 1.0
        If($ExecuteChance -GT $SelfAction.Chance) {
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                0
            )
        }

        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackMissed,
                $Self,
                $Target,
                0
            )
        }

        $EffectiveDamageP1 = [Math]::Round([Math]::Abs(
            $SelfAction.EffectValue * (
                ($Self.Stats[[StatId]::Attack].Base - $Target.Stats[[StatId]::Defense].Base) *
                (1 + ($Self.Stats[[StatId]::Luck].Base - $Target.Stats[[StatId]::Luck].Base))
            ) * (Get-Random -Minimum 0.07 -Maximum 0.15)
        ))
        $EffectiveDamageCritFactor     = 1.0
        $EffectiveDamageAffinityFactor = 1.0

        $CriticalChance = Get-Random -Minimum 1 -Maximum 1000
        If($CriticalChance -LE $Self.Stats[[StatId]::Luck].Base) {
            $EffectiveDamageCritFactor = 1.5
        }

        Switch($Target.Affinity) {
            { $_ -EQ $SelfAction.Type } {
                $EffectiveDamageAffinityFactor = -0.75
                Break
            }

            ([BattleActionType]::ElementalLight) {
                $EffectiveDamageAffinityFactor = 1.6
                Break
            }
        }

        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)

        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))

        If(0 -NE $DecRes) {
            Return [BattleActionResult]::new(
                [BattleActionResultType]::FailedAttackFailed,
                $Self,
                $Target,
                $FinalDamage
            )
        } Else {
            If($Target -IS [Player]) {
                $Script:ThePlayerBattleStatWindow.HpDrawDirty = $true
            } Else {
                $Script:TheEnemyBattleStatWindow.HpDrawDirty = $true
            }

            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritical,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                Return [BattleActionResult]::new(
                    [BattleActionResultType]::SuccessWithCritAndAffinityBonus,
                    $Self,
                    $Target,
                    $FinalDamage
                )
            }

            Return [BattleActionResult]::new(
                [BattleActionResultType]::Success,
                $Self,
                $Target,
                $FinalDamage
            )
        }
    } Else {
        Return [BattleActionResult]::new(
            [BattleActionResultType]::FailedNoUsesRemaining,
            $Self,
            $Target,
            0
        )
    }
}

[ScriptBlock]$Script:BaElementalIceCalc     = {}
[ScriptBlock]$Script:BaMagicPoisonCalc      = {}
[ScriptBlock]$Script:BaMagicConfuseCalc     = {}
[ScriptBlock]$Script:BaMagicSleepCalc       = {}
[ScriptBlock]$Script:BaMagicAgingCalc       = {}
[ScriptBlock]$Script:BaMagicHealingCalc     = {}
[ScriptBlock]$Script:BaMagicStatAugmentCalc = {}

Class BattleEntityProperty {
    Static [Single]$StatNumThresholdCaution          = 0.6D
    Static [Single]$StatNumThresholdDanger           = 0.3D

    [Int]$Base
    [Int]$BasePre
    [Int]$BaseAugmentValue
    [Int]$Max
    [Int]$MaxPre
    [Int]$MaxAugmentValue
    [Int]$AugmentTurnDuration
    [Boolean]$BaseAugmentActive
    [Boolean]$MaxAugmentActive
    [StatNumberState]$State
    [ScriptBlock]$ValidateFunction

    BattleEntityProperty() {
        $this.Base                = 0
        $this.BasePre             = 0
        $this.BaseAugmentValue    = 0
        $this.Max                 = 0
        $this.MaxPre              = 0
        $this.MaxAugmentValue     = 0
        $this.AugmentTurnDuration = 0
        $this.BaseAugmentActive   = $false
        $this.MaxAugmentActive    = $false
        $this.State               = [StatNumberState]::Normal
        $this.ValidateFunction    = $null
    }

    BattleEntityProperty(
        [Int]$Base,
        [Int]$BasePre,
        [Int]$BaseAugmentValue,
        [Int]$Max,
        [Int]$MaxPre,
        [Int]$MaxAugmentValue,
        [Int]$AugmentTurnDuration,
        [Boolean]$BaseAugmentActive,
        [Boolean]$MaxAugmentActive,
        [StatNumberState]$State,
        [ScriptBlock]$ValidateFunction
    ) {
        $this.Base                = $Base
        $this.BasePre             = $BasePre
        $this.BaseAugmentValue    = $BaseAugmentValue
        $this.Max                 = $Max
        $this.MaxPre              = $MaxPre
        $this.MaxAugmentValue     = $MaxAugmentValue
        $this.AugmentTurnDuration = $AugmentTurnDuration
        $this.BaseAugmentActive   = $BaseAugmentActive
        $this.MaxAugmentActive    = $MaxAugmentActive
        $this.State               = $State
        $this.ValidateFunction    = $ValidateFunction
    }

    [Void]Update() {
        If($this.AugmentTurnDuration -GT 0) {
            If($this.BasePre -EQ 0) {
                $this.BasePre = $this.Base
            }
            If($this.MaxPre -EQ 0) {
                $this.MaxPre = $this.Max
            }
            If($this.MaxAugmentActive -EQ $false) {
                [Int]$t                = $this.Max + $this.MaxAugmentValue
                $t                     = [Math]::Clamp($t, 0, [Int]::MaxValue)
                $this.Max              = $t
                $this.MaxAugmentActive = $true
            }
            If($this.BaseAugmentActive -EQ $false) {
                [Int]$t                 = $this.Base + $this.BaseAugmentValue
                $t                      = [Math]::Clamp($t, 0, [Int]::MaxValue)
                $this.Base              = $t
                $this.BaseAugmentActive = $true
            }
        } Else {
            If($this.MaxAugmentActive -EQ $true) {
                $this.Max              = $this.MaxPre
                $this.MaxPre           = 0
                $this.MaxAugmentActive = $false
            }
            If($this.BaseAugmentActive -EQ $true) {
                $this.Base              = $this.BasePre
                $this.BasePre           = 0
                $this.BaseAugmentActive = $false
            }
        }

        Invoke-Command $this.ValidateFunction -ArgumentList $this
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of IncAmt is less than or equal to zero.
        -2 - The value of Base is equal to Max (no need to increment Base at this point)
        0  - Base was successfully incremented by IncAmt
    #>
    [Int]IncrementBase(
        [Int]$IncAmt
    ) {
        If($IncAmt -LE 0) {
            Return -1
        }
        If($this.Base -EQ $this.Max) {
            Return -2
        }
        [Int]$t    = $this.Base + $IncAmt
        $t         = [Math]::Clamp($t, 0, $this.Max) # This should work regardless if BaseAugmentActive = true
        $this.Base = $t

        Return 0
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of DecAmt is greater than or equal to zero.
        -2 - The value of Base is less than or equal to zero.
        0  - Base was successfully decremented by DecAmt.
    #>
    [Int]DecrementBase(
        [Int]$DecAmt
    ) {
        If($DecAmt -GE 0) {
            Return -1
        }
        If($this.Base -LE 0) {
            Return -2
        }
        [Int]$t    = $this.Base + $DecAmt
        $t         = [Math]::Clamp($t, 0, $this.Max)
        $this.Base = $t

        Return 0
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of IncAmt is less than or equal to zero.
        0  - Max was successfully incremented by IncAmt.
    #>
    [Int]IncrementMax(
        [Int]$IncAmt
    ) {
        If($IncAmt -LE 0) {
            Return -1
        }
        $this.Max += $IncAmt

        Return 0
    }

    <#
    .OUTPUTS
    Integer
        -1 - The value of DecAmt is greater than or equal to zero.
        0  - Max was successfully decremented by DecAmt.
    #>
    [Int]DecrementMax(
        [Int]$DecAmt
    ) {
        If($DecAmt -GE 0) {
            Return -1
        }
        [Int]$t   = $this.Max - $DecAmt
        $t        = [Math]::Clamp($t, 0, [Int]::MaxValue)
        $this.Max = $t
        If($this.Max -LT $this.Base) {
            $this.Base = $this.Max
        }

        Return 0
    }
}

Class BattleAction {
    [String]$Name
    [ScriptBlock]$Effect
    [ScriptBlock]$PreCalc
    [ScriptBlock]$PostCalc
    [BattleActionType]$Type
    [Int]$MpCost
    [Int]$EffectValue
    [Single]$Chance
    [String]$Description

    BattleAction() {
        $this.Name        = ''
        $this.Type        = [BattleActionType]::None
        $this.Effect      = $null
        $this.PreCalc     = $null
        $this.PostCalc    = $null
        $this.EffectValue = 0
        $this.Chance      = 0.0
        $this.Description = ''
    }

    BattleAction(
        [String]$Name,
        [BattleActionType]$Type,
        [ScriptBlock]$Effect,
        [Int]$Uses,
        [Int]$EffectValue,
        [Single]$Chance
    ) {
        $this.Name        = $Name
        $this.Type        = $Type
        $this.Effect      = $Effect
        $this.PreCalc     = {}
        $this.PostCalc    = {}
        $this.EffectValue = $EffectValue
        $this.Chance      = $Chance
        $this.Description = ''
    }

    BattleAction(
        [String]$Name,
        [String]$Description,
        [BattleActionType]$Type,
        [ScriptBlock]$Effect,
        [Int]$Uses,
        [Int]$UsesMax,
        [Int]$EffectValue,
        [Single]$Chance
    ) {
        $this.Name        = $Name
        $this.Type        = $Type
        $this.Effect      = $Effect
        $this.PreCalc     = {}
        $this.PostCalc    = {}
        $this.EffectValue = $EffectValue
        $this.Chance      = $Chance
        $this.Description = $Description
    }

    BattleAction(
        [String]$Name,
        [String]$Description,
        [BattleActionType]$Type,
        [ScriptBlock]$Effect,
        [Int]$MpCost,
        [Int]$EffectValue,
        [Single]$Chance
    ) {
        $this.Name        = $Name
        $this.Type        = $Type
        $this.Effect      = $Effect
        $this.PreCalc     = {}
        $this.PostCalc    = {}
        $this.MpCost      = $MpCost
        $this.EffectValue = $EffectValue
        $this.Chance      = $Chance
        $this.Description = $Description
    }

    BattleAction(
        [BattleAction]$Copy
    ) {
        $this.Name        = $Copy.Name
        $this.Type        = $Copy.Type
        $this.Effect      = $Copy.Effect
        $this.PreCalc     = $Copy.PreCalc
        $this.PostCalc    = $Copy.PostCalc
        $this.MpCost      = $Copy.MpCost
        $this.EffectValue = $Copy.EffectValue
        $this.Chance      = $Copy.Chance
        $this.Description = $Copy.Description
    }
}

Class BattleEntity {
    [String]$Name
    [Hashtable]$Stats
    [Hashtable]$ActionListing
    [ScriptBlock]$SpoilsEffect
    [ActionSlot[]]$ActionMarbleBag
    [BattleActionType]$Affinity

    BattleEntity() {
        $this.Name            = ''
        $this.Stats           = @{}
        $this.ActionListing   = @{}
        $this.SpoilsEffect    = $null
        $this.ActionMarbleBag = $null
        $this.Affinity        = [BattleActionType]::None
    }

    BattleEntity(
        [String]$Name,
        [Hashtable]$Stats,
        [Hashtable]$ActionListing,
        [ScriptBlock]$SpoilsEffect,
        [ActionSlot[]]$ActionMarbleBag,
        [BattleActionType]$Affinity
    ) {
        $this.Name            = $Name
        $this.Stats           = $Stats
        $this.ActionListing   = $ActionListing
        $this.SpoilsEffect    = $SpoilsEffect
        $this.ActionMarbleBag = $ActionMarbleBag
        $this.Affinity        = $Affinity
    }

    [Void]Update() {
        Foreach($a in $this.Stats.Values) {
            $a.Update()
        }
    }
}

Class BattleActionResult {
    [BattleActionResultType]$Type
    [BattleEntity]$Originator
    [BattleEntity]$Target
    [Int]$ActionEffectSum

    BattleActionResult() {}

    BattleActionResult(
        [BattleActionResultType]$Type,
        [BattleEntity]$OriginatorRef,
        [BattleEntity]$TargetRef,
        [Int]$ActionEffectSum
    ) {
        $this.Type            = $Type
        $this.Originator      = $OriginatorRef
        $this.Target          = $TargetRef
        $this.ActionEffectSum = $ActionEffectSum
    }
}

Class BAPunch : BattleAction {
    BAPunch() : base() {
        $this.Name        = 'Punch'
        $this.Description = 'A punch. Just like dad taught you.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 50
        $this.Chance      = 1.0
    }
}

Class BAKick : BattleAction {
    BAKick() : base() {
        $this.Name        = 'Kick'
        $this.Description = 'A kick. Don''t stub your toe.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 50
        $this.Chance      = 1.0
    }
}

Class BAKarateChop : BattleAction {
    BAKarateChop() : base() {
        $this.Name        = 'Karate Chop'
        $this.Description = 'Test your might!'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 60
        $this.Chance      = 0.8
    }
}

Class BAKarateKick : BattleAction {
    BAKarateKick() : base() {
        $this.Name        = 'Karate Kick'
        $this.Description = 'I hope your shins are fit.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BAPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 65
        $this.Chance      = 0.75
    }
}

Class BABash : BattleAction {
    BABash() : base() {
        $this.Name        = 'Bash'
        $this.Description = 'HULK SMASH!'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 75
        $this.Chance      = 0.7
    }
}

Class BABite : BattleAction {
    BABite() : base() {
        $this.Name        = 'Bite'
        $this.Description = 'When fists fail, teeth do just fine.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 40
        $this.Chance      = 0.9
    }
}

Class BAScratch : BattleAction {
    BAScratch() : base() {
        $this.Name        = 'Scratch'
        $this.Description = 'Nails are sometimes useful.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 45
        $this.Chance      = 1.0
    }
}

Class BADoubleScratch : BattleAction {
    BADoubleScratch() : base() {
        $this.Name        = 'Double Scratch'
        $this.Description = 'The manicure on these is lethal.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 85
        $this.Chance      = 0.75
    }
}

Class BAHeadbutt : BattleAction {
    BAHeadbutt() : base() {
        $this.Name        = 'Headbutt'
        $this.Description = 'Put that noggin'' to work!'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 160
        $this.Chance      = 0.4
    }
}

Class BADropKick : BattleAction {
    BADropKick() : base() {
        $this.Name        = 'Dropkick'
        $this.Description = 'Don''t use this on Murphy.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 120
        $this.Chance      = 0.3
    }
}

Class BAThrow : BattleAction {
    BAThrow() : base() {
        $this.Name        = 'Throw'
        $this.Description = 'One man''s trash is a useful weapon.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 0
        $this.Chance      = 0.9
    }
}

Class BAPeck : BattleAction {
    BAPeck() : base() {
        $this.Name        = 'Peck'
        $this.Description = 'One from Grandma usually means cookies later.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 20
        $this.Chance      = 1.0
    }
}

Class BATalonStab : BattleAction {
    BATalonStab() : base() {
        $this.Name        = 'Talon Stab'
        $this.Description = 'You don''t want a hug from these.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 70
        $this.Chance      = 1.0
    }
}

Class BASwordSlash : BattleAction {
    BASwordSlash() : base() {
        $this.Name        = 'Sword Slash'
        $this.Description = 'A basic sword attack.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 60
        $this.Chance      = 1.0
    }
}

Class BASwordStab : BattleAction {
    BASwordStab() : base() {
        $this.Name        = 'Sword Stab'
        $this.Description = 'This was practiced with toothpicks.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 80
        $this.Chance      = 0.7
    }
}

Class BAAxeSlash : BattleAction {
    BAAxeSlash() : base() {
        $this.Name        = 'Axe Slash'
        $this.Description = 'Chopping trees pays off.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 70
        $this.Chance      = 1.0
    }
}

Class BAAxeCleave : BattleAction {
    BAAxeCleave() : base() {
        $this.Name        = 'Axe Cleave'
        $this.Description = 'Before his fury, the trees stood no chance.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 90
        $this.Chance      = 0.8
    }
}

Class BAAxeThrow : BattleAction {
    BAAxeThrow() : base() {
        $this.Name        = 'Axe Throw'
        $this.Description = 'Don''t let one hit you on the way out.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 180
        $this.Chance      = 0.3
    }
}

Class BAKnifeStab : BattleAction {
    BAKnifeStab() : base() {
        $this.Name        = 'Knife Stab'
        $this.Description = 'Just a little prick, right?'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 40
        $this.Chance      = 0.9
    }
}

Class BAKnifeThrow : BattleAction {
    BAKnifeThrow() : base() {
        $this.Name        = 'Knife Throw'
        $this.Description = 'Like throwing darts, but cooler.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 80
        $this.Chance      = 0.3
    }
}

Class BAClubSwing : BattleAction {
    BAClubSwing() : base() {
        $this.Name        = 'Club Swing'
        $this.Description = 'Me Ooga. Me swing-um big-um stick.'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 70
        $this.Chance      = 0.7
    }
}

Class BAHomerunHit : BattleAction {
    BAHomerunHit() : base() {
        $this.Name        = 'Homerun Hit'
        $this.Description = 'Swing, batter... SWING!'
        $this.Type        = [BattleActionType]::Physical
        $this.Effect      = $Script:BaPhysicalCalc
        $this.MpCost      = 0
        $this.EffectValue = 200
        $this.Chance      = 0.1
    }
}

Class BAFlamePunch : BattleAction {
    BAFlamePunch() : base() {
        $this.Name        = 'Flame Punch'
        $this.Description = 'Flaming fists of fury.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 5
        $this.EffectValue = 75
        $this.Chance      = 1.0
    }
}

Class BAFlameKick : BattleAction {
    BAFlameKick() : base() {
        $this.Name        = 'Flame Kick'
        $this.Description = 'I got channed heat on my heels.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 5
        $this.EffectValue = 85
        $this.Chance      = 0.9
    }
}

Class BAFireball : BattleAction {
    BAFireball() : base() {
        $this.Name        = 'Fireball'
        $this.Description = 'That''s a spicy meatball!'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 7
        $this.EffectValue = 80
        $this.Chance      = 0.75
    }
}

Class BAMortarToss : BattleAction {
    BAMortarToss() : base() {
        $this.Name        = 'Mortar Toss'
        $this.Description = 'An esploozshun of firez.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 9
        $this.EffectValue = 100
        $this.Chance      = 0.7
    }
}

Class BAIKill : BattleAction {
    BAIKill() : base() {
        $this.Name        = 'IKill'
        $this.Description = 'Insta death'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 0
        $this.EffectValue = 50000
        $this.Chance      = 1.0
    }
}

Class BABlazeBurst : BattleAction {
    BABlazeBurst() : base() {
        $this.Name        = 'Blaze Burst'
        $this.Description = 'Like an arc flash, only worse.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 10
        $this.EffectValue = 80
        $this.Chance      = 0.8
    }
}

Class BAFlamethrower : BattleAction {
    BAFlamethrower() : base() {
        $this.Name        = 'Flamethrower'
        $this.Description = 'Our inspiration was Elon.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 10
        $this.EffectValue = 90
        $this.Chance      = 0.7
    }
}

Class BAEmberSlash : BattleAction {
    BAEmberSlash() : base() {
        $this.Name        = 'Ember Slash'
        $this.Description = 'At least the wound is cauterized.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAPyroblast : BattleAction {
    BAPyroblast() : base() {
        $this.Name        = 'Pyroblast'
        $this.Description = 'Fireworks never looked so good.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 15
        $this.EffectValue = 110
        $this.Chance      = 0.6
    }
}

Class BAAshenNova : BattleAction {
    BAAshenNova() : base() {
        $this.Name        = 'Ashen Nova'
        $this.Description = 'Reminds me of Pompeii. Only worse.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAIncenerate : BattleAction {
    BAIncenerate() : base() {
        $this.Name        = 'Incenerate'
        $this.Description = 'Kill it with fire, they said.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 20
        $this.EffectValue = 120
        $this.Chance      = 0.7
    }
}

Class BACinderStorm : BattleAction {
    BACinderStorm() : base() {
        $this.Name        = 'Cinder Storm'
        $this.Description = 'Hot coal hail. Yum.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 5
        $this.EffectValue = 60
        $this.Chance      = 0.9
    }
}

Class BALavaSurge : BattleAction {
    BALavaSurge() : base() {
        $this.Name        = 'Lava Surge'
        $this.Description = 'It''s like a surge of love, only the molten kind.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAFireCataclysm : BattleAction {
    BAFireCataclysm() : base() {
        $this.Name        = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalFire]) Cataclysm"
        $this.Description = 'Firey death rains upon you.'
        $this.Type        = [BattleActionType]::ElementalFire
        $this.Effect      = $Script:BaElementalFireCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAIcePunch : BattleAction {
    BAIcePunch() : base() {
        $this.Name        = 'Ice Punch'
        $this.Description = 'Frigid AND stiff.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAFrostKick : BattleAction {
    BAFrostKick() : base() {
        $this.Name        = 'Frost Kick'
        $this.Description = 'Ice on the knee. It''s a thing.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAIcicleStrike : BattleAction {
    BAIcicleStrike() : base() {
        $this.Name        = 'Icicle Strike'
        $this.Description = 'When they''re this big, who needs a sword?'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAGlacialSpike : BattleAction {
    BAGlacialSpike() : base() {
        $this.Name        = 'Glacial Spike'
        $this.Description = 'Global warming helped me make this one.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAChillSlash : BattleAction {
    BAChillSlash() : base() {
        $this.Name        = 'Chill Slash'
        $this.Description = 'Let''s all cool down, yeah?'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAIceBolt : BattleAction {
    BAIceBolt() : base() {
        $this.Name        = 'Ice Bolt'
        $this.Description = 'Not the kind of bolt you secure things with.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAArcticBlast : BattleAction {
    BAArcticBlast() : base() {
        $this.Name        = 'Arctic Blast'
        $this.Description = 'Oh you won''t be long for gettin'' froshbit, now!'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAFrostWave : BattleAction {
    BAFrostWave() : base() {
        $this.Name        = 'Frost Wave'
        $this.Description = 'Ride the wave, dude.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAArcticFury : BattleAction {
    BAArcticFury() : base() {
        $this.Name        = 'Arctic Fury'
        $this.Description = 'An ass whooping is a dish best served cold.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAFrozenSpear : BattleAction {
    BAFrozenSpear() : base() {
        $this.Name        = 'Frozen Spear'
        $this.Description = 'I found this spear in a fridge.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAHailstorm : BattleAction {
    BAHailstorm() : base() {
        $this.Name        = 'Hailstorm'
        $this.Description = 'A common cause of insurace claims.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAIcefallSlam : BattleAction {
    BAIcefallSlam() : base() {
        $this.Name        = 'Icefall Slam'
        $this.Description = 'Not avoiding the avalanche is a bad idea.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAIceCataclysm : BattleAction {
    BAIceCataclysm() : base() {
        $this.Name        = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalIce]) Cataclysm"
        $this.Description = 'Icy death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalIce
        $this.Effect      = $Script:BaElementalIceCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAAquaJet : BattleAction {
    BAAquaJet() : base() {
        $this.Name        = 'Aqua Jet'
        $this.Description = 'A Boeing 737 made entirely of water.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BATidalSurge : BattleAction {
    BATidalSurge() : base() {
        $this.Name        = 'Tidal Surge'
        $this.Description = 'They ebb, they flow, they attac.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAWaterWhip : BattleAction {
    BAWaterWhip() : base() {
        $this.Name        = 'Water Whip'
        $this.Description = 'Indiana Jones''s least favorite whip.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 5
        $this.EffectValue = 80
        $this.Chance      = 0.9
    }
}

Class BAMistStrike : BattleAction {
    BAMistStrike() : base() {
        $this.Name        = 'Mist Strike'
        $this.Description = 'Was it a cat I saw? Was I tac a ti saw?'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAHydroSlash : BattleAction {
    BAHydroSlash() : base() {
        $this.Name        = 'Hydro Slash'
        $this.Description = 'A moistened bint lobbed this scimitar at me.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAWavePunch : BattleAction {
    BAWavePunch() : base() {
        $this.Name        = 'Wave Punch'
        $this.Description = 'The latest Hawaiian Punch flavor. Swelling aftertaste.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 15
        $this.EffectValue = 100
        $this.Chance      = 1.0
    }
}

Class BAAquaticBolt : BattleAction {
    BAAquaticBolt() : base() {
        $this.Name        = 'Aquatic Bolt'
        $this.Description = 'Some watery things to pelt your neighbor with.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAAquaSphere : BattleAction {
    BAAquaSphere() : base() {
        $this.Name        = 'Aqua Sphere'
        $this.Description = 'Listen to ''Barbie Girl'' all day long. Enjoy.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BATidalCrush : BattleAction {
    BATidalCrush() : base() {
        $this.Name        = 'Tidal Crush'
        $this.Description = 'Your high school crush came to kill you, in water form.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BATsunami : BattleAction {
    BATsunami() : base() {
        $this.Name        = 'Tsunami'
        $this.Description = 'WAVES!'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BASeafoamBolt : BattleAction {
    BASeafoamBolt() : base() {
        $this.Name        = 'Seafoam Bolt'
        $this.Description = 'Sometimes I see these white bubbles on the shore.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BATyphoon : BattleAction {
    BATyphoon() : base() {
        $this.Name        = 'Typhoon'
        $this.Description = 'Not to be confused with the infamous Tie Foon.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BARaindance : BattleAction {
    BARaindance() : base() {
        $this.Name        = 'Raindance'
        $this.Description = 'Like Riverdance, only shit.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BAWateryGrave : BattleAction {
    BAWateryGrave() : base() {
        $this.Name        = 'Watery Grave'
        $this.Description = 'Davey Jones is holed up here.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BATempest : BattleAction {
    BATempest() : base() {
        $this.Name        = 'Tempest'
        $this.Description = 'If it were a tempest of love, would you feel any different?'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}

Class BAWaterCataclysm : BattleAction {
    BAWaterCataclysm() : base() {
        $this.Name        = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalWater]) Cataclysm"
        $this.Description = 'Watery death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalWater
        $this.Effect      = $Script:BaElementalWaterCalc
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}

Class BATerraStrike : BattleAction {
    BATerraStrike() : base() {
        $this.Name        = 'Terra Strike'
        $this.Description = 'Sticks and stones can break your bones.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAQuakeFist : BattleAction {
    BAQuakeFist() : base() {
        $this.Name        = 'Quake Fist'
        $this.Description = 'Two nerds get in a fight at QuakeCon.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BABoulderBash : BattleAction {
    BABoulderBash() : base() {
        $this.Name        = 'Boulder Bash'
        $this.Description = 'We played Resident Evil 5 to the end.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BATremor : BattleAction {
    BATremor() : base() {
        $this.Name        = 'Tremor'
        $this.Description = 'Does more damage than those Kevin Bacon movies.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BAGraniteDust : BattleAction {
    BAGraniteDust() : base() {
        $this.Name        = 'Granite Dust'
        $this.Description = 'There''s blood on the ground before you know it.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BARockslide : BattleAction {
    BARockslide() : base() {
        $this.Name        = 'Rockslide'
        $this.Description = 'Fallin'' rocks, fallin'' rocks, fallin'' rocks.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BASinkhole : BattleAction {
    BASinkhole() : base() {
        $this.Name        = 'Sinkhole'
        $this.Description = 'Tumbling down the rabbit hole.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}

Class BAGeoFence : BattleAction {
    BAGeoFence() : base() {
        $this.Name        = 'Geo Fence'
        $this.Description = 'Get off my lawn!'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}

Class BAEarthCataclysm : BattleAction {
    BAEarthCataclysm() : base() {
        $this.Name        = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalEarth]) Cataclysm"
        $this.Description = 'A rocky death rains down on you.'
        $this.Type        = [BattleActionType]::ElementalEarth
        $this.Effect      = $Script:BaElementalEarthCalc
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}

Class BAGaleStrike : BattleAction {
    BAGaleStrike() : base() {
        $this.Name        = 'Gale Strike'
        $this.Description = 'The wind can hurt you.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 50
        $this.EffectValue = 250
        $this.Chance      = 0.5
    }
}

Class BAZephyrSlash : BattleAction {
    BAZephyrSlash() : base() {
        $this.Name        = 'Zephyr Slash'
        $this.Description = 'What the hell is a zephyr, anyway?'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BABreezeBlade : BattleAction {
    BABreezeBlade() : base() {
        $this.Name        = 'Breeze Blade'
        $this.Description = 'Easy, breezy, bleedy, dying guy.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BAThunderClap : BattleAction {
    BAThunderClap() : base() {
        $this.Name        = 'Thunder Clap'
        $this.Description = 'Sometimes an euphemism, this time a threat.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BASkywardCut : BattleAction {
    BASkywardCut() : base() {
        $this.Name        = 'Skyward Cut'
        $this.Description = 'Remember to always cut away from yourself.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BAGrandFlash : BattleAction {
    BAGrandFlash() : base() {
        $this.Name        = 'Grand Flash'
        $this.Description = 'Right when the lightning strikes.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BACyclone : BattleAction {
    BACyclone() : base() {
        $this.Name        = 'Cyclone'
        $this.Description = 'Something about moving all night long.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BALightningBolt : BattleAction {
    BALightningBolt() : base() {
        $this.Name        = 'Lightning Bolt'
        $this.Description = 'These look cool from a distance.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BAGaleflash : BattleAction {
    BAGaleflash() : base() {
        $this.Name        = 'Galeflash'
        $this.Description = 'The lightning rode on the wind.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BABreezyWind : BattleAction {
    BABreezyWind() : base() {
        $this.Name        = 'Breezy Wind'
        $this.Description = 'So brisk it''ll carry her bonnet off.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BALeafShield : BattleAction {
    BALeafShield() : base() {
        $this.Name        = 'Leaf Shield'
        $this.Description = 'Are you sure this''ll work?'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BAWindCataclysm : BattleAction {
    BAWindCataclysm() : base() {
        $this.Name        = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalWind]) Cataclysm"
        $this.Description = 'Windy death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalWind
        $this.Effect      = $Script:BaElementalWindCalc
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BARadiance : BattleAction {
    BARadiance() : base() {
        $this.Name        = 'Radiance'
        $this.Description = 'All teh brights.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = $Script:BaElementalLightCalc
        $this.MpCost      = 100
        $this.EffectValue = 500
        $this.Chance      = 0.1
    }
}

Class BAHolyNova : BattleAction {
    BAHolyNova() : base() {
        $this.Name        = 'Holy Nova'
        $this.Description = 'More Bible than you can handle.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 200
        $this.EffectValue = 1000
        $this.Chance      = 0.1
    }
}

Class BADivineBeam : BattleAction {
    BADivineBeam() : base() {
        $this.Name        = 'Divine Beam'
        $this.Description = 'Got Jesus?'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BAPrismShock : BattleAction {
    BAPrismShock() : base() {
        $this.Name        = 'Prism Shock'
        $this.Description = 'The pretty rainbow of death.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BAHaloStrike : BattleAction {
    BAHaloStrike() : base() {
        $this.Name        = 'Halo Strike'
        $this.Description = 'These surprisingly hurt.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BALightbringer : BattleAction {
    BALightbringer() : base() {
        $this.Name        = 'Lightbringer'
        $this.Description = 'Bring the party!'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BASacredPulse : BattleAction {
    BASacredPulse() : base() {
        $this.Name        = 'Sacred Pulse'
        $this.Description = 'The defunct newsletter of the Catholic Church.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BADaybreaker : BattleAction {
    BADaybreaker() : base() {
        $this.Name        = 'Daybreaker'
        $this.Description = 'Some statue in Skyrim gave me this.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BAAngelicHymn : BattleAction {
    BAAngelicHymn() : base() {
        $this.Name        = 'Angelic Hymn'
        $this.Description = 'This is how I sound when I sing Britney Spears.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BABrilliance : BattleAction {
    BABrilliance() : base() {
        $this.Name        = 'Brilliance'
        $this.Description = 'How I feel when I look at myself in the mirror.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 300
        $this.EffectValue = 1500
        $this.Chance      = 0.1
    }
}

Class BASunfire : BattleAction {
    BASunfire() : base() {
        $this.Name        = 'Sunfire'
        $this.Description = 'Scorched Earth, mofo.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 400
        $this.EffectValue = 2000
        $this.Chance      = 0.1
    }
}

Class BALightCataclysm : BattleAction {
    BALightCataclysm() : base() {
        $this.Name        = "$($Script:BATAdornmentCharTable[[BattleActionType]::ElementalLight]) Cataclysm"
        $this.Description = 'Holy death rains down upon you.'
        $this.Type        = [BattleActionType]::ElementalLight
        $this.Effect      = {}
        $this.MpCost      = 500
        $this.EffectValue = 2500
        $this.Chance      = 0.1
    }
}

Class Player : BattleEntity {
    [Int]$CurrentGold

    Player() : base() {
        $this.CurrentGold     = 0
    }

    Player(
        [String]$Name,
        [Int]$BaseHp,
        [Int]$MaxHp,
        [Int]$BaseMp,
        [Int]$MaxMp,
        [Int]$Gold,
        [String[]]$TargetOfFilter
    ) : base() {
        $this.Name                              = $Name
        $this.CurrentGold                       = $Gold
        $this.Stats[[StatId]::HitPoints].Base   = $BaseHp
        $this.Stats[[StatId]::HitPoints].Max    = $MaxHp
        $this.Stats[[StatId]::MagicPoints].Base = $BaseMp
        $this.Stats[[StatId]::MagicPoints].Max  = $MaxMp
    }
}

Class EnemyBattleEntity : BattleEntity {
    [Int]$SpoilsGold              = 0

    EnemyBattleEntity() : base() {
        $this.SpoilsEffect = {
            Param(
                [Player]$Player,
                [EnemyBattleEntity]$Opponent
            )
            $Player.CurrentGold += $Opponent.SpoilsGold
        }
    }
}

Class EEBat : EnemyBattleEntity {
    EEBat() : base() {
        $this.Name  = 'Bat'
        $this.Stats = @{
            [StatId]::HitPoints = [BattleEntityProperty]@{
                Base                = 500
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 500
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Switch($Self.Base) {
                        { $_ -GT ($Self.Max * [BattleEntityProperty]::StatNumThresholdCaution) } {
                            $Self.State = [StatNumberState]::Normal
                        }

                        { ($_ -GT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger)) -AND ($_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdCaution)) } {
                            $Self.State = [StatNumberState]::Caution
                        }

                        { $_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger) } {
                            $Self.State = [StatNumberState]::Danger
                        }
                    }
                }
            }
            [StatId]::MagicPoints = [BattleEntityProperty]@{
                Base                = 50
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 50
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Switch($Self.Base) {
                        { $_ -GT ($Self.Max * [BattleEntityProperty]::StatNumThresholdCaution) } {
                            $Self.State = [StatNumberState]::Normal
                        }

                        { ($_ -GT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger)) -AND ($_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdCaution)) } {
                            $Self.State = [StatNumberState]::Caution
                        }

                        { $_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger) } {
                            $Self.State = [StatNumberState]::Danger
                        }
                    }
                }
            }
            [StatId]::Attack = [BattleEntityProperty]@{
                Base                = 12
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 12
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return $Self.Base
                }
            }
            [StatId]::Defense = [BattleEntityProperty]@{
                Base                = 16
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 16
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return
                }
            }
            [StatId]::MagicAttack = [BattleEntityProperty]@{
                Base                = 6
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 6
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return
                }
            }
            [StatId]::MagicDefense = [BattleEntityProperty]@{
                Base                = 4
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 4
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return
                }
            }
            [StatId]::Speed = [BattleEntityProperty]@{
                Base                = 9
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 9
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return
                }
            }
            [StatId]::Luck = [BattleEntityProperty]@{
                Base                = 5
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 5
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return
                }
            }
            [StatId]::Accuracy = [BattleEntityProperty]@{
                Base                = 9
                BasePre             = 0
                BaseAugmentValue    = 0
                Max                 = 9
                MaxPre              = 0
                MaxAugmentValue     = 0
                AugmentTurnDuration = 0
                BaseAugmentActive   = $false
                MaxAugmentActive    = $false
                State               = [StatNumberState]::Normal
                ValidateFunction    = {
                    Param(
                        [BattleEntityProperty]$Self
                    )

                    Return
                }
            }
        }
        $this.ActionListing = @{
            [ActionSlot]::A = [BAPunch]::new()
            [ActionSlot]::B = [BAScratch]::new()
            [ActionSlot]::C = $null
            [ActionSlot]::D = $null
        }
        $this.ActionMarbleBag = @([ActionSlot]::A, [ActionSlot]::A, [ActionSlot]::A, [ActionSlot]::A, [ActionSlot]::A, [ActionSlot]::B, [ActionSlot]::B, [ActionSlot]::B, [ActionSlot]::B, [ActionSlot]::B)
        $this.Affinity        = [BattleActionType]::ElementalIce
        # $this.Image           = $Script:EeiBat
        $this.SpoilsGold      = 50
        $this.SpoilsItems     = @()
    }
}


Class EENightwing : EEBat {
    EENightwing() : base() {
        $this.Name  = 'Nightwing'
    }
}

Class EEWingblight : EEBat {
    EEWingblight() : base() {
        $this.Name        = 'Wingblight'
    }
}

Class EEDarkfang : EEBat {
    EEDarkfang() : base() {
        $this.Name        = 'Darkfang'
    }
}

Class EENocturna : EEBat {
    EENocturna() : base() {
        $this.Name        = 'Nocturna'
    }
}

Class EEBloodswoop : EEBat {
    EEBloodswoop() : base() {
        $this.Name  = 'Bloodswoop'
    }
}

Class EEDuskbane : EEBat {
    EEDuskbane() : base() {
        $this.Name        = 'Duskbane'
    }
}

Class BattleManager {
    [BattleManagerState]$State            = [BattleManagerState]::TurnIncrement
    [Int]$TurnCounter                     = 0
    [Int]$TurnLimit                       = 0
    [Boolean]$CanPhaseOneAct              = $true
    [Boolean]$CanPhaseTwoAct              = $true
    [BattleEntity]$PhaseOneEntity         = $null
    [BattleEntity]$PhaseTwoEntity         = $null
    [ScriptBlock]$SpoilsAction            = $null

    BattleManager() {}

    [Void]Update() {
        Switch($this.State) {
            TurnIncrement {
                If($this.TurnLimit -GT 0) {
                    If(($this.TurnCounter + 1) -GT $this.TurnLimit) {
                        $this.State = [BattleManagerState]::BattleLost

                        Return
                    }
                    $this.TurnCounter++
                    $this.State = [BattleManagerState]::PhaseOrdering

                    Return
                }
                $this.TurnCounter++
                $this.State = [BattleManagerState]::PhaseOrdering

                Return
            }

            PhaseOrdering {
                [Single]$PlayerEffectiveSpeed = 0.0
                [Single]$EnemyEffectiveSpeed  = 0.0

                $PlayerEffectiveSpeed = $Script:ThePlayer.Stats[[StatId]::Speed].Base + ($(Get-Random -Minimum 0.0 -Maximum 1.0) * $Script:ThePlayer.Stats[[StatId]::Luck].Base)
                $EnemyEffectiveSpeed  = $Script:TheCurrentEnemy.Stats[[StatId]::Speed].Base + ($(Get-Random -Minimum 0.0 -Maximum 1.0) * $Script:TheCurrentEnemy.Stats[[StatId]::Luck].Base)
                [Single]$EsWinner     = [Math]::Max($PlayerEffectiveSpeed, $EnemyEffectiveSpeed)
                If($EsWinner -EQ $PlayerEffectiveSpeed) {
                    $this.PhaseOneEntity = $Script:ThePlayer
                    $this.PhaseTwoEntity = $Script:TheCurrentEnemy
                } Elseif($EsWinner -EQ $EnemyEffectiveSpeed) {
                    $this.PhaseOneEntity = $Script:TheCurrentEnemy
                    $this.PhaseTwoEntity = $Script:ThePlayer
                }
                $this.State = [BattleManagerState]::PhaseAExecution

                Return
            }

            PhaseAExecution {
                If(($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }
                If($this.CanPhaseOneAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    # Because the test runner needs to be in control of the execution, any action selected by any Entity is required to be random.
                    # Because the Get-Random cmdlet doesn't work with hashtables, the indexer pattern that's used for the Enemy Entity is required to
                    # be used for the Player Entity. Consequently, the ActionMarbleBag is required to be populated.
                    [ActionSlot]$SelectedSlot = $($this.PhaseOneEntity.ActionMarbleBag | Get-Random)
                    $ToExecute = $this.PhaseOneEntity.ActionListing[$SelectedSlot]
                    $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)

                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            # TODO: LOG A CRITICAL SUCCESS MESSAGE
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    # TODO: LOG A PHYSICAL ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' hit '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            # TODO: WRITE A SUCCESS WITH AFFINITY BONUS MESSAGE

                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful, and scored an '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'AFFINITY BONUS!'
                            #         )
                            #     )
                            # )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            # TODO: LOG AN AFFINITY AND CRITICAL BONUS MESSAGE

                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful, and scored a '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'CRITICAL '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             'and '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'AFFINITY BONUS!'
                            #         )
                            #     )
                            # )

                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            # TODO: LOG ATTACK SUCCESS MESSAGE

                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful!'
                            #         )
                            #     )
                            # )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    # TODO: LOG PHYSICAL ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' hit '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            # TODO: LOG ATTACK MISSED MESSAGE

                            # Try {
                            #     $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                            #     $Script:TheSfxMPlayer.Play()
                            # } Catch {}
                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' missed!'
                            #         )
                            #     )
                            # )

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            # TODO: LOG ATTACK FAILED MESSAGE

                            # Try {
                            #     $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                            #     $Script:TheSfxMPlayer.Play()
                            # } Catch {}
                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' failed!'
                            #         )
                            #     )
                            # )

                            Break
                        }

                        ([BattleActionResultType]::FailedElementalMatch) {
                            # NOTE: THIS RESULT TYPE ISN'T CURRENTLY USED

                            Break
                        }
                    }
                } Else {
                    # TODO: LOG ENTITY CAN'T ACT MESSAGE

                    # Try {
                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                    #     $Script:TheSfxMPlayer.Play()
                    # } Catch {}
                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    #     @(
                    #         [ATStringCompositeSc]::new(
                    #             $this.PhaseOneEntity.NameDrawColor,
                    #             [ATDecorationNone]::new(),
                    #             $this.PhaseOneEntity.Name
                    #         ),
                    #         [ATStringCompositeSc]::new(
                    #             [CCTextDefault24]::new(),
                    #             [ATDecorationNone]::new(),
                    #             ' is unable to act at this time!'
                    #         )
                    #     )
                    # )
                }
                Foreach($Stat in $this.PhaseOneEntity.Stats.Values) {
                    If($Stat.AugmentTurnDuration -GT 0) {
                        $Stat.AugmentTurnDuration--
                        If($Stat.AugmentTurnDuration -EQ 0) {
                            If($this.PhaseOneEntity -IS [Player]) {
                                $Stat.Update()
                                # TODO: LOG UPDATING MESSAGE

                                # $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                                # $Script:ThePlayerBattleStatWindow.Draw()
                            } Else {
                                $Stat.Update()
                                # TODO: LOG UPDATING MESSAGE

                                # $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                                # $Script:TheEnemyBattleStatWindow.Draw()
                            }
                        }
                    }
                }
                $this.State = [BattleManagerState]::PhaseBExecution

                Break
            }

            PhaseBExecution {
                If(($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }
                $this.PhaseIndicator.IndicatorDrawDirty = $true
                $this.PhaseIndicator.Draw($this.PhaseTwoEntity)
                If($this.PhaseTwoEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()
                If($this.CanPhaseTwoAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    If($this.PhaseTwoEntity -IS [Player]) {
                        # TODO: FOR THE TESTER TO WORK, THIS SECTION HAS TO BE AUTOMATIC LIKE THE ENEMY IS.

                        # $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        # While($null -EQ $ToExecute) {
                        #     $Script:ThePlayerBattleActionWindow.Draw()
                        #     $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        # }
                        # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                        #     @(
                        #         [ATStringCompositeSc]::new(
                        #             $this.PhaseTwoEntity.NameDrawColor,
                        #             [ATDecorationNone]::new(),
                        #             $this.PhaseTwoEntity.Name
                        #         ),
                        #         [ATStringCompositeSc]::new(
                        #             [CCTextDefault24]::new(),
                        #             [ATDecorationNone]::new(),
                        #             ' uses '
                        #         ),
                        #         [ATStringCompositeSc]::new(
                        #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                        #             [ATDecorationNone]::new(),
                        #             $ToExecute.Name
                        #         )
                        #     )
                        # )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        # $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        [ActionSlot]$SelectedSlot = $($this.PhaseTwoEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseTwoEntity.ActionListing[$SelectedSlot]

                        # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                        #     @(
                        #         [ATStringCompositeSc]::new(
                        #             $this.PhaseTwoEntity.NameDrawColor,
                        #             [ATDecorationNone]::new(),
                        #             $this.PhaseTwoEntity.Name
                        #         ),
                        #         [ATStringCompositeSc]::new(
                        #             [CCTextDefault24]::new(),
                        #             [ATDecorationNone]::new(),
                        #             ' uses '
                        #         ),
                        #         [ATStringCompositeSc]::new(
                        #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                        #             [ATDecorationNone]::new(),
                        #             $ToExecute.Name
                        #         )
                        #     )
                        # )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        # $Script:TheEnemyBattleStatWindow.Draw()
                    }
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            # TODO: LOG A CRITICAL SUCCESS MESSAGE
                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful, and scored a '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'CRITICAL!'
                            #         )
                            #     )
                            # )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    # TODO: LOG A PHYSICAL ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' hit '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            # TODO: WRITE A SUCCESS WITH AFFINITY BONUS MESSAGE

                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful, and scored an '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'AFFINITY BONUS!'
                            #         )
                            #     )
                            # )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ACTION TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            # TODO: LOG AN AFFINITY AND CRITICAL SUCCESS MESSAGE

                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful, and scored a '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'CRITICAL '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             'and '
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCAppleYellowLight24]::new(),
                            #             [ATDecoration]::new($true),
                            #             'AFFINITY BONUS!'
                            #         )
                            #     )
                            # )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            # TODO: LOG ATTACK SUCCESS MESSAGE 

                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' was successful!'
                            #         )
                            #     )
                            # )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    # TODO: LOG PHYSICAL ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' hit '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    # TODO: LOG A FIRE ATTACK TYPE MESSAGE

                                    # Try {
                                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                    #     $Script:TheSfxMPlayer.Play()
                                    # } Catch {}
                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' burned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    # TODO: LOG A WATER ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' soaked '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    # TODO: LOG AN EARTH ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' stoned '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    # TODO: LOG A WIND ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' sheared '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    # TODO: LOG A LIGHT ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast holy power on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    # TODO: LOG A DARK ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast unholy power on  '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    # TODO: LOG AN ICE ATTACK TYPE MESSAGE

                                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                    #     @(
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseTwoEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseTwoEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' cast ice powers on '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $this.PhaseOneEntity.NameDrawColor,
                                    #             [ATDecorationNone]::new(),
                                    #             $this.PhaseOneEntity.Name
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' for '
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    #             [ATDecorationNone]::new(),
                                    #             $ActionResult.ActionEffectSum
                                    #         ),
                                    #         [ATStringCompositeSc]::new(
                                    #             [CCTextDefault24]::new(),
                                    #             [ATDecorationNone]::new(),
                                    #             ' damage.'
                                    #         )
                                    #     )
                                    # )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    # NOTE: THIS ATTACK TYPE ISN'T CURRENTLY USED

                                    Break
                                }
                            }
                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            # TODO: LOG ATTACK MISSED MESSAGE

                            # Try {
                            #     $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                            #     $Script:TheSfxMPlayer.Play()
                            # } Catch {}
                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' missed!'
                            #         )
                            #     )
                            # )

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            # TODO: LOG ATTACK FAILED MESSAGE

                            # Try {
                            #     $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                            #     $Script:TheSfxMPlayer.Play()
                            # } Catch {}
                            # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            #     @(
                            #         [ATStringCompositeSc]::new(
                            #             $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                            #             [ATDecorationNone]::new(),
                            #             $ToExecute.Name
                            #         ),
                            #         [ATStringCompositeSc]::new(
                            #             [CCTextDefault24]::new(),
                            #             [ATDecorationNone]::new(),
                            #             ' failed!'
                            #         )
                            #     )
                            # )

                            Break
                        }

                        ([BattleActionResultType]::FailedElementalMatch) {
                            # NOTE: THIS RESULT TYPE ISN'T CURRENTLY USED

                            Break
                        }
                    }
                } Else {
                    # NOTE: LOG ENTITY CAN'T ACT MESSAGE

                    # Try {
                    #     $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                    #     $Script:TheSfxMPlayer.Play()
                    # } Catch {}
                    # $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    #     @(
                    #         [ATStringCompositeSc]::new(
                    #             $this.PhaseTwoEntity.NameDrawColor,
                    #             [ATDecorationNone]::new(),
                    #             $this.PhaseTwoEntity.Name
                    #         ),
                    #         [ATStringCompositeSc]::new(
                    #             [CCTextDefault24]::new(),
                    #             [ATDecorationNone]::new(),
                    #             ' is unable to act at this time!'
                    #         )
                    #     )
                    # )
                }
                Foreach($Stat in $this.PhaseTwoEntity.Stats.Values) {
                    If($Stat.AugmentTurnDuration -GT 0) {
                        $Stat.AugmentTurnDuration--
                        If($Stat.AugmentTurnDuration -EQ 0) {
                            If($this.PhaseTwoEntity -IS [Player]) {
                                $Stat.Update()
                                # TODO: LOG UPDATING MESSAGE

                                # $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                                # $Script:ThePlayerBattleStatWindow.Draw()
                            } Else {
                                $Stat.Update()
                                # TODO: LOG UPDATING MESSAGE
                                
                                # $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                                # $Script:TheEnemyBattleStatWindow.Draw()
                            }
                        }
                    }
                }
                $this.State = [BattleManagerState]::TurnIncrement

                Break
            }

            Calculation {
                If($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseOneEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        $this.SpoilsAction = $this.PhaseTwoEntity.SpoilsEffect
                        $this.State        = [BattleManagerState]::BattleWon

                        Break
                    }
                } Elseif($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseTwoEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        $this.SpoilsAction = $this.PhaseOneEntity.SpoilsEffect
                        $this.State        = [BattleManagerState]::BattleWon

                        Break
                    }
                }
                $this.State = [BattleManagerState]::TurnIncrement

                Break
            }

            BattleWon {
                $Script:TheBgmMPlayer.Stop()
                If($Script:HasBattleWonChimePlayed -EQ $false) {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBattlePlayerWin)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:HasBattleWonChimePlayed = $true
                }
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'You''ve won the battle!'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                If($this.PhaseOneEntity -IS [Player]) {
                    $this.SpoilsAction = $this.PhaseTwoEntity.SpoilsEffect
                    Invoke-Command $this.SpoilsAction -ArgumentList ([Player]$this.PhaseOneEntity), ([EnemyBattleEntity]$this.PhaseTwoEntity)
                } Elseif($this.PhaseTwoEntity -IS [Player]) {
                    $this.SpoilsAction = $this.PhaseOneEntity.SpoilsEffect
                    Invoke-Command $this.SpoilsAction -ArgumentList ([Player]$this.PhaseTwoEntity), ([EnemyBattleEntity]$this.PhaseOneEntity)
                }
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'Press ''Enter'' to exit.'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                While($a.VirtualKeyCode -NE 13) {
                    $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                }
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen

                Break
            }

            BattleLost {
                $Script:TheBgmMPlayer.Stop()
                If($Script:HasBattleLostChimePlayed -EQ $false) {
                    $Script:TheSfxMachine.SoundLocation = $Script:SfxBattlePlayerLose
                    $Script:TheSfxMachine.Play()
                    $Script:HasBattleLostChimePlayed = $true
                }
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'You''ve lost the battle.'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]@{
                                Blink = $true
                            },
                            'GAME OVER'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                Start-Sleep -Seconds 5
                Clear-Host

                Exit
            }

            Default {}
        }
    }

    [Void]Cleanup() {
        $Script:BattleCursorVisible          = $false
        $Script:ThePlayerBattleStatWindow    = $null
        $Script:TheEnemyBattleStatWindow     = $null
        $Script:ThePlayerBattleActionWindow  = $null
        $Script:TheBattleStatusMessageWindow = $null
        $Script:TheBattleEnemyImageWindow    = $null
        $Script:HasBattleIntroPlayed         = $false
        $Script:IsBattleBgmPlaying           = $false
        $Script:HasBattleWonChimePlayed      = $false
        $Script:HasBattleLostChimePlayed     = $false
    }
}
