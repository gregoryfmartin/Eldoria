using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

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

Class BattleEntityProperty {
    Static [Single]$StatNumThresholdCaution          = 0.6D
    Static [Single]$StatNumThresholdDanger           = 0.3D
    Static [ConsoleColor24]$StatNumDrawColorSafe     = [CCAppleGreenLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorCaution  = [CCAppleYellowLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorDanger   = [CCAppleRedLight24]::new()
    Static [ConsoleColor24]$StatAugDrawColorPositive = [CCAppleCyanLight24]::new()
    Static [ConsoleColor24]$StatAugDrawColorNegative = [CCApplePurpleDark24]::new()

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
    [ConsoleColor24]$NameDrawColor
    [BattleActionType]$Affinity

    BattleEntity() {
        $this.Name            = ''
        $this.Stats           = @{}
        $this.ActionListing   = @{}
        $this.SpoilsEffect    = $null
        $this.ActionMarbleBag = $null
        $this.NameDrawColor   = [CCTextDefault24]::new()
        $this.Affinity        = [BattleActionType]::None
    }

    BattleEntity(
        [String]$Name,
        [Hashtable]$Stats,
        [Hashtable]$ActionListing,
        [ScriptBlock]$SpoilsEffect,
        [ActionSlot[]]$ActionMarbleBag,
        [ConsoleColor24]$NameDrawColor,
        [BattleActionType]$Affinity
    ) {
        $this.Name            = $Name
        $this.Stats           = $Stats
        $this.ActionListing   = $ActionListing
        $this.SpoilsEffect    = $SpoilsEffect
        $this.ActionMarbleBag = $ActionMarbleBag
        $this.NameDrawColor   = $NameDrawColor
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

Class Player : BattleEntity {
    Static [ConsoleColor24]$AsideColor    = [CCAppleIndigoLight24]::new()
    Static [ConsoleColor24]$GoldDrawColor = [CCAppleYellowLight24]::new()

    [Int]$CurrentGold
    [ATCoordinates]$MapCoordinates
    [List[MapTileObject]]$Inventory
    [List[String]]$TargetOfFilter
    [PlayerActionInventory]$ActionInventory

    Player() : base() {
        $this.CurrentGold     = 0
        $this.MapCoordinates  = [ATCoordinates]::new(0, 0)
        $this.Inventory       = [List[MapTileObject]]::new()
        $this.TargetOfFilter  = [List[String]]::new()
        $this.ActionInventory = [PlayerActionInventory]::new()
    }

    Player(
        [Int]$CurrentGold,
        [ATCoordinates]$MapCoordinates,
        [List[MapTileObject]]$Inventory,
        [String[]]$TargetOfFilter
    ) : base() {
        $this.CurrentGold     = $CurrentGold
        $this.MapCoordinates  = $MapCoordinates
        $this.Inventory       = $Inventory
        $this.TargetOfFilter  = [List[String]]::new()
        $this.ActionInventory = [PlayerActionInventory]::new()

        Foreach($a in $TargetOfFilter) {
            $this.TargetOfFilter.Add($a) | Out-Null
        }
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
        $this.MapCoordinates                    = [ATCoordinates]::new(0, 0)
        $this.Inventory                         = [List[MapTileObject]]::new()
        $this.TargetOfFilter                    = [List[String]]::new()
        $this.ActionInventory                   = [PlayerActionInventory]::new()

        Foreach($a in $TargetOfFilter) {
            $this.TargetOfFilter.Add($a) | Out-Null
        }
    }

    [Boolean]IsItemInInventory(
        [String]$ItemName
    ) {
        Foreach($a in $this.Inventory) {
            If($a.Name -IEQ $ItemName) {
                Return $true
            }
        }

        Return $false
    }

    [MapTileObject]GetItemReference(
        [String]$ItemName
    ) {
        Foreach($a in $this.Inventory) {
            If($a.Name -IEQ $ItemName) {
                Return $a
            }
        }

        Return $null
    }

    [ItemRemovalStatus]RemoveInventoryItemByName(
        [String]$ItemName
    ) {
        $c = 0

        Foreach($a in $this.Inventory) {
            If($a.Name -IEQ $ItemName) {
                If($a.KeyItem -EQ $true) {
                    Return [ItemRemovalStatus]::FailKeyItem
                }
                $this.Inventory.RemoveAt($c)

                Return [ItemRemovalStatus]::Success
            }
            $c++
        }

        Return [ItemRemovalStatus]::FailGeneral
    }

    [ItemRemovalStatus]RemoveInventoryItemByIndex(
        [Int]$Index
    ) {
        [MapTileObject]$a = $null

        Try {
            $a = $this.Inventory[$Index]
        } Catch {
            Return [ItemRemovalStatus]::FailGeneral
        }
        If($a.KeyItem -EQ $true) {
            Return [ItemRemovalStatus]::FailKeyItem
        }
        $this.Inventory.RemoveAt($Index)

        Return [ItemRemovalStatus]::Success
    }

    [Void]MapMoveNorth() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = $Script:CurrentMap.MapHeight - 1
                $b = $this.MapCoordinates.Row + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $this.MapCoordinates.Row = 0
                } Else {
                    $this.MapCoordinates.Row++
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = $Script:CurrentMap.MapHeight - 1
                $b = $this.MapCoordinates.Row + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Row++
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Void]MapMoveSouth() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitSouth] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = 0
                $b = $this.MapCoordinates.Row - 1

                If($b -LT $a) {
                    $this.MapCoordinates.Row = $Script:CurrentMap.MapHeight - 1
                } Else {
                    $this.MapCoordinates.Row--
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = 0
                $b = $this.MapCoordinates.Row - 1

                If($b -LT $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Row--
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Void]MapMoveEast() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitEast] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = $Script:CurrentMap.MapWidth - 1
                $b = $this.MapCoordinates.Column + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $this.MapCoordinates.Column = 0
                } Else {
                    $this.MapCoordinates.Column++
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = $Script:CurrentMap.MapWidth - 1
                $b = $this.MapCoordinates.Column + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Column++
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Void]MapMoveWest() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitWest] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = 0
                $b = $this.MapCoordinates.Column - 1

                If($b -LT $a) {
                    $this.MapCoordinates.Column = $Script:CurrentMap.MapWidth - 1
                } Else {
                    $this.MapCoordinates.Column--
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = 0
                $b = $this.MapCoordinates.Column - 1

                If($b -LT $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Column--
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Boolean]ValidateSourceInFilter(
        [String]$SourceItemClass
    ) {
        Return ($SourceItemClass -IN $this.TargetOfFilter)
    }
}

Class EnemyBattleEntity : BattleEntity {
    [EnemyEntityImage]$Image      = $null
    [Int]$SpoilsGold              = 0
    [MapTileObject[]]$SpoilsItems = @()

    EnemyBattleEntity() : base() {
        $this.SpoilsEffect = {
            Param(
                [Player]$Player,
                [EnemyBattleEntity]$Opponent
            )

            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                @(
                    [ATStringCompositeSc]::new(
                        $Opponent.NameDrawColor,
                        [ATDecorationNone]::new(),
                        $Opponent.Name
                    ),
                    [ATStringCompositeSc]::new(
                        [CCTextDefault24]::new(),
                        [ATDecorationNone]::new(),
                        ' dropped '
                    ),
                    [ATStringCompositeSc]::new(
                        [CCAppleYellowDark24]::new(),
                        [ATDecorationNone]::new(),
                        $Opponent.SpoilsGold
                    ),
                    [ATStringCompositeSc]::new(
                        [CCTextDefault24]::new(),
                        [ATDecorationNone]::new(),
                        ' gold.'
                    )
                )
            )
            $Script:TheBattleStatusMessageWindow.Draw()
            $Player.CurrentGold += $Opponent.SpoilsGold
            If($Opponent.SpoilsItems.Length -GT 0) {
                [String]$ItemNames = ($Opponent.SpoilsItems | Select-Object -ExpandProperty 'Name') -JOIN ', '
                
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'Also found '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecorationNone]::new(),
                            $ItemNames
                        ),
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            '.'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                Foreach($a in $Opponent.SpoilsItems) {
                    $Player.Inventory.Add($a) | Out-Null
                }
            }
        }
    }
    
    EnemyBattleEntity(
        [EnemyEntityImage]$Image
    ) : base() {
        $this.Image = $Image

        $this.SpoilsEffect = {
            Param(
                [Player]$Player,
                [EnemyBattleEntity]$Opponent
            )

            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                @(
                    [ATStringCompositeSc]::new(
                        $Opponent.NameDrawColor,
                        [ATDecorationNone]::new(),
                        $Opponent.Name
                    ),
                    [ATStringCompositeSc]::new(
                        [CCTextDefault24]::new(),
                        [ATDecorationNone]::new(),
                        ' dropped '
                    ),
                    [ATStringCompositeSc]::new(
                        [CCAppleYellowDark24]::new(),
                        [ATDecorationNone]::new(),
                        $Opponent.SpoilsGold
                    ),
                    [ATStringCompositeSc]::new(
                        [CCTextDefault24]::new(),
                        [ATDecorationNone]::new(),
                        ' gold.'
                    )
                )
            )
            $Script:TheBattleStatusMessageWindow.Draw()
            $Player.CurrentGold += $Opponent.SpoilsGold
            If($Opponent.SpoilsItems.Length -GT 0) {
                [String]$ItemNames = ($Opponent.SpoilsItems | Select-Object -ExpandProperty 'Name') -JOIN ', '
                
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'Also found '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecorationNone]::new(),
                            $ItemNames
                        ),
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            '.'
                        )
                    )
                )
                $Script:TheBattleStatuMessageWindow.Draw()
                Foreach($a in $Opponent.SpoilsItems) {
                    $Player.Inventory.Add($a) | Out-Null
                }
            }
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
        $this.Image           = $Script:EeiBat
        $this.SpoilsGold      = 50
        $this.SpoilsItems     = @(
            [MTOMilk]::new()
        )
    }
}


Class EENightwing : EEBat {
    EENightwing() : base() {
        $this.Name  = 'Nightwing'
        $this.Image = [EEINightwing]::new()
    }
}

Class EEWingblight : EEBat {
    EEWingblight() : base() {
        $this.Name        = 'Wingblight'
        $this.Image       = $Script:EeiWingblight
        $this.SpoilsItems = @()
    }
}

Class EEDarkfang : EEBat {
    EEDarkfang() : base() {
        $this.Name        = 'Darkfang'
        $this.Image       = $Script:EeiDarkfang
        $this.SpoilsItems = @()
    }
}

Class EENocturna : EEBat {
    EENocturna() : base() {
        $this.Name        = 'Nocturna'
        $this.Image       = $Script:EeiNocturna
        $this.SpoilsItems = @()
    }
}

Class EEBloodswoop : EEBat {
    EEBloodswoop() : base() {
        $this.Name  = 'Bloodswoop'
        $this.Image = $Script:EeiBloodswoop
    }
}

Class EEDuskbane : EEBat {
    EEDuskbane() : base() {
        $this.Name        = 'Duskbane'
        $this.Image       = $Script:EeiDuskbane
        $this.SpoilsItems = @()
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
    [BattlePhaseIndicator]$PhaseIndicator = $null

    BattleManager() {
        If($Script:BattleCursorVisible -EQ $false) {
            Write-Host "$([ATControlSequences]::CursorHide)"
            $Script:BattleCursorVisible = $true
        }
        If($null -EQ $Script:ThePlayerBattleStatWindow) {
            $Script:ThePlayerBattleStatWindow = [BattleEntityStatusWindow]::new(1, 1, 17, 19, $Script:ThePlayer)
        }
        If($null -EQ $Script:TheEnemyBattleStatWindow) {
            $Script:TheEnemyBattleStatWindow = [BattleEntityStatusWindow]::new(1, 22, 17, 40, $Script:TheCurrentEnemy)
        }
        If($null -EQ $Script:ThePlayerBattleActionWindow) {
            $Script:ThePlayerBattleActionWindow = [BattlePlayerActionWindow]::new()
        }
        If($null -EQ $Script:TheBattleStatusMessageWindow) {
            $Script:TheBattleStatusMessageWindow = [BattleStatusMessageWindow]::new()
        }
        If($null -EQ $Script:TheBattleEnemyImageWindow) {
            $Script:TheBattleEnemyImageWindow = [BattleEnemyImageWindow]::new()
        }
        If($null -EQ $this.PhaseIndicator) {
            $this.PhaseIndicator = [BattlePhaseIndicator]::new()
        }
    }

    [Void]Update() {
        $Script:ThePlayer.Update()
        $Script:TheCurrentEnemy.Update()
        $Script:ThePlayerBattleStatWindow.Draw()
        $Script:TheEnemyBattleStatWindow.Draw()
        $Script:TheBattleEnemyImageWindow.Draw()
        $Script:ThePlayerBattleActionWindow.Draw()
        $Script:TheBattleStatusMessageWindow.Draw()
        $Script:Rui.CursorPosition = $([ATCoordinates]::new(0, 0)).ToAutomationCoordinates()
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
                $this.PhaseIndicator.IndicatorDrawDirty = $true
                $this.PhaseIndicator.Draw($this.PhaseOneEntity)
                If($this.PhaseOneEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()
                If($this.CanPhaseOneAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    If($this.PhaseOneEntity -IS [Player]) {
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseOneEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseOneEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else  {
                        [ActionSlot]$SelectedSlot = $($this.PhaseOneEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseOneEntity.ActionListing[$SelectedSlot]
                        
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseOneEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseOneEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored an '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'and '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' missed!'
                                    )
                                )
                            )

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' failed!'
                                    )
                                )
                            )

                            Break
                        }

                        ([BattleActionResultType]::FailedElementalMatch) {
                            Break
                        }
                    }
                } Else {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                        @(
                            [ATStringCompositeSc]::new(
                                $this.PhaseOneEntity.NameDrawColor,
                                [ATDecorationNone]::new(),
                                $this.PhaseOneEntity.Name
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' is unable to act at this time!'
                            )
                        )
                    )
                }
                Foreach($Stat in $this.PhaseOneEntity.Stats.Values) {
                    If($Stat.AugmentTurnDuration -GT 0) {
                        $Stat.AugmentTurnDuration--
                        If($Stat.AugmentTurnDuration -EQ 0) {
                            If($this.PhaseOneEntity -IS [Player]) {
                                $Stat.Update()
                                $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                                $Script:ThePlayerBattleStatWindow.Draw()
                            } Else {
                                $Stat.Update()
                                $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                                $Script:TheEnemyBattleStatWindow.Draw()
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
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseTwoEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseTwoEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        [ActionSlot]$SelectedSlot = $($this.PhaseTwoEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseTwoEntity.ActionListing[$SelectedSlot]
                        
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseTwoEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseTwoEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored an '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'and '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }
                            Break
                        }
    
                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' missed!'
                                    )
                                )
                            )

                            Break
                        }
    
                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' failed!'
                                    )
                                )
                            )

                            Break
                        }
    
                        ([BattleActionResultType]::FailedElementalMatch) {
                            Break
                        }
                    }
                } Else {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                        @(
                            [ATStringCompositeSc]::new(
                                $this.PhaseTwoEntity.NameDrawColor,
                                [ATDecorationNone]::new(),
                                $this.PhaseTwoEntity.Name
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' is unable to act at this time!'
                            )
                        )
                    )
                }
                Foreach($Stat in $this.PhaseTwoEntity.Stats.Values) {
                    If($Stat.AugmentTurnDuration -GT 0) {
                        $Stat.AugmentTurnDuration--
                        If($Stat.AugmentTurnDuration -EQ 0) {
                            If($this.PhaseTwoEntity -IS [Player]) {
                                $Stat.Update()
                                $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                                $Script:ThePlayerBattleStatWindow.Draw()
                            } Else {
                                $Stat.Update()
                                $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                                $Script:TheEnemyBattleStatWindow.Draw()
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
