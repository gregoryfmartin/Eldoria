using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

# LOGGING FILE CREATION
# [String]$Script:LogFileName = '.\Log.log'
# 'WELCOME TO THE DANGER ZONE!!!' | Out-File -FilePath $Script:LogFileName

# GLOBAL VARIABLE DEFINITIONS

Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Working' -PercentComplete -1

#[Player]              $Script:ThePlayer                = [Player]::new('Steve', 250, 500, 25, 25, 5000, @('MTOMilk'))

[String]                  $Script:OsCheckLinux              = 'OsLinux'
[String]                  $Script:OsCheckMac                = 'OsMac'
[String]                  $Script:OsCheckWindows            = 'OsWindows'
[String]                  $Script:OsCheckUnknown            = 'OsUnknown'
[StatusWindow]            $Script:TheStatusWindow           = [StatusWindow]::new()
[CommandWindow]           $Script:TheCommandWindow          = [CommandWindow]::new()
[SceneWindow]             $Script:TheSceneWindow            = [SceneWindow]::new()
[MessageWindow]           $Script:TheMessageWindow          = [MessageWindow]::new()
[InventoryWindow]         $Script:TheInventoryWindow        = $null
[ATCoordinatesDefault]    $Script:DefaultCursorCoordinates  = [ATCoordinatesDefault]::new()
[BattleEntityStatusWindow]$Script:ThePlayerBattleStatWindow = $null
[BattleEntityStatusWindow]$Script:TheEnemyBattleStatWindow  = $null
[BufferManager]           $Script:TheBufferManager          = [BufferManager]::new()
[GameCore]                $Script:TheGameCore               = [GameCore]::new()
[BattleEntity]            $Script:TheCurrentEnemy           = $null





[Player]$Script:ThePlayer = [Player]@{
    Name = 'Steve'
    Stats = @{
        [StatId]::HitPoints = [BattleEntityProperty]@{
            Base                = 200
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 200
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
                        Return
                    }

                    { ($_ -GT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger)) -AND ($_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdCaution)) } {
                        $Self.State = [StatNumberState]::Caution
                        Return
                    }

                    { $_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger) } {
                        $Self.State = [StatNumberState]::Danger
                        Return
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
                        Return
                    }

                    { ($_ -GT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger)) -AND ($_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdCaution)) } {
                        $Self.State = [StatNumberState]::Caution
                        Return
                    }

                    { $_ -LT ($Self.Max * [BattleEntityProperty]::StatNumThresholdDanger) } {
                        $Self.State = [StatNumberState]::Danger
                        Return
                    }
                }
            }
        }
        [StatId]::Attack = [BattleEntityProperty]@{
            Base                = 15
            BasePre             = 0
            BaseAugmentValue    = 5
            Max                 = 15
            MaxPre              = 0
            MaxAugmentValue     = 0
            AugmentTurnDuration = 5
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
            Base                = 8
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 8
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
    ActionListing = @{
        [ActionSlot]::A = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::B = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::C = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::D = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
    }
    SpoilsEffect    = {}
    ActionMarbleBag = [List[[ActionSlot]]]::new()
    CurrentGold     = 500
    MapCoordinates  = [ATCoordinates]::new(0, 0)
    Inventory       = [List[MapTileObject]]::new()
    TargetOfFilter  = [List[String]]::new()
}




$Script:TheCurrentEnemy = [BattleEntity]@{
    Name = 'Bad Guy'
    Stats = @{
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
    ActionListing = @{
        [ActionSlot]::A = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::B = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::C = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::D = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
    }
    SpoilsEffect = {}
    ActionMarbleBag = [List[[ActionSlot]]]::new()
}






Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Complete' -PercentComplete -1

Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Working' -PercentComplete -1

[Map]$Script:SampleMap   = [Map]::new('Sample Map', 2, 2, $false)
[Map]$Script:CurrentMap  = $Script:SampleMap
[Map]$Script:PreviousMap = $null

Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Complete' -PercentComplete -1

Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Working' -PercentComplete -1

[SIFieldNorthRoad]        $Script:FieldNorthRoadImage         = [SIFieldNorthRoad]::new()
[SIFieldNorthEastRoad]    $Script:FieldNorthEastRoadImage     = [SIFieldNorthEastRoad]::new()
[SIFieldNorthWestRoad]    $Script:FieldNorthWestRoadImage     = [SIFieldNorthWestRoad]::new()
[SIFieldNorthEastWestRoad]$Script:FieldNorthEastWestRoadImage = [SIFieldNorthEastWestRoad]::new()
[SIFieldSouthRoad]        $Script:FieldSouthRoadImage         = [SIFieldSouthRoad]::new()
[SIFieldSouthEastRoad]    $Script:FieldSouthEastRoadImage     = [SIFieldSouthEastRoad]::new()
[SIFieldSouthWestRoad]    $Script:FieldSouthWestRoadImage     = [SIFieldSouthWestRoad]::new()
[SIFieldSouthEastWestRoad]$Script:FieldSouthEastWestRoadImage = [SIFieldSouthEastWestRoad]::new()

Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Completed
Write-Progress -Activity 'Creating Maps              ' -Id 2 -Completed
Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Completed

#$Script:TheSceneWindow.Image = $Script:FieldNorthRoadImage

$Script:Rui = $(Get-Host).UI.RawUI

[Boolean]$Script:GpsRestoredFromInvBackup = $true

# ENUMERATION DEFINITIONS

Enum GameStatePrimary {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    InventoryScreen
    BattleScreen
    Cleanup
}

Enum GameStateSecondary {
    Normal
    Battle
    Shop
    Inn
}

Enum StatNumberState {
    Normal
    Caution
    Danger
}

Enum CommonVirtualKeyCodes {
    Escape     = 27
    LeftArrow  = 37
    RightArrow = 39
    UpArrow    = 38
    DownArrow  = 40
    A          = 65
    D          = 68
}

Enum ItemRemovalStatus {
    Success
    FailGeneral
    FailKeyItem
}

Enum BattleActionType {
    Physical
    ElementalFire
    ElementalWater
    ElementalEarth
    ElementalWind
    ElementalLight
    ElementalDark
    MagicPoison
    MagicConfuse
    MagicSleep
    MagicAging
    None
}

Enum HpIncrementResult {
    FailHpFull
    FailHpAddNegative
    Success
}

Enum HpDecrementResult {
    FailHpEmpty
    FailHpSubtractPositive
    Success
}

Enum MpIncrementResult {
    FailMpFull
    FailMpAddNegative
    Success
}

Enum MpDecrementResult {
    FailMpEmpty
    FailMpSubtractPositive
    Success
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
}

# COMMAND TABLE DEFINITION
$Script:TheCommandTable = @{
    'move' = {
        Param(
            [String]$a0
        )

        Switch($a0) {
            { $_ -IEQ 'north' -OR $_ -IEQ 'n' } {
                $Script:ThePlayer.MapMoveNorth()
            }

            { $_ -IEQ 'south' -OR $_ -IEQ 's' } {
                $Script:ThePlayer.MapMoveSouth()
            }

            { $_ -IEQ 'east' -OR $_ -IEQ 'e' } {
                $Script:ThePlayer.MapMoveEast()
            }

            { $_ -IEQ 'west' -OR $_ -IEQ 'w' } {
                $Script:ThePlayer.MapMoveWest()
            }
        }
    }

    'm' = {
        Param(
            [String]$a0
        )

        Switch($a0) {
            { $_ -IEQ 'north' -OR $_ -IEQ 'n' } {
                $Script:ThePlayer.MapMoveNorth()
            }

            { $_ -IEQ 'south' -OR $_ -IEQ 's' } {
                $Script:ThePlayer.MapMoveSouth()
            }

            { $_ -IEQ 'east' -OR $_ -IEQ 'e' } {
                $Script:ThePlayer.MapMoveEast()
            }

            { $_ -IEQ 'west' -OR $_ -IEQ 'w' } {
                $Script:ThePlayer.MapMoveWest()
            }
        }
    }

    'look' = {
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheCommandWindow.InvokeLookAction()

        Return
    }

    'l' = {
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheCommandWindow.InvokeLookAction()

        Return
    }

    'inventory' = {
        $Script:TheCommandWindow.UpdateCommandHistory($true)

        # Copy the active buffer to the A back buffer
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()

        # Change state
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

        Return
    }

    'i' = {
        $Script:TheCommandWindow.UpdateCommandHistory($true)

        # Copy the active buffer to the A back buffer
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()

        # Change state
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

        Return
    }

    'examine' = {
        Param(
            [String]$a0
        )

        $Script:TheCommandWindow.InvokeExamineAction($a0)

        Return
    }

    'exa' = {
        Param(
            [String]$a0
        )

        $Script:TheCommandWindow.InvokeExamineAction($a0)

        Return
    }

    'get' = {
        Param(
            [String]$a0
        )

        $Script:TheCommandWindow.InvokeGetAction($a0)

        Return
    }

    'g' = {
        Param(
            [String]$a0
        )

        $Script:TheCommandWindow.InvokeGetAction($a0)

        Return
    }

    'take' = {
        Param(
            [String]$a0
        )

        $Script:TheCommandWindow.InvokeGetAction($a0)

        Return
    }

    't' = {
        Param(
            [String]$a0
        )

        $Script:TheCommandWindow.InvokeGetAction($a0)

        Return
    }

    'use' = {
        Param(
            [String]$a0,
            [String]$a1
        )

        If($PSBoundParameters.ContainsKey('a0') -AND $PSBoundParameters.ContainsKey('a1')) {
            If($Script:ThePlayer.IsItemInInventory($a0)) {
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().IsItemInTile($a1)) {
                    [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)
                    [MapTileObject]$mti = $Script:CurrentMap.GetTileAtPlayerCoordinates().GetItemReference($a1)

                    If($mti.ValidateSourceInFilter($pi.PSTypeNames[0])) {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        Invoke-Command $mti.Effect -ArgumentList $mti, $pi
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessage(
                            "Can't use a(n) $($a0) on a $($a1).",
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                } Else {
                    If($a1 -IEQ 'self') {
                        [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)

                        If($Script:ThePlayer.ValidateSourceInFilter($pi.PSTypeNames[0])) {
                            $Script:TheCommandWindow.UpdateCommandHistory($true)
                            Invoke-Command $pi.Effect -ArgumentList $pi, $Script:ThePlayer
                        }
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessage(
                            'Whatever you typed doesn''t make any sense.',
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                }
            } Else {
                # The item isn't in the Player's Inventory, thus rendering this an inoperable command (despite not being syntactically invalid).
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMessage(
                    "You don't seem to have any $($a0) in your pocket(s).",
                    [CCAppleYellowLight24]::new(),
                    [ATDecorationNone]::new()
                )

                Return
            }
        } Elseif($PSBoundParameters.ContainsKey('a0') -AND (-NOT $PSBoundParameters.ContainsKey('a1'))) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)

            If($Script:ThePlayer.IsItemInInventory($a0)) {
                $Script:TheMessageWindow.WriteMessage(
                    "You need to tell me what you want to use the $($a0) on.",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            } Else {
                $Script:TheMessageWindow.WriteMessage(
                    "I have no idea how to use a(n) $($a0).",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            }
        }
    }

    'u' = {
        Param(
            [String]$a0,
            [String]$a1
        )

        If($PSBoundParameters.ContainsKey('a0') -AND $PSBoundParameters.ContainsKey('a1')) {
            If($Script:ThePlayer.IsItemInInventory($a0)) {
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().IsItemInTile($a1)) {
                    [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)
                    [MapTileObject]$mti = $Script:CurrentMap.GetTileAtPlayerCoordinates().GetItemReference($a1)

                    If($mti.ValidateSourceInFilter($pi.PSTypeNames[0])) {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        Invoke-Command $mti.Effect -ArgumentList $mti, $pi
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessage(
                            "Can't use a(n) $($a0) on a $($a1).",
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                } Else {
                    If($a1 -IEQ 'self') {
                        [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)

                        If($Script:ThePlayer.ValidateSourceInFilter($pi.PSTypeNames[0])) {
                            $Script:TheCommandWindow.UpdateCommandHistory($true)
                            Invoke-Command $pi.Effect -ArgumentList $pi, $Script:ThePlayer
                        }
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessage(
                            'Whatever you typed doesn''t make any sense.',
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]::new($true)
                        )
                    }
                }
            } Else {
                # The item isn't in the Player's Inventory, thus rendering this an inoperable command (despite not being syntactically invalid).
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMessage(
                    "You don't seem to have any $($a0) in your pocket(s).",
                    [CCAppleYellowLight24]::new(),
                    [ATDecorationNone]::new()
                )

                Return
            }
        } Elseif($PSBoundParameters.ContainsKey('a0') -AND (-NOT $PSBoundParameters.ContainsKey('a1'))) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)

            If($Script:ThePlayer.IsItemInInventory($a0)) {
                $Script:TheMessageWindow.WriteMessage(
                    "You need to tell me what you want to use the $($a0) on.",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            } Else {
                $Script:TheMessageWindow.WriteMessage(
                    "I have no idea how to use a(n) $($a0).",
                    [CCAppleYellowDark24]::new(),
                    [ATDecorationNone]::new()
                )
            }
        }
    }

    'drop' = {
        Param(
            [String]$a0
        )

        If($args.Length -GE 1) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessage(
                'Can''t drop all those items at once, bruh.',
                [CCAppleYellowDark24]::new(),
                [ATDecorationNone]::new()
            )

            Return
        }

        If($PSBoundParameters.Count -EQ 1) {
            If($PSBoundParameters.ContainsKey('a0')) {
                If($Script:ThePlayer.IsItemInInventory($a0)) {
                    If($Script:ThePlayer.RemoveInventoryItemByName($a0) -EQ [ItemRemovalStatus]::Success) {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        $Script:TheMessageWindow.WriteMessage(
                            "Dropped $($a0) from your inventory.",
                            [CCAppleYellowDark24]::new(),
                            [ATDecorationNone]::new()
                        )
                    } Else {
                        Exit
                    }
                } Else {
                    $Script:TheCommandWindow.UpdateCommandHistory($false)
                    $Script:TheMessageWindow.WriteMessage(
                        "There ain't no $($a0) in your pockets gov'.",
                        [CCAppleYellowDark24]::new(),
                        [ATDecorationNone]::new()
                    )
                }
            }
        } Elseif($PSBoundParameters.Count -LE 0) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessage(
                'I don''t know what to drop...',
                [CCAppleRedDark24]::new(),
                [ATDecoration]::new($true)
            )
        }
    }
}

# GLOBAL STATE BLOCK TABLE DEFINITION
$Script:TheGlobalStateBlockTable = @{
    [GameStatePrimary]::SplashScreenA = {}

    [GameStatePrimary]::SplashScreenB = {}

    [GameStatePrimary]::TitleScreen = {}

    [GameStatePrimary]::PlayerSetupScreen = {}

    [GameStatePrimary]::GamePlayScreen = {
        If($null -NE $Script:TheInventoryWindow) {
            $Script:TheInventoryWindow = $null
        }

        If($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::InventoryScreen -AND $Script:GpsRestoredFromInvBackup -EQ $false) {
            $Script:TheBufferManager.RestoreBufferAToActive()

            # Force redraws of the content; a restoration from a buffer capture will NOT retain the 24-bit color information
            # and I really don't feel like trying to figure out how to grab the buffer manually
            $Script:GpsRestoredFromInvBackup             = $true
            $Script:TheSceneWindow.SceneImageDirty       = $true
            $Script:TheStatusWindow.PlayerNameDrawDirty  = $true
            $Script:TheStatusWindow.PlayerHpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerMpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerGoldDrawDirty  = $true
            $Script:TheCommandWindow.CommandHistoryDirty = $true
            $Script:TheMessageWindow.MessageADirty       = $true
            $Script:TheMessageWindow.MessageBDirty       = $true
            $Script:TheMessageWindow.MessageCDirty       = $true

            # Write the sequence to show the cursor since it's hidden by the Inventory Screen
            Write-Host "$([ATControlSequences]::CursorShow)"
        }

        # Update the Player
        $Script:ThePlayer.Update()

        $Script:TheStatusWindow.Draw()
        $Script:TheCommandWindow.Draw()
        $Script:TheSceneWindow.Draw()
        $Script:TheMessageWindow.Draw()
        $Script:TheCommandWindow.HandleInput()
    }

    [GameStatePrimary]::InventoryScreen = {
        If($null -EQ $Script:TheInventoryWindow) {
            $Script:TheInventoryWindow = [InventoryWindow]::new()
        }

        If($Script:GpsRestoredFromInvBackup -EQ $true) {
            $Script:GpsRestoredFromInvBackup = $false
        }

        $Script:TheInventoryWindow.Draw()
        $Script:TheInventoryWindow.HandleInput()
    }
    
    [GameStatePrimary]::BattleScreen = {
        If($null -EQ $Script:ThePlayerBattleStatWindow) {
            $Script:ThePlayerBattleStatWindow = [BattleEntityStatusWindow]::new(1, 1, 17, 19, $Script:ThePlayer)
        }
        If($null -EQ $Script:TheEnemyBattleStatWindow) {
            $Script:TheEnemyBattleStatWindow = [BattleEntityStatusWindow]::new(1, 22, 17, 40, $Script:TheCurrentEnemy)
        }

        $Script:ThePlayer.Update()
        $Script:TheCurrentEnemy.Update()

        $Script:ThePlayerBattleStatWindow.Draw()
        $Script:TheEnemyBattleStatWindow.Draw()
        
        # FOR TESTING PURPOSES ONLY!
        Read-Host
    }

    [GameStatePrimary]::Cleanup = {}
}

# [GameStatePrimary]$Script:TheGlobalGameState         = [GameStatePrimary]::BattleScreen
[GameStatePrimary]$Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState

# CLASS DEFINITIONS

Class EmojiBank {
    Static [String]$SmileyNormal             = "`u{1F600}"
    Static [String]$SimleyRofl               = "`u{1F606}"
    Static [String]$SmileySweat              = "`u{1F605}"
    Static [String]$SmileyMelting            = "`u{1FAE0}"
    Static [String]$AffectionNormal          = "`u{1F970}"
    Static [String]$AffectionHeartEyes       = "`u{1F60D}"
    Static [String]$AffectionBlowingKiss     = "`u{1F618}"
    Static [String]$TongueNormal             = "`u{1F61B}"
    Static [String]$TongueZany               = "`u{1F92A}"
    Static [String]$HandOverMouthSmile       = "`u{1F92D}"
    Static [String]$HandOverMouth            = "`u{1FAE2}"
    Static [String]$HandPeeking              = "`u{1FAE3}"
    Static [String]$HandShush                = "`u{1F92B}"
    Static [String]$HandThinking             = "`u{1F914}"
    Static [String]$HandSalute               = "`u{1FAE1}"
    Static [String]$SkepticRaisedEyebrow     = "`u{1F928}"
    Static [String]$SkepticNeutral           = "`u{1F610}"
    Static [String]$SkepticDottedFace        = "`u{1FAE5}"
    Static [String]$SkepticSmirk             = "`u{1F60F}"
    Static [String]$SkepticUnamused          = "`u{1F612}"
    Static [String]$SkepticRollingEyes       = "`u{1F644}"
    Static [String]$SkepticExhale            = "`u{1F62E}"
    Static [String]$SleepyRelieved           = "`u{1F60C}"
    Static [String]$SleepyPensive            = "`u{1F614}"
    Static [String]$SleepySleepy             = "`u{1F62A}"
    Static [String]$SleepyDrooling           = "`u{1F924}"
    Static [String]$SleepyAsleep             = "`u{1F634}"
    Static [String]$UnwellMedicalMask        = "`u{1F637}"
    Static [String]$UnwellThermometer        = "`u{1F912}"
    Static [String]$UnwellHeadBandage        = "`u{1F915}"
    Static [String]$UnwellNausea             = "`u{1F922}"
    Static [String]$UnwellVomiting           = "`u{1F92E}"
    Static [String]$UnwellSneezing           = "`u{1F927}"
    Static [String]$UnwellFever              = "`u{1F975}"
    Static [String]$UnwellChill              = "`u{1F976}"
    Static [String]$UnwellWoozy              = "`u{1F974}"
    Static [String]$UnwellDead               = "`u{1F635}"
    Static [String]$UnwellHeadExplode        = "`u{1F92F}"
    Static [String]$HatCowboy                = "`u{1F920}"
    Static [String]$HatParty                 = "`u{1F973}"
    Static [String]$HatDisgusied             = "`u{1F978}"
    Static [String]$GlassesSunglasses        = "`u{1F60E}"
    Static [String]$GlassesNerd              = "`u{1F913}"
    Static [String]$GlassesMonocle           = "`u{1F9D0}"
    Static [String]$ConcernedConfused        = "`u{1F615}"
    Static [String]$ConcernedDiagMouth       = "`u{1FAE4}"
    Static [String]$ConcernedWorried         = "`u{1F61F}"
    Static [String]$ConcernedSlightFrown     = "`u{1F641}"
    Static [String]$ConcernedOpenMouth       = "`u{1F62E}"
    Static [String]$ConcernedHushed          = "`u{1F62F}"
    Static [String]$ConcernedAstonished      = "`u{1F632}"
    Static [String]$ConcernedFlushed         = "`u{1F633}"
    Static [String]$ConcernedPleading        = "`u{1F97A}"
    Static [String]$ConcernedHoldingTears    = "`u{1F979}"
    Static [String]$ConcernedFearful         = "`u{1F628}"
    Static [String]$ConcernedAnxious         = "`u{1F630}"
    Static [String]$ConcernedCrying          = "`u{1F622}"
    Static [String]$ConcernedWailing         = "`u{1F63D}"
    Static [String]$ConcernedScreaming       = "`u{1F631}"
    Static [String]$NegativeNoseSteam        = "`u{1F624}"
    Static [String]$NegativeEnraged          = "`u{1F621}"
    Static [String]$NegativeAngry            = "`u{1F620}"
    Static [String]$NegativeExplitive        = "`u{1F92C}"
    Static [String]$NegativeSkull            = "`u{1F480}"
    Static [String]$CostumePoop              = "`u{1F4A9}"
    Static [String]$CostumeClown             = "`u{1F921}"
    Static [String]$CostumeOgre              = "`u{1F479}"
    Static [String]$CostumeGoblin            = "`u{1F47A}"
    Static [String]$CostumeGhost             = "`u{1F47B}"
    Static [String]$CostumeAlien             = "`u{1F47D}"
    Static [String]$CostumeInvaders          = "`u{1F47E}"
    Static [String]$CostumeRobot             = "`u{1F916}"
    Static [String]$CatGrinning              = "`u{1F63A}"
    Static [String]$CatHeartEyes             = "`u{1F63B}"
    Static [String]$CatWrySmile              = "`u{1F63C}"
    Static [String]$CatCrying                = "`u{1F63F}"
    Static [String]$CatAngry                 = "`u{1F63E}"
    Static [String]$MiscLoveLetter           = "`u{1F48C}"
    Static [String]$MiscBrokenHeart          = "`u{1F494}"
    Static [String]$MiscOrangeHeart          = "`u{1F9E1}"
    Static [String]$MiscYellowHeart          = "`u{1F49B}"
    Static [String]$MiscGreenHeart           = "`u{1F49A}"
    Static [String]$MiscBlueHeart            = "`u{1F499}"
    Static [String]$MiscLightBlueHeart       = "`u{1FA75}"
    Static [String]$MiscPurpleHeart          = "`u{1F49C}"
    Static [String]$MiscBrownHeart           = "`u{1F90E}"
    Static [String]$MiscBlackHeart           = "`u{1F5A4}"
    Static [String]$MiscGreyHeart            = "`u{1FA76}"
    Static [String]$MiscWhiteHeart           = "`u{1F90D}"
    Static [String]$MiscKissMark             = "`u{1F48B}"
    Static [String]$MiscHundredPoints        = "`u{1F4AF}"
    Static [String]$MiscAngerSymbol          = "`u{1F4A2}"
    Static [String]$MiscCollisionSymbol      = "`u{1F4A5}"
    Static [String]$MiscSweatDroplets        = "`u{1F4A6}"
    Static [String]$MiscDashingAway          = "`u{1F4A8}"
    Static [String]$MiscHole                 = "`u{1F573}"
    Static [String]$MiscSpeechBubble         = "`u{1F4AC}"
    Static [String]$MiscTripleZ              = "`u{1F4A4}"
    Static [String]$PersonBaby               = "`u{1F476}"
    Static [String]$PersonChild              = "`u{1F9D2}"
    Static [String]$PersonBoy                = "`u{1F466}"
    Static [String]$PersonGirl               = "`u{1F467}"
    Static [String]$PersonPerson             = "`u{1F9D1}"
    Static [String]$PersonBlondeHair         = "`u{1F471}"
    Static [String]$PersonMan                = "`u{1F468}"
    Static [String]$PersonManBeard           = "`u{1F9D4}"
    Static [String]$PersonWoman              = "`u{1F469}"
    Static [String]$PersonOldMan             = "`u{1F474}"
    Static [String]$PersonOldWoman           = "`u{1F475}"
    Static [String]$PersonGestureFrowning    = "`u{1F64D}"
    Static [String]$PersonGesturePouting     = "`u{1F64E}"
    Static [String]$PersonGestureNo          = "`u{1F645}"
    Static [String]$PersonGestureOkay        = "`u{1F646}"
    Static [String]$PersonGestureRaiseHand   = "`u{1F64B}"
    Static [String]$PersonGestureBowing      = "`u{1F647}"
    Static [String]$PersonGestureFacepalming = "`u{1F926}"
    Static [String]$PersonGestureShrugging   = "`u{1F937}"
}

<#
Defines a 24-bit color to be used in ANSI-based terminals. Each channel is clamped to appropriate unsigned integer values.
#>
Class ConsoleColor24 {
    [ValidateRange(0, 255)][Int]$Red
    [ValidateRange(0, 255)][Int]$Green
    [ValidateRange(0, 255)][Int]$Blue

    ConsoleColor24(
        [Int]$Red,
        [Int]$Green,
        [Int]$Blue
    ) {
        $this.Red   = $Red
        $this.Green = $Green
        $this.Blue  = $Blue
    }

    ConsoleColor24(
        [PSCustomObject]$JsonData
    ) {
        $psoProps = $JsonData.PSObject.Properties
        $this.Red   = [Int]$psoProps['Red'].Value
        $this.Green = [Int]$psoProps['Green'].Value
        $this.Blue  = [Int]$psoProps['Blue'].Value
    }
}

Class ATControlSequences {
    Static [String]$ForegroundColor24Prefix = "`e[38;2;"
    Static [String]$BackgroundColor24Prefix = "`e[48;2;"
    Static [String]$DecorationBlink         = "`e[5m"
    Static [String]$ModifierReset           = "`e[0m"
    Static [String]$CursorHide              = "`e[?25l"
    Static [String]$CursorShow              = "`e[?25h"

    Static [String]GenerateFG24String([ConsoleColor24]$Color) {
        Return "$([ATControlSequences]::ForegroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }

    Static [String]GenerateBG24String([ConsoleColor24]$Color) {
        Return "$([ATControlSequences]::BackgroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }

    Static [String]GenerateCoordinateString([Int]$Row, [Int]$Column) {
        Return "`e[$($Row.ToString());$($Column.ToString())H"
    }
}

<#
Defines an ANSI Buffer Cell Foreground Color modifier in 24-bit color. This class leverages ConsoleColor24 to accomplish this.
#>
Class ATForegroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color

    ATForegroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    ATForegroundColor24(
        [PSCustomObject]$JsonData
    ) {
        $this.Color = [ConsoleColor24]::new($JsonData)
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}

<#
Defines an ANSI Buffer Cell Background Color modifier in 24-bit color. This class leverages ConsoleColor24 to accomplish this.
#>
Class ATBackgroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color

    ATBackgroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    ATBackgroundColor24(
        [PSObject]$JsonData
    ) {
        $this.Color = [ConsoleColor24]::new($JsonData)
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateBG24String($this.Color)
    }
}

<#
Defines a collection of potential ANSI Buffer Cell decorators.
#>
Class ATDecoration {
    [ValidateNotNullOrEmpty()][Boolean]$Blink

    ATDecoration(
        [Boolean]$Blink
    ) {
        $this.Blink = $Blink
    }

    ATDecoration(
        [PSObject]$JsonData
    ) {
        $psoProps = $JsonData.PSObject.Properties
        $this.Blink = [Boolean]$psoProps['Blink'].Value
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        If($this.Blink) {
            $a += [ATControlSequences]::DecorationBlink
        }

        Return $a
    }
}

Class ATCoordinates {
    [ValidateNotNullOrEmpty()][Int]$Row
    [ValidateNotNullOrEmpty()][Int]$Column

    ATCoordinates(
        [Int]$Row,
        [Int]$Column
    ) {
        $this.Row    = $Row
        $this.Column = $Column
    }

    ATCoordinates(
        [Coordinates]$AutomationCoordinates
    ) {
        $this.Row    = $AutomationCoordinates.X
        $this.Column = $AutomationCoordinates.Y
    }

    ATCoordinates(
        [PSObject]$JsonData
    ) {
        $psoProps    = $JsonData.PSObject.Properties
        $this.Row    = [Int]$psoProps['Row'].Value
        $this.Column = [Int]$psoProps['Column'].Value
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateCoordinateString($this.Row, $this.Column)
    }

    [Coordinates]ToAutomationCoordinates() {
        Return [Coordinates]::new($this.Row, $this.Column)
    }
}

Class CCBlack24 : ConsoleColor24 {
    CCBlack24() : base(0, 0, 0) {}
}

Class CCWhite24 : ConsoleColor24 {
    CCWhite24() : base(255, 255, 255) {}
}

Class CCRed24 : ConsoleColor24 {
    CCRed24() : base(255, 0, 0) {}
}

Class CCGreen24 : ConsoleColor24 {
    CCGreen24() : base(0, 255, 0) {}
}

Class CCBlue24 : ConsoleColor24 {
    CCBlue24() : base (0, 0, 255) {}
}

Class CCYellow24 : ConsoleColor24 {
    CCYellow24() : base(255, 255, 0) {}
}

Class CCDarkYellow24 : ConsoleColor24 {
    CCDarkYellow24() : base(255, 204, 0) {}
}

Class CCDarkCyan24 : ConsoleColor24 {
    CCDarkCyan24() : base(0, 139, 139) {}
}

Class CCDarkGrey24 : ConsoleColor24 {
    CCDarkGrey24() : base(45, 45, 45) {}
}

Class CCRandom24 : ConsoleColor24 {
    CCRandom24() : base($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0)) {}
}

Class CCAppleRedLight24 : ConsoleColor24 {
    CCAppleRedLight24(): base(255, 59, 48) {}
}

Class CCAppleRedDark24 : ConsoleColor24 {
    CCAppleRedDark24(): base(255, 69, 58) {}
}

Class CCAppleOrangeLight24 : ConsoleColor24 {
    CCAppleOrangeLight24(): base(255, 149, 0) {}
}

Class CCAppleOrangeDark24 : ConsoleColor24 {
    CCAppleOrangeDark24(): base(255, 159, 10) {}
}

Class CCAppleYellowLight24 : ConsoleColor24 {
    CCAppleYellowLight24(): base(255, 204, 0) {}
}

Class CCAppleYellowDark24 : ConsoleColor24 {
    CCAppleYellowDark24(): base(255, 214, 10) {}
}

Class CCAppleGreenLight24 : ConsoleColor24 {
    CCAppleGreenLight24(): base(52, 199, 89) {}
}

Class CCAppleGreenDark24 : ConsoleColor24 {
    CCAppleGreenDark24(): base(48, 209, 88) {}
}

Class CCAppleMintLight24 : ConsoleColor24 {
    CCAppleMintLight24(): base(0, 199, 190) {}
}

Class CCAppleMintDark24 : ConsoleColor24 {
    CCAppleMintDark24(): base(99, 230, 226) {}
}

Class CCAppleTealLight24 : ConsoleColor24 {
    CCAppleTealLight24(): base(48, 176, 199) {}
}

Class CCAppleTealDark24 : ConsoleColor24 {
    CCAppleTealDark24(): base(64, 200, 224) {}
}

Class CCAppleCyanLight24 : ConsoleColor24 {
    CCAppleCyanLight24(): base(50, 173, 230) {}
}

Class CCAppleCyanDark24 : ConsoleColor24 {
    CCAppleCyanDark24(): base(100, 210, 255) {}
}

Class CCAppleBlueLight24 : ConsoleColor24 {
    CCAppleBlueLight24(): base(0, 122, 255) {}
}

Class CCAppleBlueDark24 : ConsoleColor24 {
    CCAppleBlueDark24(): base(10, 132, 255) {}
}

Class CCAppleIndigoLight24 : ConsoleColor24 {
    CCAppleIndigoLight24(): base(88, 86, 214) {}
}

Class CCAppleIndigoDark24 : ConsoleColor24 {
    CCAppleIndigoDark24(): base(94, 92, 230) {}
}

Class CCApplePurpleLight24 : ConsoleColor24 {
    CCApplePurpleLight24(): base(175, 82, 222) {}
}

Class CCApplePurpleDark24 : ConsoleColor24 {
    CCApplePurpleDark24(): base(191, 90, 242) {}
}

Class CCApplePinkLight24 : ConsoleColor24 {
    CCApplePinkLight24(): base(255, 45, 85) {}
}

Class CCApplePinkDark24 : ConsoleColor24 {
    CCApplePinkDark24(): base(255, 55, 95) {}
}

Class CCAppleBrownLight24 : ConsoleColor24 {
    CCAppleBrownLight24(): base(162, 132, 94) {}
}

Class CCAppleBrownDark24 : ConsoleColor24 {
    CCAppleBrownDark24(): base(172, 142, 104) {}
}

Class CCAppleGrey1Light24 : ConsoleColor24 {
    CCAppleGrey1Light24(): base(142, 142, 147) {}
}

Class CCAppleGrey1Dark24 : ConsoleColor24 {
    CCAppleGrey1Dark24(): base(142, 142, 147) {}
}

Class CCAppleGrey2Light24 : ConsoleColor24 {
    CCAppleGrey2Light24(): base(174, 174, 178) {}
}

Class CCAppleGrey2Dark24 : ConsoleColor24 {
    CCAppleGrey2Dark24(): base(99, 99, 102) {}
}

Class CCAppleGrey3Light24 : ConsoleColor24 {
    CCAppleGrey3Light24(): base(199, 199, 204) {}
}

Class CCAppleGrey3Dark24 : ConsoleColor24 {
    CCAppleGrey3Dark24(): base(72, 72, 74) {}
}

Class CCAppleGrey4Light24 : ConsoleColor24 {
    CCAppleGrey4Light24(): base(209, 209, 214) {}
}

Class CCAppleGrey4Dark24 : ConsoleColor24 {
    CCAppleGrey4Dark24(): base(58, 58, 60) {}
}

Class CCAppleGrey5Light24 : ConsoleColor24 {
    CCAppleGrey5Light24(): base(229, 229, 234) {}
}

Class CCAppleGrey5Dark24 : ConsoleColor24 {
    CCAppleGrey5Dark24(): base(44, 44, 46) {}
}

Class CCAppleGrey6Light24 : ConsoleColor24 {
    CCAppleGrey6Light24(): base(242, 242, 247) {}
}

Class CCAppleGrey6Dark24 : ConsoleColor24 {
    CCAppleGrey6Dark24(): base(28, 28, 30) {}
}

<#
https://www.pantone.com/connect/14-4318-TCX
#>
Class CCPantoneSkyBlue24 : ConsoleColor24 {
    CCPantoneSkyBlue24(): base(54, 73, 83) {}
}
<#
https://www.pantone.com/connect/15-6322-TPX
#>
Class CCPantoneLightGrassGreen24 : ConsoleColor24 {
    CCPantoneLightGrassGreen24(): base(49, 70, 53) {}
}

<#
https://www.pantone.com/connect/19-1218-TCX
#>
Class CCPantonePottingSoil24 : ConsoleColor24 {
    CCPantonePottingSoil24(): base(33, 22, 18) {}
}

Class CCTextDefault24 : CCAppleGrey5Light24 {}

Class ATForegroundColor24None : ATForegroundColor24 {
    ATForegroundColor24None(): base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATBackgroundColor24None : ATBackgroundColor24 {
    ATBackgroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone(): base(0, 0) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATCoordinatesDefault : ATCoordinates {
    ATCoordinatesDefault() : base(1, 18) {}
}

Class ATDecorationNone : ATDecoration {
    ATDecorationNone(): base($false) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATStringPrefix {
    [ValidateNotNullOrEmpty()][ATForegroundColor24]$ForegroundColor
    [ValidateNotNullOrEmpty()][ATBackgroundColor24]$BackgroundColor
    [ValidateNotNullOrEmpty()][ATDecoration]$Decorations
    [ValidateNotNullOrEmpty()][ATCoordinates]$Coordinates

    ATStringPrefix() {
        $this.ForegroundColor = [ATForegroundColor24None]::new()
        $this.BackgroundColor = [ATBackgroundColor24None]::new()
        $this.Decorations     = [ATDecorationNone]::new()
        $this.Coordinates     = [ATCoordinatesNone]::new()
    }

    ATStringPrefix(
        [ATForegroundColor24]$ForegroundColor,
        [ATBackgroundColor24]$BackgroundColor,
        [ATDecoration]$Decorations,
        [ATCoordinates]$Coordinates
    ) {
        $this.ForegroundColor = $ForegroundColor
        $this.BackgroundColor = $BackgroundColor
        $this.Decorations     = $Decorations
        $this.Coordinates     = $Coordinates
    }

    [String]ToAnsiControlSequenceString() {
        Return "$($this.Coordinates.ToAnsiControlSequenceString())$($this.Decorations.ToAnsiControlSequenceString())$($this.ForegroundColor.ToAnsiControlSequenceString())$($this.BackgroundColor.ToAnsiControlSequenceString())"
    }
}

Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATString {
    [ValidateNotNullOrEmpty()][ATStringPrefix]$Prefix
    [ValidateNotNull()][String]$UserData
    [ValidateNotNullOrEmpty()][Boolean]$UseATReset

    ATString() {
        $this.Prefix     = [ATStringPrefixNone]::new()
        $this.UserData   = ''
        $this.UseATReset = $false
    }

    ATString(
        [ATStringPrefix]$Prefix,
        [String]$UserData,
        [Boolean]$UseATReset
    ) {
        $this.Prefix     = $Prefix
        $this.UserData   = $UserData
        $this.UseATReset = $UseATReset
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = "$($this.Prefix.ToAnsiControlSequenceString())$($this.UserData)"

        If($this.UseATReset) {
            $a += [ATControlSequences]::ModifierReset
        }

        Return $a
    }
}

Class ATStringNone : ATString {
    ATStringNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATSceneImageString : ATString {
    Static [String]$SceneImageBlank = ' '

    ATSceneImageString(
        [ATBackgroundColor24]$BackgroundColor,
        [ATCoordinates]$Coordinates
    ): base() {
        $this.Prefix = [ATStringPrefix]::new(
            [ATForegroundColor24None]::new(),
            $BackgroundColor,
            [ATDecorationNone]::new(),
            $Coordinates
        )
        $this.UserData   = [ATSceneImageString]::SceneImageBlank
        $this.UseATReset = $true
    }
}

<#
HASHTABLE CREATOR

[BattleEntityProperty]@{
    Base                = ?
    BasePre             = 0
    BaseAugmentValue    = 0
    Max                 = ?
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
#>
Class BattleEntityProperty {
    Static [Single]$StatNumThresholdCaution         = 0.6D
    Static [Single]$StatNumThresholdDanger          = 0.2D
    Static [ConsoleColor24]$StatNumDrawColorSafe    = [CCAppleGreenLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorCaution = [CCAppleYellowLight24]::new()
    Static [ConsoleColor24]$StatNumDrawColorDanger  = [CCAppleRedLight24]::new()

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
                $this.Max    = $this.MaxPre
                $this.MaxPre = 0
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

        [Int]$t    = $this.Base - $DecAmt
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

<#
HASHTABLE CREATOR

[BattleAction]@{
    Name   = ?
    Type   = ?
    Effect = ?
}
#>
Class BattleAction {
    [String]$Name
    [ScriptBlock]$Effect
    [BattleActionType]$Type

    BattleAction() {
        $this.Name   = ''
        $this.Type   = [BattleActionType]::None
        $this.Effect = $null
    }

    BattleAction(
        [String]$Name,
        [BattleActionType]$Type,
        [ScriptBlock]$Effect
    ) {
        $this.Name   = $Name
        $this.Type   = $Type
        $this.Effect = $Effect
    }
}

<#
HASHTABLE CREATOR

[BattleEntity]@{
    Name            = ?
    Stats           = @{
        [StatId]::HitPoints    = [BattleEntityProperty]@{}
        [StatId]::MagicPoints  = [BattleEntityProperty]@{}
        [StatId]::Attack       = [BattleEntityProperty]@{}
        [StatId]::Defense      = [BattleEntityProperty]@{}
        [StatId]::MagicAttack  = [BattleEntityProperty]@{}
        [StatId]::MagicDefense = [BattleEntityProperty]@{}
        [StatId]::Speed        = [BattleEntityProperty]@{}
        [StatId]::Luck         = [BattleEntityProperty]@{}
        [StatId]::Accuracy     = [BattleEntityProperty]@{}
    }
    SpoilsEffect    = {}
    ActionListing   = $null
    ActionMarbleBag = $null
}

FULL HASHTABLE CREATOR
[BattleEntity]@{
    Name = 'Steve'
    Stats = @{
        [StatId]::HitPoints = [BattleEntityProperty]@{
            Base                = 200
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 200
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
            Base                = 15
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 15
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
            Base                = 8
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 8
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
    ActionListing = @{
        [ActionSlot]::A = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::B = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::C = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::D = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
    }
    SpoilsEffect = {}
    ActionMarbleBag = [System.Collections.Generic.List[[ActionSlot]]]::new()
}
#>

<#
Name            - The user-friendly name of the entity. This will be used for display in the various game windows.
Stats           - A Hashtable of the format [StatId], [BattleEntityProperty]. This pairs a BattleEntityProperty with a StatId.
ActionListing   - A Hashtable of the format [ActionSlot], [BattleAction]. This pairs a BattleAction with an ActionSlot.
SpoilsEffect    - A ScriptBlock that's run when the BattleEntity loses a combat sequence. This is meant to apply to Enemies.
ActionMarbleBag - A List of fixed size (10) that helps determine the chance of an Action from the ActionListing being selected by the AI.
NameDrawColor   - The foreground color to use while drawing the Name property to a window.
#>
Class BattleEntity {
    [String]$Name
    [Hashtable]$Stats
    [Hashtable]$ActionListing
    [ScriptBlock]$SpoilsEffect
    [List[ActionSlot]]$ActionMarbleBag
    [ConsoleColor24]$NameDrawColor

    BattleEntity() {
        $this.Name            = ''
        $this.Stats           = @{}
        $this.ActionListing   = @{}
        $this.SpoilsEffect    = $null
        $this.ActionMarbleBag = $null
        $this.NameDrawColor   = [CCAppleBlueLight24]::new()
    }

    BattleEntity(
        [String]$Name,
        [Hashtable]$Stats,
        [Hashtable]$ActionListing,
        [ScriptBlock]$SpoilsEffect,
        [List[ActionSlot]]$ActionMarbleBag,
        [ConsoleColor24]$NameDrawColor
    ) {
        $this.Name            = $Name
        $this.Stats           = $Stats
        $this.ActionListing   = $ActionListing
        $this.SpoilsEffect    = $SpoilsEffect
        $this.ActionMarbleBag = $ActionMarbleBag
        $this.NameDrawColor   = $NameDrawColor
    }

    [Void]Update() {
        Foreach($a in $this.Stats.Values) {
            $a.Update()
        }
    }
}

<#
HASHTABLE CREATOR

[Player]@{
    Name = 'Steve'
    Stats = @{
        [StatId]::HitPoints = [BattleEntityProperty]@{
            Base                = 200
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 200
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
            Base                = 15
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 15
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
            Base                = 8
            BasePre             = 0
            BaseAugmentValue    = 0
            Max                 = 8
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
    ActionListing = @{
        [ActionSlot]::A = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::B = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::C = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
        [ActionSlot]::D = [BattleAction]@{
            Name   = ''
            Type   = [BattleActionType]::None
            Effect = {}
        }
    }
    SpoilsEffect    = {}
    ActionMarbleBag = [System.Collections.Generic.List[[ActionSlot]]]::new()
    CurrentGold     = 500
    MapCoordinates  = [ATCoordinates]::new(0, 0)
    Inventory       = [List[MapTileObject]]::new()
    TargetOfFilter  = [List[String]]::new(@('MTOMilk'))
}
#>
Class Player : BattleEntity {
    Static [ConsoleColor24]$AsideColor = [CCAppleIndigoLight24]::new()
    Static [ConsoleColor24]$GoldDrawColor = [CCAppleYellowLight24]::new()

    [Int]$CurrentGold
    [ATCoordinates]$MapCoordinates
    [List[MapTileObject]]$Inventory
    [List[String]]$TargetOfFilter

    Player(): base() {
        $this.CurrentGold    = 0
        $this.MapCoordinates = [ATCoordinates]::new(0, 0)
        $this.Inventory      = [List[MapTileObject]]::new()
        $this.TargetOfFilter = [List[String]]::new()
    }

    Player(
        [Int]$CurrentGold,
        [ATCoordinates]$MapCoordinates,
        [List[MapTileObject]]$Inventory,
        [String[]]$TargetOfFilter
    ): base() {
        $this.CurrentGold    = $CurrentGold
        $this.MapCoordinates = $MapCoordinates
        $this.Inventory      = $Inventory
        $this.TargetOfFilter = [List[String]]::new()

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
    ): base() {
        $this.Name        = $Name
        $this.CurrentGold = $Gold

        $this.Stats[[StatId]::HitPoints].Base   = $BaseHp
        $this.Stats[[StatId]::HitPoints].Max    = $MaxHp
        $this.Stats[[StatId]::MagicPoints].Base = $BaseMp
        $this.Stats[[StatId]::MagicPoints].Max  = $MaxMp

        $this.MapCoordinates = [ATCoordinates]::new(0, 0)
        $this.Inventory      = [List[MapTileObject]]::new()
        $this.TargetOfFilter = [List[String]]::new()

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

    # [Boolean]RemoveInventoryItemByName(
    #     [String]$ItemName
    # ) {
    #     $c = 0

    #     Foreach($a in $this.Inventory) {
    #         If($a.Name -IEQ $ItemName) {
    #             $this.Inventory.RemoveAt($c)
    #             Return $true
    #         }
    #         $c++
    #     }

    #     Return $false
    # }

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

# Class Player {
#     [String]$Name
#     [Int]$CurrentHitPoints
#     [Int]$MaxHitPoints
#     [Int]$CurrentMagicPoints
#     [Int]$MaxMagicPoints
#     [Int]$CurrentGold
#     [Int]$MaxGold
#     [StatNumberState]$HitPointsState
#     [StatNumberState]$MagicPointsState
#     [ATCoordinates]$MapCoordinates
#     [List[MapTileObject]]$Inventory
#     [List[String]]$TargetOfFilter

#     Static [Single]$StatNumThresholdCaution         = 0.6D
#     Static [Single]$StatNumThresholdDanger          = 0.2D
#     Static [ConsoleColor24]$StatNameDrawColor       = [CCAppleBlueLight24]::new()
#     Static [ConsoleColor24]$StatNumDrawColorSafe    = [CCAppleGreenLight24]::new()
#     Static [ConsoleColor24]$StatNumDrawColorCaution = [CCAppleYellowLight24]::new()
#     Static [ConsoleColor24]$StatNumDrawColorDanger  = [CCAppleRedLight24]::new()
#     Static [ConsoleColor24]$StatGoldDrawColor       = [CCAppleYellowDark24]::new()
#     Static [ConsoleColor24]$AsideDrawColor          = [CCAppleIndigoLight24]::new()

#     Player(
#         [String]$Name,
#         [Int]$CurrentHitPoints,
#         [Int]$MaxHitPoints,
#         [Int]$CurrentMagicPoints,
#         [Int]$MaxMagicPoints,
#         [Int]$CurrentGold,
#         [Int]$MaxGold
#     ) {
#         $this.Name               = $Name
#         $this.CurrentHitPoints   = $CurrentHitPoints
#         $this.MaxHitPoints       = $MaxHitPoints
#         $this.CurrentMagicPoints = $CurrentMagicPoints
#         $this.MaxMagicPoints     = $MaxMagicPoints
#         $this.CurrentGold        = $CurrentGold
#         $this.MaxGold            = $MaxGold
#         $this.HitPointsState     = [StatNumberState]::Normal
#         $this.MagicPointsState   = [StatNumberState]::Normal
#         $this.MapCoordinates     = [ATCoordinates]::new(0, 0)
#         $this.Inventory          = [List[MapTileObject]]::new()
#         $this.TargetOfFilter     = [List[String]]::new()
#     }

#     Player(
#         [String]$Name,
#         [Int]$CurrentHitPoints,
#         [Int]$MaxHitPoints,
#         [Int]$CurrentMagicPoints,
#         [Int]$MaxMagicPoints,
#         [Int]$CurrentGold,
#         [Int]$MaxGold,
#         [String[]]$TargetOfFilter
#     ) {
#         $this.Name               = $Name
#         $this.CurrentHitPoints   = $CurrentHitPoints
#         $this.MaxHitPoints       = $MaxHitPoints
#         $this.CurrentMagicPoints = $CurrentMagicPoints
#         $this.MaxMagicPoints     = $MaxMagicPoints
#         $this.CurrentGold        = $CurrentGold
#         $this.MaxGold            = $MaxGold
#         $this.HitPointsState     = [StatNumberState]::Normal
#         $this.MagicPointsState   = [StatNumberState]::Normal
#         $this.MapCoordinates     = [ATCoordinates]::new(0, 0)
#         $this.Inventory          = [List[MapTileObject]]::new()
#         $this.TargetOfFilter     = [List[String]]::new()

#         Foreach($a in $TargetOfFilter) {
#             $this.TargetOfFilter.Add($a) | Out-Null
#         }
#     }

#     [String]GetFormattedNameString([ATCoordinates]$Coordinates) {
#         [ATString]$p1 = [ATString]::new(
#             [ATStringPrefix]::new(
#                 [Player]::StatNameDrawColor,
#                 [ATBackgroundColor24None]::new(),
#                 [ATDecorationNone]::new(),
#                 $Coordinates
#             ),
#             $this.Name,
#             $true
#         )

#         Return "$($p1.ToAnsiControlSequenceString())"
#     }

#     [String]GetFormattedHitPointsString([ATCoordinates]$Coordinates) {
#         [String]$a = ''

#         $this.TestCurrentHpState()

#         Switch($this.HitPointsState) {
#             Normal {
#                 [ATString]$p1 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         $Coordinates
#                     ),
#                     'H ',
#                     $false
#                 )
#                 [ATString]$p2 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorSafe,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.CurrentHitPoints) `n`t",
#                     $false
#                 )
#                 [ATString]$p3 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     '/ ',
#                     $false
#                 )
#                 [ATString]$p4 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorSafe,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.MaxHitPoints)",
#                     $true
#                 )

#                 $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
#             }

#             Caution {
#                 [ATString]$p1 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         $Coordinates
#                     ),
#                     'H ',
#                     $false
#                 )
#                 [ATString]$p2 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorCaution,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.CurrentHitPoints) `n`t",
#                     $false
#                 )
#                 [ATString]$p3 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     '/ ',
#                     $false
#                 )
#                 [ATString]$p4 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorCaution,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.MaxHitPoints)",
#                     $true
#                 )

#                 $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
#             }

#             Danger {
#                 [ATString]$p1 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         $Coordinates
#                     ),
#                     'H ',
#                     $false
#                 )
#                 [ATString]$p2 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorDanger,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecoration]::new($true),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.CurrentHitPoints) `n`t",
#                     $false
#                 )
#                 [ATString]$p3 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     '/ ',
#                     $false
#                 )
#                 [ATString]$p4 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorDanger,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecoration]::new($true),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.MaxHitPoints)",
#                     $true
#                 )

#                 $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
#             }

#             Default {}
#         }

#         Return $a
#     }

#     [String]GetFormattedMagicPointsString([ATCoordinates]$Coordinates) {
#         [String]$a = ''

#         $this.TestCurrentMpState()

#         Switch($this.MagicPointsState) {
#             Normal {
#                 [ATString]$p1 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         $Coordinates
#                     ),
#                     'M ',
#                     $false
#                 )
#                 [ATString]$p2 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorSafe,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.CurrentMagicPoints) `n`t",
#                     $false
#                 )
#                 [ATString]$p3 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     '/ ',
#                     $false
#                 )
#                 [ATString]$p4 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorSafe,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.MaxMagicPoints)",
#                     $true
#                 )

#                 $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
#             }

#             Caution {
#                 [ATString]$p1 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         $Coordinates
#                     ),
#                     'M ',
#                     $false
#                 )
#                 [ATString]$p2 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorCaution,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.CurrentMagicPoints) `n`t",
#                     $false
#                 )
#                 [ATString]$p3 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     '/ ',
#                     $false
#                 )
#                 [ATString]$p4 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorCaution,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.MaxMagicPoints)",
#                     $true
#                 )

#                 $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
#             }

#             Danger {
#                 [ATString]$p1 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         $Coordinates
#                     ),
#                     'M ',
#                     $false
#                 )
#                 [ATString]$p2 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorDanger,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecoration]::new($true),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.CurrentMagicPoints) `n`t",
#                     $false
#                 )
#                 [ATString]$p3 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [CCTextDefault24]::new(),
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecorationNone]::new(),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     '/ ',
#                     $false
#                 )
#                 [ATString]$p4 = [ATString]::new(
#                     [ATStringPrefix]::new(
#                         [Player]::StatNumDrawColorDanger,
#                         [ATBackgroundColor24None]::new(),
#                         [ATDecoration]::new($true),
#                         [ATCoordinatesNone]::new()
#                     ),
#                     "$($this.MaxMagicPoints)",
#                     $true
#                 )

#                 $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
#             }

#             Default {}
#         }

#         Return $a
#     }

#     [String]GetFormattedGoldString([ATCoordinates]$Coordinates) {
#         [ATString]$p1 = [ATString]::new(
#             [ATStringPrefix]::new(
#                 [Player]::StatGoldDrawColor,
#                 [ATBackgroundColor24None]::new(),
#                 [ATDecorationNone]::new(),
#                 $Coordinates
#             ),
#             "$($this.CurrentGold)",
#             $false
#         )
#         [ATString]$p2 = [ATString]::new(
#             [ATStringPrefix]::new(
#                 [CCTextDefault24]::new(),
#                 [ATBackgroundColor24None]::new(),
#                 [ATDecorationNone]::new(),
#                 [ATCoordinatesNone]::new()
#             ),
#             'G',
#             $true
#         )

#         Return "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())"
#     }

#     [Void]TestCurrentHpState() {
#         Switch($this.CurrentHitPoints) {
#             { $_ -GT ($this.MaxHitPoints * [Player]::StatNumThresholdCaution) } {
#                 $this.HitPointsState = [StatNumberState]::Normal
#             }

#             { ($_ -GT ($this.MaxHitPoints * [Player]::StatNumThresholdDanger)) -AND ($_ -LT ($this.MaxHitPoints * [Player]::StatNumThresholdCaution)) } {
#                 $this.HitPointsState = [StatNumberState]::Caution
#             }

#             { $_ -LT ($this.MaxHitPoints * [Player]::StatNumThresholdDanger) } {
#                 $this.HitPointsState = [StatNumberState]::Danger
#             }

#             Default {}
#         }
#     }

#     [Void]TestCurrentMpState() {
#         Switch($this.CurrentMagicPoints) {
#             { $_ -GT ($this.MaxMagicPoints * [Player]::StatNumThresholdCaution) } {
#                 $this.MagicPointsState = [StatNumberState]::Normal
#             }

#             { ($_ -GT ($this.MaxMagicPoints * [Player]::StatNumThresholdDanger)) -AND ($_ -LT ($this.MaxMagicPoints * [Player]::StatNumThresholdCaution)) } {
#                 $this.MagicPointsState = [StatNumberState]::Caution
#             }

#             { $_ -LT ($this.MaxMagicPoints * [Player]::StatNumThresholdDanger) } {
#                 $this.MagicPointsState = [StatNumberState]::Danger
#             }

#             Default {}
#         }
#     }

#     [Boolean]IsItemInInventory(
#         [String]$ItemName
#     ) {
#         Foreach($a in $this.Inventory) {
#             If($a.Name -IEQ $ItemName) {
#                 Return $true
#             }
#         }

#         Return $false
#     }

#     [MapTileObject]GetItemReference(
#         [String]$ItemName
#     ) {
#         Foreach($a in $this.Inventory) {
#             If($a.Name -IEQ $ItemName) {
#                 Return $a
#             }
#         }

#         Return $null
#     }

#     # [Boolean]RemoveInventoryItemByName(
#     #     [String]$ItemName
#     # ) {
#     #     $c = 0

#     #     Foreach($a in $this.Inventory) {
#     #         If($a.Name -IEQ $ItemName) {
#     #             $this.Inventory.RemoveAt($c)
#     #             Return $true
#     #         }
#     #         $c++
#     #     }

#     #     Return $false
#     # }

#     [ItemRemovalStatus]RemoveInventoryItemByName(
#         [String]$ItemName
#     ) {
#         $c = 0

#         Foreach($a in $this.Inventory) {
#             If($a.Name -IEQ $ItemName) {
#                 If($a.KeyItem -EQ $true) {
#                     Return [ItemRemovalStatus]::FailKeyItem
#                 }
#                 $this.Inventory.RemoveAt($c)
#                 Return [ItemRemovalStatus]::Success
#             }
#             $c++
#         }

#         Return [ItemRemovalStatus]::FailGeneral
#     }

#     [ItemRemovalStatus]RemoveInventoryItemByIndex(
#         [Int]$Index
#     ) {
#         [MapTileObject]$a = $null

#         Try {
#             $a = $this.Inventory[$Index]
#         } Catch {
#             Return [ItemRemovalStatus]::FailGeneral
#         }

#         If($a.KeyItem -EQ $true) {
#             Return [ItemRemovalStatus]::FailKeyItem
#         }

#         $this.Inventory.RemoveAt($Index)
#         Return [ItemRemovalStatus]::Success
#     }

#     [Void]MapMoveNorth() {
#         If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
#             If($Script:CurrentMap.BoundaryWrap -EQ $true) {
#                 $a = $Script:CurrentMap.MapHeight - 1
#                 $b = $this.MapCoordinates.Row + 1
#                 $c = $a % $b

#                 If($c -EQ $a) {
#                     $this.MapCoordinates.Row = 0
#                 } Else {
#                     $this.MapCoordinates.Row++
#                 }

#                 $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                 $Script:TheCommandWindow.UpdateCommandHistory($true)
#                 Return
#             } Else {
#                 $a = $Script:CurrentMap.MapHeight - 1
#                 $b = $this.MapCoordinates.Row + 1
#                 $c = $a % $b

#                 If($c -EQ $a) {
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)
#                     $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
#                 } Else {
#                     $this.MapCoordinates.Row++
#                     $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)

#                     Return
#                 }
#             }
#         } Else {
#             $Script:TheCommandWindow.UpdateCommandHistory($true)
#             $Script:TheMessageWindow.WriteYouShallNotPassMessage()
#             Return
#         }
#     }

#     [Void]MapMoveSouth() {
#         If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitSouth] -EQ $true) {
#             If($Script:CurrentMap.BoundaryWrap -EQ $true) {
#                 $a = 0
#                 $b = $this.MapCoordinates.Row - 1

#                 If($b -LT $a) {
#                     $this.MapCoordinates.Row = $Script:CurrentMap.MapHeight - 1
#                 } Else {
#                     $this.MapCoordinates.Row--
#                 }

#                 $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                 $Script:TheCommandWindow.UpdateCommandHistory($true)
#                 Return
#             } Else {
#                 $a = 0
#                 $b = $this.MapCoordinates.Row - 1

#                 If($b -LT $a) {
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)
#                     $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
#                 } Else {
#                     $this.MapCoordinates.Row--
#                     $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)

#                     Return
#                 }
#             }
#         } Else {
#             $Script:TheCommandWindow.UpdateCommandHistory($true)
#             $Script:TheMessageWindow.WriteYouShallNotPassMessage()
#             Return
#         }
#     }

#     [Void]MapMoveEast() {
#         If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitEast] -EQ $true) {
#             If($Script:CurrentMap.BoundaryWrap -EQ $true) {
#                 $a = $Script:CurrentMap.MapWidth - 1
#                 $b = $this.MapCoordinates.Column + 1
#                 $c = $a % $b

#                 If($c -EQ $a) {
#                     $this.MapCoordinates.Column = 0
#                 } Else {
#                     $this.MapCoordinates.Column++
#                 }

#                 $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                 $Script:TheCommandWindow.UpdateCommandHistory($true)
#                 Return
#             } Else {
#                 $a = $Script:CurrentMap.MapWidth - 1
#                 $b = $this.MapCoordinates.Column + 1
#                 $c = $a % $b

#                 If($c -EQ $a) {
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)
#                     $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
#                 } Else {
#                     $this.MapCoordinates.Column++
#                     $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)

#                     Return
#                 }
#             }
#         } Else {
#             $Script:TheCommandWindow.UpdateCommandHistory($true)
#             $Script:TheMessageWindow.WriteYouShallNotPassMessage()
#             Return
#         }
#     }

#     [Void]MapMoveWest() {
#         If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitWest] -EQ $true) {
#             If($Script:CurrentMap.BoundaryWrap -EQ $true) {
#                 $a = 0
#                 $b = $this.MapCoordinates.Column - 1

#                 If($b -LT $a) {
#                     $this.MapCoordinates.Column = $Script:CurrentMap.MapWidth - 1
#                 } Else {
#                     $this.MapCoordinates.Column--
#                 }

#                 $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                 $Script:TheCommandWindow.UpdateCommandHistory($true)
#                 Return
#             } Else {
#                 $a = 0
#                 $b = $this.MapCoordinates.Column - 1

#                 If($b -LT $a) {
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)
#                     $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
#                 } Else {
#                     $this.MapCoordinates.Column--
#                     $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
#                     $Script:TheCommandWindow.UpdateCommandHistory($true)

#                     Return
#                 }
#             }
#         } Else {
#             $Script:TheCommandWindow.UpdateCommandHistory($true)
#             $Script:TheMessageWindow.WriteYouShallNotPassMessage()
#             Return
#         }
#     }

#     [Boolean]ValidateSourceInFilter(
#         [String]$SourceItemClass
#     ) {
#         Return ($SourceItemClass -IN $this.TargetOfFilter)
#     }

#     [Boolean]IncrementHitPoints(
#         [Int]$IncAmt
#     ) {
#         # Check to see if the Current Hit Points are EQUAL TO the Max Hit Points
#         If($this.CurrentHitPoints -EQ $this.MaxHitPoints) {
#             Return $false
#         }

#         # Ensure that IncAmt is GREATER THAN zero; the clamping function below relies on it
#         If($IncAmt -LE 0) {
#             Return $false
#         }

#         # It can safely be assumed that the Player's Current Hit Points are LESS THAN the Max Hit Points; add the IncAmt, but clamp at max
#         $a                     = $this.CurrentHitPoints += $IncAmt
#         $a                     = [Math]::Clamp($a, 0, $this.MaxHitPoints)
#         $this.CurrentHitPoints = $a

#         # Notify the Status Window that the Player's Hit Point information is dirty
#         $Script:TheStatusWindow.PlayerHpDrawDirty = $true

#         Return $true
#     }

#     [Boolean]DecrementHitPoints(
#         [Int]$DecAmt
#     ) {
#         # Check to see if Current Hit Points are EQUAL TO zero
#         If($this.CurrentHitPoints -EQ 0) {
#             Return $false
#         }

#         # Ensure that DecAmt is LESS THAN zero; the clamping function below relies on it
#         If($DecAmt -GE 0) {
#             Return $false
#         }

#         # It can be safely assumed that the Player's Current Hit Points are GREATER THAN zero; add the DecAmt, but clamp at zero
#         $a                     = $this.CurrentHitPoints += $DecAmt
#         $a                     = [Math]::Clamp($a, 0, $this.MaxHitPoints)
#         $this.CurrentHitPoints = $a

#         # Notify the Status Window that the Player's Hit Point information is dirty
#         $Script:TheStatusWindow.PlayerHpDrawDirty = $true

#         Return $true
#     }
# }

Class SceneImage {
    Static [Int]$Width  = 48
    Static [Int]$Height = 18

    [ATSceneImageString[,]]$Image

    SceneImage() {
        $this.Image = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
    }

    SceneImage(
        [ATSceneImageString[,]]$Image
    ) {
        $this.Image = $Image
    }

    [Void]CreateSceneImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $rf                 = ($r * [SceneImage]::Width) + $c
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new(([SceneWindow]::ImageDrawRowOffset + $r), ([SceneWindow]::ImageDrawColumnOffset + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}

Class SIEmpty : SceneImage {
    SIEmpty(): base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class SIInternalBase : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIInternalBase(): base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
    }
}

Class SIRandomNoise : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIRandomNoise(): base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

        For($a = 0; $a -LT $this.ColorMap.Count; $a++) {
            $this.ColorMap[$a] = [CCRandom24]::new()
        }

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthEastRoad : SIInternalBase {
    SIFieldNorthEastRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthEastRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleBrownLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthWestRoad : SIInternalBase {
    SIFieldNorthWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthWestRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldNorthEastWestRoad : SIInternalBase {
    SIFieldNorthEastWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldNorthEastWestRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleBrownLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleBrownLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleBrownLight24]::new()
        $this.ColorMap[360] = [CCAppleBrownLight24]::new()
        $this.ColorMap[361] = [CCAppleBrownLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleBrownLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthRoad : SIInternalBase {
    SIFieldSouthRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthEastRoad : SIInternalBase {
    SIFieldSouthEastRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthEastRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleGreenLight24]::new()
        $this.ColorMap[769] = [CCAppleGreenLight24]::new()
        $this.ColorMap[770] = [CCAppleGreenLight24]::new()
        $this.ColorMap[771] = [CCAppleGreenLight24]::new()
        $this.ColorMap[772] = [CCAppleGreenLight24]::new()
        $this.ColorMap[773] = [CCAppleGreenLight24]::new()
        $this.ColorMap[774] = [CCAppleGreenLight24]::new()
        $this.ColorMap[775] = [CCAppleGreenLight24]::new()
        $this.ColorMap[776] = [CCAppleGreenLight24]::new()
        $this.ColorMap[777] = [CCAppleGreenLight24]::new()
        $this.ColorMap[778] = [CCAppleGreenLight24]::new()
        $this.ColorMap[779] = [CCAppleGreenLight24]::new()
        $this.ColorMap[780] = [CCAppleGreenLight24]::new()
        $this.ColorMap[781] = [CCAppleGreenLight24]::new()
        $this.ColorMap[782] = [CCAppleGreenLight24]::new()
        $this.ColorMap[783] = [CCAppleGreenLight24]::new()
        $this.ColorMap[784] = [CCAppleGreenLight24]::new()
        $this.ColorMap[785] = [CCAppleGreenLight24]::new()
        $this.ColorMap[786] = [CCAppleGreenLight24]::new()
        $this.ColorMap[787] = [CCAppleGreenLight24]::new()
        $this.ColorMap[788] = [CCAppleGreenLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleGreenLight24]::new()
        $this.ColorMap[817] = [CCAppleGreenLight24]::new()
        $this.ColorMap[818] = [CCAppleGreenLight24]::new()
        $this.ColorMap[819] = [CCAppleGreenLight24]::new()
        $this.ColorMap[820] = [CCAppleGreenLight24]::new()
        $this.ColorMap[821] = [CCAppleGreenLight24]::new()
        $this.ColorMap[822] = [CCAppleGreenLight24]::new()
        $this.ColorMap[823] = [CCAppleGreenLight24]::new()
        $this.ColorMap[824] = [CCAppleGreenLight24]::new()
        $this.ColorMap[825] = [CCAppleGreenLight24]::new()
        $this.ColorMap[826] = [CCAppleGreenLight24]::new()
        $this.ColorMap[827] = [CCAppleGreenLight24]::new()
        $this.ColorMap[828] = [CCAppleGreenLight24]::new()
        $this.ColorMap[829] = [CCAppleGreenLight24]::new()
        $this.ColorMap[830] = [CCAppleGreenLight24]::new()
        $this.ColorMap[831] = [CCAppleGreenLight24]::new()
        $this.ColorMap[832] = [CCAppleGreenLight24]::new()
        $this.ColorMap[833] = [CCAppleGreenLight24]::new()
        $this.ColorMap[834] = [CCAppleGreenLight24]::new()
        $this.ColorMap[835] = [CCAppleGreenLight24]::new()
        $this.ColorMap[836] = [CCAppleGreenLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthWestRoad : SIInternalBase {
    SIFieldSouthWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthWestRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleGreenLight24]::new()
        $this.ColorMap[797] = [CCAppleGreenLight24]::new()
        $this.ColorMap[798] = [CCAppleGreenLight24]::new()
        $this.ColorMap[799] = [CCAppleGreenLight24]::new()
        $this.ColorMap[800] = [CCAppleGreenLight24]::new()
        $this.ColorMap[801] = [CCAppleGreenLight24]::new()
        $this.ColorMap[802] = [CCAppleGreenLight24]::new()
        $this.ColorMap[803] = [CCAppleGreenLight24]::new()
        $this.ColorMap[804] = [CCAppleGreenLight24]::new()
        $this.ColorMap[805] = [CCAppleGreenLight24]::new()
        $this.ColorMap[806] = [CCAppleGreenLight24]::new()
        $this.ColorMap[807] = [CCAppleGreenLight24]::new()
        $this.ColorMap[808] = [CCAppleGreenLight24]::new()
        $this.ColorMap[809] = [CCAppleGreenLight24]::new()
        $this.ColorMap[810] = [CCAppleGreenLight24]::new()
        $this.ColorMap[811] = [CCAppleGreenLight24]::new()
        $this.ColorMap[812] = [CCAppleGreenLight24]::new()
        $this.ColorMap[813] = [CCAppleGreenLight24]::new()
        $this.ColorMap[814] = [CCAppleGreenLight24]::new()
        $this.ColorMap[815] = [CCAppleGreenLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleGreenLight24]::new()
        $this.ColorMap[845] = [CCAppleGreenLight24]::new()
        $this.ColorMap[846] = [CCAppleGreenLight24]::new()
        $this.ColorMap[847] = [CCAppleGreenLight24]::new()
        $this.ColorMap[848] = [CCAppleGreenLight24]::new()
        $this.ColorMap[849] = [CCAppleGreenLight24]::new()
        $this.ColorMap[850] = [CCAppleGreenLight24]::new()
        $this.ColorMap[851] = [CCAppleGreenLight24]::new()
        $this.ColorMap[852] = [CCAppleGreenLight24]::new()
        $this.ColorMap[853] = [CCAppleGreenLight24]::new()
        $this.ColorMap[854] = [CCAppleGreenLight24]::new()
        $this.ColorMap[855] = [CCAppleGreenLight24]::new()
        $this.ColorMap[856] = [CCAppleGreenLight24]::new()
        $this.ColorMap[857] = [CCAppleGreenLight24]::new()
        $this.ColorMap[858] = [CCAppleGreenLight24]::new()
        $this.ColorMap[859] = [CCAppleGreenLight24]::new()
        $this.ColorMap[860] = [CCAppleGreenLight24]::new()
        $this.ColorMap[861] = [CCAppleGreenLight24]::new()
        $this.ColorMap[862] = [CCAppleGreenLight24]::new()
        $this.ColorMap[863] = [CCAppleGreenLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class SIFieldSouthEastWestRoad : SIInternalBase {
    SIFieldSouthEastWestRoad(): base() {
        Write-Progress -Activity 'Creating Scene Images      ' -Id 3 -Status 'Creating SIFieldSouthEastWestRoad' -PercentComplete -1
        $this.ColorMap[0]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[1]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[2]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[3]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[4]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[5]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[6]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[7]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[8]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[9]   = [CCAppleBlueLight24]::new()
        $this.ColorMap[10]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[11]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[12]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[13]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[14]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[15]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[16]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[17]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[18]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[19]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[20]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[21]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[22]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[23]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[24]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[25]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[26]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[27]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[28]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[29]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[30]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[31]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[32]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[33]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[34]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[35]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[36]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[37]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[38]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[39]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[40]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[41]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[42]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[43]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[44]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[45]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[46]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[47]  = [CCAppleBlueLight24]::new() # End Row 0
        $this.ColorMap[48]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[49]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[50]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[51]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[52]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[53]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[54]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[55]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[56]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[57]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[58]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[59]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[60]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[61]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[62]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[63]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[64]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[65]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[66]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[67]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[68]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[69]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[70]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[71]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[72]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[73]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[74]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[75]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[76]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[77]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[78]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[79]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[80]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[81]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[82]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[83]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[84]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[85]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[86]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[87]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[88]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[89]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[90]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[91]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[92]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[93]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[94]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[95]  = [CCAppleBlueLight24]::new() # End Row 1
        $this.ColorMap[96]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[97]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[98]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[99]  = [CCAppleBlueLight24]::new()
        $this.ColorMap[100] = [CCAppleBlueLight24]::new()
        $this.ColorMap[101] = [CCAppleBlueLight24]::new()
        $this.ColorMap[102] = [CCAppleBlueLight24]::new()
        $this.ColorMap[103] = [CCAppleBlueLight24]::new()
        $this.ColorMap[104] = [CCAppleBlueLight24]::new()
        $this.ColorMap[105] = [CCAppleBlueLight24]::new()
        $this.ColorMap[106] = [CCAppleBlueLight24]::new()
        $this.ColorMap[107] = [CCAppleBlueLight24]::new()
        $this.ColorMap[108] = [CCAppleBlueLight24]::new()
        $this.ColorMap[109] = [CCAppleBlueLight24]::new()
        $this.ColorMap[110] = [CCAppleBlueLight24]::new()
        $this.ColorMap[111] = [CCAppleBlueLight24]::new()
        $this.ColorMap[112] = [CCAppleBlueLight24]::new()
        $this.ColorMap[113] = [CCAppleBlueLight24]::new()
        $this.ColorMap[114] = [CCAppleBlueLight24]::new()
        $this.ColorMap[115] = [CCAppleBlueLight24]::new()
        $this.ColorMap[116] = [CCAppleBlueLight24]::new()
        $this.ColorMap[117] = [CCAppleBlueLight24]::new()
        $this.ColorMap[118] = [CCAppleBlueLight24]::new()
        $this.ColorMap[119] = [CCAppleBlueLight24]::new()
        $this.ColorMap[120] = [CCAppleBlueLight24]::new()
        $this.ColorMap[121] = [CCAppleBlueLight24]::new()
        $this.ColorMap[122] = [CCAppleBlueLight24]::new()
        $this.ColorMap[123] = [CCAppleBlueLight24]::new()
        $this.ColorMap[124] = [CCAppleBlueLight24]::new()
        $this.ColorMap[125] = [CCAppleBlueLight24]::new()
        $this.ColorMap[126] = [CCAppleBlueLight24]::new()
        $this.ColorMap[127] = [CCAppleBlueLight24]::new()
        $this.ColorMap[128] = [CCAppleBlueLight24]::new()
        $this.ColorMap[129] = [CCAppleBlueLight24]::new()
        $this.ColorMap[130] = [CCAppleBlueLight24]::new()
        $this.ColorMap[131] = [CCAppleBlueLight24]::new()
        $this.ColorMap[132] = [CCAppleBlueLight24]::new()
        $this.ColorMap[133] = [CCAppleBlueLight24]::new()
        $this.ColorMap[134] = [CCAppleBlueLight24]::new()
        $this.ColorMap[135] = [CCAppleBlueLight24]::new()
        $this.ColorMap[136] = [CCAppleBlueLight24]::new()
        $this.ColorMap[137] = [CCAppleBlueLight24]::new()
        $this.ColorMap[138] = [CCAppleBlueLight24]::new()
        $this.ColorMap[139] = [CCAppleBlueLight24]::new()
        $this.ColorMap[140] = [CCAppleBlueLight24]::new()
        $this.ColorMap[141] = [CCAppleBlueLight24]::new()
        $this.ColorMap[142] = [CCAppleBlueLight24]::new()
        $this.ColorMap[143] = [CCAppleBlueLight24]::new() # End Row 2
        $this.ColorMap[144] = [CCAppleBlueLight24]::new()
        $this.ColorMap[145] = [CCAppleBlueLight24]::new()
        $this.ColorMap[146] = [CCAppleBlueLight24]::new()
        $this.ColorMap[147] = [CCAppleBlueLight24]::new()
        $this.ColorMap[148] = [CCAppleBlueLight24]::new()
        $this.ColorMap[149] = [CCAppleBlueLight24]::new()
        $this.ColorMap[150] = [CCAppleBlueLight24]::new()
        $this.ColorMap[151] = [CCAppleBlueLight24]::new()
        $this.ColorMap[152] = [CCAppleBlueLight24]::new()
        $this.ColorMap[153] = [CCAppleBlueLight24]::new()
        $this.ColorMap[154] = [CCAppleBlueLight24]::new()
        $this.ColorMap[155] = [CCAppleBlueLight24]::new()
        $this.ColorMap[156] = [CCAppleBlueLight24]::new()
        $this.ColorMap[157] = [CCAppleBlueLight24]::new()
        $this.ColorMap[158] = [CCAppleBlueLight24]::new()
        $this.ColorMap[159] = [CCAppleBlueLight24]::new()
        $this.ColorMap[160] = [CCAppleBlueLight24]::new()
        $this.ColorMap[161] = [CCAppleBlueLight24]::new()
        $this.ColorMap[162] = [CCAppleBlueLight24]::new()
        $this.ColorMap[163] = [CCAppleBlueLight24]::new()
        $this.ColorMap[164] = [CCAppleBlueLight24]::new()
        $this.ColorMap[165] = [CCAppleBlueLight24]::new()
        $this.ColorMap[166] = [CCAppleBlueLight24]::new()
        $this.ColorMap[167] = [CCAppleBlueLight24]::new()
        $this.ColorMap[168] = [CCAppleBlueLight24]::new()
        $this.ColorMap[169] = [CCAppleBlueLight24]::new()
        $this.ColorMap[170] = [CCAppleBlueLight24]::new()
        $this.ColorMap[171] = [CCAppleBlueLight24]::new()
        $this.ColorMap[172] = [CCAppleBlueLight24]::new()
        $this.ColorMap[173] = [CCAppleBlueLight24]::new()
        $this.ColorMap[174] = [CCAppleBlueLight24]::new()
        $this.ColorMap[175] = [CCAppleBlueLight24]::new()
        $this.ColorMap[176] = [CCAppleBlueLight24]::new()
        $this.ColorMap[177] = [CCAppleBlueLight24]::new()
        $this.ColorMap[178] = [CCAppleBlueLight24]::new()
        $this.ColorMap[179] = [CCAppleBlueLight24]::new()
        $this.ColorMap[180] = [CCAppleBlueLight24]::new()
        $this.ColorMap[181] = [CCAppleBlueLight24]::new()
        $this.ColorMap[182] = [CCAppleBlueLight24]::new()
        $this.ColorMap[183] = [CCAppleBlueLight24]::new()
        $this.ColorMap[184] = [CCAppleBlueLight24]::new()
        $this.ColorMap[185] = [CCAppleBlueLight24]::new()
        $this.ColorMap[186] = [CCAppleBlueLight24]::new()
        $this.ColorMap[187] = [CCAppleBlueLight24]::new()
        $this.ColorMap[188] = [CCAppleBlueLight24]::new()
        $this.ColorMap[189] = [CCAppleBlueLight24]::new()
        $this.ColorMap[190] = [CCAppleBlueLight24]::new()
        $this.ColorMap[191] = [CCAppleBlueLight24]::new() # End Row 3
        $this.ColorMap[192] = [CCAppleBlueLight24]::new()
        $this.ColorMap[193] = [CCAppleBlueLight24]::new()
        $this.ColorMap[194] = [CCAppleBlueLight24]::new()
        $this.ColorMap[195] = [CCAppleBlueLight24]::new()
        $this.ColorMap[196] = [CCAppleBlueLight24]::new()
        $this.ColorMap[197] = [CCAppleBlueLight24]::new()
        $this.ColorMap[198] = [CCAppleBlueLight24]::new()
        $this.ColorMap[199] = [CCAppleBlueLight24]::new()
        $this.ColorMap[200] = [CCAppleBlueLight24]::new()
        $this.ColorMap[201] = [CCAppleBlueLight24]::new()
        $this.ColorMap[202] = [CCAppleBlueLight24]::new()
        $this.ColorMap[203] = [CCAppleBlueLight24]::new()
        $this.ColorMap[204] = [CCAppleBlueLight24]::new()
        $this.ColorMap[205] = [CCAppleBlueLight24]::new()
        $this.ColorMap[206] = [CCAppleBlueLight24]::new()
        $this.ColorMap[207] = [CCAppleBlueLight24]::new()
        $this.ColorMap[208] = [CCAppleBlueLight24]::new()
        $this.ColorMap[209] = [CCAppleBlueLight24]::new()
        $this.ColorMap[210] = [CCAppleBlueLight24]::new()
        $this.ColorMap[211] = [CCAppleBlueLight24]::new()
        $this.ColorMap[212] = [CCAppleBlueLight24]::new()
        $this.ColorMap[213] = [CCAppleBlueLight24]::new()
        $this.ColorMap[214] = [CCAppleBlueLight24]::new()
        $this.ColorMap[215] = [CCAppleBlueLight24]::new()
        $this.ColorMap[216] = [CCAppleBlueLight24]::new()
        $this.ColorMap[217] = [CCAppleBlueLight24]::new()
        $this.ColorMap[218] = [CCAppleBlueLight24]::new()
        $this.ColorMap[219] = [CCAppleBlueLight24]::new()
        $this.ColorMap[220] = [CCAppleBlueLight24]::new()
        $this.ColorMap[221] = [CCAppleBlueLight24]::new()
        $this.ColorMap[222] = [CCAppleBlueLight24]::new()
        $this.ColorMap[223] = [CCAppleBlueLight24]::new()
        $this.ColorMap[224] = [CCAppleBlueLight24]::new()
        $this.ColorMap[225] = [CCAppleBlueLight24]::new()
        $this.ColorMap[226] = [CCAppleBlueLight24]::new()
        $this.ColorMap[227] = [CCAppleBlueLight24]::new()
        $this.ColorMap[228] = [CCAppleBlueLight24]::new()
        $this.ColorMap[229] = [CCAppleBlueLight24]::new()
        $this.ColorMap[230] = [CCAppleBlueLight24]::new()
        $this.ColorMap[231] = [CCAppleBlueLight24]::new()
        $this.ColorMap[232] = [CCAppleBlueLight24]::new()
        $this.ColorMap[233] = [CCAppleBlueLight24]::new()
        $this.ColorMap[234] = [CCAppleBlueLight24]::new()
        $this.ColorMap[235] = [CCAppleBlueLight24]::new()
        $this.ColorMap[236] = [CCAppleBlueLight24]::new()
        $this.ColorMap[237] = [CCAppleBlueLight24]::new()
        $this.ColorMap[238] = [CCAppleBlueLight24]::new()
        $this.ColorMap[239] = [CCAppleBlueLight24]::new() # End Row 4
        $this.ColorMap[240] = [CCAppleGreenLight24]::new()
        $this.ColorMap[241] = [CCAppleGreenLight24]::new()
        $this.ColorMap[242] = [CCAppleGreenLight24]::new()
        $this.ColorMap[243] = [CCAppleGreenLight24]::new()
        $this.ColorMap[244] = [CCAppleGreenLight24]::new()
        $this.ColorMap[245] = [CCAppleGreenLight24]::new()
        $this.ColorMap[246] = [CCAppleGreenLight24]::new()
        $this.ColorMap[247] = [CCAppleGreenLight24]::new()
        $this.ColorMap[248] = [CCAppleGreenLight24]::new()
        $this.ColorMap[249] = [CCAppleGreenLight24]::new()
        $this.ColorMap[250] = [CCAppleGreenLight24]::new()
        $this.ColorMap[251] = [CCAppleGreenLight24]::new()
        $this.ColorMap[252] = [CCAppleGreenLight24]::new()
        $this.ColorMap[253] = [CCAppleGreenLight24]::new()
        $this.ColorMap[254] = [CCAppleGreenLight24]::new()
        $this.ColorMap[255] = [CCAppleGreenLight24]::new()
        $this.ColorMap[256] = [CCAppleGreenLight24]::new()
        $this.ColorMap[257] = [CCAppleGreenLight24]::new()
        $this.ColorMap[258] = [CCAppleGreenLight24]::new()
        $this.ColorMap[259] = [CCAppleGreenLight24]::new()
        $this.ColorMap[260] = [CCAppleGreenLight24]::new()
        $this.ColorMap[261] = [CCAppleGreenLight24]::new()
        $this.ColorMap[262] = [CCAppleGreenLight24]::new()
        $this.ColorMap[263] = [CCAppleGreenLight24]::new()
        $this.ColorMap[264] = [CCAppleGreenLight24]::new()
        $this.ColorMap[265] = [CCAppleGreenLight24]::new()
        $this.ColorMap[266] = [CCAppleGreenLight24]::new()
        $this.ColorMap[267] = [CCAppleGreenLight24]::new()
        $this.ColorMap[268] = [CCAppleGreenLight24]::new()
        $this.ColorMap[269] = [CCAppleGreenLight24]::new()
        $this.ColorMap[270] = [CCAppleGreenLight24]::new()
        $this.ColorMap[271] = [CCAppleGreenLight24]::new()
        $this.ColorMap[272] = [CCAppleGreenLight24]::new()
        $this.ColorMap[273] = [CCAppleGreenLight24]::new()
        $this.ColorMap[274] = [CCAppleGreenLight24]::new()
        $this.ColorMap[275] = [CCAppleGreenLight24]::new()
        $this.ColorMap[276] = [CCAppleGreenLight24]::new()
        $this.ColorMap[277] = [CCAppleGreenLight24]::new()
        $this.ColorMap[278] = [CCAppleGreenLight24]::new()
        $this.ColorMap[279] = [CCAppleGreenLight24]::new()
        $this.ColorMap[280] = [CCAppleGreenLight24]::new()
        $this.ColorMap[281] = [CCAppleGreenLight24]::new()
        $this.ColorMap[282] = [CCAppleGreenLight24]::new()
        $this.ColorMap[283] = [CCAppleGreenLight24]::new()
        $this.ColorMap[284] = [CCAppleGreenLight24]::new()
        $this.ColorMap[285] = [CCAppleGreenLight24]::new()
        $this.ColorMap[286] = [CCAppleGreenLight24]::new()
        $this.ColorMap[287] = [CCAppleGreenLight24]::new() # End Row 5
        $this.ColorMap[288] = [CCAppleGreenLight24]::new()
        $this.ColorMap[289] = [CCAppleGreenLight24]::new()
        $this.ColorMap[290] = [CCAppleGreenLight24]::new()
        $this.ColorMap[291] = [CCAppleGreenLight24]::new()
        $this.ColorMap[292] = [CCAppleGreenLight24]::new()
        $this.ColorMap[293] = [CCAppleGreenLight24]::new()
        $this.ColorMap[294] = [CCAppleGreenLight24]::new()
        $this.ColorMap[295] = [CCAppleGreenLight24]::new()
        $this.ColorMap[296] = [CCAppleGreenLight24]::new()
        $this.ColorMap[297] = [CCAppleGreenLight24]::new()
        $this.ColorMap[298] = [CCAppleGreenLight24]::new()
        $this.ColorMap[299] = [CCAppleGreenLight24]::new()
        $this.ColorMap[300] = [CCAppleGreenLight24]::new()
        $this.ColorMap[301] = [CCAppleGreenLight24]::new()
        $this.ColorMap[302] = [CCAppleGreenLight24]::new()
        $this.ColorMap[303] = [CCAppleGreenLight24]::new()
        $this.ColorMap[304] = [CCAppleGreenLight24]::new()
        $this.ColorMap[305] = [CCAppleGreenLight24]::new()
        $this.ColorMap[306] = [CCAppleGreenLight24]::new()
        $this.ColorMap[307] = [CCAppleGreenLight24]::new()
        $this.ColorMap[308] = [CCAppleGreenLight24]::new()
        $this.ColorMap[309] = [CCAppleGreenLight24]::new()
        $this.ColorMap[310] = [CCAppleGreenLight24]::new()
        $this.ColorMap[311] = [CCAppleGreenLight24]::new()
        $this.ColorMap[312] = [CCAppleGreenLight24]::new()
        $this.ColorMap[313] = [CCAppleGreenLight24]::new()
        $this.ColorMap[314] = [CCAppleGreenLight24]::new()
        $this.ColorMap[315] = [CCAppleGreenLight24]::new()
        $this.ColorMap[316] = [CCAppleGreenLight24]::new()
        $this.ColorMap[317] = [CCAppleGreenLight24]::new()
        $this.ColorMap[318] = [CCAppleGreenLight24]::new()
        $this.ColorMap[319] = [CCAppleGreenLight24]::new()
        $this.ColorMap[320] = [CCAppleGreenLight24]::new()
        $this.ColorMap[321] = [CCAppleGreenLight24]::new()
        $this.ColorMap[322] = [CCAppleGreenLight24]::new()
        $this.ColorMap[323] = [CCAppleGreenLight24]::new()
        $this.ColorMap[324] = [CCAppleGreenLight24]::new()
        $this.ColorMap[325] = [CCAppleGreenLight24]::new()
        $this.ColorMap[326] = [CCAppleGreenLight24]::new()
        $this.ColorMap[327] = [CCAppleGreenLight24]::new()
        $this.ColorMap[328] = [CCAppleGreenLight24]::new()
        $this.ColorMap[329] = [CCAppleGreenLight24]::new()
        $this.ColorMap[330] = [CCAppleGreenLight24]::new()
        $this.ColorMap[331] = [CCAppleGreenLight24]::new()
        $this.ColorMap[332] = [CCAppleGreenLight24]::new()
        $this.ColorMap[333] = [CCAppleGreenLight24]::new()
        $this.ColorMap[334] = [CCAppleGreenLight24]::new()
        $this.ColorMap[335] = [CCAppleGreenLight24]::new() # End Row 6
        $this.ColorMap[336] = [CCAppleGreenLight24]::new()
        $this.ColorMap[337] = [CCAppleGreenLight24]::new()
        $this.ColorMap[338] = [CCAppleGreenLight24]::new()
        $this.ColorMap[339] = [CCAppleGreenLight24]::new()
        $this.ColorMap[340] = [CCAppleGreenLight24]::new()
        $this.ColorMap[341] = [CCAppleGreenLight24]::new()
        $this.ColorMap[342] = [CCAppleGreenLight24]::new()
        $this.ColorMap[343] = [CCAppleGreenLight24]::new()
        $this.ColorMap[344] = [CCAppleGreenLight24]::new()
        $this.ColorMap[345] = [CCAppleGreenLight24]::new()
        $this.ColorMap[346] = [CCAppleGreenLight24]::new()
        $this.ColorMap[347] = [CCAppleGreenLight24]::new()
        $this.ColorMap[348] = [CCAppleGreenLight24]::new()
        $this.ColorMap[349] = [CCAppleGreenLight24]::new()
        $this.ColorMap[350] = [CCAppleGreenLight24]::new()
        $this.ColorMap[351] = [CCAppleGreenLight24]::new()
        $this.ColorMap[352] = [CCAppleGreenLight24]::new()
        $this.ColorMap[353] = [CCAppleGreenLight24]::new()
        $this.ColorMap[354] = [CCAppleGreenLight24]::new()
        $this.ColorMap[355] = [CCAppleGreenLight24]::new()
        $this.ColorMap[356] = [CCAppleGreenLight24]::new()
        $this.ColorMap[357] = [CCAppleGreenLight24]::new()
        $this.ColorMap[358] = [CCAppleGreenLight24]::new()
        $this.ColorMap[359] = [CCAppleGreenLight24]::new()
        $this.ColorMap[360] = [CCAppleGreenLight24]::new()
        $this.ColorMap[361] = [CCAppleGreenLight24]::new()
        $this.ColorMap[362] = [CCAppleGreenLight24]::new()
        $this.ColorMap[363] = [CCAppleGreenLight24]::new()
        $this.ColorMap[364] = [CCAppleGreenLight24]::new()
        $this.ColorMap[365] = [CCAppleGreenLight24]::new()
        $this.ColorMap[366] = [CCAppleGreenLight24]::new()
        $this.ColorMap[367] = [CCAppleGreenLight24]::new()
        $this.ColorMap[368] = [CCAppleGreenLight24]::new()
        $this.ColorMap[369] = [CCAppleGreenLight24]::new()
        $this.ColorMap[370] = [CCAppleGreenLight24]::new()
        $this.ColorMap[371] = [CCAppleGreenLight24]::new()
        $this.ColorMap[372] = [CCAppleGreenLight24]::new()
        $this.ColorMap[373] = [CCAppleGreenLight24]::new()
        $this.ColorMap[374] = [CCAppleGreenLight24]::new()
        $this.ColorMap[375] = [CCAppleGreenLight24]::new()
        $this.ColorMap[376] = [CCAppleGreenLight24]::new()
        $this.ColorMap[377] = [CCAppleGreenLight24]::new()
        $this.ColorMap[378] = [CCAppleGreenLight24]::new()
        $this.ColorMap[379] = [CCAppleGreenLight24]::new()
        $this.ColorMap[380] = [CCAppleGreenLight24]::new()
        $this.ColorMap[381] = [CCAppleGreenLight24]::new()
        $this.ColorMap[382] = [CCAppleGreenLight24]::new()
        $this.ColorMap[383] = [CCAppleGreenLight24]::new() # End Row 7
        $this.ColorMap[384] = [CCAppleGreenLight24]::new()
        $this.ColorMap[385] = [CCAppleGreenLight24]::new()
        $this.ColorMap[386] = [CCAppleGreenLight24]::new()
        $this.ColorMap[387] = [CCAppleGreenLight24]::new()
        $this.ColorMap[388] = [CCAppleGreenLight24]::new()
        $this.ColorMap[389] = [CCAppleGreenLight24]::new()
        $this.ColorMap[390] = [CCAppleGreenLight24]::new()
        $this.ColorMap[391] = [CCAppleGreenLight24]::new()
        $this.ColorMap[392] = [CCAppleGreenLight24]::new()
        $this.ColorMap[393] = [CCAppleGreenLight24]::new()
        $this.ColorMap[394] = [CCAppleGreenLight24]::new()
        $this.ColorMap[395] = [CCAppleGreenLight24]::new()
        $this.ColorMap[396] = [CCAppleGreenLight24]::new()
        $this.ColorMap[397] = [CCAppleGreenLight24]::new()
        $this.ColorMap[398] = [CCAppleGreenLight24]::new()
        $this.ColorMap[399] = [CCAppleGreenLight24]::new()
        $this.ColorMap[400] = [CCAppleGreenLight24]::new()
        $this.ColorMap[401] = [CCAppleGreenLight24]::new()
        $this.ColorMap[402] = [CCAppleGreenLight24]::new()
        $this.ColorMap[403] = [CCAppleGreenLight24]::new()
        $this.ColorMap[404] = [CCAppleGreenLight24]::new()
        $this.ColorMap[405] = [CCAppleGreenLight24]::new()
        $this.ColorMap[406] = [CCAppleBrownLight24]::new()
        $this.ColorMap[407] = [CCAppleBrownLight24]::new()
        $this.ColorMap[408] = [CCAppleBrownLight24]::new()
        $this.ColorMap[409] = [CCAppleBrownLight24]::new()
        $this.ColorMap[410] = [CCAppleBrownLight24]::new()
        $this.ColorMap[411] = [CCAppleGreenLight24]::new()
        $this.ColorMap[412] = [CCAppleGreenLight24]::new()
        $this.ColorMap[413] = [CCAppleGreenLight24]::new()
        $this.ColorMap[414] = [CCAppleGreenLight24]::new()
        $this.ColorMap[415] = [CCAppleGreenLight24]::new()
        $this.ColorMap[416] = [CCAppleGreenLight24]::new()
        $this.ColorMap[417] = [CCAppleGreenLight24]::new()
        $this.ColorMap[418] = [CCAppleGreenLight24]::new()
        $this.ColorMap[419] = [CCAppleGreenLight24]::new()
        $this.ColorMap[420] = [CCAppleGreenLight24]::new()
        $this.ColorMap[421] = [CCAppleGreenLight24]::new()
        $this.ColorMap[422] = [CCAppleGreenLight24]::new()
        $this.ColorMap[423] = [CCAppleGreenLight24]::new()
        $this.ColorMap[424] = [CCAppleGreenLight24]::new()
        $this.ColorMap[425] = [CCAppleGreenLight24]::new()
        $this.ColorMap[426] = [CCAppleGreenLight24]::new()
        $this.ColorMap[427] = [CCAppleGreenLight24]::new()
        $this.ColorMap[428] = [CCAppleGreenLight24]::new()
        $this.ColorMap[429] = [CCAppleGreenLight24]::new()
        $this.ColorMap[430] = [CCAppleGreenLight24]::new()
        $this.ColorMap[431] = [CCAppleGreenLight24]::new() # End Row 8
        $this.ColorMap[432] = [CCAppleGreenLight24]::new()
        $this.ColorMap[433] = [CCAppleGreenLight24]::new()
        $this.ColorMap[434] = [CCAppleGreenLight24]::new()
        $this.ColorMap[435] = [CCAppleGreenLight24]::new()
        $this.ColorMap[436] = [CCAppleGreenLight24]::new()
        $this.ColorMap[437] = [CCAppleGreenLight24]::new()
        $this.ColorMap[438] = [CCAppleGreenLight24]::new()
        $this.ColorMap[439] = [CCAppleGreenLight24]::new()
        $this.ColorMap[440] = [CCAppleGreenLight24]::new()
        $this.ColorMap[441] = [CCAppleGreenLight24]::new()
        $this.ColorMap[442] = [CCAppleGreenLight24]::new()
        $this.ColorMap[443] = [CCAppleGreenLight24]::new()
        $this.ColorMap[444] = [CCAppleGreenLight24]::new()
        $this.ColorMap[445] = [CCAppleGreenLight24]::new()
        $this.ColorMap[446] = [CCAppleGreenLight24]::new()
        $this.ColorMap[447] = [CCAppleGreenLight24]::new()
        $this.ColorMap[448] = [CCAppleGreenLight24]::new()
        $this.ColorMap[449] = [CCAppleGreenLight24]::new()
        $this.ColorMap[450] = [CCAppleGreenLight24]::new()
        $this.ColorMap[451] = [CCAppleGreenLight24]::new()
        $this.ColorMap[452] = [CCAppleGreenLight24]::new()
        $this.ColorMap[453] = [CCAppleGreenLight24]::new()
        $this.ColorMap[454] = [CCAppleBrownLight24]::new()
        $this.ColorMap[455] = [CCAppleBrownLight24]::new()
        $this.ColorMap[456] = [CCAppleBrownLight24]::new()
        $this.ColorMap[457] = [CCAppleBrownLight24]::new()
        $this.ColorMap[458] = [CCAppleBrownLight24]::new()
        $this.ColorMap[459] = [CCAppleGreenLight24]::new()
        $this.ColorMap[460] = [CCAppleGreenLight24]::new()
        $this.ColorMap[461] = [CCAppleGreenLight24]::new()
        $this.ColorMap[462] = [CCAppleGreenLight24]::new()
        $this.ColorMap[463] = [CCAppleGreenLight24]::new()
        $this.ColorMap[464] = [CCAppleGreenLight24]::new()
        $this.ColorMap[465] = [CCAppleGreenLight24]::new()
        $this.ColorMap[466] = [CCAppleGreenLight24]::new()
        $this.ColorMap[467] = [CCAppleGreenLight24]::new()
        $this.ColorMap[468] = [CCAppleGreenLight24]::new()
        $this.ColorMap[469] = [CCAppleGreenLight24]::new()
        $this.ColorMap[470] = [CCAppleGreenLight24]::new()
        $this.ColorMap[471] = [CCAppleGreenLight24]::new()
        $this.ColorMap[472] = [CCAppleGreenLight24]::new()
        $this.ColorMap[473] = [CCAppleGreenLight24]::new()
        $this.ColorMap[474] = [CCAppleGreenLight24]::new()
        $this.ColorMap[475] = [CCAppleGreenLight24]::new()
        $this.ColorMap[476] = [CCAppleGreenLight24]::new()
        $this.ColorMap[477] = [CCAppleGreenLight24]::new()
        $this.ColorMap[478] = [CCAppleGreenLight24]::new()
        $this.ColorMap[479] = [CCAppleGreenLight24]::new() # End Row 9
        $this.ColorMap[480] = [CCAppleGreenLight24]::new()
        $this.ColorMap[481] = [CCAppleGreenLight24]::new()
        $this.ColorMap[482] = [CCAppleGreenLight24]::new()
        $this.ColorMap[483] = [CCAppleGreenLight24]::new()
        $this.ColorMap[484] = [CCAppleGreenLight24]::new()
        $this.ColorMap[485] = [CCAppleGreenLight24]::new()
        $this.ColorMap[486] = [CCAppleGreenLight24]::new()
        $this.ColorMap[487] = [CCAppleGreenLight24]::new()
        $this.ColorMap[488] = [CCAppleGreenLight24]::new()
        $this.ColorMap[489] = [CCAppleGreenLight24]::new()
        $this.ColorMap[490] = [CCAppleGreenLight24]::new()
        $this.ColorMap[491] = [CCAppleGreenLight24]::new()
        $this.ColorMap[492] = [CCAppleGreenLight24]::new()
        $this.ColorMap[493] = [CCAppleGreenLight24]::new()
        $this.ColorMap[494] = [CCAppleGreenLight24]::new()
        $this.ColorMap[495] = [CCAppleGreenLight24]::new()
        $this.ColorMap[496] = [CCAppleGreenLight24]::new()
        $this.ColorMap[497] = [CCAppleGreenLight24]::new()
        $this.ColorMap[498] = [CCAppleGreenLight24]::new()
        $this.ColorMap[499] = [CCAppleGreenLight24]::new()
        $this.ColorMap[500] = [CCAppleGreenLight24]::new()
        $this.ColorMap[501] = [CCAppleBrownLight24]::new()
        $this.ColorMap[502] = [CCAppleBrownLight24]::new()
        $this.ColorMap[503] = [CCAppleBrownLight24]::new()
        $this.ColorMap[504] = [CCAppleBrownLight24]::new()
        $this.ColorMap[505] = [CCAppleBrownLight24]::new()
        $this.ColorMap[506] = [CCAppleBrownLight24]::new()
        $this.ColorMap[507] = [CCAppleBrownLight24]::new()
        $this.ColorMap[508] = [CCAppleGreenLight24]::new()
        $this.ColorMap[509] = [CCAppleGreenLight24]::new()
        $this.ColorMap[510] = [CCAppleGreenLight24]::new()
        $this.ColorMap[511] = [CCAppleGreenLight24]::new()
        $this.ColorMap[512] = [CCAppleGreenLight24]::new()
        $this.ColorMap[513] = [CCAppleGreenLight24]::new()
        $this.ColorMap[514] = [CCAppleGreenLight24]::new()
        $this.ColorMap[515] = [CCAppleGreenLight24]::new()
        $this.ColorMap[516] = [CCAppleGreenLight24]::new()
        $this.ColorMap[517] = [CCAppleGreenLight24]::new()
        $this.ColorMap[518] = [CCAppleGreenLight24]::new()
        $this.ColorMap[519] = [CCAppleGreenLight24]::new()
        $this.ColorMap[520] = [CCAppleGreenLight24]::new()
        $this.ColorMap[521] = [CCAppleGreenLight24]::new()
        $this.ColorMap[522] = [CCAppleGreenLight24]::new()
        $this.ColorMap[523] = [CCAppleGreenLight24]::new()
        $this.ColorMap[524] = [CCAppleGreenLight24]::new()
        $this.ColorMap[525] = [CCAppleGreenLight24]::new()
        $this.ColorMap[526] = [CCAppleGreenLight24]::new()
        $this.ColorMap[527] = [CCAppleGreenLight24]::new() # End Row 10
        $this.ColorMap[528] = [CCAppleGreenLight24]::new()
        $this.ColorMap[529] = [CCAppleGreenLight24]::new()
        $this.ColorMap[530] = [CCAppleGreenLight24]::new()
        $this.ColorMap[531] = [CCAppleGreenLight24]::new()
        $this.ColorMap[532] = [CCAppleGreenLight24]::new()
        $this.ColorMap[533] = [CCAppleGreenLight24]::new()
        $this.ColorMap[534] = [CCAppleGreenLight24]::new()
        $this.ColorMap[535] = [CCAppleGreenLight24]::new()
        $this.ColorMap[536] = [CCAppleGreenLight24]::new()
        $this.ColorMap[537] = [CCAppleGreenLight24]::new()
        $this.ColorMap[538] = [CCAppleGreenLight24]::new()
        $this.ColorMap[539] = [CCAppleGreenLight24]::new()
        $this.ColorMap[540] = [CCAppleGreenLight24]::new()
        $this.ColorMap[541] = [CCAppleGreenLight24]::new()
        $this.ColorMap[542] = [CCAppleGreenLight24]::new()
        $this.ColorMap[543] = [CCAppleGreenLight24]::new()
        $this.ColorMap[544] = [CCAppleGreenLight24]::new()
        $this.ColorMap[545] = [CCAppleGreenLight24]::new()
        $this.ColorMap[546] = [CCAppleGreenLight24]::new()
        $this.ColorMap[547] = [CCAppleGreenLight24]::new()
        $this.ColorMap[548] = [CCAppleGreenLight24]::new()
        $this.ColorMap[549] = [CCAppleBrownLight24]::new()
        $this.ColorMap[550] = [CCAppleBrownLight24]::new()
        $this.ColorMap[551] = [CCAppleBrownLight24]::new()
        $this.ColorMap[552] = [CCAppleBrownLight24]::new()
        $this.ColorMap[553] = [CCAppleBrownLight24]::new()
        $this.ColorMap[554] = [CCAppleBrownLight24]::new()
        $this.ColorMap[555] = [CCAppleBrownLight24]::new()
        $this.ColorMap[556] = [CCAppleGreenLight24]::new()
        $this.ColorMap[557] = [CCAppleGreenLight24]::new()
        $this.ColorMap[558] = [CCAppleGreenLight24]::new()
        $this.ColorMap[559] = [CCAppleGreenLight24]::new()
        $this.ColorMap[560] = [CCAppleGreenLight24]::new()
        $this.ColorMap[561] = [CCAppleGreenLight24]::new()
        $this.ColorMap[562] = [CCAppleGreenLight24]::new()
        $this.ColorMap[563] = [CCAppleGreenLight24]::new()
        $this.ColorMap[564] = [CCAppleGreenLight24]::new()
        $this.ColorMap[565] = [CCAppleGreenLight24]::new()
        $this.ColorMap[566] = [CCAppleGreenLight24]::new()
        $this.ColorMap[567] = [CCAppleGreenLight24]::new()
        $this.ColorMap[568] = [CCAppleGreenLight24]::new()
        $this.ColorMap[569] = [CCAppleGreenLight24]::new()
        $this.ColorMap[570] = [CCAppleGreenLight24]::new()
        $this.ColorMap[571] = [CCAppleGreenLight24]::new()
        $this.ColorMap[572] = [CCAppleGreenLight24]::new()
        $this.ColorMap[573] = [CCAppleGreenLight24]::new()
        $this.ColorMap[574] = [CCAppleGreenLight24]::new()
        $this.ColorMap[575] = [CCAppleGreenLight24]::new() # End Row 11
        $this.ColorMap[576] = [CCAppleGreenLight24]::new()
        $this.ColorMap[577] = [CCAppleGreenLight24]::new()
        $this.ColorMap[578] = [CCAppleGreenLight24]::new()
        $this.ColorMap[579] = [CCAppleGreenLight24]::new()
        $this.ColorMap[580] = [CCAppleGreenLight24]::new()
        $this.ColorMap[581] = [CCAppleGreenLight24]::new()
        $this.ColorMap[582] = [CCAppleGreenLight24]::new()
        $this.ColorMap[583] = [CCAppleGreenLight24]::new()
        $this.ColorMap[584] = [CCAppleGreenLight24]::new()
        $this.ColorMap[585] = [CCAppleGreenLight24]::new()
        $this.ColorMap[586] = [CCAppleGreenLight24]::new()
        $this.ColorMap[587] = [CCAppleGreenLight24]::new()
        $this.ColorMap[588] = [CCAppleGreenLight24]::new()
        $this.ColorMap[589] = [CCAppleGreenLight24]::new()
        $this.ColorMap[590] = [CCAppleGreenLight24]::new()
        $this.ColorMap[591] = [CCAppleGreenLight24]::new()
        $this.ColorMap[592] = [CCAppleGreenLight24]::new()
        $this.ColorMap[593] = [CCAppleGreenLight24]::new()
        $this.ColorMap[594] = [CCAppleGreenLight24]::new()
        $this.ColorMap[595] = [CCAppleGreenLight24]::new()
        $this.ColorMap[596] = [CCAppleGreenLight24]::new()
        $this.ColorMap[597] = [CCAppleBrownLight24]::new()
        $this.ColorMap[598] = [CCAppleBrownLight24]::new()
        $this.ColorMap[599] = [CCAppleBrownLight24]::new()
        $this.ColorMap[600] = [CCAppleBrownLight24]::new()
        $this.ColorMap[601] = [CCAppleBrownLight24]::new()
        $this.ColorMap[602] = [CCAppleBrownLight24]::new()
        $this.ColorMap[603] = [CCAppleBrownLight24]::new()
        $this.ColorMap[604] = [CCAppleGreenLight24]::new()
        $this.ColorMap[605] = [CCAppleGreenLight24]::new()
        $this.ColorMap[606] = [CCAppleGreenLight24]::new()
        $this.ColorMap[607] = [CCAppleGreenLight24]::new()
        $this.ColorMap[608] = [CCAppleGreenLight24]::new()
        $this.ColorMap[609] = [CCAppleGreenLight24]::new()
        $this.ColorMap[610] = [CCAppleGreenLight24]::new()
        $this.ColorMap[611] = [CCAppleGreenLight24]::new()
        $this.ColorMap[612] = [CCAppleGreenLight24]::new()
        $this.ColorMap[613] = [CCAppleGreenLight24]::new()
        $this.ColorMap[614] = [CCAppleGreenLight24]::new()
        $this.ColorMap[615] = [CCAppleGreenLight24]::new()
        $this.ColorMap[616] = [CCAppleGreenLight24]::new()
        $this.ColorMap[617] = [CCAppleGreenLight24]::new()
        $this.ColorMap[618] = [CCAppleGreenLight24]::new()
        $this.ColorMap[619] = [CCAppleGreenLight24]::new()
        $this.ColorMap[620] = [CCAppleGreenLight24]::new()
        $this.ColorMap[621] = [CCAppleGreenLight24]::new()
        $this.ColorMap[622] = [CCAppleGreenLight24]::new()
        $this.ColorMap[623] = [CCAppleGreenLight24]::new() # End Row 12
        $this.ColorMap[624] = [CCAppleGreenLight24]::new()
        $this.ColorMap[625] = [CCAppleGreenLight24]::new()
        $this.ColorMap[626] = [CCAppleGreenLight24]::new()
        $this.ColorMap[627] = [CCAppleGreenLight24]::new()
        $this.ColorMap[628] = [CCAppleGreenLight24]::new()
        $this.ColorMap[629] = [CCAppleGreenLight24]::new()
        $this.ColorMap[630] = [CCAppleGreenLight24]::new()
        $this.ColorMap[631] = [CCAppleGreenLight24]::new()
        $this.ColorMap[632] = [CCAppleGreenLight24]::new()
        $this.ColorMap[633] = [CCAppleGreenLight24]::new()
        $this.ColorMap[634] = [CCAppleGreenLight24]::new()
        $this.ColorMap[635] = [CCAppleGreenLight24]::new()
        $this.ColorMap[636] = [CCAppleGreenLight24]::new()
        $this.ColorMap[637] = [CCAppleGreenLight24]::new()
        $this.ColorMap[638] = [CCAppleGreenLight24]::new()
        $this.ColorMap[639] = [CCAppleGreenLight24]::new()
        $this.ColorMap[640] = [CCAppleGreenLight24]::new()
        $this.ColorMap[641] = [CCAppleGreenLight24]::new()
        $this.ColorMap[642] = [CCAppleGreenLight24]::new()
        $this.ColorMap[643] = [CCAppleGreenLight24]::new()
        $this.ColorMap[644] = [CCAppleGreenLight24]::new()
        $this.ColorMap[645] = [CCAppleBrownLight24]::new()
        $this.ColorMap[646] = [CCAppleBrownLight24]::new()
        $this.ColorMap[647] = [CCAppleBrownLight24]::new()
        $this.ColorMap[648] = [CCAppleBrownLight24]::new()
        $this.ColorMap[649] = [CCAppleBrownLight24]::new()
        $this.ColorMap[650] = [CCAppleBrownLight24]::new()
        $this.ColorMap[651] = [CCAppleBrownLight24]::new()
        $this.ColorMap[652] = [CCAppleGreenLight24]::new()
        $this.ColorMap[653] = [CCAppleGreenLight24]::new()
        $this.ColorMap[654] = [CCAppleGreenLight24]::new()
        $this.ColorMap[655] = [CCAppleGreenLight24]::new()
        $this.ColorMap[656] = [CCAppleGreenLight24]::new()
        $this.ColorMap[657] = [CCAppleGreenLight24]::new()
        $this.ColorMap[658] = [CCAppleGreenLight24]::new()
        $this.ColorMap[659] = [CCAppleGreenLight24]::new()
        $this.ColorMap[660] = [CCAppleGreenLight24]::new()
        $this.ColorMap[661] = [CCAppleGreenLight24]::new()
        $this.ColorMap[662] = [CCAppleGreenLight24]::new()
        $this.ColorMap[663] = [CCAppleGreenLight24]::new()
        $this.ColorMap[664] = [CCAppleGreenLight24]::new()
        $this.ColorMap[665] = [CCAppleGreenLight24]::new()
        $this.ColorMap[666] = [CCAppleGreenLight24]::new()
        $this.ColorMap[667] = [CCAppleGreenLight24]::new()
        $this.ColorMap[668] = [CCAppleGreenLight24]::new()
        $this.ColorMap[669] = [CCAppleGreenLight24]::new()
        $this.ColorMap[670] = [CCAppleGreenLight24]::new()
        $this.ColorMap[671] = [CCAppleGreenLight24]::new() # End Row 13
        $this.ColorMap[672] = [CCAppleGreenLight24]::new()
        $this.ColorMap[673] = [CCAppleGreenLight24]::new()
        $this.ColorMap[674] = [CCAppleGreenLight24]::new()
        $this.ColorMap[675] = [CCAppleGreenLight24]::new()
        $this.ColorMap[676] = [CCAppleGreenLight24]::new()
        $this.ColorMap[677] = [CCAppleGreenLight24]::new()
        $this.ColorMap[678] = [CCAppleGreenLight24]::new()
        $this.ColorMap[679] = [CCAppleGreenLight24]::new()
        $this.ColorMap[680] = [CCAppleGreenLight24]::new()
        $this.ColorMap[681] = [CCAppleGreenLight24]::new()
        $this.ColorMap[682] = [CCAppleGreenLight24]::new()
        $this.ColorMap[683] = [CCAppleGreenLight24]::new()
        $this.ColorMap[684] = [CCAppleGreenLight24]::new()
        $this.ColorMap[685] = [CCAppleGreenLight24]::new()
        $this.ColorMap[686] = [CCAppleGreenLight24]::new()
        $this.ColorMap[687] = [CCAppleGreenLight24]::new()
        $this.ColorMap[688] = [CCAppleGreenLight24]::new()
        $this.ColorMap[689] = [CCAppleGreenLight24]::new()
        $this.ColorMap[690] = [CCAppleGreenLight24]::new()
        $this.ColorMap[691] = [CCAppleGreenLight24]::new()
        $this.ColorMap[692] = [CCAppleGreenLight24]::new()
        $this.ColorMap[693] = [CCAppleBrownLight24]::new()
        $this.ColorMap[694] = [CCAppleBrownLight24]::new()
        $this.ColorMap[695] = [CCAppleBrownLight24]::new()
        $this.ColorMap[696] = [CCAppleBrownLight24]::new()
        $this.ColorMap[697] = [CCAppleBrownLight24]::new()
        $this.ColorMap[698] = [CCAppleBrownLight24]::new()
        $this.ColorMap[699] = [CCAppleBrownLight24]::new()
        $this.ColorMap[700] = [CCAppleGreenLight24]::new()
        $this.ColorMap[701] = [CCAppleGreenLight24]::new()
        $this.ColorMap[702] = [CCAppleGreenLight24]::new()
        $this.ColorMap[703] = [CCAppleGreenLight24]::new()
        $this.ColorMap[704] = [CCAppleGreenLight24]::new()
        $this.ColorMap[705] = [CCAppleGreenLight24]::new()
        $this.ColorMap[706] = [CCAppleGreenLight24]::new()
        $this.ColorMap[707] = [CCAppleGreenLight24]::new()
        $this.ColorMap[708] = [CCAppleGreenLight24]::new()
        $this.ColorMap[709] = [CCAppleGreenLight24]::new()
        $this.ColorMap[710] = [CCAppleGreenLight24]::new()
        $this.ColorMap[711] = [CCAppleGreenLight24]::new()
        $this.ColorMap[712] = [CCAppleGreenLight24]::new()
        $this.ColorMap[713] = [CCAppleGreenLight24]::new()
        $this.ColorMap[714] = [CCAppleGreenLight24]::new()
        $this.ColorMap[715] = [CCAppleGreenLight24]::new()
        $this.ColorMap[716] = [CCAppleGreenLight24]::new()
        $this.ColorMap[717] = [CCAppleGreenLight24]::new()
        $this.ColorMap[718] = [CCAppleGreenLight24]::new()
        $this.ColorMap[719] = [CCAppleGreenLight24]::new() # End Row 14
        $this.ColorMap[720] = [CCAppleGreenLight24]::new()
        $this.ColorMap[721] = [CCAppleGreenLight24]::new()
        $this.ColorMap[722] = [CCAppleGreenLight24]::new()
        $this.ColorMap[723] = [CCAppleGreenLight24]::new()
        $this.ColorMap[724] = [CCAppleGreenLight24]::new()
        $this.ColorMap[725] = [CCAppleGreenLight24]::new()
        $this.ColorMap[726] = [CCAppleGreenLight24]::new()
        $this.ColorMap[727] = [CCAppleGreenLight24]::new()
        $this.ColorMap[728] = [CCAppleGreenLight24]::new()
        $this.ColorMap[729] = [CCAppleGreenLight24]::new()
        $this.ColorMap[730] = [CCAppleGreenLight24]::new()
        $this.ColorMap[731] = [CCAppleGreenLight24]::new()
        $this.ColorMap[732] = [CCAppleGreenLight24]::new()
        $this.ColorMap[733] = [CCAppleGreenLight24]::new()
        $this.ColorMap[734] = [CCAppleGreenLight24]::new()
        $this.ColorMap[735] = [CCAppleGreenLight24]::new()
        $this.ColorMap[736] = [CCAppleGreenLight24]::new()
        $this.ColorMap[737] = [CCAppleGreenLight24]::new()
        $this.ColorMap[738] = [CCAppleGreenLight24]::new()
        $this.ColorMap[739] = [CCAppleGreenLight24]::new()
        $this.ColorMap[740] = [CCAppleGreenLight24]::new()
        $this.ColorMap[741] = [CCAppleBrownLight24]::new()
        $this.ColorMap[742] = [CCAppleBrownLight24]::new()
        $this.ColorMap[743] = [CCAppleBrownLight24]::new()
        $this.ColorMap[744] = [CCAppleBrownLight24]::new()
        $this.ColorMap[745] = [CCAppleBrownLight24]::new()
        $this.ColorMap[746] = [CCAppleBrownLight24]::new()
        $this.ColorMap[747] = [CCAppleBrownLight24]::new()
        $this.ColorMap[748] = [CCAppleGreenLight24]::new()
        $this.ColorMap[749] = [CCAppleGreenLight24]::new()
        $this.ColorMap[750] = [CCAppleGreenLight24]::new()
        $this.ColorMap[751] = [CCAppleGreenLight24]::new()
        $this.ColorMap[752] = [CCAppleGreenLight24]::new()
        $this.ColorMap[753] = [CCAppleGreenLight24]::new()
        $this.ColorMap[754] = [CCAppleGreenLight24]::new()
        $this.ColorMap[755] = [CCAppleGreenLight24]::new()
        $this.ColorMap[756] = [CCAppleGreenLight24]::new()
        $this.ColorMap[757] = [CCAppleGreenLight24]::new()
        $this.ColorMap[758] = [CCAppleGreenLight24]::new()
        $this.ColorMap[759] = [CCAppleGreenLight24]::new()
        $this.ColorMap[760] = [CCAppleGreenLight24]::new()
        $this.ColorMap[761] = [CCAppleGreenLight24]::new()
        $this.ColorMap[762] = [CCAppleGreenLight24]::new()
        $this.ColorMap[763] = [CCAppleGreenLight24]::new()
        $this.ColorMap[764] = [CCAppleGreenLight24]::new()
        $this.ColorMap[765] = [CCAppleGreenLight24]::new()
        $this.ColorMap[766] = [CCAppleGreenLight24]::new()
        $this.ColorMap[767] = [CCAppleGreenLight24]::new() # End Row 15
        $this.ColorMap[768] = [CCAppleBrownLight24]::new()
        $this.ColorMap[769] = [CCAppleBrownLight24]::new()
        $this.ColorMap[770] = [CCAppleBrownLight24]::new()
        $this.ColorMap[771] = [CCAppleBrownLight24]::new()
        $this.ColorMap[772] = [CCAppleBrownLight24]::new()
        $this.ColorMap[773] = [CCAppleBrownLight24]::new()
        $this.ColorMap[774] = [CCAppleBrownLight24]::new()
        $this.ColorMap[775] = [CCAppleBrownLight24]::new()
        $this.ColorMap[776] = [CCAppleBrownLight24]::new()
        $this.ColorMap[777] = [CCAppleBrownLight24]::new()
        $this.ColorMap[778] = [CCAppleBrownLight24]::new()
        $this.ColorMap[779] = [CCAppleBrownLight24]::new()
        $this.ColorMap[780] = [CCAppleBrownLight24]::new()
        $this.ColorMap[781] = [CCAppleBrownLight24]::new()
        $this.ColorMap[782] = [CCAppleBrownLight24]::new()
        $this.ColorMap[783] = [CCAppleBrownLight24]::new()
        $this.ColorMap[784] = [CCAppleBrownLight24]::new()
        $this.ColorMap[785] = [CCAppleBrownLight24]::new()
        $this.ColorMap[786] = [CCAppleBrownLight24]::new()
        $this.ColorMap[787] = [CCAppleBrownLight24]::new()
        $this.ColorMap[788] = [CCAppleBrownLight24]::new()
        $this.ColorMap[789] = [CCAppleBrownLight24]::new()
        $this.ColorMap[790] = [CCAppleBrownLight24]::new()
        $this.ColorMap[791] = [CCAppleBrownLight24]::new()
        $this.ColorMap[792] = [CCAppleBrownLight24]::new()
        $this.ColorMap[793] = [CCAppleBrownLight24]::new()
        $this.ColorMap[794] = [CCAppleBrownLight24]::new()
        $this.ColorMap[795] = [CCAppleBrownLight24]::new()
        $this.ColorMap[796] = [CCAppleBrownLight24]::new()
        $this.ColorMap[797] = [CCAppleBrownLight24]::new()
        $this.ColorMap[798] = [CCAppleBrownLight24]::new()
        $this.ColorMap[799] = [CCAppleBrownLight24]::new()
        $this.ColorMap[800] = [CCAppleBrownLight24]::new()
        $this.ColorMap[801] = [CCAppleBrownLight24]::new()
        $this.ColorMap[802] = [CCAppleBrownLight24]::new()
        $this.ColorMap[803] = [CCAppleBrownLight24]::new()
        $this.ColorMap[804] = [CCAppleBrownLight24]::new()
        $this.ColorMap[805] = [CCAppleBrownLight24]::new()
        $this.ColorMap[806] = [CCAppleBrownLight24]::new()
        $this.ColorMap[807] = [CCAppleBrownLight24]::new()
        $this.ColorMap[808] = [CCAppleBrownLight24]::new()
        $this.ColorMap[809] = [CCAppleBrownLight24]::new()
        $this.ColorMap[810] = [CCAppleBrownLight24]::new()
        $this.ColorMap[811] = [CCAppleBrownLight24]::new()
        $this.ColorMap[812] = [CCAppleBrownLight24]::new()
        $this.ColorMap[813] = [CCAppleBrownLight24]::new()
        $this.ColorMap[814] = [CCAppleBrownLight24]::new()
        $this.ColorMap[815] = [CCAppleBrownLight24]::new() # End Row 16
        $this.ColorMap[816] = [CCAppleBrownLight24]::new()
        $this.ColorMap[817] = [CCAppleBrownLight24]::new()
        $this.ColorMap[818] = [CCAppleBrownLight24]::new()
        $this.ColorMap[819] = [CCAppleBrownLight24]::new()
        $this.ColorMap[820] = [CCAppleBrownLight24]::new()
        $this.ColorMap[821] = [CCAppleBrownLight24]::new()
        $this.ColorMap[822] = [CCAppleBrownLight24]::new()
        $this.ColorMap[823] = [CCAppleBrownLight24]::new()
        $this.ColorMap[824] = [CCAppleBrownLight24]::new()
        $this.ColorMap[825] = [CCAppleBrownLight24]::new()
        $this.ColorMap[826] = [CCAppleBrownLight24]::new()
        $this.ColorMap[827] = [CCAppleBrownLight24]::new()
        $this.ColorMap[828] = [CCAppleBrownLight24]::new()
        $this.ColorMap[829] = [CCAppleBrownLight24]::new()
        $this.ColorMap[830] = [CCAppleBrownLight24]::new()
        $this.ColorMap[831] = [CCAppleBrownLight24]::new()
        $this.ColorMap[832] = [CCAppleBrownLight24]::new()
        $this.ColorMap[833] = [CCAppleBrownLight24]::new()
        $this.ColorMap[834] = [CCAppleBrownLight24]::new()
        $this.ColorMap[835] = [CCAppleBrownLight24]::new()
        $this.ColorMap[836] = [CCAppleBrownLight24]::new()
        $this.ColorMap[837] = [CCAppleBrownLight24]::new()
        $this.ColorMap[838] = [CCAppleBrownLight24]::new()
        $this.ColorMap[839] = [CCAppleBrownLight24]::new()
        $this.ColorMap[840] = [CCAppleBrownLight24]::new()
        $this.ColorMap[841] = [CCAppleBrownLight24]::new()
        $this.ColorMap[842] = [CCAppleBrownLight24]::new()
        $this.ColorMap[843] = [CCAppleBrownLight24]::new()
        $this.ColorMap[844] = [CCAppleBrownLight24]::new()
        $this.ColorMap[845] = [CCAppleBrownLight24]::new()
        $this.ColorMap[846] = [CCAppleBrownLight24]::new()
        $this.ColorMap[847] = [CCAppleBrownLight24]::new()
        $this.ColorMap[848] = [CCAppleBrownLight24]::new()
        $this.ColorMap[849] = [CCAppleBrownLight24]::new()
        $this.ColorMap[850] = [CCAppleBrownLight24]::new()
        $this.ColorMap[851] = [CCAppleBrownLight24]::new()
        $this.ColorMap[852] = [CCAppleBrownLight24]::new()
        $this.ColorMap[853] = [CCAppleBrownLight24]::new()
        $this.ColorMap[854] = [CCAppleBrownLight24]::new()
        $this.ColorMap[855] = [CCAppleBrownLight24]::new()
        $this.ColorMap[856] = [CCAppleBrownLight24]::new()
        $this.ColorMap[857] = [CCAppleBrownLight24]::new()
        $this.ColorMap[858] = [CCAppleBrownLight24]::new()
        $this.ColorMap[859] = [CCAppleBrownLight24]::new()
        $this.ColorMap[860] = [CCAppleBrownLight24]::new()
        $this.ColorMap[861] = [CCAppleBrownLight24]::new()
        $this.ColorMap[862] = [CCAppleBrownLight24]::new()
        $this.ColorMap[863] = [CCAppleBrownLight24]::new() # End Row 17

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class MapTileObject {
    [String]$Name
    [String]$MapObjName
    [ScriptBlock]$Effect
    [Boolean]$CanAddToInventory
    [String]$ExamineString
    [List[String]]$TargetOfFilter
    [ScriptBlock]$BaseEffectCall
    [String]$PlayerEffectString
    [Boolean]$KeyItem

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect
    ) {
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.Effect            = $Effect
        $this.CanAddToInventory = $CanAddToInventory
        $this.ExamineString     = $ExamineString
        $this.TargetOfFilter    = [List[String]]::new()
        $this.BaseEffectCall    = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
        $this.PlayerEffectString = ''
        $this.KeyItem            = $false
    }

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect,
        [String[]]$TargetOfFilter
    ) {
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.Effect            = $Effect
        $this.CanAddToInventory = $CanAddToInventory
        $this.ExamineString     = $ExamineString
        $this.TargetOfFilter    = [List[String]]::new()
        $this.BaseEffectCall    = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
        $this.PlayerEffectString = ''
        $this.KeyItem            = $false

        Foreach($a in $TargetOfFilter) {
            $this.TargetOfFilter.Add($a) | Out-Null
        }
    }

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect,
        [String[]]$TargetOfFilter,
        [String]$PlayerEffectString
    ) {
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.Effect            = $Effect
        $this.CanAddToInventory = $CanAddToInventory
        $this.ExamineString     = $ExamineString
        $this.TargetOfFilter    = [List[String]]::new()
        $this.BaseEffectCall    = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
        $this.PlayerEffectString = $PlayerEffectString
        $this.KeyItem            = $false

        Foreach($a in $TargetOfFilter) {
            $this.TargetOfFilter.Add($a) | Out-Null
        }
    }

    MapTileObject(
        [String]$Name,
        [String]$MapObjName,
        [Boolean]$CanAddToInventory,
        [String]$ExamineString,
        [ScriptBlock]$Effect,
        [String[]]$TargetOfFilter,
        [String]$PlayerEffectString,
        [Boolean]$KeyItem
    ) {
        $this.Name              = $Name
        $this.MapObjName        = $MapObjName
        $this.Effect            = $Effect
        $this.CanAddToInventory = $CanAddToInventory
        $this.ExamineString     = $ExamineString
        $this.TargetOfFilter    = [List[String]]::new()
        $this.BaseEffectCall    = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
        $this.PlayerEffectString = $PlayerEffectString
        $this.KeyItem            = $KeyItem

        Foreach($a in $TargetOfFilter) {
            $this.TargetOfFilter.Add($a) | Out-Null
        }
    }

    [Boolean]ValidateSourceInFilter([String]$SourceItemClass) {
        Return ($SourceItemClass -IN $this.TargetOfFilter)
    }
}

Class MapTile {
    Static [Int]$TileExitNorth = 0
    Static [Int]$TileExitSouth = 1
    Static [Int]$TileExitEast  = 2
    Static [Int]$TileExitWest  = 3

    [SceneImage]$BackgroundImage
    [List[MapTileObject]]$ObjectListing
    [Boolean[]]$Exits

    MapTile(
        [SceneImage]$BackgroundImage,
        [MapTileObject[]]$ObjectListing,
        [Boolean[]]$Exits
    ) {
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits

        Foreach($a In $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }

    [Boolean]IsItemInTile([String]$ItemName) {
        Foreach($a in $this.ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                Return $true
            }
        }

        Return $false
    }

    [MapTileObject]GetItemReference([String]$ItemName) {
        Foreach($a in $this.ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                Return $a
            }
        }

        Return $null
    }
}

Class Map {
    [String]$Name
    [Int]$MapWidth
    [Int]$MapHeight
    [Boolean]$BoundaryWrap
    [MapTile[,]]$Tiles

    Map(
        [String]$Name,
        [Int]$MapWidth,
        [Int]$MapHeight,
        [Boolean]$BoundaryWrap
    ) {
        Write-Progress -Activity 'Creating Maps              ' -Id 2 -Status 'Creating a map' -PercentComplete -1
        $this.Name         = $Name
        $this.MapWidth     = $MapWidth
        $this.MapHeight    = $MapHeight
        $this.BoundaryWrap = $BoundaryWrap
        $this.Tiles = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
    }

    [MapTile]GetTileAtPlayerCoordinates() {
        Return $this.Tiles[$Script:ThePlayer.MapCoordinates.Row, $Script:ThePlayer.MapCoordinates.Column]
    }
}

Class MTOTree : MapTileObject {
    [Boolean]$HasRopeTied

    MTOTree(): base('Tree', 'tree', $false, 'It''s a tree. Looks like all the other ones.', {
        <#
        Note the pattern here for the params. In order for state changes to work, the ScriptBlock will need to have two arguments:
        A reference to the object itself, and the source. AFAIK, this is because of how the ScriptBlock gets invoked. The $this reference
        doesn't work as it references the CommandWindow instance rather than the owning object (in this case, MTOTree). Because of this
        somewhat counterintuitive nature, the caller (in this case, the 'use' command) will invoke the ScriptBlock with two arguments that
        match the signature here. State changes can be inflicted upon Self (passed as a reference), and Source gets removed from the Player's
        Inventory.
        #>
        Param(
            [MTOTree]$Self,
            [Object]$Source
        )

        Switch($Source.PSTypeNames[0]) {
            'MTORope' {
                $Script:TheMessageWindow.WriteMessage(
                    'I''ve tied the Rope to the Tree',
                    [CCAppleIndigoDark24]::new(),
                    [ATDecorationNone]::new()
                )

                <#
                It's important to note that this action *SHOULD* cause a state change with this object. To be more specific,
                prior to running this action, it's assumed that the Tree did NOT have a Rope tied to it. After this action,
                it does. So the questions now are (A) can you tie another Rope to the Tree, and (B) what can you do with the Tree
                now that it has a Rope tied to it?

                Also, the Rope should be removed from the Player's Inventory, but I don't yet have that functionality in place.

                UPDATE: I have this functionality in place.
                #>

                $Self.HasRopeTied   = $true
                $Self.ExamineString = 'A rope is tied to this tree. Wee.'

                $Script:ThePlayer.RemoveInventoryItemByName($Source.Name)
            }
        }
    },
    @(
        'MTORope'
    )) {
        $this.HasRopeTied = $false
    }
}

Class MTOLadder : MapTileObject {
    MTOLadder():  base('Ladder', 'ladder', $false, 'Used to climb things. Just don''t walk under one.', {}) {}
}

Class MTORope : MapTileObject {
    MTORope(): base('Rope', 'rope', $false, 'It''s not a snake. Hopefully.', {}) {}
}

Class MTOStairs : MapTileObject {
    MTOStairs(): base('Stairs', 'stairs', $false, 'A faithful ally for elevating one''s position.', {}) {}
}

Class MTOPole : MapTileObject {
    MTOPole(): base('Pole', 'pole', $false, 'Not the north or the south one.', {}) {}
}

Class MTOBacon : MapTileObject {
    MTOBacon(): base('Bacon', 'bacon', $false, 'Shredded swine flesh. Cholesterol never tasted so good.', {}) {
        $this.KeyItem = $true
    }
}

Class MTOApple : MapTileObject {
    MTOApple(): base('Apple', 'apple', $true, 'A big, juicy, red apple. Worm not included.', {}) {}
}

Class MTOStick : MapTileObject {
    MTOStick(): base('Stick', 'stick', $false, 'Be careful not to poke your eye out with it.', {}) {}
}

Class MTOYogurt : MapTileObject {
    MTOYogurt(): base('Yogurt', 'yogurt', $false, 'For some reason, people enjoy this spoiled milk.', {}) {}
}

Class MTORock : MapTileObject {
    MTORock(): base('Rock', 'rock', $false, 'A garden variety rock. Good for taunting raccoons with.', {}) {}
}

Class MTOMilk : MapTileObject {
    [Int]$PlayerHpBonus
    [Boolean]$IsSpoiled

    MTOMilk(): base('Milk', 'milk', $false, '2%. We don''t take kindly to whole milk ''round here.', {
        Param(
            [MTOMilk]$Self,
            [Object]$Source
        )

        Switch($Source.PSTypeNames[0]) {
            'Player' {
                <#
                Now we're getting into some pretty esoteric stuff here.

                First, we need to check and see if the Milk is spoiled.
                #>
                If($Self.IsSpoiled -EQ $true) {
                    # It is - this will cause the Player's Hp to decrease
                    # Attempt to decrement the Player's Hp by the Hp Bonus
                    If($Source.DecrementHitPoints(-$Self.PlayerHpBonus) -EQ $true) {
                        # Decrement was successful; write a message to the Message Window
                        $Script:TheMessageWindow.WriteMessage(
                            'Now that wasn''t very smart, was it?',
                            [CCAppleOrangeLight24]::new(),
                            [ATDecorationNone]::new()
                        )

                        # Remove the milk from the Player's Inventory
                        $Source.RemoveInventoryItemByName($Self.Name)
                    } Else {
                        # Decrement failed; write a message to the Message Window
                        $Script:TheMessageWindow.WriteMessage(
                            'There''s no need to drink this now.',
                            [CCAppleYellowLight24]::new(),
                            [ATDecorationNone]::new()
                        )
                    }
                } Else {
                    # The milk isn't spoiled - attempt to increment the Player's Hp by the Hp Bonus
                    # Attempt to increment the Player's HP by the Hp Bonus
                    If($Script:ThePlayer.IncrementHitPoints($Self.PlayerHpBonus) -EQ $true) {
                        # Increment was successful; write a message to the Message Window
                        $Script:TheMessageWindow.WriteMessage(
                            'Hmmm. Delicious cow juice.',
                            [CCAppleGreenLight24]::new(),
                            [ATDecorationNone]::new()
                        )

                        # Remove the milk from the Player's Inventory
                        $Script:ThePlayer.RemoveInventoryItemByName($Self.Name)
                    } Else {
                        # Increment wasn't successful; write a message to the Message Window
                        $Script:TheMessageWindow.WriteMessage(
                            'There''s no need to drink this now.',
                            [CCAppleYellowLight24]::new(),
                            [ATDecorationNone]::new()
                        )
                    }
                }
            }
        }
    }) {
        $a = $(Get-Random -Minimum 0 -Maximum 10)
        $this.PlayerHpBonus = 75
        $this.IsSpoiled     = ($a -GE 6 ? $true : $false)

        If($this.IsSpoiled -EQ $true) {
            $this.ExamineString      = 'This looks funny. Should I really be drinking this?'
            $this.PlayerEffectString = "-$($this.PlayerHpBonus) HP, 10% chance to inflict Poison"
        } Else {
            $this.PlayerEffectString = "+$($this.PlayerHpBonus) HP"
        }
    }
}

Class BufferManager {
    [BufferCell[,]]$ScreenBufferA
    [BufferCell[,]]$ScreenBufferB

    BufferManager() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Buffer Manager' -PercentComplete -1
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }

    [Void]CopyActiveToBufferA() {
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    }

    [Void]CopyActiveToBufferAWithWipe() {
        $this.ScreenBufferA = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
    }

    [Void]CopyActiveToBufferB() {
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
    }

    [Void]CopyActiveToBufferBWithWipe() {
        $this.ScreenBufferB = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
    }

    [Void]SwapAToB() {
        $this.ScreenBufferB = $this.ScreenBufferA
    }

    [Void]SwapBToA() {
        $this.ScreenBufferA = $this.ScreenBufferB
    }

    [Void]RestoreBufferAToActive() {
        Clear-Host
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferA)
        $this.ScreenBufferA = New-Object 'BufferCell[,]' 80, 80
    }

    [Void]RestoreBufferBToActive() {
        Clear-Host
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $this.ScreenBufferB)
        $this.ScreenBufferB = New-Object 'BufferCell[,]' 80, 80
    }
}

Class WindowBase {
    Static [Int]$BorderDrawColorTop     = 0
    Static [Int]$BorderDrawColorBottom  = 1
    Static [Int]$BorderDrawColorLeft    = 2
    Static [Int]$BorderDrawColorRight   = 3
    Static [Int]$BorderStringHorizontal = 0
    Static [Int]$BorderStringVertical   = 1
    Static [Int]$BorderDirtyTop         = 0
    Static [Int]$BorderDirtyBottom      = 1
    Static [Int]$BorderDirtyLeft        = 2
    Static [Int]$BorderDirtyRight       = 3

    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[]]$BorderDrawColors
    [String[]]$BorderStrings
    [Boolean[]]$BorderDrawDirty
    [Int]$Width
    [Int]$Height

    WindowBase() {
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new()
        )
        $this.BorderStrings = [String[]](
            '',
            ''
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.UpdateDimensions()
    }

    WindowBase(
        [ATCoordinates]$LeftTop,
        [ATCoordinates]$RightBottom,
        [ConsoleColor24[]]$BorderDrawColors,
        [String[]]$BorderStrings,
        [Boolean[]]$BorderDrawDirty
    ) {
        $this.LeftTop          = $LeftTop
        $this.RightBottom      = $RightBottom
        $this.BorderDrawColors = $BorderDrawColors
        $this.BorderStrings    = $BorderStrings
        $this.BorderDrawDirty  = $BorderDrawDirty
        $this.UpdateDimensions()
    }

    [Void]Draw() {
        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                [ATString]$bt = [ATStringNone]::new()
                [ATString]$bb = [ATStringNone]::new()
                [ATString]$bl = [ATStringNone]::new()
                [ATString]$br = [ATStringNone]::new()

                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop]) {
                    $bt = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            $this.LeftTop
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom]) {
                    $bb = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft]) {
                    $bl = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                            }

                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight]) {
                    $br = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column + 1)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.RightBottom.Column + 1).ToAnsiControlSequenceString())"
                            }

                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
                }


                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }

            { $_ -EQ $Script:OsCheckWindows } {
                [ATString]$bt = [ATStringNone]::new()
                [ATString]$bb = [ATStringNone]::new()
                [ATString]$bl = [ATStringNone]::new()
                [ATString]$br = [ATStringNone]::new()

                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop]) {
                    $bt = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            $this.LeftTop
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom]) {
                    $bb = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.RightBottom.Row, $this.LeftTop.Column)
                        ),
                        "$($this.BorderStrings[[WindowBase]::BorderStringHorizontal])",
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft]) {
                    $bl = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.LeftTop.Column).ToAnsiControlSequenceString())"
                            }

                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
                }
                If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight]) {
                    $br = [ATString]::new(
                        [ATStringPrefix]::new(
                            $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight],
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinates]::new($this.LeftTop.Row + 1, $this.RightBottom.Column + 1)
                        ),
                        $(Invoke-Command -ScriptBlock {
                            [String]$temp = ''

                            For($a = 0; $a -LT $this.Height; $a++) {
                                $temp += "$($this.BorderStrings[[WindowBase]::BorderStringVertical])$([ATCoordinates]::new(($this.LeftTop.Row + 1) + $a, $this.RightBottom.Column + 1).ToAnsiControlSequenceString())"
                            }

                            Return $temp
                        }),
                        $false
                    )
                    $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
                }


                Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
            }

            Default {}
        }
    }

    [Void]UpdateDimensions() {
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }
}

Class StatusWindow : WindowBase {
    Static [Int]$PlayerStatDrawColumn = 3
    Static [Int]$PlayerNameDrawRow    = 2
    Static [Int]$PlayerHpDrawRow      = 4
    Static [Int]$PlayerMpDrawRow      = 6
    Static [Int]$PlayerGoldDrawRow    = 9
    Static [Int]$WindowLTRow          = 1
    Static [Int]$WindowLTColumn       = 1
    Static [Int]$WindowRBRow          = 10
    Static [Int]$WindowRBColumn       = 19

    Static  [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    Static  [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$PlayerNameDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerNameDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerHpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerMpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerGoldDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    # Static [ATCoordinates]$PlayerAilDrawCoordinates  = [ATCoordinates]::new(2, 11)

    [Boolean]$PlayerNameDrawDirty
    [Boolean]$PlayerHpDrawDirty
    [Boolean]$PlayerMpDrawDirty
    [Boolean]$PlayerGoldDrawDirty
    # [Boolean]$PlayerAilDrawDirty

    StatusWindow() : base() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating Status Window' -PercentComplete -1
        $this.LeftTop          = [ATCoordinates]::new([StatusWindow]::WindowLTRow, [StatusWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([StatusWindow]::WindowRBRow, [StatusWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusWindow]::WindowBorderHorizontal,
            [StatusWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()
        $this.PlayerNameDrawDirty = $true
        $this.PlayerHpDrawDirty   = $true
        $this.PlayerMpDrawDirty   = $true
        $this.PlayerGoldDrawDirty = $true
        # $this.PlayerAilDrawDirty  = $true
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        Switch($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                If($this.PlayerNameDrawDirty) {
                    [ATString]$a = [ATString]::new(
                        [ATStringPrefix]::new(
                            $Script:ThePlayer.NameDrawColor,
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [StatusWindow]::PlayerNameDrawCoordinates
                        ),
                        $Script:ThePlayer.Name,
                        $true
                    )
                    Write-Host "$($a.ToAnsiControlSequenceString())"

                    # Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $this.PlayerNameDrawDirty = $false
                }
                If($this.PlayerHpDrawDirty) {
                    [String]$a = ''

                    Switch($Script:ThePlayer.Stats[[StatId]::HitPoints].State) {
                        ([StatNumberState]::Normal) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Caution) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Danger) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        Default {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }
                    }

                    Write-Host "$($a)"

                    # Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $this.PlayerHpDrawDirty = $false
                }
                If($this.PlayerMpDrawDirty) {
                    Switch($Script:ThePlayer.Stats[[StatId]::MagicPoints].State) {
                        ([StatNumberState]::Normal) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Caution) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Danger) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        Default {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }
                    }

                    Write-Host "$($a)"

                    # Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $this.PlayerMpDrawDirty = $false
                }
                If($this.PlayerGoldDrawDirty) {
                    [ATString]$p1 = [ATString]::new(
                        [ATStringPrefix]::new(
                            [Player]::GoldDrawColor,
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [StatusWindow]::PlayerGoldDrawCoordinates
                        ),
                        "$($Script:ThePlayer.CurrentGold)",
                        $false
                    )
                    [ATString]$p2 = [ATString]::new(
                        [ATStringPrefix]::new(
                            [CCTextDefault24]::new(),
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinatesNone]::new()
                        ),
                        'G',
                        $true
                    )

                    Write-Host "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())"

                    # Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $this.PlayerGoldDrawDirty = $false
                }
            }

            { $_ -EQ $Script:OsCheckWindows } {
                If($this.PlayerNameDrawDirty) {
                    [ATString]$a = [ATString]::new(
                        [ATStringPrefix]::new(
                            $Script:ThePlayer.NameDrawColor,
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [StatusWindow]::PlayerNameDrawCoordinates
                        ),
                        $Script:ThePlayer.Name,
                        $true
                    )
                    Write-Host "$($a.ToAnsiControlSequenceString())"

                    # Write-Host $Script:ThePlayer.GetFormattedNameString([StatusWindow]::PlayerNameDrawCoordinates)
                    $this.PlayerNameDrawDirty = $false
                }
                If($this.PlayerHpDrawDirty) {
                    [String]$a = ''

                    Switch($Script:ThePlayer.Stats[[StatId]::HitPoints].State) {
                        ([StatNumberState]::Normal) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Caution) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Danger) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        Default {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerHpDrawCoordinates
                                ),
                                'H ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }
                    }

                    Write-Host "$($a)"

                    # Write-Host $Script:ThePlayer.GetFormattedHitPointsString([StatusWindow]::PlayerHpDrawCoordinates)
                    $this.PlayerHpDrawDirty = $false
                }
                If($this.PlayerMpDrawDirty) {
                    Switch($Script:ThePlayer.Stats[[StatId]::MagicPoints].State) {
                        ([StatNumberState]::Normal) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Caution) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorCaution,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        ([StatNumberState]::Danger) {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorDanger,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecoration]::new($true),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }

                        Default {
                            [ATString]$p1 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [StatusWindow]::PlayerMpDrawCoordinates
                                ),
                                'M ',
                                $false
                            )
                            [ATString]$p2 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t",
                                $false
                            )
                            [ATString]$p3 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [CCTextDefault24]::new(),
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                '/ ',
                                $false
                            )
                            [ATString]$p4 = [ATString]::new(
                                [ATStringPrefix]::new(
                                    [BattleEntityProperty]::StatNumDrawColorSafe,
                                    [ATBackgroundColor24None]::new(),
                                    [ATDecorationNone]::new(),
                                    [ATCoordinatesNone]::new()
                                ),
                                "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)",
                                $true
                            )

                            $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                        }
                    }

                    Write-Host "$($a)"

                    # Write-Host $Script:ThePlayer.GetFormattedMagicPointsString([StatusWindow]::PlayerMpDrawCoordinates)
                    $this.PlayerMpDrawDirty = $false
                }
                If($this.PlayerGoldDrawDirty) {
                    [ATString]$p1 = [ATString]::new(
                        [ATStringPrefix]::new(
                            [Player]::GoldDrawColor,
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [StatusWindow]::PlayerGoldDrawCoordinates
                        ),
                        "$($Script:ThePlayer.CurrentGold)",
                        $false
                    )
                    [ATString]$p2 = [ATString]::new(
                        [ATStringPrefix]::new(
                            [CCTextDefault24]::new(),
                            [ATBackgroundColor24None]::new(),
                            [ATDecorationNone]::new(),
                            [ATCoordinatesNone]::new()
                        ),
                        'G',
                        $true
                    )

                    Write-Host "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())"

                    # Write-Host $Script:ThePlayer.GetFormattedGoldString([StatusWindow]::PlayerGoldDrawCoordinates)
                    $this.PlayerGoldDrawDirty = $false
                }
            }

            Default {}
        }
    }
}

Class CommandWindow : WindowBase {
    Static [Int]$CommandHistoryARef    = 0
    Static [Int]$CommandHistoryBRef    = 1
    Static [Int]$CommandHistoryCRef    = 2
    Static [Int]$CommandHistoryDRef    = 3
    Static [Int]$CommandHistoryERef    = 4
    Static [Int]$WindowLTRow           = 12
    Static [Int]$WindowLTColumn        = 1
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 19
    Static [Int]$DrawColumnOffset      = 1
    Static [Int]$DrawDivRowOffset      = 2
    Static [Int]$DrawHistoryDRowOffset = 3
    Static [Int]$DrawHistoryCRowOffset = 4
    Static [Int]$DrawHistoryBRowOffset = 5
    Static [Int]$DrawHistoryARowOffset = 6
    Static [Int]$DrawHistoryERowOffset = 7

    Static [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    Static [String]$WindowBorderVertical   = '|'
    Static [String]$WindowCommandDiv       = '``````````````````'

    Static [ATCoordinates]$CommandDivDrawCoordinates      = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryEDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryDDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryCDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$CommandHistoryADrawCoordinates = [ATCoordinatesNone]::new()

    Static [ConsoleColor24]$HistoryEntryValid   = [CCGreen24]::new()
    Static [ConsoleColor24]$HistoryEntryError   = [CCRed24]::new()
    Static [ConsoleColor24]$HistoryBlankColor   = [CCBlack24]::new()
    Static [ConsoleColor24]$CommandDivDrawColor = [CCWhite24]::new()
    Static [ATString]$CommandDiv                = [ATStringNone]::new()
    Static [ATString]$CommandBlank              = [ATStringNone]::new()
    Static [ATString]$CommandHistBlank          = [ATStringNone]::new()

    [ATString]$CommandActual
    [ATString[]]$CommandHistory

    [Boolean]$CommandDivDirty
    [Boolean]$CommandHistoryDirty

    CommandWindow() : base() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Command Window' -PercentComplete -1

        $this.LeftTop     = [ATCoordinates]::new([CommandWindow]::WindowLTRow, [CommandWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([CommandWindow]::WindowRBRow, [CommandWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )

        $this.BorderStrings = [String[]](
            [CommandWindow]::WindowBorderHorizontal,
            [CommandWindow]::WindowBorderVertical
        )

        $this.UpdateDimensions()

        $this.CommandDivDirty     = $true
        $this.CommandHistoryDirty = $false
        [Int]$rowBase             = $this.RightBottom.Row
        [Int]$columnBase          = $this.LeftTop.Column + [CommandWindow]::DrawColumnOffset

        [CommandWindow]::CommandDivDrawCoordinates      = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawDivRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryEDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryERowOffset, $columnBase)
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryDRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryCRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryBRowOffset, $columnBase)
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]::new($rowBase - [CommandWindow]::DrawHistoryARowOffset, $columnBase)

        [CommandWindow]::CommandDiv = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::CommandDivDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandDivDrawCoordinates
            ),
            [CommandWindow]::WindowCommandDiv,
            $true
        )
        [CommandWindow]::CommandBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::HistoryBlankColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new() # These can't yet be specified
            ),
            '                  ',
            $true
        )
        [CommandWindow]::CommandHistBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [CommandWindow]::HistoryBlankColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new() # These can't yet be specified
            ),
            '                  ',
            $true
        )

        $this.CommandActual                                       = [ATStringNone]::new()
        $this.CommandHistory                                      = New-Object 'ATString[]' 5 # This literal can't be codified; PS requires it be here
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryADrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryBDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryCDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryDDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [CommandWindow]::CommandHistoryEDrawCoordinates
            ),
            [CommandWindow]::CommandBlank.UserData,
            $true
        )
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.CommandDivDirty -EQ $true) {
            Write-Host "$([CommandWindow]::CommandDiv.ToAnsiControlSequenceString())"
            $this.CommandDivDirty = $false
        }

        If($this.CommandHistoryDirty -EQ $true) {
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryDDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryCDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryBDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryADrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].ToAnsiControlSequenceString())"

            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryEDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.CommandHistory[[CommandWindow]::CommandHistoryERef].ToAnsiControlSequenceString())"

            $this.CommandHistoryDirty = $false
        }
    }

    [Void]HandleInput() {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()

        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')

        While($keyCap.VirtualKeyCode -NE 13) {
            $cpx = $Script:Rui.CursorPosition.X

            If($cpx -GE 19) {
                $this.InvokeCommandParser()
            }

            Switch($keyCap.VirtualKeyCode) {
                8 { # Backspace
                    $fpx = $Script:Rui.CursorPosition.X
                    If($fpx -GT $Script:DefaultCursorCoordinates.Row) {
                        Write-Host " `b" -NoNewLine

                        If($this.CommandActual.UserData.Length -GT 0) {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                        }
                    } Elseif($fpx -LT $Script:DefaultCursorCoordinates.Row) {
                        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
                    } Elseif($fpx -EQ $Script:DefaultCursorCoordinates.Row) {
                        Write-Host " `b" -NoNewline

                        If($this.CommandActual.UserData.Length -GT 0) {
                            $this.CommandActual.UserData = $this.CommandActual.UserData.Remove($this.CommandActual.UserData.Length - 1, 1)
                        }
                    }
                }

                Default {
                    $this.CommandActual.UserData += $keyCap.Character
                }
            }

            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }

        $this.InvokeCommandParser()
    }

    [Void]InvokeCommandParser() {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        Write-Host "$([CommandWindow]::CommandBlank.ToAnsiControlSequenceString())" -NoNewline
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()

        If([String]::IsNullOrEmpty($this.CommandActual.UserData)) {
            Return
        } Else {
            $cmdactSplit = -SPLIT $this.CommandActual.UserData
            $rootFound   = $Script:TheCommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }

            If($null -NE $rootFound) {
                Switch($cmdactSplit.Length) {
                    1 {
                        Invoke-Command $rootFound.Value
                    }

                    2 {
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1]
                    }

                    3 {
                        Invoke-Command $rootFound.Value -ArgumentList $cmdactSplit[1], $cmdactSplit[2]
                    }

                    Default {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        # TODO: This is an exceptional case
                    }
                }
            } Else {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                Return
            }
        }
    }

    [Void]InvokeItemReactor(
        [String]$ItemName
    ) {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing

        If($a.Count -EQ 0) {
            # There are no objects on this map tile
            # TODO: Update the Command History with a valid response
            # TODO: Write to the message window that there weren't any items found
        }
    }

    [Void]InvokeLookAction() {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        $b = 78
        $c = ''
        $f = ''
        $z = 0
        $y = $false

        If($a.Count -LE 0) {
            $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()
            Return
        }

        Foreach($d in $a) {
            If($z -EQ $a.Count - 1) {
                $c += $d.Name
            } Else {
                $c += $d.Name + ', '
            }
            $z++
        }
        $e = $c.Length

        If($e -GT $b) {
            $y = $true
            $c -MATCH '([\s,]+\w+){5}$' | Out-Null
            If($_ -EQ $true) {
                $c = $c -REPLACE '([\s,]+\w+){5}$', ''
                $f = $matches[0].Remove(0, 2)
            }
        }

        $Script:TheMessageWindow.WriteMessage(
            'I can see the following things here:',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
        $Script:TheMessageWindow.WriteMessage(
            $c,
            [CCApplePinkDark24]::new(),
            [ATDecorationNone]::new()
        )

        If($y -EQ $true) {
            $Script:TheMessageWindow.WriteMessage(
                $f,
                [CCApplePinkDark24]::new(),
                [ATDecorationNone]::new()
            )
        }
    }

    [Void]InvokeExamineAction(
        [String]$ItemName
    ) {
        Foreach($a in $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:TheMessageWindow.WriteMessage(
                    "$($a.ExamineString)",
                    [CCAppleMintDark24]::new(),
                    [ATDecorationNone]::new()
                )
                Return
            }
        }

        $Script:TheCommandWindow.UpdateCommandHistory($false)
        $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)

        Return
    }

    [Void]InvokeGetAction(
        [String]$ItemName
    ) {
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing

        If($a.Count -LE 0) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()

            Return
        }

        Foreach($b in $a) {
            If($b.Name -IEQ $ItemName) {
                If($b.CanAddToInventory -EQ $true) {
                    $Script:ThePlayer.Inventory.Add($b) | Out-Null
                    $c = $a.Remove($b) | Out-Null

                    If($c -EQ $false) {
                        Write-Error 'Failed to remove an item from the Map Tile!'
                        Exit
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        $Script:TheMessageWindow.WriteItemTakenMessage($ItemName)

                        Return
                    }
                } Else {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteItemCantTakeMessage($ItemName)

                    Return
                }
            }
        }

        $Script:TheCommandWindow.UpdateCommandHistory($false)
        $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)

        Return
    }

    [Void]UpdateCommandHistory(
        [Boolean]$CmdValid
    ) {
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor

        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor

        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor

        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].UserData               = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.Decorations     = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef].Prefix.ForegroundColor = $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor

        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].UserData = $this.CommandActual.UserData

        If($CmdValid -EQ $true) {
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryValid
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations     = [ATDecorationNone]::new()
        } Else {
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.ForegroundColor = [CommandWindow]::HistoryEntryError
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations = [ATDecoration]::new($true)
        }

        $this.CommandActual.UserData = ''
        $this.CommandHistoryDirty    = $true
    }
}

Class SceneWindow : WindowBase {
    Static [Int]$WindowLTRow           = 1
    Static [Int]$WindowLTColumn        = 30
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 78
    Static [Int]$ImageDrawRowOffset    = [SceneWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [SceneWindow]::WindowLTColumn + 1


    Static [String]$WindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
    Static [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$SceneImageDrawCoordinates = [ATCoordinatesNone]::new()

    [Boolean]$SceneImageDirty = $true
    [SceneImage]$Image        = [SIEmpty]::new()

    SceneWindow(): base() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Scene Window' -PercentComplete -1
        $this.LeftTop          = [ATCoordinates]::new([SceneWindow]::WindowLTRow, [SceneWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([SceneWindow]::WindowRBRow, [SceneWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [SceneWindow]::WindowBorderHorizontal,
            [SceneWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        [SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]::new([SceneWindow]::ImageDrawRowOffset, [SceneWindow]::ImageDrawColumnOffset)
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.SceneImageDirty) {
            $this.Image = $Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.SceneImageDirty = $false
        }
    }

    [Void]UpdateCurrentImage([SceneImage]$NewImage) {
        $this.Image           = $NewImage
        $this.SceneImageDirty = $true
    }
}

Class MessageWindow : WindowBase {
    Static [Int]$MessageHistoryARef = 0
    Static [Int]$MessageHistoryBRef = 1
    Static [Int]$MessageHistoryCRef = 2
    Static [Int]$WindowLTRow        = 21
    Static [Int]$WindowLTColumn     = 1
    Static [Int]$WindowBRRow        = 26
    Static [Int]$WindowBRColumn     = 80

    Static [String]$WindowBorderHorizontal = '-------------------------------------------------------------------------------'
    Static [String]$WindowBorderVertical   = '|'

    Static [ATCoordinates]$MessageADrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageCDrawCoordinates = [ATCoordinatesNone]::new()

    Static [ATString]$MessageWindowBlank = [ATStringNone]::new()

    [ATString[]]$MessageHistory

    [Boolean]$MessageADirty = $false
    [Boolean]$MessageBDirty = $false
    [Boolean]$MessageCDirty = $false

    MessageWindow() : base() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Message Window' -PercentComplete -1

        $this.LeftTop          = [ATCoordinates]::new(21, 1)
        $this.RightBottom      = [ATCoordinates]::new(25, 78)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [MessageWindow]::WindowBorderHorizontal,
            [MessageWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        [MessageWindow]::MessageCDrawCoordinates = [ATCoordinates]::new(($this.RightBottom.Row - 1), ($this.LeftTop.Column + 1))
        [MessageWindow]::MessageBDrawCoordinates = [ATCoordinates]::new(([MessageWindow]::MessageCDrawCoordinates.Row - 1), ($this.LeftTop.Column + 1))
        [MessageWindow]::MessageADrawCoordinates = [ATCoordinates]::new(([MessageWindow]::MessageBDrawCoordinates.Row - 1), ($this.LeftTop.Column + 1))

        [MessageWindow]::MessageWindowBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [ATForegroundColor24None]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            '                                                                             ',
            $true
        )

        $this.MessageHistory = New-Object 'ATString[]' 3

        $this.MessageHistory[[MessageWindow]::MessageHistoryARef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [MessageWindow]::MessageADrawCoordinates
            ),
            [MessageWindow]::MessageWindowBlank.UserData,
            $true
        )
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [MessageWindow]::MessageBDrawCoordinates
            ),
            [MessageWindow]::MessageWindowBlank.UserData,
            $true
        )
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [MessageWindow]::MessageCDrawCoordinates
            ),
            [MessageWindow]::MessageWindowBlank.UserData,
            $true
        )
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.MessageADirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"

            $this.MessageADirty = $false
        }

        If($this.MessageBDirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"

            $this.MessageBDirty = $false
        }

        If($this.MessageCDirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Coordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"

            $this.MessageCDirty = $false
        }
    }

    [Void]WriteMessage([String]$Message, [ATForegroundColor24]$ForegroundColor, [ATDecoration]$Decoration) {
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor

        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor

        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData               = $Message
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor = $ForegroundColor
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations     = $Decoration

        # $this.MessageHistory[[MessageWindow]::MessageHistoryCRef] = [ATString]::new(
        #     [ATStringPrefix]::new(
        #         $ForegroundColor,
        #         [ATBackgroundColor24None]::new(),
        #         [ATDecorationNone]::new(),
        #         [MessageWindow]::MessageCDrawCoordinates
        #     ),
        #     $Message,
        #     $true
        # )

        $this.MessageADirty = $true
        $this.MessageBDirty = $true
        $this.MessageCDirty = $true
    }

    [Void]WriteBadCommandMessage([String]$Command) {
        $this.WriteMessage(
            "$($Command) isn't a valid command.",
            [CCAppleRedDark24]::new(),
            [ATDecoration]::new($true)
        )
    }

    [Void]WriteBadArg0Message([String]$Command, [String]$Arg0) {
        $this.WriteMessage(
            "We can't $($Command) with a(n) $($Arg0).",
            [CCAppleYellowDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteBadArg1Message([String]$Command, [String]$Arg0, [String]$Arg1) {
        $this.WriteMessage(
            "We can't $($Command) with a(n) $(Arg0) and a(n) $($Arg1).",
            [CCAppleYellowDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteSomethingBadMessage() {
        $this.WriteMessage(
            'I''m God, and even I don''t know what just happened...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteInvisibleWallEncounteredMessage() {
        $this.WriteMessage(
            'The invisible wall blocks your path...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteYouShallNotPassMessage() {
        $this.WriteMessage(
            'The path you asked for is impossible...',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteMapNoItemsFoundMessage() {
        $this.WriteMessage(
            'There''s nothing of interest here.',
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteMapInvalidItemMessage([String]$ItemName) {
        $this.WriteMessage(
            "There's no $($ItemName) here.",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteItemTakenMessage([String]$ItemName) {
        $this.WriteMessage(
            "I've taken the $($ItemName) and put it in my pocket.",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }

    [Void]WriteItemCantTakeMessage(
        [String]$ItemName
    ) {
        $this.WriteMessage(
            "It's not possible to take the $($ItemName).",
            [CCAppleIndigoDark24]::new(),
            [ATDecorationNone]::new()
        )
    }
}

Class InventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowBRRow    = 20
    Static [Int]$WindowBRColumn = 79

    Static [String]$WindowBorderHorizontal = '********************************************************************************'
    Static [String]$WindowBorderVertical   = '*'

    Static [String]$IChevronCharacter           = '>'
    Static [String]$IChevronBlankCharacter      = ' '
    Static [String]$PagingChevronRightCharacter = '>'
    Static [String]$PagingChevronLeftCharacter  = '<'
    Static [String]$PagingChevronBlankCharater  = ' '

    Static [String]$DivLineHorizontalString = '----------------------------------------------------------------------------'
    Static [String]$ZpLineBlank             = '                                                                             '

    Static [String]$DescLineBlank = '                                                                          '

    Static [ATString]$PagingChevronRight = [ATString]::new(
        [ATStringPrefix]::new(
            [CCAppleYellowLight24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 78)
        ),
        [InventoryWindow]::PagingChevronRightCharacter,
        $true
    )
    Static [ATString]$PagingChevronLeft = [ATString]::new(
        [ATStringPrefix]::new(
            [CCAppleYellowLight24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 3)
        ),
        [InventoryWindow]::PagingChevronLeftCharacter,
        $true
    )
    Static [ATString]$PagingChevronRightBlank = [ATString]::new(
        [ATStringPrefix]::new(
            [CCAppleMintLight24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 78)
        ),
        [InventoryWindow]::PagingChevronBlankCharater,
        $true
    )
    Static [ATString]$PagingChevronLeftBlank = [ATString]::new(
        [ATStringPrefix]::new(
            [ATForegroundColor24None]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(2, 3)
        ),
        [InventoryWindow]::PagingChevronBlankCharater,
        $true
    )

    Static [ATString]$DivLineHorizontal = [ATString]::new(
        [ATStringPrefix]::new(
            [CCTextDefault24]::new(),
            [ATBackgroundColor24None]::new(),
            [ATDecorationNone]::new(),
            [ATCoordinates]::new(13, 3)
        ),
        [InventoryWindow]::DivLineHorizontalString,
        $true
    )

    Static [Boolean]$DebugMode = $false

    Static [Int]$MoronCounter = 0

    Static [String]$ZeroPagePrompt = 'You have no items in your inventory.'

    [Boolean]$PlayerChevronDirty        = $true
    [Boolean]$PagingChevronRightDirty   = $true
    [Boolean]$PagingChevronLeftDirty    = $true
    [Boolean]$ItemsListDirty            = $true
    [Boolean]$CurrentPageDirty          = $true
    [Boolean]$PlayerChevronVisible      = $true
    [Boolean]$PagingChevronRightVisible = $false
    [Boolean]$PagingChevronLeftVisible  = $false
    [Boolean]$ZeroPageActive            = $false
    [Boolean]$MoronPageActive           = $false
    [Boolean]$BookDirty                 = $true
    [Boolean]$ActiveItemBlinking        = $false
    [Boolean]$DivLineDirty              = $true
    [Boolean]$ItemDescDirty             = $true
    [Boolean]$ZpBlankedDirty            = $true
    [Boolean]$ZpPromptDirty             = $true

    [Int]$ItemsPerPage             = 10
    [Int]$NumPages                 = 1
    [Int]$CurrentPage              = 1
    [List[MapTileObject]]$PageRefs = $null

    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks

    [Int]$ActiveIChevronIndex = 0

    InventoryWindow(): base() {
        $this.LeftTop     = [ATCoordinates]::new([InventoryWindow]::WindowLTRow, [InventoryWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([InventoryWindow]::WindowBRRow, [InventoryWindow]::WindowBRColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [InventoryWindow]::WindowBorderHorizontal,
            [InventoryWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()

        $this.PageRefs = [List[MapTileObject]]::new()

        $this.CreateIChevrons()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.BookDirty -EQ $true) {
            $this.CalculateNumPages()
            $this.BookDirty = $false
        }

        If($this.CurrentPageDirty -EQ $true) {
            $this.PopulatePage()
        }

        If($this.ZeroPageActive -EQ $true) {
            If($this.MoronPageActive -EQ $true) {
                $this.WriteMoronPage()
            } Else {
                $this.WriteZeroInventoryPage()
            }
        } Else {
            If($this.DivLineDirty -EQ $true) {
                Write-Host "$([InventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
                $this.DivLineDirty = $false
            }

            If($this.PlayerChevronVisible -EQ $true -AND $this.PlayerChevronDirty -EQ $true) {
                Foreach($ic in $this.IChevrons) {
                    Write-Host "$($ic.Item1.ToAnsiControlSequenceString())"
                }
                $this.PlayerChevronDirty = $false
            }

            If($this.NumPages -GT 1) {
                If($this.CurrentPage -EQ 1) {
                    If($this.PagingChevronLeftVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftVisible = $false
                        $this.PagingChevronLeftDirty = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $true -AND $this.PagingChevronRightDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                } Elseif($this.CurrentPage -GT 1 -AND $this.CurrentPage -LT $this.NumPages) {
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $true -AND $this.PagingChevronRightDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                    If($this.PagingChevronLeftVisible -EQ $true -AND $this.PagingChevronLeftDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    If($this.PagingChevronRightVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightVisible = $false
                        $this.PagingChevronRightDirty = $true
                    }
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If($this.PagingChevronLeftVisible -EQ $true -AND $this.PagingChevronLeftDirty -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                }
            } Elseif($this.NumPages -EQ 1) {
                # Both of the paging chevrons need hidden at this point since there aren't any more pages in the book... currently.
                If($this.PagingChevronLeftVisible -EQ $true) {
                    $this.PagingChevronLeftVisible = $false
                }
                If($this.PagingChevronRightVisible -EQ $true) {
                    $this.PagingChevronRightVisible = $false
                }
                If($this.PagingChevronLeftVisible -EQ $false) {
                    Write-Host "$([InventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                }
                If($this.PagingChevronRightVisible -EQ $false) {
                    Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                }
            }

            # Try to make the "active" Item Label blink
            If($this.ActiveItemBlinking -EQ $false) {
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()

                $this.ItemsListDirty     = $true
                $this.ActiveItemBlinking = $true
            }

            If($this.ItemsListDirty -EQ $true) {
                $this.WriteItemLabels()
                Write-Host "$([ATControlSequences]::CursorHide)"
                $this.ItemsListDirty = $false
            }

            If($this.ItemDescDirty -EQ $true) {
                [ATString]$b = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(15, 4)
                    ),
                    [InventoryWindow]::DescLineBlank,
                    $true
                )
                [ATString]$d = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(15, 4)
                    ),
                    $this.PageRefs[$this.ActiveIChevronIndex].ExamineString,
                    $true
                )
                [ATString]$f = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(16, 4)
                    ),
                    [InventoryWindow]::DescLineBlank,
                    $true
                )
                [ATString]$e = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCApplePinkLight24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(16, 4)
                    ),
                    $this.PageRefs[$this.ActiveIChevronIndex].PlayerEffectString,
                    $true
                )
                [ATString]$h = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(17, 4)
                    ),
                    [InventoryWindow]::DescLineBlank,
                    $true
                )
                [ATString]$i = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCAppleYellowLight24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecoration]::new($true),
                        [ATCoordinates]::new(17, 4)
                    ),
                    ($this.PageRefs[$this.ActiveIChevronIndex].KeyItem -EQ $true ? 'KEY ITEM': ''),
                    $true
                )

                Write-Host "$($b.ToAnsiControlSequenceString())"
                Write-Host "$($d.ToAnsiControlSequenceString())"
                Write-Host "$($f.ToAnsiControlSequenceString())"
                Write-Host "$($e.ToAnsiControlSequenceString())"
                Write-Host "$($h.ToAnsiControlSequenceString())"
                Write-Host "$($i.ToAnsiControlSequenceString())"
            }
        }
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 15)
                ),
                [InventoryWindow]::IChevronCharacter,
                $true
            ),
            $true
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 15)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [CCAppleGreenLight24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 50)
                ),
                [InventoryWindow]::IChevronBlankCharacter,
                $false
            ),
            $false
        ))
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c          = 0

        Foreach($i in $this.PageRefs) {
            $this.ItemLabels.Add(
                [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(
                            $this.IChevrons[$c].Item1.Prefix.Coordinates.Row,
                            $this.IChevrons[$c].Item1.Prefix.Coordinates.Column + 2
                        )
                    ),
                    $i.Name,
                    $true
                )
            )
            $c++ # FYI - This was intentional
        }

        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 17)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(3, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(5, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(7, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(9, 52)
                ),
                '               ',
                $true
            )
        )
        $this.ItemLabelBlanks.Add(
            [ATString]::new(
                [ATStringPrefix]::new(
                    [ATForegroundColor24None]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(11, 52)
                ),
                '               ',
                $true
            )
        )
    }

    [Void]CalculateNumPages() {
        $pp = $Script:ThePlayer.Inventory.Count / $this.ItemsPerPage
        If($pp -LT 1) {
            $this.NumPages = 1
        } Else {
            $this.NumPages = [Math]::Ceiling($pp)
        }
    }

    [Void]TurnPageForward() {
        If(($this.CurrentPage + 1) -LE $this.NumPages) {
            $this.CurrentPage++
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]TurnPageBackward() {
        If(($this.CurrentPage - 1) -GE 1) {
            $this.CurrentPage--
            $this.CurrentPageDirty   = $true
            $this.ActiveItemBlinking = $false
            $this.ItemDescDirty      = $true
        }
    }

    [Void]PopulatePage() {
        If($Script:ThePlayer.Inventory.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            $this.ZpPromptDirty    = $true
            $this.ZpBlankedDirty   = $true

            If([InventoryWindow]::MoronCounter -LT 20) {
                [InventoryWindow]::MoronCounter++
            } Else {
                $this.MoronPageActive = $true
            }
        } Else {
            $this.PageRefs        = [List[MapTileObject]]::new()
            $this.ZeroPageActive  = $false
            $this.MoronPageActive = $false
            $rs                   = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage)
            $rs                   = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                   = 10


            Try {
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, $re)
            } Catch {
                $this.PageRefs = $Script:ThePlayer.Inventory.GetRange($rs, ($Script:ThePlayer.Inventory.Count - $rs))
            }

            $this.CreateItemLabels()

            $this.ItemsListDirty   = $true
            $this.CurrentPageDirty = $false
        }
    }

    [Void]WriteItemLabels() {
        Foreach($i in $this.ItemLabelBlanks) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
        Foreach($i in $this.ItemLabels) {
            Write-Host "$($i.ToAnsiControlSequenceString())"
        }
    }

    [ATString]GetActiveIChevron() {
        $this.ActiveIChevronIndex = 0

        Foreach($a in $this.IChevrons) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
            $this.ActiveIChevronIndex++
        }

        $this.ActiveIChevronIndex = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2 = $true
        Return $this.IChevrons[$this.ActiveIChevronIndex].Item1
    }

    [Void]WriteZeroInventoryPage() {
        If($this.ZpBlankedDirty -EQ $true) {
            Foreach($a in 2..19) {
                [ATString]$b = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCTextDefault24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new($a, 2)
                    ),
                    [InventoryWindow]::ZpLineBlank,
                    $true
                )
                Write-Host "$($b.ToAnsiControlSequenceString())"
            }
            $this.ZpBlankedDirty = $false
        }
        If($this.ZpPromptDirty -EQ $true) {
            [ATString]$a = [ATString]::new(
                [ATStringPrefix]::new(
                    [CCTextDefault24]::new(),
                    [ATBackgroundColor24None]::new(),
                    [ATDecorationNone]::new(),
                    [ATCoordinates]::new(
                        $this.Height / 2,
                        ($this.Width / 2) - ([InventoryWindow]::ZeroPagePrompt.Length / 2)
                    )
                ),
                [InventoryWindow]::ZeroPagePrompt,
                $true
            )
    
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ZpPromptDirty = $false
        }
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPosition() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = [InventoryWindow]::IChevronBlankCharacter

        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {}

        $this.ActiveIChevronIndex                                          = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()

        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ItemDescDirty      = $true
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            27 {
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 {
                If(($this.ActiveIChevronIndex - 1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()

                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            40 {
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()

                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            39 {
                If(($this.ActiveIChevronIndex + 5) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()

                    $this.ActiveIChevronIndex += 5

                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            37 {
                If(($this.ActiveIChevronIndex -5) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronBlankCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()

                    $this.ActiveIChevronIndex -= 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = [InventoryWindow]::IChevronCharacter
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]::new($true)
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }

                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            68 {
                $this.TurnPageForward()
            }

            65 {
                $this.TurnPageBackward()
            }

            83 {
                # This is the drop item functionality
                Switch($this.CurrentPage) {
                    1 {
                        [ItemRemovalStatus]$a = $Script:ThePlayer.RemoveInventoryItemByIndex($this.ActiveIChevronIndex)
                        If($a -EQ [ItemRemovalStatus]::Success) {
                            [Console]::Beep(493.9, 250)
                            [Console]::Beep((493.9 * 2), 250)

                            $this.BookDirty        = $true
                            $this.CurrentPageDirty = $true

                            Return
                        }
                        [Console]::Beep(493.9, 250)
                        [Console]::Beep((493.9 / 2), 250)
                    }

                    { $_ -GT 1 } {
                        [Int]$a               = ((10 * ($this.CurrentPage - 1)) + $this.ActiveIChevronIndex) - 1
                        [ItemRemovalStatus]$b = $Script:ThePlayer.RemoveInventoryItemByIndex($a)
                        If($b -EQ [ItemRemovalStatus]::Success) {
                            [Console]::Beep(493.9, 250)
                            [Console]::Beep((493.9 * 2), 250)

                            $this.BookDirty        = $true
                            $this.CurrentPageDirty = $true

                            Return
                        }

                        [Console]::Beep(493.9, 250)
                        [Console]::Beep((493.9 / 2), 250)
                    }
                }
            }
        }
    }
}

Class BattleEntityStatusWindow : WindowBase {
    # Static [Int]$WindowLTRow    = 1
    # Static [Int]$WindowLTColumn = 1
    # Static [Int]$WindowBRRow    = 17
    # Static [Int]$WindowBRColumn = 19

    Static [String]$WindowBorderHorizontal = '*------------------*'
    Static [String]$WindowBorderVertical   = '|'

    Static [String]$FullLineBlankActual = '                 '

    [ATCoordinates]$NameDrawCoordinates   = [ATCoordinatesNone]::new()
    [ATCoordinates]$HpDrawCoordinates     = [ATCoordinatesNone]::new()
    [ATCoordinates]$MpDrawCoordinates     = [ATCoordinatesNone]::new()
    [ATCoordinates]$StatL1DrawCoordinates = [ATCoordinatesNone]::new() # Attack/Defense
    [ATCoordinates]$StatL2DrawCoordinates = [ATCoordinatesNone]::new() # MAT/MDF
    [ATCoordinates]$StatL3DrawCoordinates = [ATCoordinatesNone]::new() # SPD/AGL
    [ATCoordinates]$StatL4DrawCoordinates = [ATCoordinatesNone]::new() # LCK

    [Int]$WindowLTRow    = 0
    [Int]$WindowLTColumn = 0
    [Int]$WindowBRRow    = 0
    [Int]$WindowBRColumn = 0
    
    [Boolean]$NameDrawDirty   = $true
    [Boolean]$HpDrawDirty     = $true
    [Boolean]$MpDrawDirty     = $true
    [Boolean]$StatL1DrawDirty = $true
    [Boolean]$StatL2DrawDirty = $true
    [Boolean]$StatL3DrawDirty = $true
    [Boolean]$StatL4DrawDirty = $true

    [ATString]$FullLineBlank      = [ATStringNone]::new()
    [ATString]$NameDrawString     = [ATStringNone]::new()
    [ATString[]]$HpDrawString     = @([ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new())
    [ATString[]]$MpDrawString     = @([ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new())
    [ATString[]]$StatL1DrawString = @([ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new())
    [ATString[]]$StatL2DrawString = @([ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new())
    [ATString[]]$StatL3DrawString = @([ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new())
    [ATString[]]$StatL4DrawString = @([ATStringNone]::new(), [ATStringNone]::new(), [ATStringNone]::new())

    [BattleEntity]$BERef = $null

    BattleEntityStatusWindow(): base() {
        $this.LeftTop     = [ATCoordinates]::new($this.WindowLTRow, $this.WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new($this.WindowBRRow, $this.WindowBRColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [BattleEntityStatusWindow]::WindowBorderHorizontal,
            [BattleEntityStatusWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()
        
        $this.FullLineBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [ATForegroundColor24None]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            [BattleEntityStatusWindow]::FullLineBlankActual,
            $true
        )
    }

    BattleEntityStatusWindow(
        [Int]$LTRow,
        [Int]$LTColumn,
        [Int]$BRRow,
        [Int]$BRColumn,
        [BattleEntity]$BERef = $null
    ): base() {
        $this.WindowLTRow    = $LTRow
        $this.WindowLTColumn = $LTColumn
        $this.WindowBRRow    = $BRRow
        $this.WindowBRColumn = $BRColumn
        $this.LeftTop        = [ATCoordinates]::new($this.WindowLTRow, $this.WindowLTColumn)
        $this.RightBottom    = [ATCoordinates]::new($this.WindowBRRow, $this.WindowBRColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [BattleEntityStatusWindow]::WindowBorderHorizontal,
            [BattleEntityStatusWindow]::WindowBorderVertical
        )
        $this.UpdateDimensions()
        
        $this.FullLineBlank = [ATString]::new(
            [ATStringPrefix]::new(
                [ATForegroundColor24None]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            [BattleEntityStatusWindow]::FullLineBlankActual,
            $true
        )

        $this.BERef = $BERef

        # Update the element draw coordinates relative to the dimensions of the window
        $this.NameDrawCoordinates   = [ATCoordinates]::new($this.LeftTop.Row + 1, $this.LeftTop.Column + 2)
        $this.HpDrawCoordinates     = [ATCoordinates]::new($this.LeftTop.Row + 2, $this.LeftTop.Column + 2)
        $this.MpDrawCoordinates     = [ATCoordinates]::new($this.LeftTop.Row + 5, $this.LeftTop.Column + 2)
        $this.StatL1DrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + 9, $this.LeftTop.Column + 2)
        $this.StatL2DrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + 11, $this.LeftTop.Column + 2)
        $this.StatL3DrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + 13, $this.LeftTop.Column + 2)
        $this.StatL4DrawCoordinates = [ATCoordinates]::new($this.LeftTop.Row + 15, $this.LeftTop.Column + 2)
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.NameDrawDirty -EQ $true) {
            $this.CreateNameDrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.NameDrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.NameDrawString.ToAnsiControlSequenceString())"

            $this.NameDrawDirty = $false
        }
        If($this.HpDrawDirty -EQ $true) {
            $this.CreateHpDrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.HpDrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            $this.FullLineBlank.Prefix.Coordinates.Row++
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.HpDrawString[0].ToAnsiControlSequenceString())$($this.HpDrawString[1].ToAnsiControlSequenceString())$($this.HpDrawString[2].ToAnsiControlSequenceString())$($this.HpDrawString[3].ToAnsiControlSequenceString())"

            $this.HpDrawDirty = $false
        }
        If($this.MpDrawDirty -EQ $true) {
            $this.CreateMpDrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.MpDrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            $this.FullLineBlank.Prefix.Coordinates.Row++
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.MpDrawString[0].ToAnsiControlSequenceString())$($this.MpDrawString[1].ToAnsiControlSequenceString())$($this.MpDrawString[2].ToAnsiControlSequenceString())$($this.MpDrawString[3].ToAnsiControlSequenceString())"

            $this.MpDrawDirty = $false
        }
        If($this.StatL1DrawDirty -EQ $true) {
            $this.CreateStatL1DrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.StatL1DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.StatL1DrawString[0].ToAnsiControlSequenceString())$($this.StatL1DrawString[1].ToAnsiControlSequenceString())$($this.StatL1DrawString[2].ToAnsiControlSequenceString())$($this.StatL1DrawString[3].ToAnsiControlSequenceString())$($this.StatL1DrawString[4].ToAnsiControlSequenceString())$($this.StatL1DrawString[5].ToAnsiControlSequenceString())"

            $this.StatL1DrawDirty = $false
        }
        If($this.StatL2DrawDirty -EQ $true) {
            $this.CreateStatL2DrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.StatL2DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.StatL2DrawString[0].ToAnsiControlSequenceString())$($this.StatL2DrawString[1].ToAnsiControlSequenceString())$($this.StatL2DrawString[2].ToAnsiControlSequenceString())$($this.StatL2DrawString[3].ToAnsiControlSequenceString())$($this.StatL2DrawString[4].ToAnsiControlSequenceString())$($this.StatL2DrawString[5].ToAnsiControlSequenceString())"

            $this.StatL2DrawDirty = $false
        }
        If($this.StatL3DrawDirty -EQ $true) {
            $this.CreateStatL3DrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.StatL3DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.StatL3DrawString[0].ToAnsiControlSequenceString())$($this.StatL3DrawString[1].ToAnsiControlSequenceString())$($this.StatL3DrawString[2].ToAnsiControlSequenceString())$($this.StatL3DrawString[3].ToAnsiControlSequenceString())$($this.StatL3DrawString[4].ToAnsiControlSequenceString())$($this.StatL3DrawString[5].ToAnsiControlSequenceString())"

            $this.StatL3DrawDirty = $false
        }
        If($this.StatL4DrawDirty -EQ $true) {
            $this.CreateStatL4DrawString()

            $this.FullLineBlank.Prefix.Coordinates = $this.StatL4DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            Write-Host "$($this.StatL4DrawString[0].ToAnsiControlSequenceString())$($this.StatL4DrawString[1].ToAnsiControlSequenceString())$($this.StatL4DrawString[2].ToAnsiControlSequenceString())"

            $this.StatL4DrawDirty = $false
        }
    }

    [Void]CreateNameDrawString() {
        $this.NameDrawString = [ATString]::new(
            [ATStringPrefix]::new(
                [ATForegroundColor24None]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.NameDrawCoordinates
            ),
            $this.BERef.Name,
            $true
        )
    }

    [Void]CreateHpDrawString() {
        [ConsoleColor24]$NumDrawColor = [CCTextDefault24]::new()

        Switch($this.BERef.Stats[[StatId]::HitPoints].State) {
            ([StatNumberState]::Normal) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }

            ([StatNumberState]::Caution) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorCaution
            }

            ([StatNumberState]::Danger) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
            }

            Default {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }
        }

        $this.HpDrawString[0] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.HpDrawCoordinates
            ),
            'H ',
            $false
        )
        $this.HpDrawString[1] = [ATString]::new(
            [ATStringPrefix]::new(
                $NumDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            "$($this.BERef.Stats[[StatId]::HitPoints].Base)",
            $false
        )
        $this.HpDrawString[2] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinates]::new($this.HpDrawCoordinates.Row + 2, $this.HpDrawCoordinates.Column + 6)
            ),
            '/ ',
            $false
        )
        $this.HpDrawString[3] = [ATString]::new(
            [ATStringPrefix]::new(
                $NumDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            "$($this.BERef.Stats[[StatId]::HitPoints].Max)",
            $true
        )
    }

    [Void]CreateMpDrawString() {
        [ConsoleColor24]$NumDrawColor = [CCTextDefault24]::new()

        Switch($this.BERef.Stats[[StatId]::MagicPoints].State) {
            ([StatNumberState]::Normal) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }

            ([StatNumberState]::Caution) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorCaution
            }

            ([StatNumberState]::Danger) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
            }

            Default {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }
        }

        $this.MpDrawString[0] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.MpDrawCoordinates
            ),
            'M ',
            $false
        )
        $this.MpDrawString[1] = [ATString]::new(
            [ATStringPrefix]::new(
                $NumDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            "$($this.BERef.Stats[[StatId]::MagicPoints].Base)",
            $false
        )
        $this.MpDrawString[2] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinates]::new($this.MpDrawCoordinates.Row + 2, $this.MpDrawCoordinates.Column + 6)
            ),
            '/ ',
            $false
        )
        $this.MpDrawString[3] = [ATString]::new(
            [ATStringPrefix]::new(
                $NumDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            "$($this.BERef.Stats[[StatId]::MagicPoints].Max)",
            $true
        )
    }

    [Void]CreateStatL1DrawString() {
        [BattleEntityProperty]$AtkStat = $this.BERef.Stats[[StatId]::Attack]
        [BattleEntityProperty]$DefStat = $this.BERef.Stats[[StatId]::Defense]
        [ConsoleColor24]$AtkDrawColor  = [CCTextDefault24]::new()
        [ConsoleColor24]$DefDrawColor  = [CCTextDefault24]::new()
        [String]$AtkStatSignStr        = ''
        [String]$DefStatSignStr        = ''
        [String]$AtkStatFmtStr         = ''
        [String]$DefStatFmtStr         = ''

        If($AtkStat.AugmentTurnDuration -GT 0) {
            Switch($AtkStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $AtkDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $AtkStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $AtkDrawColor   = [BattleEntityProperty]::StatNumDrawDanger
                    $AtkStatSignStr = '-'
                }

                Default {
                    $AtkDrawColor   = [CCTextDefault24]::new()
                    $AtkStatSignStr = ' '
                }
            }
        } Else {
            $AtkDrawColor = [CCTextDefault24]::new()
            $AtkStatSignStr = ' '
        }
        If($AtkStat.Base -LT 10) {
            $AtkStatFmtStr = "{0:d2}" -F $AtkStat.Base
        } Elseif($AtkStat.Base -GE 10) {
            $AtkStatFmtStr = "$($AtkStat.Base)"
        }

        If($DefStat.AugmentTurnDuration -GT 0) {
            Switch($DefStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $DefDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $DefStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $DefDrawColor   = [BattleEntityProperty]::StatNumDrawDanger
                    $DefStatSignStr = '-'
                }

                Default {
                    $DefDrawColor = [CCTextDefault24]::new()
                    $DefStatSignStr = ' '
                }
            }
        } Else {
            $DefDrawColor   = [CCTextDefault24]::new()
            $DefStatSignStr = ' '
        }
        If($DefStat.Base -LT 10) {
            $DefStatFmtStr = "{0:d2}" -F $DefStat.Base
        } Elseif($DefStat.Base -GE 10) {
            $DefStatFmtStr = "$($DefStat.Base)"
        }

        # Attack Portion - 0 = ' ATK '
        $this.StatL1DrawString[0] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.StatL1DrawCoordinates
            ),
            'ATK ',
            $false
        )

        # Attack Portion - 1 = Sign Indicator
        $this.StatL1DrawString[1] = [ATString]::new(
            [ATStringPrefix]::new(
                $AtkDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $AtkStatSignStr,
            $false
        )

        # Attack Portion - 2 = Attack Stat Value
        $this.StatL1DrawString[2] = [ATString]::new(
            [ATStringPrefix]::new(
                $AtkDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $AtkStatFmtStr,
            $false
        )

        # Defense Portion - 3 = ' DEF '
        $this.StatL1DrawString[3] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            ' DEF ',
            $false
        )

        # Defense Portion - 4 Sign Indicator
        $this.StatL1DrawString[4] = [ATString]::new(
            [ATStringPrefix]::new(
                $DefDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $DefStatSignStr,
            $false
        )

        # Defense Portion - 5 Defense Stat Value
        $this.StatL1DrawString[5] = [ATString]::new(
            [ATStringPrefix]::new(
                $DefDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $DefStatFmtStr,
            $true
        )
    }

    [Void]CreateStatL2DrawString() {
        [BattleEntityProperty]$MatStat = $this.BERef.Stats[[StatId]::MagicAttack]
        [BattleEntityProperty]$MdfStat = $this.BERef.Stats[[StatId]::MagicDefense]
        [ConsoleColor24]$MatDrawColor  = [CCTextDefault24]::new()
        [ConsoleColor24]$MdfDrawColor  = [CCTextDefault24]::new()
        [String]$MatStatSignStr        = ''
        [String]$MdfStatSignStr        = ''
        [String]$MatStatFmtStr         = ''
        [String]$MdfStatFmtStr         = ''

        If($MatStat.AugmentTurnDuration -GT 0) {
            Switch($MatStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $MatDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $MatStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $MatDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
                    $MatStatSignStr = '-'
                }

                Default {
                    $MatDrawColor = [CCTextDefault24]::new()
                    $MatStatSignStr = ' '
                }
            }
        } Else {
            $MatDrawColor   = [CCTextDefault24]::new()
            $MatStatSignStr = ' '
        }
        If($MatStat.Base -LT 10) {
            $MatStatFmtStr = "{0:d2}" -F $MatStat.Base
        } Elseif($MatStat.Base -GE 10) {
            $MatStatFmtStr = "$($MatStat.Base)"
        }

        If($MdfStat.AugmentTurnDuration -GT 0) {
            Switch($MdfStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $MdfDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $MdfStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $MdfDrawColor   = [BattleEntityProperty]::StatNumDrawColorDanger
                    $MdfStatSignStr = '-'
                }

                Default {
                    $MdfDrawColor   = [CCTextDefault24]::new()
                    $MdfStatSignStr = ' '
                }
            }
        } Else {
            $MdfDrawColor   = [CCTextDefault24]::new()
            $MdfStatSignStr = ' '
        }
        If($MdfStat.Base -LT 10) {
            $MdfStatFmtStr = "{0:d2}" -F $MdfStat.Base
        } Elseif($MdfStat.Base -GE 10) {
            $MdfStatFmtStr = "$($MdfStat.Base)"
        }

        # Magic Attack Portion - 0 = ' MAT '
        $this.StatL2DrawString[0] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.StatL2DrawCoordinates
            ),
            'MAT ',
            $false
        )

        # Magic Attack Portion - 1 = Sign Indicator
        $this.StatL2DrawString[1] = [ATString]::new(
            [ATStringPrefix]::new(
                $MatDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $MatStatSignStr,
            $false
        )

        # Magic Attack Portion - 2 = Magic Attack Stat Value
        $this.StatL2DrawString[2] = [ATString]::new(
            [ATStringPrefix]::new(
                $MatDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $MatStatFmtStr,
            $false
        )

        # Magic Defense Portion - 3 = ' MDF '
        $this.StatL2DrawString[3] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            ' MDF ',
            $false
        )

        # Magic Defense Portion - 4 Sign Indicator
        $this.StatL2DrawString[4] = [ATString]::new(
            [ATStringPrefix]::new(
                $MdfDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $MdfStatSignStr,
            $false
        )

        # Magic Defense Portion - 5 Magic Defense Stat Value
        $this.StatL2DrawString[5] = [ATString]::new(
            [ATStringPrefix]::new(
                $MdfDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $MdfStatFmtStr,
            $true
        )
    }

    [Void]CreateStatL3DrawString() {
        [BattleEntityProperty]$SpdStat = $this.BERef.Stats[[StatId]::Speed]
        [BattleEntityProperty]$AccStat = $this.BERef.Stats[[StatId]::Accuracy]
        [ConsoleColor24]$SpdDrawColor  = [CCTextDefault24]::new()
        [ConsoleColor24]$AccDrawColor  = [CCTextDefault24]::new()
        [String]$SpdStatSignStr        = ''
        [String]$AccStatSignStr        = ''
        [String]$SpdStatFmtStr         = ''
        [String]$AccStatFmtStr         = ''

        If($SpdStat.AugmentTurnDuration -GT 0) {
            Switch($SpdStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $SpdDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $SpdStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $SpdDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
                    $SpdStatSignStr = '-'
                }

                Default {
                    $SpdDrawColor   = [CCTextDefault24]::new()
                    $SpdStatSignStr = ' '
                }
            }
        } Else {
            $SpdDrawColor   = [CCTextDefault24]::new()
            $SpdStatSignStr = ' '
        }
        If($SpdStat.Base -LT 10) {
            $SpdStatFmtStr = "{0:d2}" -F $SpdStat.Base
        } Elseif($SpdStat.Base -GE 10) {
            $SpdStatFmtStr = "$($SpdStat.Base)"
        }

        If($AccStat.AugmentTurnDuration -GT 0) {
            Switch($AccStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $AccDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $AccStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $AccDrawColor   = [BattleEntityProperty]::StatNumDrawColorDanger
                    $AccStatSignStr = '-'
                }

                Default {
                    $AccDrawColor   = [CCTextDefault24]::new()
                    $AccStatSignStr = ' '
                }
            }
        } Else {
            $AccDrawColor   = [CCTextDefault24]::new()
            $AccStatSignStr = ' '
        }
        If($AccStat.Base -LT 10) {
            $AccStatFmtStr = "{0:d2}" -F $AccStat.Base
        } Elseif($AccStat.Base -GE 10) {
            $AccStatFmtStr = "$($AccStat.Base)"
        }

        # Speed Portion - 0 = ' SPD '
        $this.StatL3DrawString[0] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.StatL3DrawCoordinates
            ),
            'SPD ',
            $false
        )

        # Speed Portion - 1 = Sign Indicator
        $this.StatL3DrawString[1] = [ATString]::new(
            [ATStringPrefix]::new(
                $SpdDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $SpdStatSignStr,
            $false
        )

        # Speed Portion - 2 = Speed Stat Value
        $this.StatL3DrawString[2] = [ATString]::new(
            [ATStringPrefix]::new(
                $SpdDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $SpdStatFmtStr,
            $false
        )

        # Accuracy Portion - 3 = ' ACC '
        $this.StatL3DrawString[3] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            ' ACC ',
            $false
        )

        # Accuracy Portion - 4 Sign Indicator
        $this.StatL3DrawString[4] = [ATString]::new(
            [ATStringPrefix]::new(
                $AccDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $AccStatSignStr,
            $false
        )

        # Accuracy Portion - 5 Accuracy Stat Value
        $this.StatL3DrawString[5] = [ATString]::new(
            [ATStringPrefix]::new(
                $AccDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $AccStatFmtStr,
            $true
        )
    }

    [Void]CreateStatL4DrawString() {
        [BattleEntityProperty]$LckStat = $this.BERef.Stats[[StatId]::Luck]
        [ConsoleColor24]$LckDrawColor  = [CCTextDefault24]::new()
        [String]$LckStatSignStr        = ''
        [String]$LckStatFmtStr         = ''

        If($LckStat.AugmentTurnDuration -GT 0) {
            Switch($LckStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $LckDrawColor   = [BattleEntityProperty]::StatNumDrawColorSafe
                    $LckStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $LckDrawColor   = [BattleEntityProperty]::StatNumDrawColorDanger
                    $LckStatSignStr = '-'
                }

                Default {
                    $LckDrawColor   = [CCTextDefault24]::new()
                    $LckStatSignStr = ' '
                }
            }
        } Else {
            $LckDrawColor   = [CCTextDefault24]::new()
            $LckStatSignStr = ' '
        }
        If($LckStat.Base -LT 10) {
            $LckStatFmtStr = "{0:d2}" -F $LckStat.Base
        } Elseif($LckStat.Base -GE 10) {
            $LckStatFmtStr = "$($LckStat.Base)"
        }

        $this.StatL4DrawString[0] = [ATString]::new(
            [ATStringPrefix]::new(
                [CCTextDefault24]::new(),
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                $this.StatL4DrawCoordinates
            ),
            'LCK ',
            $false
        )
        $this.StatL4DrawString[1] = [ATString]::new(
            [ATStringPrefix]::new(
                $LckDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $LckStatSignStr,
            $false
        )
        $this.StatL4DrawString[2] = [ATString]::new(
            [ATStringPrefix]::new(
                $LckDrawColor,
                [ATBackgroundColor24None]::new(),
                [ATDecorationNone]::new(),
                [ATCoordinatesNone]::new()
            ),
            $LckStatFmtStr,
            $true
        )
    }
}

Class GameCore {
    [Int]$TargetFrameRate
    [Single]$MsPerFrame
    [Boolean]$GameRunning
    [Double]$LastFrameTime
    [Double]$CurrentFrameTime
    [TimeSpan]$FpsDelta

    GameCore() {
        Write-Progress -Activity 'Creating ''global'' variables' -Id 1 -Status 'Creating the Game Core' -PercentComplete -1

        $this.TargetFrameRate      = 30
        $this.MsPerFrame           = 1000 / $this.TargetFrameRate
        $this.GameRunning          = $true
        $this.LastFrameTime        = 0D
        $this.CurrentFrameTime     = 0D
        $this.FpsDelta             = [TimeSpan]::Zero
        $Script:TheGlobalGameState = [GameStatePrimary]::BattleScreen
    }

    [Void]Run() {
        While($this.GameRunning -EQ $true) {
            $this.Logic()
            # "GameCore::Run - `t`tSetting LastFrameTime ($($this.LastFrameTime)) to CurrentFrameTime ($($this.CurrentFrameTime))." | Out-File -FilePath $Script:LogFileName -Append
            # $this.LastFrameTime = $this.CurrentFrameTime

            # "GameCore::Run - `t`tSetting CurrentFrameTime ($($this.CurrentFrameTime)) to the current time in ticks ($([DateTime]::Now.Ticks))." | Out-File -FilePath $Script:LogFileName -Append
            # $this.CurrentFrameTime = [DateTime]::Now.Ticks

            # "GameCore::Run - `t`tChecking to see if CurrentFrameTime ($($this.CurrentFrameTime)) minus LastFrameTime ($($this.LastFrameTime)) is GREATER THAN OR EQUAL TO MsPerFrame ($($this.MsPerFrame))." | Out-File -FilePath $Script:LogFileName -Append
            # "GameCore::Run - `t`tThe equation is $($this.CurrentFrameTime) - $($this.LastFrameTime) >= $($this.MsPerFrame)" | Out-File -FilePath $Script:LogFileName -Append
            # If(($this.CurrentFrameTime - $this.LastFrameTime) -GE $this.MsPerFrame) {
            #     "GameCore::Run - `t`t`tThe value is GREATER THAN OR EQUAL TO MsPerFrame." | Out-File -FilePath $Script:LogFileName -Append
            #     "GameCore::Run - `t`t`tSet FpsDelta to a new TimeSpan of CurrentFrameTime minus LastFrameTime." | Out-File -FilePath $Script:LogFileName -Append
            #     $this.FpsDelta = [TimeSpan]::new($this.CurrentFrameTime - $this.LastFrameTime)

            #     "GameCore::Run - `t`t`tCall the Logic method." | Out-File -FilePath $Script:LogFileName -Append
            #     $this.Logic()
            # }
        }
    }

    [Void]Logic() {
        Invoke-Command $Script:TheGlobalStateBlockTable[$Script:TheGlobalGameState]
    }
}

# FUNCTION DEFINITIONS

Function Test-GfmOs {
    [CmdletBinding()]
    Param ()

    Process {
        Get-PSDrive -Name Variable | Out-Null
        If ($?) {
            Get-ChildItem Variable:/IsLinux | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsLinux).Value -EQ $true) {
                    Return $Script:OsCheckLinux
                }
            }

            Get-ChildItem Variable:/IsMacOS | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsMacOS).Value -EQ $true) {
                    Return $Script:OsCheckMac
                }
            }

            Get-ChildItem Variable:/IsWindows | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsWindows).Value -EQ $true) {
                    Return $Script:OsCheckWindows
                }
            }
        }

        Return $Script:OsCheckUnknown
    }
}

# RUNNER
Clear-Host

#$Script:TheStatusWindow.Draw()
#$Script:TheCommandWindow.Draw()
#$Script:TheSceneWindow.Draw()
#$Script:TheMessageWindow.Draw()
#$Script:TheMessageWindow.WriteMessage('This is a sample message', [CCAppleGreenLight24]::new())
#$Script:TheMessageWindow.WriteMessage('This is a another message', [CCAppleMintLight24]::new())
#$Script:TheMessageWindow.WriteMessage('>> This is yet ANOTHER message', [CCAppleRedLight24]::new())

$Script:ThePlayer.Inventory.Add([MTOLadder]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStairs]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOLadder]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOStairs]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOTree]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOMilk]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOMilk]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOMilk]::new()) | Out-Null

$Script:SampleMap.Tiles[0, 0] = [MapTile]::new(
    $Script:FieldNorthEastRoadImage,
    @(
        [MTOApple]::new(),
        [MTOTree]::new(),
        [MTOLadder]::new(),
        [MTORope]::new(),
        [MTOStairs]::new(),
        [MTOPole]::new()
    ),
    @(
        $true,
        $false,
        $true,
        $false
    )
)
$Script:SampleMap.Tiles[0, 1] = [MapTile]::new(
    $Script:FieldNorthWestRoadImage,
    @(
        [MTOApple]::new()
    ),
    @(
        $true,
        $false,
        $false,
        $true
    )
)
$Script:SampleMap.Tiles[1, 0] = [MapTile]::new(
    $Script:FieldSouthEastRoadImage,
    @(
        [MTOTree]::new()
    ),
    @(
        $false,
        $true,
        $true,
        $false
    )
)
$Script:SampleMap.Tiles[1, 1] = [MapTile]::new(
    $Script:FieldSouthWestRoadImage,
    @(
        [MTOTree]::new()
    ),
    @(
        $false,
        $true,
        $false,
        $true
    )
)

$Script:TheGameCore.Run()

#$Script:TheInventoryWindow.Draw()

# While(1) {
#     $Script:TheStatusWindow.Draw()
#     $Script:TheCommandWindow.Draw()
#     $Script:TheSceneWindow.Draw()
#     $Script:TheMessageWindow.Draw()
#     $Script:TheCommandWindow.HandleInput()
# }

#$(Get-Host).UI.RawUI.CursorPosition = [ATCoordinatesDefault]::new().ToAutomationCoordinates()
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 2); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 4); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 6); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 8); Write-Host '>' -NoNewline -ForegroundColor 12
# $(Get-Host).UI.RawUI.CursorPosition = [Coordinates]::new(5, 10); Write-Host '>' -NoNewline -ForegroundColor 12

#Read-Host
