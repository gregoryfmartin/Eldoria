using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host
using namespace System.Media

Add-Type -AssemblyName PresentationCore




###############################################################################
#
# GLOBAL VARIABLES
#
###############################################################################
[String]                          $Script:SfxUiChevronMove             = "$(Get-Location)\Assets\SFX\UI Chevron Move.wav"
[String]                          $Script:SfxUiSelectionValid          = "$(Get-Location)\Assets\SFX\UI Selection Valid.wav"
[String]                          $Script:SfxBaPhysicalStrikeA         = "$(Get-Location)\Assets\SFX\BA Physical Strike 0001.wav"
[String]                          $Script:SfxBaMissFail                = "$(Get-Location)\Assets\SFX\BA Miss Fail.wav"
[String]                          $Script:SfxBaActionDisabled          = "$(Get-Location)\Assets\SFX\BA Action Disabled.wav"
[String]                          $Script:SfxBaFireStrikeA             = "$(Get-Location)\Assets\SFX\BA Fire Strike 0001.wav"
[String]                          $Script:SfxBattleIntro               = "$(Get-Location)\Assets\SFX\Battle Intro.wav"
[String]                          $Script:SfxBattlePlayerWin           = "$(Get-Location)\Assets\SFX\Battle Player Win.wav"
[String]                          $Script:SfxBattlePlayerLose          = "$(Get-Location)\Assets\SFX\Battle Player Lose.wav"
[String]                          $Script:BgmBattleThemeA              = "$(Get-Location)\Assets\BGM\Battle Theme A.wav"
[String]                          $Script:SfxBattleNem                 = "$(Get-Location)\Assets\SFX\UI Selection NEM.wav"
[String[]]                        $Script:BadCommandRetorts            = @()
[StatusWindow]                    $Script:TheStatusWindow              = [StatusWindow]::new()
[CommandWindow]                   $Script:TheCommandWindow             = [CommandWindow]::new()
[SceneWindow]                     $Script:TheSceneWindow               = [SceneWindow]::new()
[MessageWindow]                   $Script:TheMessageWindow             = [MessageWindow]::new()
[InventoryWindow]                 $Script:TheInventoryWindow           = $null
[ATCoordinatesDefault]            $Script:DefaultCursorCoordinates     = [ATCoordinatesDefault]::new()
[BattleEntityStatusWindow]        $Script:ThePlayerBattleStatWindow    = $null
[BattleEntityStatusWindow]        $Script:TheEnemyBattleStatWindow     = $null
[BattlePlayerActionWindow]        $Script:ThePlayerBattleActionWindow  = $null
[BattleStatusMessageWindow]       $Script:TheBattleStatusMessageWindow = $null
[BattleEnemyImageWindow]          $Script:TheBattleEnemyImageWindow    = $null
[StatusHudWindow]                 $Script:TheStatusHudWindow           = $null
[StatusTechniqueSelectionWindow]  $Script:TheStatusTechSelectionWindow = $null
[StatusTechniqueInventoryWindow]  $Script:TheStatusTechInventoryWindow = $null
[BufferManager]                   $Script:TheBufferManager             = [BufferManager]::new()
[GameCore]                        $Script:TheGameCore                  = [GameCore]::new()
[EnemyBattleEntity]               $Script:TheCurrentEnemy              = $null
[BattleManager]                   $Script:TheBattleManager             = $null
[Boolean]                         $Script:IsBattleBgmPlaying           = $false
[Boolean]                         $Script:HasBattleIntroPlayed         = $false
[Boolean]                         $Script:HasBattleWonChimePlayed      = $false
[Boolean]                         $Script:HasBattleLostChimePlayed     = $false
[EEIBat]                          $Script:EeiBat                       = [EEIBat]::new()
[EEINightwing]                    $Script:EeiNightwing                 = [EEINightwing]::new()
[EEIWingblight]                   $Script:EeiWingblight                = [EEIWingblight]::new()
[EEIDarkfang]                     $Script:EeiDarkfang                  = [EEIDarkfang]::new()
[EEINocturna]                     $Script:EeiNocturna                  = [EEINocturna]::new()
[EEIBloodswoop]                   $Script:EeiBloodswoop                = [EEIBloodswoop]::new()
[EEIDuskbane]                     $Script:EeiDuskbane                  = [EEIDuskbane]::new()
[System.Windows.Media.MediaPlayer]$Script:TheSfxMPlayer                = [System.Windows.Media.MediaPlayer]::new()
[System.Windows.Media.MediaPlayer]$Script:TheBgmMPlayer                = [System.Windows.Media.MediaPlayer]::new()
[Double]                          $Script:AffinityMultNeg              = -0.75
[Double]                          $Script:AffinityMultPos              = 1.6
[ActionSlot]                      $Script:StatusEsSelectedSlot         = [ActionSlot]::None
[BattleAction]                    $Script:StatusIsSelected             = $null
[StatusScreenMode]                $Script:StatusScreenMode             = [StatusScreenMode]::EquippedTechSelection




###############################################################################
#
# ENUMERATION DEFINITIONS
#
###############################################################################
Enum GameStatePrimary {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    InventoryScreen
    BattleScreen
    PlayerStatusScreen
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

Enum ItemRemovalStatus {
    Success
    FailGeneral
    FailKeyItem
}

Enum ActionInvRemovalStatus {
    Success
    Fail
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

Enum StatusScreenMode {
    EquippedTechSelection
    TechInventorySelection
}




###############################################################################
#
# GLOBAL VARIABLE INITIALIZATIONS
#
###############################################################################
$Script:BadCommandRetorts = @(
    'Huh?',
    'Do what now?',
    'Come again?',
    'Pardon?',
    'Y U no type rite?',
    'Bruh...',
    'Are you drunk?',
    'Your commands are sus.',
    'Git gud, scrub.',
    'Did you RTFM?',
    'git commit -am "Eye kant spell"',
    'ceuwcnesckldsc',
    '843214385321832904'
)

[Map]$Script:SampleMap   = [Map]::new('Sample Map', 2, 2, $false)
[Map]$Script:CurrentMap  = $Script:SampleMap
[Map]$Script:PreviousMap = $null

[SIFieldNorthRoad]        $Script:FieldNorthRoadImage         = [SIFieldNorthRoad]::new()
[SIFieldNorthEastRoad]    $Script:FieldNorthEastRoadImage     = [SIFieldNorthEastRoad]::new()
[SIFieldNorthWestRoad]    $Script:FieldNorthWestRoadImage     = [SIFieldNorthWestRoad]::new()
[SIFieldNorthEastWestRoad]$Script:FieldNorthEastWestRoadImage = [SIFieldNorthEastWestRoad]::new()
[SIFieldSouthRoad]        $Script:FieldSouthRoadImage         = [SIFieldSouthRoad]::new()
[SIFieldSouthEastRoad]    $Script:FieldSouthEastRoadImage     = [SIFieldSouthEastRoad]::new()
[SIFieldSouthWestRoad]    $Script:FieldSouthWestRoadImage     = [SIFieldSouthWestRoad]::new()
[SIFieldSouthEastWestRoad]$Script:FieldSouthEastWestRoadImage = [SIFieldSouthEastWestRoad]::new()

$Script:Rui = $(Get-Host).UI.RawUI

[Boolean]$Script:GpsRestoredFromInvBackup = $true
[Boolean]$Script:GpsRestoredFromBatBackup = $false
[Boolean]$Script:GpsRestoredFromStaBackup = $false
[Boolean]$Script:BattleCursorVisible      = $false

$Script:BattleEncounterRegionTable = @{
    0 = @(
        'EEBat',
        'EENightwing',
        'EEWingblight',
        'EEDarkfang',
        'EENocturna',
        'EEBloodswoop',
        'EEDuskbane'
    )
}

$Script:BATAdornmentCharTable = @{
    [BattleActionType]::Physical         = [Tuple[[String], [ConsoleColor24]]]::new("`u{2022}", [CCTextDefault24]::new())
    [BattleActionType]::ElementalFire    = [Tuple[[String], [ConsoleColor24]]]::new("`u{03B6}", [CCAppleRedLight24]::new())
    [BattleActionType]::ElementalWater   = [Tuple[[String], [ConsoleColor24]]]::new("`u{03C8}", [CCAppleBlueLight24]::new())
    [BattleActionType]::ElementalEarth   = [Tuple[[String], [ConsoleColor24]]]::new("`u{03B5}", [CCAppleBrownLight24]::new())
    [BattleActionType]::ElementalWind    = [Tuple[[String], [ConsoleColor24]]]::new("`u{03C6}", [CCAppleGreenLight24]::new())
    [BattleActionType]::ElementalLight   = [Tuple[[String], [ConsoleColor24]]]::new("`u{03BC}", [CCAppleYellowLight24]::new())
    [BattleActionType]::ElementalDark    = [Tuple[[String], [ConsoleColor24]]]::new("`u{03B4}", [CCApplePurpleDark24]::new())
    [BattleActionType]::ElementalIce     = [Tuple[[String], [ConsoleColor24]]]::new("`u{03B9}", [CCAppleCyanDark24]::new())
    [BattleActionType]::MagicPoison      = [Tuple[[String], [ConsoleColor24]]]::new("`u{03BE}", [CCAppleIndigoLight24]::new())
    [BattleActionType]::MagicConfuse     = [Tuple[[String], [ConsoleColor24]]]::new("`u{0398}", [CCAppleCyanDark24]::new())
    [BattleActionType]::MagicSleep       = [Tuple[[String], [ConsoleColor24]]]::new("`u{03B7}", [CCAppleGrey4Light24]::new())
    [BattleActionType]::MagicAging       = [Tuple[[String], [ConsoleColor24]]]::new("`u{03C3}", [CCAppleGrey6Light24]::new())
    [BattleActionType]::MagicHealing     = [Tuple[[String], [ConsoleColor24]]]::new("`u{20AA}", [CCAppleMintLight24]::new())
    [BattleActionType]::MagicStatAugment = [Tuple[[String], [ConsoleColor24]]]::new("`u{20B9}", [CCAppleOrangeLight24]::new())
}




###############################################################################
#
# COMMAND TABLE DEFINITION
#
###############################################################################
$Script:TheCommandTable = @{
    'move' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'move',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('move', '')

                Return
            } Else {
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
        
                    Default {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteBadCommandMessage('move')
        
                        Return
                    }
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return
        }

        Return
    }

    'm' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'move',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('move', '')

                Return
            } Else {
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
        
                    Default {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteBadCommandMessage('m')
        
                        Return
                    }
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return
        }

        Return
    }

    'look' = {
        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'look',
                $args
            )
        }

        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheCommandWindow.InvokeLookAction()

        Return
    }

    'l' = {
        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'look',
                $args
            )
        }

        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheCommandWindow.InvokeLookAction()

        Return
    }

    'inventory' = {
        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'inventory',
                $args
            )
        }
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

        Return
    }

    'i' = {
        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'inventory',
                $args
            )
        }
        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

        Return
    }

    'examine' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'examine',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('examine', '')

                Return
            } Else {
                $Script:TheCommandWindow.InvokeExamineAction($a0)
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return
        }

        Return
    }

    'exa' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'examine',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('examine', '')

                Return
            } Else {
                $Script:TheCommandWindow.InvokeExamineAction($a0)
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return
        }

        Return
    }

    'get' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'get',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('get', '')

                Return
            } Else {
                $Script:TheCommandWindow.InvokeGetAction($a0)
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return 
        }

        Return
    }

    'g' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'get',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('get', '')

                Return
            } Else {
                $Script:TheCommandWindow.InvokeGetAction($a0)
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return 
        }

        Return
    }

    'take' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'take',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('take', '')

                Return
            } Else {
                $Script:TheCommandWindow.InvokeGetAction($a0)
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return 
        }

        Return
    }

    't' = {
        Param(
            [String]$a0
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'take',
                $args
            )
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If([String]::IsNullOrEmpty($a0) -EQ $true) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadArg0Message('take', '')

                Return
            } Else {
                $Script:TheCommandWindow.InvokeGetAction($a0)
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            
            Return 
        }

        Return
    }

    'use' = {
        Param(
            [String]$a0,
            [String]$a1
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'use',
                $args
            )
        }

        If(($PSBoundParameters.ContainsKey('a0') -EQ $true) -AND ($PSBoundParameters.ContainsKey('a1') -EQ $true)) {
            If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().IsItemInTile($a1) -EQ $true) {
                    [MapTileObject]$pi  = $Script:ThePlayer.GetItemReference($a0)
                    [MapTileObject]$mti = $Script:CurrentMap.GetTileAtPlayerCoordinates().GetItemReference($a1)

                    If($mti.ValidateSourceInFilter($pi.PSTypeNames[0]) -EQ $true) {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        Invoke-Command $mti.Effect -ArgumentList $mti, $pi
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessageComposite(
                            @(
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    'Can''t use a(n) '
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleYellowDark24]::new(),
                                    [ATDecoration]::new($true),
                                    $a0
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' on a(n) '
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleYellowDark24]::new(),
                                    [ATDecoration]::new($true),
                                    $a1
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    '.'
                                )
                            )
                        )
                    }
                } Else {
                    If($a1 -IEQ 'self') {
                        [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)

                        # This code is problematic if the filter has no items in it
                        If($Script:ThePlayer.ValidateSourceInFilter($pi.PSTypeNames[0]) -EQ $true) {
                            $Script:TheCommandWindow.UpdateCommandHistory($true)
                            Invoke-Command $pi.Effect -ArgumentList $pi, $Script:ThePlayer
                        } Else {
                            $Script:TheCommandWindow.UpdateCommandHistory($false)
                            $Script:TheMessageWindow.WriteMessageComposite(
                                @(
                                    [ATStringCompositeSc]::new(
                                        [CCAppleRedDark24]::new(),
                                        [ATDecorationNone]::new(),
                                        'I can''t use '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowDark24]::new(),
                                        [ATDecoration]@{
                                            Blink      = $true
                                            Italic     = $true
                                            Underline  = $true
                                            Strikethru = $false
                                        },
                                        $a0
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleRedDark24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' on myself.'
                                    )
                                )
                            )
                        }
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessageComposite(
                            @(
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    "$($Script:BadCommandRetorts | Get-Random)"
                                )
                            )
                        )
                    }
                }
            } Else {
                # The item isn't in the Player's Inventory, thus rendering this an inoperable command (despite not being syntactically invalid).
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            'You don''t seem to have any '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            ' in your pocket(s).'
                        )
                    )
                )

                Return
            }
        } Elseif(($PSBoundParameters.ContainsKey('a0') -EQ $true) -AND ((-NOT $PSBoundParameters.ContainsKey('a1')) -EQ $true)) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)

            If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            'You need to tell me what you want to use the '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            ' on.'
                        )
                    )
                )
            } Else {
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            'I have no idea how to use a(n) '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            '.'
                        )
                    )
                )
            }
        } Elseif(((-NOT $PSBoundParameters.ContainsKey('a0')) -EQ $true) -AND ((-NOT $PSBoundParameters.ContainsKey('a1')) -EQ $true)) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNRedDark24]::new(),
                        [ATDecorationNone]::new(),
                        "$($Script:BadCommandRetorts | Get-Random)"
                    )
                )
            )
        }
    }

    'u' = {
        Param(
            [String]$a0,
            [String]$a1
        )

        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'use',
                $args
            )
        }

        If(($PSBoundParameters.ContainsKey('a0') -EQ $true) -AND ($PSBoundParameters.ContainsKey('a1') -EQ $true)) {
            If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().IsItemInTile($a1) -EQ $true) {
                    [MapTileObject]$pi  = $Script:ThePlayer.GetItemReference($a0)
                    [MapTileObject]$mti = $Script:CurrentMap.GetTileAtPlayerCoordinates().GetItemReference($a1)

                    If($mti.ValidateSourceInFilter($pi.PSTypeNames[0]) -EQ $true) {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        Invoke-Command $mti.Effect -ArgumentList $mti, $pi
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessageComposite(
                            @(
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    'Can''t use a(n) '
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleYellowDark24]::new(),
                                    [ATDecoration]::new($true),
                                    $a0
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' on a(n) '
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleYellowDark24]::new(),
                                    [ATDecoration]::new($true),
                                    $a1
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    '.'
                                )
                            )
                        )
                    }
                } Else {
                    If($a1 -IEQ 'self') {
                        [MapTileObject]$pi = $Script:ThePlayer.GetItemReference($a0)

                        # This code is problematic if the filter has no items in it
                        If($Script:ThePlayer.ValidateSourceInFilter($pi.PSTypeNames[0]) -EQ $true) {
                            $Script:TheCommandWindow.UpdateCommandHistory($true)
                            Invoke-Command $pi.Effect -ArgumentList $pi, $Script:ThePlayer
                        } Else {
                            $Script:TheCommandWindow.UpdateCommandHistory($false)
                            $Script:TheMessageWindow.WriteMessageComposite(
                                @(
                                    [ATStringCompositeSc]::new(
                                        [CCAppleRedDark24]::new(),
                                        [ATDecorationNone]::new(),
                                        'I can''t use '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowDark24]::new(),
                                        [ATDecoration]@{
                                            Blink      = $true
                                            Italic     = $true
                                            Underline  = $true
                                            Strikethru = $false
                                        },
                                        $a0
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleRedDark24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' on myself.'
                                    )
                                )
                            )
                        }
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($false)
                        $Script:TheMessageWindow.WriteMessageComposite(
                            @(
                                [ATStringCompositeSc]::new(
                                    [CCAppleRedDark24]::new(),
                                    [ATDecorationNone]::new(),
                                    "$($Script:BadCommandRetorts | Get-Random)"
                                )
                            )
                        )
                    }
                }
            } Else {
                # The item isn't in the Player's Inventory, thus rendering this an inoperable command (despite not being syntactically invalid).
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            'You don''t seem to have any '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            ' in your pocket(s).'
                        )
                    )
                )

                Return
            }
        } Elseif(($PSBoundParameters.ContainsKey('a0') -EQ $true) -AND ((-NOT $PSBoundParameters.ContainsKey('a1')) -EQ $true)) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)

            If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            'You need to tell me what you want to use the '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            ' on.'
                        )
                    )
                )
            } Else {
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            'I have no idea how to use a(n) '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecorationNone]::new(),
                            '.'
                        )
                    )
                )
            }
        } Elseif(((-NOT $PSBoundParameters.ContainsKey('a0')) -EQ $true) -AND ((-NOT $PSBoundParameters.ContainsKey('a1')) -EQ $true)) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNRedDark24]::new(),
                        [ATDecorationNone]::new(),
                        "$($Script:BadCommandRetorts | Get-Random)"
                    )
                )
            )
        }
    }

    'drop' = {
        Param(
            [String]$a0
        )

        If($args.Length -GE 1) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNYellowDark24]::new(),
                        [ATDecorationNone]::new(),
                        'Can''t drop all those items at once, bruh.'
                    )
                )
            )

            Return
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
                If($Script:ThePlayer.RemoveInventoryItemByName($a0) -EQ [ItemRemovalStatus]::Success) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteMessageComposite(
                        @(
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                'Dropped '
                            ),
                            [ATStringCompositeSc]::new(
                                [CCAppleNYellowDark24]::new(),
                                [ATDecoration]@{
                                    Blink = $true
                                },
                                "$($a0)"
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' from your inventory.'
                            )
                        )
                    )

                    Return
                } Else {
                    # WARNING
                    # At this point, this branch is considered a fatal error
                    # There really should be a better way of handling this, however
                    Exit
                }
            } Else {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'There ain''t no '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            ' in your pockets guv''.'
                        )
                    )
                )

                Return
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNRedDark24]::new(),
                        [ATDecorationNone]::new(),
                        "$($Script:BadCommandRetorts | Get-Random)"
                    )
                )
            )

            Return
        }
    }

    'd' = {
        Param(
            [String]$a0
        )

        If($args.Length -GE 1) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNYellowDark24]::new(),
                        [ATDecorationNone]::new(),
                        'Can''t drop all those items at once, bruh.'
                    )
                )
            )

            Return
        }

        If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
            If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
                If($Script:ThePlayer.RemoveInventoryItemByName($a0) -EQ [ItemRemovalStatus]::Success) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteMessageComposite(
                        @(
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                'Dropped '
                            ),
                            [ATStringCompositeSc]::new(
                                [CCAppleNYellowDark24]::new(),
                                [ATDecoration]@{
                                    Blink = $true
                                },
                                "$($a0)"
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' from your inventory.'
                            )
                        )
                    )

                    Return
                } Else {
                    # WARNING
                    # At this point, this branch is considered a fatal error
                    # There really should be a better way of handling this, however
                    Exit
                }
            } Else {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMessageComposite(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'There ain''t no '
                        ),
                        [ATStringCompositeSc]::new(
                            [CCAppleYellowDark24]::new(),
                            [ATDecoration]::new($true),
                            $a0
                        ),
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            ' in your pockets guv''.'
                        )
                    )
                )

                Return
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNRedDark24]::new(),
                        [ATDecorationNone]::new(),
                        "$($Script:BadCommandRetorts | Get-Random)"
                    )
                )
            )

            Return
        }
    }

    'status' = {
        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'use',
                $args
            )
        }

        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::PlayerStatusScreen
    }

    'sta' = {
        # Check for unbound arguments
        If($args.Length -GT 0) {
            $Script:TheMessageWindow.WriteCmdExtraArgsWarning(
                'use',
                $args
            )
        }

        $Script:TheCommandWindow.UpdateCommandHistory($true)
        $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
        $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
        $Script:TheGlobalGameState         = [GameStatePrimary]::PlayerStatusScreen
    }
}




###############################################################################
#
# GLOBAL STATE BLOCK TABLE DEFINITION
#
###############################################################################
$Script:TheGlobalStateBlockTable = @{
    [GameStatePrimary]::SplashScreenA = {}

    [GameStatePrimary]::SplashScreenB = {}

    [GameStatePrimary]::TitleScreen = {}

    [GameStatePrimary]::PlayerSetupScreen = {}

    [GameStatePrimary]::GamePlayScreen = {
        If($null -NE $Script:TheInventoryWindow) {
            $Script:TheInventoryWindow = $null
        }
        If($null -NE $Script:TheBattleManager) {
            $Script:TheBattleManager.Cleanup()
            $Script:TheBattleManager = $null
        }
        If($null -NE $Script:TheStatusHudWindow) {
            $Script:TheStatusHudWindow = $null
        }
        If($null -NE $Script:TheStatusTechSelectionWindow) {
            $Script:TheStatusTechSelectionWindow = $null
        }
        If($null -NE $Script:TheStatusTechInventoryWindow) {
            $Script:TheStatusTechInventoryWindow = $null
        }

        If(($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::InventoryScreen) -AND ($Script:GpsRestoredFromInvBackup -EQ $false)) {
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
            Write-Host "$([ATControlSequences]::CursorShow)"
        } Elseif(($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::BattleScreen) -AND ($Script:GpsRestoredFromBatBackup -EQ $false)) {
            $Script:TheBufferManager.RestoreBufferAToActive()
            
            # Force redraws of the content; a restoration from a buffer capture will NOT retain the 24-bit color information
            # and I really don't feel like trying to figure out how to grab the buffer manually
            $Script:GpsRestoredFromBatBackup             = $true
            $Script:TheSceneWindow.SceneImageDirty       = $true
            $Script:TheStatusWindow.PlayerNameDrawDirty  = $true
            $Script:TheStatusWindow.PlayerHpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerMpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerGoldDrawDirty  = $true
            $Script:TheCommandWindow.CommandHistoryDirty = $true
            $Script:TheMessageWindow.MessageADirty       = $true
            $Script:TheMessageWindow.MessageBDirty       = $true
            $Script:TheMessageWindow.MessageCDirty       = $true
            Write-Host "$([ATControlSequences]::CursorShow)"
        } Elseif(($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::PlayerStatusScreen) -AND ($Script:GpsRestoredFromStaBackup -EQ $false)) {
            $Script:TheBufferManager.RestoreBufferAToActive()
            
            # Force redraws of the content; a restoration from a buffer capture will NOT retain the 24-bit color information
            # and I really don't feel like trying to figure out how to grab the buffer manually
            $Script:GpsRestoredFromStaBackup             = $true
            $Script:TheSceneWindow.SceneImageDirty       = $true
            $Script:TheStatusWindow.PlayerNameDrawDirty  = $true
            $Script:TheStatusWindow.PlayerHpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerMpDrawDirty    = $true
            $Script:TheStatusWindow.PlayerGoldDrawDirty  = $true
            $Script:TheCommandWindow.CommandHistoryDirty = $true
            $Script:TheMessageWindow.MessageADirty       = $true
            $Script:TheMessageWindow.MessageBDirty       = $true
            $Script:TheMessageWindow.MessageCDirty       = $true
            Write-Host "$([ATControlSequences]::CursorShow)"
        }

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
        If($Script:HasBattleIntroPlayed -EQ $false) {
            If($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::GamePlayScreen) {
                [ATString]$Banner = [ATString]::new(
                    [ATStringPrefix]::new(
                        [CCAppleMintLight24]::new(),
                        [ATBackgroundColor24None]::new(),
                        [ATDecorationNone]::new(),
                        [ATCoordinates]::new(7, 40 - (15 / 2))
                    ),
                    'BATTLE COMMENCE',
                    $true
                )
                Write-Host "$($Banner.ToAnsiControlSequenceString())"
                Write-Host "$([ATControlSequences]::CursorHide)"
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxBattleIntro)
                    $Script:TheSfxMPlayer.Play()
                } Catch {}
                Start-Sleep -Seconds 1.75
                Clear-Host
            }
            $Script:HasBattleIntroPlayed = $true
        }
        If($null -EQ $Script:TheBattleManager) {
            $Script:TheBattleManager = [BattleManager]::new()
        }
        If($Script:GpsRestoredFromBatBackup -EQ $true) {
            $Script:GpsRestoredFromBatBackup = $false
        }
        If($Script:IsBattleBgmPlaying -EQ $false) {
            $Script:TheBgmMPlayer.Open($Script:BgmBattleThemeA)
            $Script:TheBgmMPlayer.Volume = 0.5
            $Script:TheBgmMPlayer.Play()
            $Script:IsBattleBgmPlaying = $true
        }
        $Script:TheBattleManager.Update()
    }

    [GameStatePrimary]::PlayerStatusScreen = {
        Write-Host "$([ATControlSequences]::CursorHide)"
        $Script:Rui.CursorPosition = [Coordinates]::new(1, 1)

        If($null -EQ $Script:TheStatusHudWindow) {
            $Script:TheStatusHudWindow = [StatusHudWindow]::new()
        }
        If($null -EQ $Script:TheStatusTechSelectionWindow) {
            $Script:TheStatusTechSelectionWindow = [StatusTechniqueSelectionWindow]::new()
        }
        If($null -EQ $Script:TheStatusTechInventoryWindow) {
            $Script:TheStatusTechInventoryWindow = [StatusTechniqueInventoryWindow]::new()
        }
        If($Script:GpsRestoredFromStaBackup -EQ $true) {
            $Script:GpsRestoredFromStaBackup = $false
        }
        $Script:TheStatusHudWindow.Draw()
        $Script:TheStatusTechSelectionWindow.Draw()
        $Script:TheStatusTechInventoryWindow.Draw()
        Switch($Script:StatusScreenMode) {
            ([StatusScreenMode]::EquippedTechSelection) {
                If($Script:TheStatusTechSelectionWindow.IsActive -NE $true) {
                    $Script:TheStatusTechSelectionWindow.SetAllActionDrawDirty()
                    $Script:TheStatusTechSelectionWindow.IsActive = $true
                }
                If($Script:TheStatusTechInventoryWindow.IsActive -NE $false) {
                    $Script:TheStatusTechInventoryWindow.IsActive = $false
                    $Script:TheStatusTechInventoryWindow.SetFlagsDirty()
                }
                $Script:TheStatusTechSelectionWindow.PlayerChevronDirty = $true # Now the redraw should work... hopefully
                $Script:TheStatusTechSelectionWindow.Draw() # See if this trips the Chevron color change; didn't work :'(
                $Script:TheStatusTechInventoryWindow.Draw()
                $Script:TheStatusTechSelectionWindow.HandleInput()
                $Script:TheStatusTechSelectionWindow.Draw()
            }

            ([StatusScreenMode]::TechInventorySelection) {
                If($Script:TheStatusTechSelectionWindow.IsActive -NE $false) {
                    $Script:TheStatusTechSelectionWindow.IsActive = $false
                }
                If($Script:TheStatusTechInventoryWindow.IsActive -NE $true) {
                    $Script:TheStatusTechInventoryWindow.IsActive = $true
                }
                $Script:TheStatusTechSelectionWindow.PlayerChevronDirty = $true # Now the redraw should work... hopefully
                $Script:TheStatusTechSelectionWindow.Draw() # See if this trips the Chevron color change; didn't work :'(
                $Script:TheStatusTechInventoryWindow.Draw()
                $Script:TheStatusTechInventoryWindow.HandleInput()
                $Script:TheStatusTechInventoryWindow.Draw()
            }

            Default {
                # Do nothing
                # Because I'm a fucking genius
            }
        }
    }

    [GameStatePrimary]::Cleanup = {}
}
[GameStatePrimary]$Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState