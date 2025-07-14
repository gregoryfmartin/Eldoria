using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EE BAT
#
###############################################################################

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
        $this.Image           = $Script:EeiBat
        $this.SpoilsGold      = 50
        $this.SpoilsItems     = @(
            [MTOMilk]::new()
        )
    }
}

