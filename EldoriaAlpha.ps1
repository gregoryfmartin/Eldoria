using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host
using namespace System.Media

Add-Type -AssemblyName PresentationCore

Set-StrictMode -Version Latest





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

Enum FnlNoiseType {
    OpenSimplex2
    OpenSimplex2S
    Cellular
    Perlin
    ValueCubic
    Value
}

Enum FnlRotationType3D {
    None
    ImproveXYPlanes
    ImproveXZPlanes
}

Enum FnlFractalType {
    None
    FBm
    Ridged
    PingPong
    DomainWarpProgressive
    DomainWarpIndependent
}

Enum FnlCellularDistanceFunction {
    Euclidean
    EuclideanSq
    Manhattan
    Hybrid
}

Enum FnlCellularReturnType {
    CellValue
    Distance
    Distance2
    Distance2Add
    Distance2Sub
    Distance2Mul
    Distance2Div
}

Enum FnlDomainWarpType {
    OpenSimplex2
    OpenSimplex2Reduced
    BasicGrid
}

Enum FnlTransformType3D {
    None
    ImproveXYPlanes
    ImproveXZPlanes
    DefaultOpenSimplex2
}





###############################################################################
#
# GLOBAL VARIABLE DECLARATIONS
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
[BattlePhaseIndicator]            $Script:TheBattlePhaseIndicator      = $null
[StatusHudWindow]                 $Script:TheStatusHudWindow           = $null
[StatusTechniqueSelectionWindow]  $Script:TheStatusTechSelectionWindow = $null
[StatusTechniqueInventoryWindow]  $Script:TheStatusTechInventoryWindow = $null
[BufferManager]                   $Script:TheBufferManager             = [BufferManager]::new()
[GameCore]                        $Script:TheGameCore                  = [GameCore]::new()
[EnemyBattleEntity]               $Script:TheCurrentEnemy              = $null
[BattleManager]                   $Script:TheBattleManager             = $null
[SoundPlayer]                     $Script:TheSfxMachine                = [SoundPlayer]::new()
[SoundPlayer]                     $Script:TheBgmMachine                = [SoundPlayer]::new()
[Boolean]                         $Script:IsBattleBgmPlaying           = $false
[Boolean]                         $Script:HasBattleIntroPlayed         = $false
[Boolean]                         $Script:HasBattleWonChimePlayed      = $false
[Boolean]                         $Script:HasBattleLostChimePlayed     = $false
[Boolean]                         $Script:GpsRestoredFromInvBackup     = $true
[Boolean]                         $Script:GpsRestoredFromBatBackup     = $false
[Boolean]                         $Script:GpsRestoredFromStaBackup     = $false
[Boolean]                         $Script:BattleCursorVisible          = $false
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
[GameStatePrimary]                $Script:TheGlobalGameState           = [GameStatePrimary]::GamePlayScreen
[GameStatePrimary]                $Script:ThePreviousGlobalGameState   = $Script:TheGlobalGameState
[Map]                             $Script:SampleMap                    = $null
[Map]                             $Script:SampleWarpMap01              = $null
[Map]                             $Script:SampleWarpMap02              = $null
[Map]                             $Script:CurrentMap                   = $null
[Map]                             $Script:PreviousMap                  = $null
[Hashtable]                       $Script:TheSceneImages               = @{
    'FieldPlainsNoRoad'                 = [SIFieldPlainsNoRoad]::new()
    'FieldPlainsRoadNorth'              = [SIFieldPlainsRoadNorth]::new()
    'FieldPlainsRoadSouth'              = [SIFieldPlainsRoadSouth]::new()
    'FieldPlainsRoadEast'               = [SIFieldPlainsRoadEast]::new()
    'FieldPlainsRoadWest'               = [SIFieldPlainsRoadWest]::new()
    'FieldPlainsRoadNorthEast'          = [SIFieldPlainsRoadNorthEast]::new()
    'FieldPlainsRoadNorthWest'          = [SIFieldPlainsRoadNorthWest]::new()
    'FieldPlainsRoadNorthSouth'         = [SIFieldPlainsRoadNorthSouth]::new()
    'FieldPlainsRoadEastWest'           = [SIFieldPlainsRoadEastWest]::new()
    'FieldPlainsRoadNorthSouthEast'     = [SIFieldPlainsRoadNorthSouthEast]::new()
    'FieldPlainsRoadNorthSouthEastWest' = [SIFieldPlainsRoadNorthSouthEastWest]::new()
    'FieldPlainsRoadNorthSouthWest'     = [SIFieldPlainsRoadNorthSouthWest]::new()
    'RiverRoadSample'                   = [SIRiverRoadSample]::new()
    'RiverRoadEWNSSample'               = [SIRiverRoadEWNSSample]::new()
    'RiverRoadEWSSSample'               = [SIRiverRoadEWSSSample]::new()
    'Random'                            = [SIRandomNoise]::new()
}





###############################################################################
#
# MAP WARP FUNCTION
#
# THIS IS LIKELY A PRETTY NAIEVE APPROACH TO THIS AT THE MOMENT, BUT WHAT THE
# HELL?
#
###############################################################################
[ScriptBlock]$Script:MapWarpHandler = {
    Param(
        [Map]$TargetMap,
        [Int]$WarpX,
        [Int]$WarpY
    )

    # ASSIGN THE PREVIOUS MAP
    $Script:PreviousMap = $Script:CurrentMap

    # ASSIGN THE CURRENT MAP
    $Script:CurrentMap = $TargetMap

    # SET THE PLAYER'S MAP COORDINATES
    $Script:ThePlayer.MapCoordinates.Row    = $WarpY
    $Script:ThePlayer.MapCoordinates.Column = $WarpX

    # TODO: THIS WOULD HAVE TO TRIGGER A REFRESH OF THE GPS IN ORDER FOR THE
    # CHANGE TO BE VISIBLE. WHATEVER LOGIC I'VE BEEN USING FOR THE TILE CHANGE
    # WOULD LIKELY SUFFICE (AGAIN, MAY BE A BIT NAIEVE BUT I THINK IT SHOULD WORK).
    # CORRECTION: THIS HAS BEEN MOVED TO THE COMMAND BLOCK CALL RATHER THAN HERE.
}





[Map]$Script:SampleMap       = [Map]::new('Map Data\SampleMap.json')
[Map]$Script:SampleWarpMap01 = [Map]::new('Map Data\MapWarpTest01.json')
[Map]$Script:SampleWarpMap02 = [Map]::new('Map Data\MapWarpTest02.json')
[Map]$Script:CurrentMap      = $Script:SampleWarpMap01

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

#
# BATTLE ACTION TABLE - LOOKUP TABLE
#
# LOOKUP FOR RESISTANCE/WEAKNESS SCALARS. THIS IS GREATLY SENSITIVE TO THE ENUMERATION
# ORDERING IN THE BATTLE ACTION TYPE ENUMERATION.
#
$Script:BATLut = @(
	# PHYSICAL ATTACKS AGAINST OTHERS
	@(1, 1, 1, 1, 1, 1, 1, 1),

	# ELEMENTAL FIRE ATTACKS AGAINST OTHERS
	@(1, -0.75, 0.5, 0.5, 0.5, 1, 1, 1.75),

	# ELEMENTAL WATER ATTACKS AGAINST OTHERS
	@(1, 1.75, -0.75, 1, 0.5, 1, 1, 0.5),

	# ELEMENTAL EARTH ATTACKS AGAINST OTHERS
	@(1, 0.5, 1, -0.75, 0.5, 1, 1, 1.75),

	# ELEMENTAL WIND ATTACKS AGAINST OTHERS
	@(1, 1, 1, 1.75, -0.75, 1, 1, 0.5),

	# ELEMENTAL LIGHT ATTACKS AGAINST OTHERS
	@(1, 1, 1, 1, 1, -0.75, 1.75, 1),

	# ELEMENTAL DARK ATTACKS AGAINST OTHERS
	@(1, 1, 1, 1, 1, 1.75, -0.75, 1),

	# ELEMENTAL ICE ATTACKS AGAINST OTHERS
	@(1, 0.5, 1.75, 1.75, 1, 1, 1, -0.75)
)

$Script:Rui = $(Get-Host).UI.RawUI





###############################################################################
#
# THE STATE BLOCK TABLE SCRIPTBLOCK DEFINITIONS
#
###############################################################################
[ScriptBlock]$Script:TheSplashScreenAState = {}

[ScriptBlock]$Script:TheSplashScreenBState = {}

[ScriptBlock]$Script:TheTitleScreenState = {}

[ScriptBlock]$Script:ThePlayerSetupState = {}

[ScriptBlock]$Script:TheGamePlayScreenState = {
    If($null -NE $Script:TheInventoryWindow) {
        $Script:TheInventoryWindow = $null
    }
    If($null -NE $Script:TheBattleManager) {
        $Script:TheBattleManager.Cleanup()
        $Script:TheBattleManager = $null
    }
    If($null -NE $Script:ThePlayerBattleStatWindow) {
        $Script:ThePlayerBattleStatWindow = $null
    }
    If($null -NE $Script:TheEnemyBattleStatWindow) {
        $Script:TheEnemyBattleStatWindow = $null
    }
    If($null -NE $Script:ThePlayerBattleActionWindow) {
        $Script:ThePlayerBattleActionWindow = $null
    }
    If($null -NE $Script:TheBattleStatusMessageWindow) {
        $Script:TheBattleStatusMessageWindow = $null
    }
    If($null -NE $Script:TheBattleEnemyImageWindow) {
        $Script:TheBattleEnemyImageWindow = $null
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

    #######################################################################
    #
    # I REALLY NEED TO UNDERSTAND WHAT THE FUCK I WAS TRYING TO DO HERE.
    # THIS CODE SEEMS LIKE A FUCKING CRIME AGAINST HUMANITY, BUT I CAN'T
    # REMEMBER WHY I DID IT THIS WAY.
    #
    #######################################################################
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

[ScriptBlock]$Script:TheInventoryScreenState = {
    If($null -EQ $Script:TheInventoryWindow) {
        Try {
            $Script:TheInventoryWindow = [InventoryWindow]::new()
        } Catch {
            Write-Error $_.Exception.Message
            Write-Error $_.Exception.StackTrace
        }
    }
    If($Script:GpsRestoredFromInvBackup -EQ $true) {
        $Script:GpsRestoredFromInvBackup = $false
    }
    $Script:TheInventoryWindow.Draw()
    $Script:TheInventoryWindow.HandleInput()
}

[ScriptBlock]$Script:TheBattleScreenState = {
    If($Script:HasBattleIntroPlayed -EQ $false) {
        If($Script:ThePreviousGlobalGameState -EQ [GameStatePrimary]::GamePlayScreen) {
            [ATString]$Banner = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleMintLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 7
                        Column = 40 - (15 / 2)
                    }
                }
                UserData   = 'BATTLE COMMENCE'
                UseATReset = $true
            }
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
        $Script:TheBattleManager       = [BattleManager]::new()
        $Script:TheBattleManager.State = [BattleManagerState]::TurnIncrement
    }
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
    If($null -EQ $Script:TheBattlePhaseIndicator) {
        $Script:TheBattlePhaseIndicator = [BattlePhaseIndicator]::new()
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

[ScriptBlock]$Script:ThePlayerStatusScreenState = {
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
            # DO NOTHING
            # BECAUSE I'M A FUCKING GENIUS
        }
    }
}

[ScriptBlock]$Script:TheCleanupState = {}





###############################################################################
#
# THE COMMAND TABLE AND ITS ASSOCIATED SCRIPT BLOCKS
#
###############################################################################
[ScriptBlock]$Script:TheMoveCommand = {
    Param(
        [String]$a0
    )

    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtraArgsWarning('move', $args)
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
        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
        $Script:TheCommandWindow.UpdateCommandHistory($false)

        Return
    }

    Return
}

[ScriptBlock]$Script:TheLookCommand = {
    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtraArgsWarning('look', $args)
    }

    $Script:TheCommandWindow.UpdateCommandHistory($true)

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

    $Script:TheMessageWindow.WriteLookMessage($c, $f, $y)

    Return
}

[ScriptBlock]$Script:TheInventoryCommand = {
    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtraArgsWarning('inventory', $args)
    }

    $Script:TheCommandWindow.UpdateCommandHistory($true)
    $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
    $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
    $Script:TheGlobalGameState         = [GameStatePrimary]::InventoryScreen

    Return
}

[ScriptBlock]$Script:TheExamineCommand = {
    Param(
        [String]$a0
    )

    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtrasArgsWarning('examine', $args)
    }

    If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
        If([String]::IsNullOrEmpty($a0) -EQ $true) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteBadArg0Message('examine', '')

            Return
        } Else {
            Foreach($a in $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing) {
                If($a.Name -IEQ $a0) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteItemExamineMessage($a.ExamineString)
    
                    Return
                }
            }
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMapInvalidItemMessage($ItemName)
    
            Return
        }
    } Else {
        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
        $Script:TheCommandWindow.UpdateCommandHistory($false)

        Return
    }

    Return
}

[ScriptBlock]$Script:TheGetCommand = {
    Param(
        [String]$a0
    )

    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtraArgsWarning('get', $args)
    }

    If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
        If([String]::IsNullOrEmpty($a0) -EQ $true) {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteBadArg0Message('get', '')

            Return
        } Else {
            $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing

            If($a.Count -LE 0) {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()

                Return
            }
            Foreach($b in $a) {
                If($b.Name -IEQ $a0) {
                    If($b.CanAddToInventory -EQ $true) {
                        $Script:ThePlayer.Inventory.Add($b) | Out-Null
                        $c = $a.Remove($b) | Out-Null
                        If($c -EQ $false) {
                            Write-Error 'Failed to remove an item from the Map Tile!'

                            Exit
                        } Else {
                            $Script:TheCommandWindow.UpdateCommandHistory($true)
                            $Script:TheMessageWindow.WriteItemTakenMessage($a0)

                            Return
                        }
                    } Else {
                        $Script:TheCommandWindow.UpdateCommandHistory($true)
                        $Script:TheMessageWindow.WriteItemCantTakeMessage($a0)

                        Return
                    }
                }
            }
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteMapInvalidItemMessage($a0)

            Return
        }
    } Else {
        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
        $Script:TheCommandWindow.UpdateCommandHistory($false)

        Return
    }

    Return
}

[ScriptBlock]$Script:TheUseCommand = {
    Param(
        [String]$a0,
        [String]$a1
    )

    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtrasArgsWarning('use', $args)
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
                    $Script:TheMessageWindow.WriteCantUseItemMessage($a0, $a1)
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
                        $Script:TheMessageWindow.WriteCatUseItemOnSelfMessage($a0)
                    }
                } Else {
                    $Script:TheCommandWindow.UpdateCommandHistory($false)
                    $Script:TheMessageWindow.WriteBadCommandRetortMessage()
                }
            }
        } Else {
            # The item isn't in the Player's Inventory, thus rendering this an inoperable command (despite not being syntactically invalid).
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteNoItemInInvMessage($a0)

            Return
        }
    } Elseif(($PSBoundParameters.ContainsKey('a0') -EQ $true) -AND ((-NOT $PSBoundParameters.ContainsKey('a1')) -EQ $true)) {
        $Script:TheCommandWindow.UpdateCommandHistory($false)

        If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
            $Script:TheMessageWindow.WriteNoItemTargetMessage($a0)
        } Else {
            $Script:TheMessageWindow.WriteItemUseUnsureMessage($a0)
        }
    } Elseif(((-NOT $PSBoundParameters.ContainsKey('a0')) -EQ $true) -AND ((-NOT $PSBoundParameters.ContainsKey('a1')) -EQ $true)) {
        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
        $Script:TheCommandWindow.UpdateCommandHistory($false)
    }
}

[ScriptBlock]$Script:TheDropCommand = {
    Param(
        [String]$a0
    )

    If($args.Length -GE 1) {
        $Script:TheCommandWindow.UpdateCommandHistory($false)
        $Script:TheMessageWindow.WriteCantDropMultMessage()

        Return
    }

    If($PSBoundParameters.ContainsKey('a0') -EQ $true) {
        If($Script:ThePlayer.IsItemInInventory($a0) -EQ $true) {
            If($Script:ThePlayer.RemoveInventoryItemByName($a0) -EQ [ItemRemovalStatus]::Success) {
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:TheMessageWindow.WriteItemDroppedMessage($a0)

                Return
            } Else {
                # WARNING
                # At this point, this branch is considered a fatal error
                # There really should be a better way of handling this, however
                Exit
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($false)
            $Script:TheMessageWindow.WriteNoItemInInvMessage($a0)

            Return
        }
    } Else {
        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
        $Script:TheCommandWindow.UpdateCommandHistory($false)

        Return
    }
}

[ScriptBlock]$Script:TheStatusCommand = {
    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtraArgsWarning('use', $args)
    }

    $Script:TheCommandWindow.UpdateCommandHistory($true)
    $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
    $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
    $Script:TheGlobalGameState         = [GameStatePrimary]::PlayerStatusScreen
}

[ScriptBlock]$Script:TheEnterCommand = {
    If($args.Length -GT 0) {
        $Script:TheMessageWindow.WriteCmdExtraArgsWarning('enter', $args)
    }

    $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing

    If($a.Count -LE 0) {
        $Script:TheCommandWindow.UpdateCommandHistory($false)

        # THIS MAY NEED MODIFIED TO A DIFFERENT METHOD CALL GIVEN THE NATURE
        # OF THE ACTION.
        $Script:TheMessageWindow.WriteMapNoItemsFoundMessage()

        Return
    }

    Foreach($b in $a) {
        # THIS COULD BE PROBLEMATIC IF THERE ARE MULTIPLE WARPABLE ITEMS ON A SINGLE TILE
        # BUT REALLY? WHY?
        If($b -IS [MTOWarpable]) {
            # ASIDE FROM THE OTHER WAYS IN WHICH WARPABLES DIFFER FROM THEIR OTHER MTO
            # CONTEMPORARIES IS THAT THEY DON'T MAKE USE OF THE MTO TARGET OF FILTER.
            # WE'RE JUST GOING TO INVOKE THE EFFECT METHOD, WHICH WOULD BE THE MAP
            # WARPING FUNCTION.
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            Invoke-Command $b.Effect -ArgumentList $b.WarpToReference.Value, $b.WarpToX, $b.WarpToY

            # I MAY ALSO WANT TO WRITE A MESSAGE TO THE MESSAGE WINDOW ABOUT HAVING
            # ENTERED A MAP? I'LL LEAVE THIS AS A TODO HERE.

            $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
            
            # THIS NEXT PART IS LIKELY SUBJECT TO CHANGE BECAUSE IT WOULD IMPLY THAT
            # BATTLES CAN OCCUR ON THE WARPING TILES, AND THIS MAY NOT MAKE MUCH SENSE
            $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

            Return
        }
    }

    # THERE ARE NO WARPABLE INSTANCES ON THIS TILE, REPORT TO THE MESSAGE WINDOW
    $Script:TheCommandWindow.UpdateCommandHistory($false)
    $Script:TheMessageWindow.WriteBadCommandRetortMessage()
}

$Script:TheCommandTable = @{
    'move'      = $Script:TheMoveCommand
    'm'         = $Script:TheMoveCommand
    'look'      = $Script:TheLookCommand
    'l'         = $Script:TheLookCommand
    'inventory' = $Script:TheInventoryCommand
    'i'         = $Script:TheInventoryCommand
    'examine'   = $Script:TheExamineCommand
    'exa'       = $Script:TheExamineCommand
    'get'       = $Script:TheGetCommand
    'g'         = $Script:TheGetCommand
    'take'      = $Script:TheGetCommand
    't'         = $Script:TheGetCommand
    'use'       = $Script:TheUseCommand
    'u'         = $Script:TheUseCommand
    'drop'      = $Script:TheDropCommand
    'd'         = $Script:TheDropCommand
    'status'    = $Script:TheStatusCommand
    'sta'       = $Script:TheStatusCommand
    'enter'     = $Script:TheEnterCommand
    'en'        = $Script:TheEnterCommand
    'exit'      = $Script:TheEnterCommand
    'ex'        = $Script:TheEnterCommand
}





###############################################################################
#
# BATTLE ACTION CALCULATION
#
###############################################################################
[ScriptBlock]$Script:BaCalc = {
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
            Return [BattleActionResult]@{
                Type            = [BattleActionResultType]::FailedAttackFailed
                Originator      = $Self
                Target          = $Target
                ActionEffectSum = 0
            }
        }

        $TargetEffectiveEvasion = [Math]::Round((0.1 + ($Target.Stats[[StatId]::Speed].Base * (Get-Random -Minimum 0.001 -Maximum 0.003))) * 100)
        $EvRandFactor           = Get-Random -Minimum 1 -Maximum 100
        If($EvRandFactor -LE $TargetEffectiveEvasion) {
            Return [BattleActionResult]@{
                Type            = [BattleActionResultType]::FailedAttackMissed
                Originator      = $Self
                Target          = $Target
                ActionEffectSum = 0
            }
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

        $EffectiveDamageAffinityFactor = $Script:BATLut[$SelfAction.Type][$Target.Affinity]

        $FinalDamage = [Math]::Round($EffectiveDamageP1 * $EffectiveDamageCritFactor * $EffectiveDamageAffinityFactor)

        [Int]$DecRes = $Target.Stats[[StatId]::HitPoints].DecrementBase(($FinalDamage * -1))

        If(0 -NE $DecRes) {
            Return [BattleActionResultType]@{
                Type            = [BattleActionResultType]::FailedAttackFailed
                Originator      = $Self
                Target          = $Target
                ActionEffectSum = $FinalDamage
            }
        } Else {
            If($Target -IS [Player]) {
                $Script:ThePlayerBattleStatWindow.HpDrawDirty = $true
            } Else {
                $Script:TheEnemyBattleStatWindow.HpDrawDirty = $true
            }

            If($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -EQ 1.0) {
                Return [BattleActionResult]@{
                    Type            = [BattleActionResultType]::SuccessWithCritical
                    Originator      = $Self
                    Target          = $Target
                    ActionEffectSum = $FinalDamage
                }
            } Elseif($EffectiveDamageCritFactor -EQ 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                Return [BattleActionResult]@{
                    Type            = [BattleActionResultType]::SuccessWithAffinityBonus
                    Originator      = $Self
                    Target          = $Target
                    ActionEffectSum = $FinalDamage
                }
            } Elseif($EffectiveDamageCritFactor -GT 1.0 -AND $EffectiveDamageAffinityFactor -GT 1.0) {
                Return [BattleActionResult]@{
                    Type            = [BattleActionResultType]::SuccessWithCritAndAffinityBonus
                    Originator      = $Self
                    Target          = $Target
                    ActionEffectSum = $FinalDamage
                }
            }

            Return [BattleActionResult]@{
                Type            = [BattleActionResultType]::Success
                Originator      = $Self
                Target          = $Target
                ActionEffectSum = $FinalDamage
            }
        }
    } Else {
        Return [BattleActionResult]@{
            Type            = [BattleActionResultType]::FailedNoUsesRemaining
            Originator      = $Self
            Target          = $Target
            ActionEffectSum = 0
        }
    }
}





###############################################################################
#
# PLAYER INITIALIZATION
#
###############################################################################
[Player]$Script:ThePlayer = [Player]@{
    Name  = 'Steve'
    Stats = @{
        [StatId]::HitPoints = [BattleEntityProperty]@{
            Base                = 1000
            Max                 = 1000
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
            Base                = 500
            Max                 = 500
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
            Base                = 25
            BasePre             = 25
            BaseAugmentValue    = 5
            Max                 = 15
            MaxPre              = 15
            MaxAugmentValue     = 0
            AugmentTurnDuration = 2
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return $Self.Base
            }
        }
        [StatId]::Defense = [BattleEntityProperty]@{
            Base                = 8
            Max                 = 8
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return
            }
        }
        [StatId]::MagicAttack = [BattleEntityProperty]@{
            Base                = 6
            Max                 = 6
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return
            }
        }
        [StatId]::MagicDefense = [BattleEntityProperty]@{
            Base                = 4
            Max                 = 4
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return
            }
        }
        [StatId]::Speed = [BattleEntityProperty]@{
            Base                = 9
            Max                 = 9
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return
            }
        }
        [StatId]::Luck = [BattleEntityProperty]@{
            Base                = 5
            Max                 = 5
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return
            }
        }
        [StatId]::Accuracy = [BattleEntityProperty]@{
            Base                = 9
            BaseAugmentValue    = -5
            Max                 = 9
            AugmentTurnDuration = 2
            ValidateFunction    = {
                Param(
                    [BattleEntityProperty]$Self
                )
                
                Return
            }
        }
    }
    ActionListing = @{
        [ActionSlot]::A = [BAPunch]::new()
        [ActionSlot]::B = [BAKick]::new()
        [ActionSlot]::C = [BAFlamePunch]::new()
        [ActionSlot]::D = [BAIKill]::new()
    }
    SpoilsEffect    = {}
    ActionMarbleBag = @()
    CurrentGold     = 500
    Affinity        = [BattleActionType]::ElementalFire
}





###############################################################################
#
# GLOBAL STATE BLOCK TABLE DEFINITION
#
###############################################################################
$Script:TheGlobalStateBlockTable = @{
    [GameStatePrimary]::SplashScreenA      = $Script:TheSplashScreenAState
    [GameStatePrimary]::SplashScreenB      = $Script:TheSplashScreenBState
    [GameStatePrimary]::TitleScreen        = $Script:TheTitleScreenState
    [GameStatePrimary]::PlayerSetupScreen  = $Script:ThePlayerSetupState
    [GameStatePrimary]::GamePlayScreen     = $Script:TheGamePlayScreenState
    [GameStatePrimary]::InventoryScreen    = $Script:TheInventoryScreenState
    [GameStatePrimary]::BattleScreen       = $Script:TheBattleScreenState
    [GameStatePrimary]::PlayerStatusScreen = $Script:ThePlayerStatusScreenState
    [GameStatePrimary]::Cleanup            = $Script:TheCleanupState
}





###############################################################################
#
# CONSOLE COLOR 24 CLASS
#
# BASIC 24-BIT COLOR DEFINITION
#
###############################################################################
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
}





###############################################################################
#
# CONSOLE COLOR 24 SPECIALIZATIONS
#
###############################################################################
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
    CCAppleRedLight24() : base(255, 59, 48) {}
}

Class CCAppleRedDark24 : ConsoleColor24 {
    CCAppleRedDark24() : base(255, 69, 58) {}
}

Class CCAppleOrangeLight24 : ConsoleColor24 {
    CCAppleOrangeLight24() : base(255, 149, 0) {}
}

Class CCAppleOrangeDark24 : ConsoleColor24 {
    CCAppleOrangeDark24() : base(255, 159, 10) {}
}

Class CCAppleYellowLight24 : ConsoleColor24 {
    CCAppleYellowLight24() : base(255, 204, 0) {}
}

Class CCAppleYellowDark24 : ConsoleColor24 {
    CCAppleYellowDark24() : base(255, 214, 10) {}
}

Class CCAppleGreenLight24 : ConsoleColor24 {
    CCAppleGreenLight24() : base(52, 199, 89) {}
}

Class CCAppleGreenDark24 : ConsoleColor24 {
    CCAppleGreenDark24() : base(48, 209, 88) {}
}

Class CCAppleMintLight24 : ConsoleColor24 {
    CCAppleMintLight24() : base(0, 199, 190) {}
}

Class CCAppleMintDark24 : ConsoleColor24 {
    CCAppleMintDark24() : base(99, 230, 226) {}
}

Class CCAppleTealLight24 : ConsoleColor24 {
    CCAppleTealLight24() : base(48, 176, 199) {}
}

Class CCAppleTealDark24 : ConsoleColor24 {
    CCAppleTealDark24() : base(64, 200, 224) {}
}

Class CCAppleCyanLight24 : ConsoleColor24 {
    CCAppleCyanLight24() : base(50, 173, 230) {}
}

Class CCAppleCyanDark24 : ConsoleColor24 {
    CCAppleCyanDark24() : base(100, 210, 255) {}
}

Class CCAppleBlueLight24 : ConsoleColor24 {
    CCAppleBlueLight24() : base(0, 122, 255) {}
}

Class CCAppleBlueDark24 : ConsoleColor24 {
    CCAppleBlueDark24() : base(10, 132, 255) {}
}

Class CCAppleIndigoLight24 : ConsoleColor24 {
    CCAppleIndigoLight24() : base(88, 86, 214) {}
}

Class CCAppleIndigoDark24 : ConsoleColor24 {
    CCAppleIndigoDark24() : base(94, 92, 230) {}
}

Class CCApplePurpleLight24 : ConsoleColor24 {
    CCApplePurpleLight24() : base(175, 82, 222) {}
}

Class CCApplePurpleDark24 : ConsoleColor24 {
    CCApplePurpleDark24() : base(191, 90, 242) {}
}

Class CCApplePinkLight24 : ConsoleColor24 {
    CCApplePinkLight24() : base(255, 45, 85) {}
}

Class CCApplePinkDark24 : ConsoleColor24 {
    CCApplePinkDark24() : base(255, 55, 95) {}
}

Class CCAppleBrownLight24 : ConsoleColor24 {
    CCAppleBrownLight24() : base(162, 132, 94) {}
}

Class CCAppleBrownDark24 : ConsoleColor24 {
    CCAppleBrownDark24() : base(172, 142, 104) {}
}

Class CCAppleGrey1Light24 : ConsoleColor24 {
    CCAppleGrey1Light24() : base(142, 142, 147) {}
}

Class CCAppleGrey1Dark24 : ConsoleColor24 {
    CCAppleGrey1Dark24() : base(142, 142, 147) {}
}

Class CCAppleGrey2Light24 : ConsoleColor24 {
    CCAppleGrey2Light24() : base(174, 174, 178) {}
}

Class CCAppleGrey2Dark24 : ConsoleColor24 {
    CCAppleGrey2Dark24() : base(99, 99, 102) {}
}

Class CCAppleGrey3Light24 : ConsoleColor24 {
    CCAppleGrey3Light24() : base(199, 199, 204) {}
}

Class CCAppleGrey3Dark24 : ConsoleColor24 {
    CCAppleGrey3Dark24() : base(72, 72, 74) {}
}

Class CCAppleGrey4Light24 : ConsoleColor24 {
    CCAppleGrey4Light24() : base(209, 209, 214) {}
}

Class CCAppleGrey4Dark24 : ConsoleColor24 {
    CCAppleGrey4Dark24() : base(58, 58, 60) {}
}

Class CCAppleGrey5Light24 : ConsoleColor24 {
    CCAppleGrey5Light24() : base(229, 229, 234) {}
}

Class CCAppleGrey5Dark24 : ConsoleColor24 {
    CCAppleGrey5Dark24() : base(44, 44, 46) {}
}

Class CCAppleGrey6Light24 : ConsoleColor24 {
    CCAppleGrey6Light24() : base(242, 242, 247) {}
}

Class CCAppleGrey6Dark24 : ConsoleColor24 {
    CCAppleGrey6Dark24() : base(28, 28, 30) {}
}

<#
https://www.pantone.com/connect/14-4318-TCX
#>
Class CCPantoneSkyBlue24 : ConsoleColor24 {
    CCPantoneSkyBlue24() : base(54, 73, 83) {}
}
<#
https://www.pantone.com/connect/15-6322-TPX
#>
Class CCPantoneLightGrassGreen24 : ConsoleColor24 {
    CCPantoneLightGrassGreen24() : base(49, 70, 53) {}
}

<#
https://www.pantone.com/connect/19-1218-TCX
#>
Class CCPantonePottingSoil24 : ConsoleColor24 {
    CCPantonePottingSoil24() : base(33, 22, 18) {}
}

<# COLOR VARIATIONS RECENTLY UPDATED FROM APPLE'S DOCUMENTATION #>
<# https://developer.apple.com/design/human-interface-guidelines/color#Specifications #>

Class CCAppleNRedLight24 : ConsoleColor24 {
    CCAppleNRedLight24() : base(255, 59, 48) {}
}

Class CCAppleNRedDark24 : ConsoleColor24 {
    CCAppleNRedDark24() : base(255, 69, 58) {}
}

Class CCAppleNRedALight24 : ConsoleColor24 {
    CCAppleNRedALight24() : base(215, 0, 21) {}
}

Class CCAppleNRedADark24 : ConsoleColor24 {
    CCAppleNRedADark24() : base(255, 105, 97) {}
}

Class CCAppleNOrangeLight24 : ConsoleColor24 {
    CCAppleNOrangeLight24() : base(255, 149, 0) {}
}

Class CCAppleNOrangeDark24 : ConsoleColor24 {
    CCAppleNOrangeDark24() : base(255, 159, 10) {}
}

Class CCAppleNOrangeALight24 : ConsoleColor24 {
    CCAppleNOrangeALight24() : base(201, 52, 0) {}
}

Class CCAppleNOrangeADark24 : ConsoleColor24 {
    CCAppleNOrangeADark24() : base(255, 179, 64) {}
}

Class CCAppleNYellowLight24 : ConsoleColor24 {
    CCAppleNYellowLight24() : base(255, 204, 0) {}
}

Class CCAppleNYellowDark24 : ConsoleColor24 {
    CCAppleNYellowDark24() : base(255, 214, 10) {}
}

Class CCAppleNYellowALight24 : ConsoleColor24 {
    CCAppleNYellowALight24() : base(178, 80, 0) {}
}

Class CCAppleNYellowADark24 : ConsoleColor24 {
    CCAppleNYellowADark24() : base(255, 212, 38) {}
}

Class CCAppleNGreenLight24 : ConsoleColor24 {
    CCAppleNGreenLight24() : base(52, 199, 89) {}
}

Class CCAppleNGreenDark24 : ConsoleColor24 {
    CCAppleNGreenDark24() : base(48, 209, 88) {}
}

Class CCAppleNGreenALight24 : ConsoleColor24 {
    CCAppleNGreenALight24() : base(36, 138, 61) {}
}

Class CCAppleNGreenADark24 : ConsoleColor24 {
    CCAppleNGreenADark24() : base(48, 219, 91) {}
}

Class CCAppleNMintLight24 : ConsoleColor24 {
    CCAppleNMintLight24() : base(0, 199, 190) {}
}

Class CCAppleNMintDark24 : ConsoleColor24 {
    CCAppleNMintDark24() : base(99, 230, 226) {}
}

Class CCAppleNMintALight24 : ConsoleColor24 {
    CCAppleNMintALight24() : base(12, 129, 123) {}
}

Class CCAppleNMintADark24 : ConsoleColor24 {
    CCAppleNMintADark24() : base(102, 212, 207) {}
}

Class CCAppleNTealLight24 : ConsoleColor24 {
    CCAppleNTealLight24() : base(48, 176, 199) {}
}

Class CCAppleNTealDark24 : ConsoleColor24 {
    CCAppleNTealDark24() : base(64, 200, 224) {}
}

Class CCAppleNTealALight24 : ConsoleColor24 {
    CCAppleNTealALight24() : base(0, 130, 153) {}
}

Class CCAppleNTealADark24 : ConsoleColor24 {
    CCAppleNTealADark24() : base(93, 230, 255) {}
}

Class CCAppleNCyanLight24 : ConsoleColor24 {
    CCAppleNCyanLight24() : base(50, 173, 230) {}
}

Class CCAppleNCyanDark24 : ConsoleColor24 {
    CCAppleNCyanDark24() : base(100, 210, 255) {}
}

Class CCAppleNCyanALight24 : ConsoleColor24 {
    CCAppleNCyanALight24() : base(0, 113, 164) {}
}

Class CCAppleNCyanADark24 : ConsoleColor24 {
    CCAppleNCyanADark24() : base(112, 215, 255) {}
}

Class CCAppleNBlueLight24 : ConsoleColor24 {
    CCAppleNBlueLight24() : base(0, 122, 255) {}
}

Class CCAppleNBlueDark24 : ConsoleColor24 {
    CCAppleNBlueDark24() : base(10, 132, 255) {}
}

Class CCAppleNBlueALight24 : ConsoleColor24 {
    CCAppleNBlueALight24() : base(0, 64, 221) {}
}

Class CCAppleNBlueADark24 : ConsoleColor24 {
    CCAppleNBlueADark24() : base(64, 156, 255) {}
}

Class CCAppleNIndigoLight24 : ConsoleColor24 {
    CCAppleNIndigoLight24() : base(88, 86, 214) {}
}

Class CCAppleNIndigoDark24 : ConsoleColor24 {
    CCAppleNIndigoDark24() : base(94, 92, 230) {}
}

Class CCAppleNIndigoALight24 : ConsoleColor24 {
    CCAppleNIndigoALight24() : base(54, 52, 163) {}
}

Class CCAppleNIndigoADark24 : ConsoleColor24 {
    CCAppleNIndigoADark24() : base(125, 122, 255) {}
}

Class CCAppleNPurpleLight24 : ConsoleColor24 {
    CCAppleNPurpleLight24() : base(175, 82, 222) {}
}

Class CCAppleNPurpleDark24 : ConsoleColor24 {
    CCAppleNPurpleDark24() : base(191, 90, 242) {}
}

Class CCAppleNPurpleALight24 : ConsoleColor24 {
    CCAppleNPurpleALight24() : base(137, 68, 171) {}
}

Class CCAppleNPurpleADark24 : ConsoleColor24 {
    CCAppleNPurpleADark24() : base(218, 143, 255) {}
}

Class CCAppleNPinkLight24 : ConsoleColor24 {
    CCAppleNPinkLight24() : base(255, 45, 85) {}
}

Class CCAppleNPinkDark24 : ConsoleColor24 {
    CCAppleNPinkDark24() : base(255, 55, 95) {}
}

Class CCAppleNPinkALight24 : ConsoleColor24 {
    CCAppleNPinkALight24() : base(211, 15, 69) {}
}

Class CCAppleNPinkADark24 : ConsoleColor24 {
    CCAppleNPinkADark24() : base(255, 100, 130) {}
}

Class CCAppleNBrownLight24 : ConsoleColor24 {
    CCAppleNBrownLight24() : base(162, 132, 94) {}
}

Class CCAppleNBrownDark24 : ConsoleColor24 {
    CCAppleNBrownDark24() : base(172, 142, 104) {}
}

Class CCAppleNBrownALight24 : ConsoleColor24 {
    CCAppleNBrownALight24() : base(127, 101, 69) {}
}

Class CCAppleNBrownADark24 : ConsoleColor24 {
    CCAppleNBrownADark24() : base(181, 148, 105) {}
}

Class CCAppleNGreyLight24 : ConsoleColor24 {
    CCAppleNGreyLight24() : base(142, 142, 147) {}
}

Class CCAppleNGreyDark24 : ConsoleColor24 {
    CCAppleNGreyDark24() : base(142, 142, 147) {}
}

Class CCAppleNGreyALight24 : ConsoleColor24 {
    CCAppleNGreyALight24() : base(108, 108, 112) {}
}

Class CCAppleNGreyADark24 : ConsoleColor24 {
    CCAppleNGreyADark24() : base(174, 174, 178) {}
}

Class CCAppleNGrey2Light24 : ConsoleColor24 {
    CCAppleNGrey2Light24() : base(174, 174, 178) {}
}

Class CCAppleNGrey2Dark24 : ConsoleColor24 {
    CCAppleNGrey2Dark24() : base(99, 99, 102) {}
}

Class CCAppleNGrey2ALight24 : ConsoleColor24 {
    CCAppleNGrey2ALight24() : base(142, 142, 147) {}
}

Class CCAppleNGrey2ADark24 : ConsoleColor24 {
    CCAppleNGrey2ADark24() : base(124, 124, 128) {}
}

Class CCAppleNGrey3Light24 : ConsoleColor24 {
    CCAppleNGrey3Light24() : base(199, 199, 204) {}
}

Class CCAppleNGrey3Dark24 : ConsoleColor24 {
    CCAppleNGrey3Dark24() : base(72, 72, 74) {}
}

Class CCAppleNGrey4ALight24 : ConsoleColor24 {
    CCAppleNGrey4ALight24() : base(188, 188, 192) {}
}

Class CCAppleNGrey4ADark24 : ConsoleColor24 {
    CCAppleNGrey4ADark24() : base(68, 68, 70) {}
}

Class CCAppleNGrey5Light24 : ConsoleColor24 {
    CCAppleNGrey5Light24() : base(229, 229, 234) {}
}

Class CCAppleNGrey5Dark24 : ConsoleColor24 {
    CCAppleNGrey5Dark24() : base(44, 44, 46) {}
}

Class CCAppleNGrey5ALight24 : ConsoleColor24 {
    CCAppleNGrey5ALight24() : base(216, 216, 220) {}
}

Class CCAppleNGrey5ADark24 : ConsoleColor24 {
    CCAppleNGrey5ADark24() : base(54, 54, 56) {}
}

Class CCAppleNGrey6Light24 : ConsoleColor24 {
    CCAppleNGrey6Light24() : base(242, 242, 247) {}
}

Class CCAppleNGrey6Dark24 : ConsoleColor24 {
    CCAppleNGrey6Dark24() : base(28, 28, 30) {}
}

Class CCAppleNGrey6ALight24 : ConsoleColor24 {
    CCAppleNGrey6ALight24() : base(235, 235, 240) {}
}

Class CCAppleNGrey6ADark24 : ConsoleColor24 {
    CCAppleNGrey6ADark24() : base(36, 36, 38) {}
}

Class CCAppleVRedLight24 : ConsoleColor24 {
    CCAppleVRedLight24() : base(255, 49, 38) {}
}

Class CCAppleVRedDark24 : ConsoleColor24 {
    CCAppleVRedDark24() : base(255, 79, 68) {}
}

Class CCAppleVRedALight24 : ConsoleColor24 {
    CCAppleVRedALight24() : base(194, 6, 24) {}
}

Class CCAppleVRedADark24 : ConsoleColor24 {
    CCAppleVRedADark24() : base(255, 65, 54) {}
}

Class CCAppleVOrangeLight24 : ConsoleColor24 {
    CCAppleVOrangeLight24() : base(245, 139, 0) {}
}

Class CCAppleVOrangeDark24 : ConsoleColor24 {
    CCAppleVOrangeDark24() : base(255, 169, 20) {}
}

Class CCAppleVOrangeALight24 : ConsoleColor24 {
    CCAppleVOrangeALight24() : base(173, 58, 0) {}
}

Class CCAppleVOrangeADark24 : ConsoleColor24 {
    CCAppleVOrangeADark24() : base(255, 179, 64) {}
}

Class CCAppleVYellowLight24 : ConsoleColor24 {
    CCAppleVYellowLight24() : base(245, 194, 0) {}
}

Class CCAppleVYellowDark24 : ConsoleColor24 {
    CCAppleVYellowDark24() : base(255, 224, 20) {}
}

Class CCAppleVYellowALight24 : ConsoleColor24 {
    CCAppleVYellowALight24() : base(146, 81, 0) {}
}

Class CCAppleVYellowADark24 : ConsoleColor24 {
    CCAppleVYellowADark24() : base(255, 212, 38) {}
}

Class CCAppleVGreenLight24 : ConsoleColor24 {
    CCAppleVGreenLight24() : base(30, 195, 55) {}
}

Class CCAppleVGreenDark24 : ConsoleColor24 {
    CCAppleVGreenDark24() : base(60, 225, 85) {}
}

Class CCAppleVGreenALight24 : ConsoleColor24 {
    CCAppleVGreenALight24() : base(0, 112, 24) {}
}

Class CCAppleVGreenADark24 : ConsoleColor24 {
    CCAppleVGreenADark24() : base(49, 222, 75) {}
}

Class CCAppleVMintLight24 : ConsoleColor24 {
    CCAppleVMintLight24() : base(0, 189, 180) {}
}

Class CCAppleVMintDark24 : ConsoleColor24 {
    CCAppleVMintDark24() : base(108, 224, 219) {}
}

Class CCAppleVMintALight24 : ConsoleColor24 {
    CCAppleVMintALight24() : base(11, 117, 112) {}
}

Class CCAppleVMintADark24 : ConsoleColor24 {
    CCAppleVMintADark24() : base(49, 222, 75) {}
}

Class CCAppleVTealLight24 : ConsoleColor24 {
    CCAppleVTealLight24() : base(46, 167, 189) {}
}

Class CCAppleVTealDark24 : ConsoleColor24 {
    CCAppleVTealDark24() : base(68, 212, 237) {}
}

Class CCAppleVTealALight24 : ConsoleColor24 {
    CCAppleVTealALight24() : base(0, 119, 140) {}
}

Class CCAppleVTealADark24 : ConsoleColor24 {
    CCAppleVTealADark24() : base(93, 230, 255) {}
}

Class CCAppleVCyanLight24 : ConsoleColor24 {
    CCAppleVCyanLight24() : base(65, 175, 220) {}
}

Class CCAppleVCyanDark24 : ConsoleColor24 {
    CCAppleVCyanDark24() : base(90, 205, 250) {}
}

Class CCAppleVCyanALight24 : ConsoleColor24 {
    CCAppleVCyanALight24() : base(0, 103, 150) {}
}

Class CCAppleVCyanADark24 : ConsoleColor24 {
    CCAppleVCyanADark24() : base(112, 215, 255) {}
}

Class CCAppleVBlueLight24 : ConsoleColor24 {
    CCAppleVBlueLight24() : base(0, 122, 245) {}
}

Class CCAppleVBlueDark24 : ConsoleColor24 {
    CCAppleVBlueDark24() : base(20, 142, 255) {}
}

Class CCAppleVBlueALight24 : ConsoleColor24 {
    CCAppleVBlueALight24() : base(0, 64, 221) {}
}

Class CCAppleVBlueADark24 : ConsoleColor24 {
    CCAppleVBlueADark24() : base(64, 156, 255) {}
}

Class CCAppleVIndigoLight24 : ConsoleColor24 {
    CCAppleVIndigoLight24() : base(84, 82, 204) {}
}

Class CCAppleVIndigoDark24 : ConsoleColor24 {
    CCAppleVIndigoDark24() : base(99, 97, 242) {}
}

Class CCAppleVIndigoALight24 : ConsoleColor24 {
    CCAppleVIndigoALight24() : base(54, 52, 163) {}
}

Class CCAppleVIndigoADark24 : ConsoleColor24 {
    CCAppleVIndigoADark24() : base(125, 122, 255) {}
}

Class CCAppleVPurpleLight24 : ConsoleColor24 {
    CCAppleVPurpleLight24() : base(159, 75, 201) {}
}

Class CCAppleVPurpleDark24 : ConsoleColor24 {
    CCAppleVPurpleDark24() : base(204, 101, 255) {}
}

Class CCAppleVPurpleALight24 : ConsoleColor24 {
    CCAppleVPurpleALight24() : base(173, 68, 171) {}
}

Class CCAppleVPurpleADark24 : ConsoleColor24 {
    CCAppleVPurpleADark24() : base(218, 143, 255) {}
}

Class CCAppleVPinkLight24 : ConsoleColor24 {
    CCAppleVPinkLight24() : base(245, 35, 75) {}
}

Class CCAppleVPinkDark24 : ConsoleColor24 {
    CCAppleVPinkDark24() : base(255, 65, 105) {}
}

Class CCAppleVPinkALight24 : ConsoleColor24 {
    CCAppleVPinkALight24() : base(193, 16, 50) {}
}

Class CCAppleVPinkADark24 : ConsoleColor24 {
    CCAppleVPinkADark24() : base(255, 58, 95) {}
}

Class CCAppleVBrownLight24 : ConsoleColor24 {
    CCAppleVBrownLight24() : base(152, 122, 84) {}
}

Class CCAppleVBrownDark24 : ConsoleColor24 {
    CCAppleVBrownDark24() : base(182, 152, 114) {}
}

Class CCAppleVBrownALight24 : ConsoleColor24 {
    CCAppleVBrownALight24() : base(119, 93, 59) {}
}

Class CCAppleVGreyLight24 : ConsoleColor24 {
    CCAppleVGreyLight24() : base(132, 132, 137) {}
}

Class CCAppleVGreyDark24 : ConsoleColor24 {
    CCAppleVGreyDark24() : base(162, 162, 167) {}
}

Class CCAppleVGreyALight24 : ConsoleColor24 {
    CCAppleVGreyALight24() : base(97, 97, 101) {}
}

Class CCAppleVGreyADark24 : ConsoleColor24 {
    CCAppleVGreyADark24() : base(152, 152, 157) {}
}

Class CCPixenSkyBlue24 : ConsoleColor24 {
    CCPixenSkyBlue24() : base(0, 253, 255) {}
}

Class CCPixenGrassDarkGreen24 : ConsoleColor24 {
    CCPixenGrassDarkGreen24() : base(0, 165, 0) {}
}

Class CCPixenRoadDarkBrown24 : ConsoleColor24 {
    CCPixenRoadDarkBrown24() : base(122, 67, 0) {}
}

Class CCPixenGrassLightGreen24 : ConsoleColor24 {
    CCPixenGrassLightGreen24() : base(0, 209, 66) {}
}

Class CCTextDefault24 : CCAppleGrey5Light24 {}

Class CCListItemCurrentHighlight24 : CCAppleNPinkLight24 {}





###############################################################################
#
# ANSI-TERMINATED STRING SUPPORT
#
# THIS IS WHERE ALL THE MAGIC SAUCE HAPPENS AT. BECAUSE, FUCKERS.
#
###############################################################################

###############################################################################
#
# AT CONTROL SEQUENCES
#
# CONTAINS COMMON ANSI-TERMINATED STRINGS THAT ARE USED THROUGHT THE PROGRAM.
#
###############################################################################
Class ATControlSequences {
    Static [String]$ForegroundColor24Prefix = "`e[38;2;"
    Static [String]$BackgroundColor24Prefix = "`e[48;2;"
    Static [String]$DecorationBlink         = "`e[5m"
    Static [String]$DecorationItalic        = "`e[3m"
    Static [String]$DecorationUnderline     = "`e[4m"
    Static [String]$DecorationStrikethru    = "`e[9m"
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

###############################################################################
#
# AT FOREGROUND COLOR 24
#
# A SYMBOLIC ENCAPSULATION OF CONSOLE COLOR 24 TO BE USED SPECIFICALLY FOR
# FOREGROUND COLOR APPLICATIONS.
#
###############################################################################
Class ATForegroundColor24 {
    [ValidateNotNull()][ConsoleColor24]$Color

    ATForegroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}

###############################################################################
#
# AT FOREGROUND COLOR 24 NONE
#
# AN ABSTRACTION OF AT FOREGROUND COLOR 24 INTENDED TO BE USED TO IMPLY NO
# FOREGROUND COLOR IN THE PRECEEDING STRING LITERAL.
#
###############################################################################
Class ATForegroundColor24None : ATForegroundColor24 {
    ATForegroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# AT BACKGROUND COLOR 24
#
# A SYMBOLIC ENCAPSULATION OF CONSOLE COLOR 24 TO BE USED SPECIFICALLY FOR
# BACKGROUND COLOR APPLICATIONS.
#
###############################################################################
Class ATBackgroundColor24 {
    [ValidateNotNull()][ConsoleColor24]$Color

    ATBackgroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateBG24String($this.Color)
    }
}

###############################################################################
#
# AT BACKGROUND COLOR 24 NONE
#
# AN ABSTRACTION OF AT BACKGROUND COLOR 24 INTENDED TO BE USED TO IMPLY NO
# BACKGROUND COLOR IN THE PRECEEDING STRING LITERAL.
#
###############################################################################
Class ATBackgroundColor24None : ATBackgroundColor24 {
    ATBackgroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# AT DECORATION
#
# A SYMBOLIC ENCAPSULATION OF ONE OR MANY ANSI DECORATIONS TO APPLY TO A
# PRECEEDING STRING LITERAL.
#
###############################################################################
Class ATDecoration {
    [ValidateNotNull()][Boolean]$Blink
    [ValidateNotNull()][Boolean]$Italic
    [ValidateNotNull()][Boolean]$Underline
    [ValidateNotNull()][Boolean]$Strikethru

    ATDecoration() {
        $this.Blink      = $false
        $this.Italic     = $false
        $this.Underline  = $false
        $this.Strikethru = $false
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        If($this.Blink -EQ $true) {
            $a += [ATControlSequences]::DecorationBlink
        }
        If($this.Italic -EQ $true) {
            $a += [ATControlSequences]::DecorationItalic
        }
        If($this.Underline -EQ $true) {
            $a += [ATControlSequences]::DecorationUnderline
        }
        If($this.Strikethru -EQ $true) {
            $a += [ATControlSequences]::DecorationStrikethru
        }

        Return $a
    }
}

###############################################################################
#
# AT COORDINATES NONE
#
# AN ABSTRACTION OF AT DECORATION INTENDED TO IMPLY NO ANSI DECORATORS BE
# APPLIED TO THE PRECEEDING STRING LITERAL.
#
###############################################################################
Class ATDecorationNone : ATDecoration {
    ATDecorationNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# AT COORDINATES
#
# A SYMBOLIC ENCAPSULATION OF A COORDINATE PAIR IN ROW,COLUMN (Y,X) ORDER.
#
###############################################################################
Class ATCoordinates {
    [ValidateNotNull()][Int]$Row
    [ValidateNotNull()][Int]$Column

    ATCoordinates() {
        $this.Row    = 1
        $this.Column = 1
    }

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
        [ATCoordinates]$CopyFrom
    ) {
        $this.Row    = $CopyFrom.Row
        $this.Column = $CopyFrom.Column
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateCoordinateString($this.Row, $this.Column)
    }

    [Coordinates]ToAutomationCoordinates() {
        Return [Coordinates]::new($this.Row, $this.Column)
    }
}

###############################################################################
#
# AT COORDINATES NONE
#
# AN ABSTRACTION OF AT COORDINATES INTENDED TO IMPLY NO ANSI COORDINATE
# MODIFIER BE APPLIED TO THE PRECEEDING STRING LITERAL.
#
###############################################################################
Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone() : base(0, 0) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# AT COORDINATES DEFAULT
#
# AN ABSTRACTION OF AT COORDINATES INTENDED TO IMPLY AN ANSI COORDINATE
# MODIFIER BE APPLIED TO THE PRECEEDING STRING LITERAL THAT MOVES THE CURSOR TO
# A "DEFAULT" LOCATION.
#
###############################################################################
Class ATCoordinatesDefault : ATCoordinates {
    ATCoordinatesDefault() : base(1, 18) {}
}

###############################################################################
#
# AT STRING PREFIX
#
# AN AGGREGATE OF SEVERAL ANSI MODIFIERS THAT COLLECTIVELY MODIFY A PRECEEDING
# STRING LITERAL.
#
###############################################################################
Class ATStringPrefix {
    [ValidateNotNull()][ATForegroundColor24]$ForegroundColor
    [ValidateNotNull()][ATBackgroundColor24]$BackgroundColor
    [ValidateNotNull()][ATDecoration]$Decorations
    [ValidateNotNull()][ATCoordinates]$Coordinates

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

###############################################################################
#
# AT STRING PREFIX NONE
#
# AN ABSTRACTION OF AT STRING PREFIX INTENDED TO IMPLY NO ANSI MODIFIERS BE
# APPLIED TO A PRECEEDING STRING LITERAL.
#
###############################################################################
Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# AT STRING
#
# AN AGGREGATE THAT COMBINES AN AT STRING PREFIX, A TARGET STRING LITERAL TO
# APPLY THE ANSI MODIFIERS TO, AND AN OPTIONAL ANSI RESET MODIFIER TO APPEND
# TO THE RESULTANT STRING ENSURING THE MODIFIERS FROM THE PREFIX AREN'T CARRIED
# BEYOND THE LENGTH OF THE LITERAL.
#
###############################################################################
Class ATString {
    [ValidateNotNull()][ATStringPrefix]$Prefix
    [ValidateNotNull()][String]$UserData
    [ValidateNotNull()][Boolean]$UseATReset

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

        If($this.UseATReset -EQ $true) {
            $a += [ATControlSequences]::ModifierReset
        }

        Return $a
    }
}

###############################################################################
#
# AT STRING NONE
#
# AN ABSTRACTION OF AT STRING INTENDED TO IMPLY NO AT STRING BE USED. THIS
# CLASS IS GENERALLY USED AS A SANE DEFAULT INITIALIZATION POINT FOR WHAT WOULD
# EVENTUALLY BE PROPER AT STRING INSTANCES.
#
###############################################################################
Class ATStringNone : ATString {
    ATStringNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# AT STRING COMPOSITE
#
# AN AGGREGATE OF AT STRING INSTANCES IN A COLLECTION. THIS CLASS PERMITS FOR
# PRETTY COMPLEX DISPLAYS BY COMBINING MULTIPLE INDEPENDENT AT STRING INSTANCES
# INTO ONE.
#
###############################################################################
Class ATStringComposite {
    [List[ATString]]$CompositeActual = [List[ATString]]::new()

    ATStringComposite() {
        If($null -EQ $this.CompositeActual) {
            $this.CompositeActual = [List[ATString]]::new()
        }

        $this.CompositeActual.Add([ATStringNone]::new()) | Out-Null
    }

    ATStringComposite(
        [ATString[]]$Components
    ) {
        If($null -EQ $this.CompositeActual) {
            $this.CompositeActual = [List[ATString]]::new()
        }

        Foreach($a in $Components) {
            $this.CompositeActual.Add($a) | Out-Null
        }
    }

    ATStringComposite(
        [List[ATString]]$Components
    ) {
        $this.CompositeActual = $Components
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        Foreach($b in $this.CompositeActual) {
            $a += $b.ToAnsiControlSequenceString()
        }

        Return $a
    }
}

###############################################################################
#
# AT SCENE IMAGE STRING
#
# AN ABSTRACTION OF AT STRING INTENDED TO BE USED FOR GENERATING "IMAGES". THIS
# CLASS SHORTCUTS MOST PROPERTIES OF AT STRING AND AT STRING PREFIX EXCEPT FOR
# BACKGROUND COLOR AND COORDINATES.
#
###############################################################################
Class ATSceneImageString : ATString {
    Static [String]$SceneImageBlank = ' '

    ATSceneImageString(
        [ATBackgroundColor24]$BackgroundColor,
        [ATCoordinates]$Coordinates
    ) : base() {
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





###############################################################################
#
# BATTLE ENGINE SUPPORT
#
# CLASSES THAT DEFINE INTERACTIONS THAT FACILITATE THE COMBAT SYSTEM. GENERAL
# CLASSES ARE INCLUDED IN HERE AS WELL AS BEING "IN-SCOPE".
#
###############################################################################

###############################################################################
#
# BATTLE ENTITY PROPERTY
#
# DESCRIBES A PROPERTY OF A BATTLE ENTITY. THIS IS A NUMERIC VALUE THAT HAS A
# MINIMUM AND MAXIMUM, SUPPORTS TEMPORARY AUGMENTATION, AND IS CAPABLE OF
# MAINTAINING ITS OWN STATE.
#
###############################################################################
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

    # THIS CTOR CAN LIKELY GO AWAY
    # BattleEntityProperty(
    #     [Int]$Base,
    #     [Int]$BasePre,
    #     [Int]$BaseAugmentValue,
    #     [Int]$Max,
    #     [Int]$MaxPre,
    #     [Int]$MaxAugmentValue,
    #     [Int]$AugmentTurnDuration,
    #     [Boolean]$BaseAugmentActive,
    #     [Boolean]$MaxAugmentActive,
    #     [StatNumberState]$State,
    #     [ScriptBlock]$ValidateFunction
    # ) {
    #     $this.Base                = $Base
    #     $this.BasePre             = $BasePre
    #     $this.BaseAugmentValue    = $BaseAugmentValue
    #     $this.Max                 = $Max
    #     $this.MaxPre              = $MaxPre
    #     $this.MaxAugmentValue     = $MaxAugmentValue
    #     $this.AugmentTurnDuration = $AugmentTurnDuration
    #     $this.BaseAugmentActive   = $BaseAugmentActive
    #     $this.MaxAugmentActive    = $MaxAugmentActive
    #     $this.State               = $State
    #     $this.ValidateFunction    = $ValidateFunction
    # }

    [Void]Update() {
        If($this.AugmentTurnDuration -GT 0) {
            $this.AugmentTurnDuration--
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

###############################################################################
#
# BATTLE ACTION
#
# DESCRIBES AN ACTION THAT AN ENTITY CAN TAKE IN BATTLE. ACTIONS GENERALLY ARE
# CAPABLE OF DETERMINING THEIR OWN DAMAGE RESULT AND CAN RUN ROUTINES BEFORE AND
# AFTER SAID CALCULATIONS.
#
###############################################################################
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
        $this.Effect      = $Script:BaCalc
        $this.PreCalc     = $null
        $this.PostCalc    = $null
        $this.EffectValue = 0
        $this.Chance      = 0.0
        $this.Description = ''
    }

    # IT'S UNLIKELY THAT ANY OF THESE CTORS ARE NEEDED
    # BattleAction(
    #     [String]$Name,
    #     [BattleActionType]$Type,
    #     [ScriptBlock]$Effect,
    #     [Int]$Uses,
    #     [Int]$EffectValue,
    #     [Single]$Chance
    # ) {
    #     $this.Name        = $Name
    #     $this.Type        = $Type
    #     $this.Effect      = $Effect
    #     $this.PreCalc     = {}
    #     $this.PostCalc    = {}
    #     $this.EffectValue = $EffectValue
    #     $this.Chance      = $Chance
    #     $this.Description = ''
    # }

    # BattleAction(
    #     [String]$Name,
    #     [String]$Description,
    #     [BattleActionType]$Type,
    #     [ScriptBlock]$Effect,
    #     [Int]$Uses,
    #     [Int]$UsesMax,
    #     [Int]$EffectValue,
    #     [Single]$Chance
    # ) {
    #     $this.Name        = $Name
    #     $this.Type        = $Type
    #     $this.Effect      = $Effect
    #     $this.PreCalc     = {}
    #     $this.PostCalc    = {}
    #     $this.EffectValue = $EffectValue
    #     $this.Chance      = $Chance
    #     $this.Description = $Description
    # }

    # BattleAction(
    #     [String]$Name,
    #     [String]$Description,
    #     [BattleActionType]$Type,
    #     [ScriptBlock]$Effect,
    #     [Int]$MpCost,
    #     [Int]$EffectValue,
    #     [Single]$Chance
    # ) {
    #     $this.Name        = $Name
    #     $this.Type        = $Type
    #     $this.Effect      = $Effect
    #     $this.PreCalc     = {}
    #     $this.PostCalc    = {}
    #     $this.MpCost      = $MpCost
    #     $this.EffectValue = $EffectValue
    #     $this.Chance      = $Chance
    #     $this.Description = $Description
    # }

    # THIS CTOR IS NEEDED BECAUSE POWERSHELL ASSIGNMENT IS BY REFERENCE
    # THANKS C++
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





###############################################################################
#
# BATTLE ACTION RESULT
#
###############################################################################
Class BattleActionResult {
    [Int]$ActionEffectSum
    [BattleEntity]$Originator
    [BattleEntity]$Target
    [BattleActionResultType]$Type

    BattleActionResult() {
        $this.ActionEffectSum = 0
        $this.Originator      = $null
        $this.Target          = $null
        $this.Type            = [BattleActionResultType]::Success
    }
}






###############################################################################
#
# SPECIALIZED BATTLE ACTION CLASSES
#
# THESE SPECIALIZATIONS DEFINE ACTUAL ACTIONS THE PLAYER ENTITY OR ANY ENEMY
# ENTITY CAN USE. EACH CLASS, UPON READING THE PROPERTY VALUES, IS
# SELF-DOCUMENTING AND WILL CONSEQUENTLY NOT BE DOCUMENTED INDEPENDENTLY.
#
# IT'S ALSO WORTH NOTING TOO THAT THE VALUES ASSIGNED TO SOME OF THESE
# PROPERTIES HAVEN'T YET BEEN TESTED AND ARE SUBJECT TO CHANGE UPON FURTHER
# REFINEMENT. THIS MAY PRESENT A GOOD OPPORTUNITY FOR A TEST SUITE.
#
###############################################################################
Class BAPunch : BattleAction {
    BAPunch() : base() {
        $this.Name        = 'Punch'
        $this.Description = 'A punch. Just like dad taught you.'
        $this.Type        = [BattleActionType]::Physical
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BAPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaPhysicalCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalFireCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalIceCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalWaterCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalEarthCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalWindCalc
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
        # $this.Effect      = $Script:BaElementalLightCalc
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
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
        # $this.Effect      = {}
        $this.MpCost      = 500
        $this.EffectValue = 2500
        $this.Chance      = 0.1
    }
}

###############################################################################
#
# BATTLE ENTITY
#
# AN AGGREGATE OF MULTIPLE CLASSES. INTENDED TO DESCRIBE AN ENTITY THAT COULD
# PARTICIPATE IN A BATTLE SITUATION.
#
# NOTABLE PROPERTIES HERE ARE AS FOLLOWS:
#
#  STATS - A HASTABLE [STATID], [BATTLEENTITYPROPERTY]
#  ACTIONLISTING - A HASHTABLE [ACTIONSLOT], [BATTLEACTION]
#  ACTIONMARBLEBAG - A LIST OF FIXED SIZE (10) TO DETMINE ACTION CHANGE LAYOUT
#
###############################################################################
Class BattleEntity {
    [String]$Name
    [Boolean]$CanAct
    [Hashtable]$Stats
    [Hashtable]$ActionListing
    [ScriptBlock]$SpoilsEffect
    [ActionSlot[]]$ActionMarbleBag
    [ConsoleColor24]$NameDrawColor
    [BattleActionType]$Affinity

    BattleEntity() {
        $this.Name            = ''
        $this.CanAct          = $true
        $this.Stats           = @{}
        $this.ActionListing   = @{}
        $this.SpoilsEffect    = $null
        $this.ActionMarbleBag = $null
        $this.NameDrawColor   = [CCTextDefault24]::new()
        $this.Affinity        = [BattleActionType]::None
    }

    # THIS CTOR CAN LIKELY GO AWAY
    # BattleEntity(
    #     [String]$Name,
    #     [Hashtable]$Stats,
    #     [Hashtable]$ActionListing,
    #     [ScriptBlock]$SpoilsEffect,
    #     [ActionSlot[]]$ActionMarbleBag,
    #     [ConsoleColor24]$NameDrawColor,
    #     [BattleActionType]$Affinity
    # ) {
    #     $this.Name            = $Name
    #     $this.Stats           = $Stats
    #     $this.ActionListing   = $ActionListing
    #     $this.SpoilsEffect    = $SpoilsEffect
    #     $this.ActionMarbleBag = $ActionMarbleBag
    #     $this.NameDrawColor   = $NameDrawColor
    #     $this.Affinity        = $Affinity
    # }

    [Void]Update() {
        Foreach($a in $this.Stats.Values) {
            $a.Update()
        }
    }
}

###############################################################################
#
# ENEMY BATTLE ENTITY
#
# AN ENTITY THAT IS NOT THE PLAYER THAT CAN BE ENCOUNTERED IN A BATTLE 
# SCENARIO.
#
###############################################################################
Class EnemyBattleEntity : BattleEntity {
    [EnemyEntityImage]$Image
    [Int]$SpoilsGold
    [MapTileObject[]]$SpoilsItems

    EnemyBattleEntity() {
        $this.Image = $null
        $this.SpoilsGold = 0
        $this.SpoilsItems = @()
        $this.SpoilsEffect = {
            Param(
                [Player]$Player,
                [EnemyBattleEntity]$Opponent
            )

            $Script:TheBattleStatusMessageWindow.WriteSpoilsMessage($Opponent)
            $Script:TheBattleStatusMessageWindow.Draw()
            $Player.CurrentGold += $Opponent.SpoilsGold
            If($Opponent.SpoilsItems.Length -GT 0) {
                [String]$ItemNames = ($Opponent.SpoilsItems | Select-Object -ExpandProperty 'Name') -JOIN ', '
                
                $Script:TheBattleStatusMessageWindow.WriteItemsFoundMessage($ItemNames)
                $Script:TheBattleStatusMessageWindow.Draw()
                Foreach($a in $Opponent.SpoilsItems) {
                    $Player.Inventory.Add($a) | Out-Null
                }
            }
        }
    }

    # THIS CTOR LIKELY ISN'T NECESSARY, AND IF IT IS, IT NEEDS TO GO AWAY IN ACTUAL USE
    # EnemyBattleEntity(
    #     [EnemyEntityImage]$Image
    # ) : base() {
    #     $this.Image       = $Image
    #     $this.SpoilsGold  = 0
    #     $this.SpoilsItems = @()
    #
    #     $this.SpoilsEffect = {
    #         Param(
    #             [Player]$Player,
    #             [EnemyBattleEntity]$Opponent
    #         )
    #
    #         $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
    #             @(
    #                 [ATStringCompositeSc]::new(
    #                     $Opponent.NameDrawColor,
    #                     [ATDecorationNone]::new(),
    #                     $Opponent.Name
    #                 ),
    #                 [ATStringCompositeSc]::new(
    #                     [CCTextDefault24]::new(),
    #                     [ATDecorationNone]::new(),
    #                     ' dropped '
    #                 ),
    #                 [ATStringCompositeSc]::new(
    #                     [CCAppleYellowDark24]::new(),
    #                     [ATDecorationNone]::new(),
    #                     $Opponent.SpoilsGold
    #                 ),
    #                 [ATStringCompositeSc]::new(
    #                     [CCTextDefault24]::new(),
    #                     [ATDecorationNone]::new(),
    #                     ' gold.'
    #                 )
    #             )
    #         )
    #         $Script:TheBattleStatusMessageWindow.Draw()
    #         $Player.CurrentGold += $Opponent.SpoilsGold
    #         If($Opponent.SpoilsItems.Length -GT 0) {
    #             [String]$ItemNames = ($Opponent.SpoilsItems | Select-Object -ExpandProperty 'Name') -JOIN ', '
    #
    #             $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
    #                 @(
    #                     [ATStringCompositeSc]::new(
    #                         [CCTextDefault24]::new(),
    #                         [ATDecorationNone]::new(),
    #                         'Also found '
    #                     ),
    #                     [ATStringCompositeSc]::new(
    #                         [CCAppleYellowDark24]::new(),
    #                         [ATDecorationNone]::new(),
    #                         $ItemNames
    #                     ),
    #                     [ATStringCompositeSc]::new(
    #                         [CCTextDefault24]::new(),
    #                         [ATDecorationNone]::new(),
    #                         '.'
    #                     )
    #                 )
    #             )
    #             $Script:TheBattleStatuMessageWindow.Draw()
    #             Foreach($a in $Opponent.SpoilsItems) {
    #                 $Player.Inventory.Add($a) | Out-Null
    #             }
    #         }
    #     }
    # }
}

###############################################################################
#
# PLAYER
#
# A SPECIALIZATION OF BATTLE ENTITY THAT REPRESENTS THE PLAYER.
#
###############################################################################
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

    # THIS CTOR IS LIKELY NOT NEEDED
    # Player(
    #     [Int]$CurrentGold,
    #     [ATCoordinates]$MapCoordinates,
    #     [List[MapTileObject]]$Inventory,
    #     [String[]]$TargetOfFilter
    # ) : base() {
    #     $this.CurrentGold     = $CurrentGold
    #     $this.MapCoordinates  = $MapCoordinates
    #     $this.Inventory       = $Inventory
    #     $this.TargetOfFilter  = [List[String]]::new()
    #     $this.ActionInventory = [PlayerActionInventory]::new()
    #
    #     Foreach($a in $TargetOfFilter) {
    #         $this.TargetOfFilter.Add($a) | Out-Null
    #     }
    # }
    #
    # THIS CTOR IS LIKELY NOT NEEDED
    # Player(
    #     [String]$Name,
    #     [Int]$BaseHp,
    #     [Int]$MaxHp,
    #     [Int]$BaseMp,
    #     [Int]$MaxMp,
    #     [Int]$Gold,
    #     [String[]]$TargetOfFilter
    # ) : base() {
    #     $this.Name                              = $Name
    #     $this.CurrentGold                       = $Gold
    #     $this.Stats[[StatId]::HitPoints].Base   = $BaseHp
    #     $this.Stats[[StatId]::HitPoints].Max    = $MaxHp
    #     $this.Stats[[StatId]::MagicPoints].Base = $BaseMp
    #     $this.Stats[[StatId]::MagicPoints].Max  = $MaxMp
    #     $this.MapCoordinates                    = [ATCoordinates]::new(0, 0)
    #     $this.Inventory                         = [List[MapTileObject]]::new()
    #     $this.TargetOfFilter                    = [List[String]]::new()
    #     $this.ActionInventory                   = [PlayerActionInventory]::new()
    #
    #     Foreach($a in $TargetOfFilter) {
    #         $this.TargetOfFilter.Add($a) | Out-Null
    #     }
    # }

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

    [Void]MapMoveSouth() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitSouth] -EQ $true) {
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

    [Void]MapMoveNorth() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
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

###############################################################################
#
# PLAYER ITEM INVENTORY
#
# A FOCAL POINT FOR THE PLAYER'S ITEM INVENTORY.
#
###############################################################################
Class PlayerItemInventory {
    [List[MapTileObject]]$Listing

    [Boolean]IsItemInInventory(
        [String]$ItemName
    ) {
        Foreach($a in $this.Listing) {
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
        [Int]$c = 0

        Foreach($a in $this.Inventory) {
            If($a.Name -IEQ $ItemName) {
                If($a.KeyItem -EQ $true) {
                    Return [ItemRemovalStatus]::FailKeyItem
                }
                $this.Listing.RemoveAt($c)

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
            $a = $this.Listing[$Index]
        } Catch {
            Return [ItemRemovalStatus]::FailGeneral
        }
        If($a.KeyItem -EQ $true) {
            Return [ItemRemovalStatus]::FailKeyItem
        }
        $this.Listing.RemoveAt($Index)

        Return [ItemRemovalStatus]::Success
    }
}

###############################################################################
#
# PLAYER ACTION INVENTORY
#
# A FOCAL POINT FOR THE PLAYER'S BATTLE ACTION INVENTORY.
#
###############################################################################
Class PlayerActionInventory {
    [List[BattleAction]]$Listing = [List[BattleAction]]::new()

    [Boolean]IsActionInInventory(
        [String]$ActionName
    ) {
        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ActionName) {
                Return $true
            }
        }

        Return $false
    }

    [BattleAction]GetActionReference(
        [String]$ActionName
    ) {
        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ActionName) {
                Return $a
            }
        }

        Return $null
    }

    [ActionInvRemovalStatus]RemoveActionByName(
        [String]$ActionName
    ) {
        [Int]$c = 0

        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ActionName) {
                $this.Listing.RemoveAt($c)

                Return [ActionInvRemovalStatus]::Success
            }
            $c++
        }

        Return [ActionInvRemovalStatus]::Fail
    }

    [ActionInvRemovalStatus]RemoveActionByIndex(
        [Int]$Index
    ) {
        [BattleAction]$a = $null

        Try {
            $a = $this.Listing[$Index]
        } Catch {
            Return [ActionInvRemovalStatus]::Fail
        }
        $this.Listing.RemoveAt($Index)

        Return [ActionInvRemovalStatus]::Success
    }

    [Boolean]Add(
        [BattleAction]$ActionToAdd
    ) {
        [Boolean]$ActionAlreadyListed = $this.IsActionInInventory($ActionToAdd.Name)

        If($ActionAlreadyListed -EQ $true) {
            Return $false
        }
        # $this.Listing.Add([BattleAction]::new($ActionToAdd))
        $this.Listing.Add($ActionToAdd)

        Return $true
    }
}

###############################################################################
#
# ENEMY ENTITY IMAGE
#
# A COMPOSITION OF AT SCENE IMAGE STRING INTENDED TO BE USED WITH AN ENEMY
# ENTITY. THIS ISN'T AN "IMAGE" PER-SE, RATHER A LARGE ARRAY OF ANSI
# TERMINATED STRINGS THAT COALESCE INTO AN IMAGE.
#
###############################################################################
Class EnemyEntityImage {
    Static [Int]$Width  = 37
    Static [Int]$Height = 15

    [ATSceneImageString[,]]$Image

    EnemyEntityImage() {
        $this.Image = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
    }

    # THIS CTOR LIKELY ISN'T USED
    # EnemyEntityImage(
    #     [ATSceneImageString[,]]$Image
    # ) {
    #     $this.Image = $Image
    # }

    [Void]CreateImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT [EnemyEntityImage]::Height; $r++) {
            For($c = 0; $c -LT [EnemyEntityImage]::Width; $c++) {
                $rf                 = ($r * [EnemyEntityImage]::Width) + $c
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new(([BattleEnemyImageWindow]::ImageDrawRowOffset + $r), ([BattleEnemyImageWindow]::ImageDrawColumnOffset + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT [EnemyEntityImage]::Height; $r++) {
            For($c = 0; $c -LT [EnemyEntityImage]::Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}

###############################################################################
#
# EEI EMPTY
#
# A SYMBOLIC REPRESENTATION OF AN EMPTY ENEMY IMAGE.
#
###############################################################################
Class EEIEmpty : EnemyEntityImage {
    EEIEmpty() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# EEI INTERNAL BASE
#
# AN EXPRESSION OF THE ENEMY ENTITY IMAGE THAT ADDS A COLOR MAP. THIS IS THE
# BASE FOR PRACTICAL APPLICATIONS.
#
###############################################################################
Class EEIInternalBase : EnemyEntityImage {
    [ATBackgroundColor24[]]$ColorMap

    EEIInternalBase() : base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
    }
}

###############################################################################
#
# EEI SPECIALIZATIONS
#
# THESE ARE SPECIALIZATIONS OF EEI INTERNAL BASE THAT REPRESENT ACTUAL "IMAGES"
# THAT WOULD BE DRAWN IN THE BATTLE WINDOW. THE NAMES OF THE CLASSES ARE
# SELF-EVIDENT.
#
###############################################################################
Class EEIBat : EEIInternalBase {
    EEIBat() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[18]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[19]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[54]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[55]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[56]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[57]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[90]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[91]  = [CCAppleRedDark24]::new()
        $this.ColorMap[92]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[93]  = [CCAppleRedDark24]::new()
        $this.ColorMap[94]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[95]  = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[117] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[123] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[128] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[129] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[130] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[131] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[136] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[142] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[153] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[154] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[155] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[156] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[159] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[160] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[161] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[162] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[163] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[164] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[165] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[166] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[167] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[168] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[169] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[170] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[171] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[172] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[173] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[174] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[177] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[178] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[179] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[180] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[190] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[191] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[192] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[193] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[194] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[195] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[196] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[197] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[198] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[199] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[200] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[201] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[202] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[203] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[204] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[205] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[206] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[207] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[208] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[209] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[210] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[211] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[212] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[213] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[214] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[215] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[216] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[217] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[226] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[227] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[228] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[229] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[230] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[231] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[232] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[233] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[234] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[235] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[236] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[237] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[238] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[239] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[240] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[241] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[242] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[243] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[244] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[245] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[246] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[247] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[248] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[249] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[250] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[251] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[252] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[253] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[254] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[255] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[263] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[264] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[265] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[266] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[267] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[268] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[269] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[270] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[271] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[272] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[273] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[274] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[275] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[276] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[277] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[278] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[279] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[280] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[281] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[282] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[283] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[284] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[285] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[286] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[287] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[288] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[289] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[290] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[291] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[292] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[300] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[301] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[302] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[303] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[304] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[305] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[306] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[307] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[308] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[309] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[310] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[311] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[312] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[313] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[314] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[315] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[316] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[317] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[318] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[319] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[320] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[321] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[322] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[323] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[324] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[325] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[326] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[327] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[328] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[329] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[336] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[337] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[338] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[339] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[340] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[341] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[342] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[343] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[344] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[348] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[349] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[350] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[351] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[352] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[353] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[354] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[355] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[359] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[360] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[361] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[362] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[363] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[364] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[365] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[366] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[367] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[373] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[374] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[375] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[379] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[380] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[386] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[387] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[388] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[389] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[390] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[391] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[397] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[398] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[402] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[403] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[404] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[410] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[424] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[425] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[426] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[427] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[441] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[459] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[462] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[463] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[466] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCAppleGrey3Dark24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleGrey1Dark24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class EEINightwing : EEIInternalBase {
    EEINightwing() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[18]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[19]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[54]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[55]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[56]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[57]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[90]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[91]  = [CCAppleRedDark24]::new()
        $this.ColorMap[92]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[93]  = [CCAppleRedDark24]::new()
        $this.ColorMap[94]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[95]  = [CCAppleIndigoDark24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCApplePurpleDark24]::new()
        $this.ColorMap[117] = [CCApplePurpleDark24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCApplePurpleDark24]::new()
        $this.ColorMap[123] = [CCApplePurpleDark24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[128] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[129] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[130] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[131] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCApplePurpleDark24]::new()
        $this.ColorMap[136] = [CCApplePurpleDark24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCApplePurpleDark24]::new()
        $this.ColorMap[142] = [CCApplePurpleDark24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCApplePurpleDark24]::new()
        $this.ColorMap[153] = [CCApplePurpleDark24]::new()
        $this.ColorMap[154] = [CCApplePurpleDark24]::new()
        $this.ColorMap[155] = [CCApplePurpleDark24]::new()
        $this.ColorMap[156] = [CCApplePurpleDark24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCApplePurpleDark24]::new()
        $this.ColorMap[159] = [CCApplePurpleDark24]::new()
        $this.ColorMap[160] = [CCApplePurpleDark24]::new()
        $this.ColorMap[161] = [CCApplePurpleDark24]::new()
        $this.ColorMap[162] = [CCApplePurpleDark24]::new()
        $this.ColorMap[163] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[164] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[165] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[166] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[167] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[168] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[169] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[170] = [CCApplePurpleDark24]::new()
        $this.ColorMap[171] = [CCApplePurpleDark24]::new()
        $this.ColorMap[172] = [CCApplePurpleDark24]::new()
        $this.ColorMap[173] = [CCApplePurpleDark24]::new()
        $this.ColorMap[174] = [CCApplePurpleDark24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCApplePurpleDark24]::new()
        $this.ColorMap[177] = [CCApplePurpleDark24]::new()
        $this.ColorMap[178] = [CCApplePurpleDark24]::new()
        $this.ColorMap[179] = [CCApplePurpleDark24]::new()
        $this.ColorMap[180] = [CCApplePurpleDark24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCApplePurpleDark24]::new()
        $this.ColorMap[190] = [CCApplePurpleDark24]::new()
        $this.ColorMap[191] = [CCApplePurpleDark24]::new()
        $this.ColorMap[192] = [CCApplePurpleDark24]::new()
        $this.ColorMap[193] = [CCApplePurpleDark24]::new()
        $this.ColorMap[194] = [CCApplePurpleDark24]::new()
        $this.ColorMap[195] = [CCApplePurpleDark24]::new()
        $this.ColorMap[196] = [CCApplePurpleDark24]::new()
        $this.ColorMap[197] = [CCApplePurpleDark24]::new()
        $this.ColorMap[198] = [CCApplePurpleDark24]::new()
        $this.ColorMap[199] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[200] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[201] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[202] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[203] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[204] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[205] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[206] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[207] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[208] = [CCApplePurpleDark24]::new()
        $this.ColorMap[209] = [CCApplePurpleDark24]::new()
        $this.ColorMap[210] = [CCApplePurpleDark24]::new()
        $this.ColorMap[211] = [CCApplePurpleDark24]::new()
        $this.ColorMap[212] = [CCApplePurpleDark24]::new()
        $this.ColorMap[213] = [CCApplePurpleDark24]::new()
        $this.ColorMap[214] = [CCApplePurpleDark24]::new()
        $this.ColorMap[215] = [CCApplePurpleDark24]::new()
        $this.ColorMap[216] = [CCApplePurpleDark24]::new()
        $this.ColorMap[217] = [CCApplePurpleDark24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCApplePurpleDark24]::new()
        $this.ColorMap[226] = [CCApplePurpleDark24]::new()
        $this.ColorMap[227] = [CCApplePurpleDark24]::new()
        $this.ColorMap[228] = [CCApplePurpleDark24]::new()
        $this.ColorMap[229] = [CCApplePurpleDark24]::new()
        $this.ColorMap[230] = [CCApplePurpleDark24]::new()
        $this.ColorMap[231] = [CCApplePurpleDark24]::new()
        $this.ColorMap[232] = [CCApplePurpleDark24]::new()
        $this.ColorMap[233] = [CCApplePurpleDark24]::new()
        $this.ColorMap[234] = [CCApplePurpleDark24]::new()
        $this.ColorMap[235] = [CCApplePurpleDark24]::new()
        $this.ColorMap[236] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[237] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[238] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[239] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[240] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[241] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[242] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[243] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[244] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[245] = [CCApplePurpleDark24]::new()
        $this.ColorMap[246] = [CCApplePurpleDark24]::new()
        $this.ColorMap[247] = [CCApplePurpleDark24]::new()
        $this.ColorMap[248] = [CCApplePurpleDark24]::new()
        $this.ColorMap[249] = [CCApplePurpleDark24]::new()
        $this.ColorMap[250] = [CCApplePurpleDark24]::new()
        $this.ColorMap[251] = [CCApplePurpleDark24]::new()
        $this.ColorMap[252] = [CCApplePurpleDark24]::new()
        $this.ColorMap[253] = [CCApplePurpleDark24]::new()
        $this.ColorMap[254] = [CCApplePurpleDark24]::new()
        $this.ColorMap[255] = [CCApplePurpleDark24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCApplePurpleDark24]::new()
        $this.ColorMap[263] = [CCApplePurpleDark24]::new()
        $this.ColorMap[264] = [CCApplePurpleDark24]::new()
        $this.ColorMap[265] = [CCApplePurpleDark24]::new()
        $this.ColorMap[266] = [CCApplePurpleDark24]::new()
        $this.ColorMap[267] = [CCApplePurpleDark24]::new()
        $this.ColorMap[268] = [CCApplePurpleDark24]::new()
        $this.ColorMap[269] = [CCApplePurpleDark24]::new()
        $this.ColorMap[270] = [CCApplePurpleDark24]::new()
        $this.ColorMap[271] = [CCApplePurpleDark24]::new()
        $this.ColorMap[272] = [CCApplePurpleDark24]::new()
        $this.ColorMap[273] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[274] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[275] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[276] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[277] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[278] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[279] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[280] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[281] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[282] = [CCApplePurpleDark24]::new()
        $this.ColorMap[283] = [CCApplePurpleDark24]::new()
        $this.ColorMap[284] = [CCApplePurpleDark24]::new()
        $this.ColorMap[285] = [CCApplePurpleDark24]::new()
        $this.ColorMap[286] = [CCApplePurpleDark24]::new()
        $this.ColorMap[287] = [CCApplePurpleDark24]::new()
        $this.ColorMap[288] = [CCApplePurpleDark24]::new()
        $this.ColorMap[289] = [CCApplePurpleDark24]::new()
        $this.ColorMap[290] = [CCApplePurpleDark24]::new()
        $this.ColorMap[291] = [CCApplePurpleDark24]::new()
        $this.ColorMap[292] = [CCApplePurpleDark24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCApplePurpleDark24]::new()
        $this.ColorMap[300] = [CCApplePurpleDark24]::new()
        $this.ColorMap[301] = [CCApplePurpleDark24]::new()
        $this.ColorMap[302] = [CCApplePurpleDark24]::new()
        $this.ColorMap[303] = [CCApplePurpleDark24]::new()
        $this.ColorMap[304] = [CCApplePurpleDark24]::new()
        $this.ColorMap[305] = [CCApplePurpleDark24]::new()
        $this.ColorMap[306] = [CCApplePurpleDark24]::new()
        $this.ColorMap[307] = [CCApplePurpleDark24]::new()
        $this.ColorMap[308] = [CCApplePurpleDark24]::new()
        $this.ColorMap[309] = [CCApplePurpleDark24]::new()
        $this.ColorMap[310] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[311] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[312] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[313] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[314] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[315] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[316] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[317] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[318] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[319] = [CCApplePurpleDark24]::new()
        $this.ColorMap[320] = [CCApplePurpleDark24]::new()
        $this.ColorMap[321] = [CCApplePurpleDark24]::new()
        $this.ColorMap[322] = [CCApplePurpleDark24]::new()
        $this.ColorMap[323] = [CCApplePurpleDark24]::new()
        $this.ColorMap[324] = [CCApplePurpleDark24]::new()
        $this.ColorMap[325] = [CCApplePurpleDark24]::new()
        $this.ColorMap[326] = [CCApplePurpleDark24]::new()
        $this.ColorMap[327] = [CCApplePurpleDark24]::new()
        $this.ColorMap[328] = [CCApplePurpleDark24]::new()
        $this.ColorMap[329] = [CCApplePurpleDark24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCApplePurpleDark24]::new()
        $this.ColorMap[336] = [CCApplePurpleDark24]::new()
        $this.ColorMap[337] = [CCApplePurpleDark24]::new()
        $this.ColorMap[338] = [CCApplePurpleDark24]::new()
        $this.ColorMap[339] = [CCApplePurpleDark24]::new()
        $this.ColorMap[340] = [CCApplePurpleDark24]::new()
        $this.ColorMap[341] = [CCApplePurpleDark24]::new()
        $this.ColorMap[342] = [CCApplePurpleDark24]::new()
        $this.ColorMap[343] = [CCApplePurpleDark24]::new()
        $this.ColorMap[344] = [CCApplePurpleDark24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCApplePurpleDark24]::new()
        $this.ColorMap[348] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[349] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[350] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[351] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[352] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[353] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[354] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[355] = [CCApplePurpleDark24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCApplePurpleDark24]::new()
        $this.ColorMap[359] = [CCApplePurpleDark24]::new()
        $this.ColorMap[360] = [CCApplePurpleDark24]::new()
        $this.ColorMap[361] = [CCApplePurpleDark24]::new()
        $this.ColorMap[362] = [CCApplePurpleDark24]::new()
        $this.ColorMap[363] = [CCApplePurpleDark24]::new()
        $this.ColorMap[364] = [CCApplePurpleDark24]::new()
        $this.ColorMap[365] = [CCApplePurpleDark24]::new()
        $this.ColorMap[366] = [CCApplePurpleDark24]::new()
        $this.ColorMap[367] = [CCApplePurpleDark24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCApplePurpleDark24]::new()
        $this.ColorMap[373] = [CCApplePurpleDark24]::new()
        $this.ColorMap[374] = [CCApplePurpleDark24]::new()
        $this.ColorMap[375] = [CCApplePurpleDark24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCApplePurpleDark24]::new()
        $this.ColorMap[379] = [CCApplePurpleDark24]::new()
        $this.ColorMap[380] = [CCApplePurpleDark24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[386] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[387] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[388] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[389] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[390] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[391] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCApplePurpleDark24]::new()
        $this.ColorMap[397] = [CCApplePurpleDark24]::new()
        $this.ColorMap[398] = [CCApplePurpleDark24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCApplePurpleDark24]::new()
        $this.ColorMap[402] = [CCApplePurpleDark24]::new()
        $this.ColorMap[403] = [CCApplePurpleDark24]::new()
        $this.ColorMap[404] = [CCApplePurpleDark24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCApplePurpleDark24]::new()
        $this.ColorMap[410] = [CCApplePurpleDark24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCApplePurpleDark24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[424] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[425] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[426] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[427] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCApplePurpleDark24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCApplePurpleDark24]::new()
        $this.ColorMap[441] = [CCApplePurpleDark24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCApplePurpleDark24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[459] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[462] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[463] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[466] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCApplePurpleDark24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleIndigoDark24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class EEIWingblight : EEIInternalBase {
    EEIWingblight() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCApplePinkDark24]::new()
        $this.ColorMap[18]  = [CCApplePinkDark24]::new()
        $this.ColorMap[19]  = [CCApplePinkDark24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCApplePinkDark24]::new()
        $this.ColorMap[54]  = [CCApplePinkDark24]::new()
        $this.ColorMap[55]  = [CCApplePinkDark24]::new()
        $this.ColorMap[56]  = [CCApplePinkDark24]::new()
        $this.ColorMap[57]  = [CCApplePinkDark24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCApplePinkDark24]::new()
        $this.ColorMap[90]  = [CCApplePinkDark24]::new()
        $this.ColorMap[91]  = [CCAppleGrey6Light24]::new()
        $this.ColorMap[92]  = [CCApplePinkDark24]::new()
        $this.ColorMap[93]  = [CCAppleGrey6Light24]::new()
        $this.ColorMap[94]  = [CCApplePinkDark24]::new()
        $this.ColorMap[95]  = [CCApplePinkDark24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCApplePurpleDark24]::new()
        $this.ColorMap[117] = [CCApplePurpleDark24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCApplePurpleDark24]::new()
        $this.ColorMap[123] = [CCApplePurpleDark24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCApplePinkDark24]::new()
        $this.ColorMap[128] = [CCApplePinkDark24]::new()
        $this.ColorMap[129] = [CCApplePinkDark24]::new()
        $this.ColorMap[130] = [CCApplePinkDark24]::new()
        $this.ColorMap[131] = [CCApplePinkDark24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCApplePurpleDark24]::new()
        $this.ColorMap[136] = [CCApplePurpleDark24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCApplePurpleDark24]::new()
        $this.ColorMap[142] = [CCApplePurpleDark24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCApplePurpleDark24]::new()
        $this.ColorMap[153] = [CCApplePurpleDark24]::new()
        $this.ColorMap[154] = [CCApplePurpleDark24]::new()
        $this.ColorMap[155] = [CCApplePurpleDark24]::new()
        $this.ColorMap[156] = [CCApplePurpleDark24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCApplePurpleDark24]::new()
        $this.ColorMap[159] = [CCApplePurpleDark24]::new()
        $this.ColorMap[160] = [CCApplePurpleDark24]::new()
        $this.ColorMap[161] = [CCApplePurpleDark24]::new()
        $this.ColorMap[162] = [CCApplePurpleDark24]::new()
        $this.ColorMap[163] = [CCApplePinkDark24]::new()
        $this.ColorMap[164] = [CCApplePinkDark24]::new()
        $this.ColorMap[165] = [CCApplePinkDark24]::new()
        $this.ColorMap[166] = [CCApplePinkDark24]::new()
        $this.ColorMap[167] = [CCApplePinkDark24]::new()
        $this.ColorMap[168] = [CCApplePinkDark24]::new()
        $this.ColorMap[169] = [CCApplePinkDark24]::new()
        $this.ColorMap[170] = [CCApplePurpleDark24]::new()
        $this.ColorMap[171] = [CCApplePurpleDark24]::new()
        $this.ColorMap[172] = [CCApplePurpleDark24]::new()
        $this.ColorMap[173] = [CCApplePurpleDark24]::new()
        $this.ColorMap[174] = [CCApplePurpleDark24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCApplePurpleDark24]::new()
        $this.ColorMap[177] = [CCApplePurpleDark24]::new()
        $this.ColorMap[178] = [CCApplePurpleDark24]::new()
        $this.ColorMap[179] = [CCApplePurpleDark24]::new()
        $this.ColorMap[180] = [CCApplePurpleDark24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCApplePurpleDark24]::new()
        $this.ColorMap[190] = [CCApplePurpleDark24]::new()
        $this.ColorMap[191] = [CCApplePurpleDark24]::new()
        $this.ColorMap[192] = [CCApplePurpleDark24]::new()
        $this.ColorMap[193] = [CCApplePurpleDark24]::new()
        $this.ColorMap[194] = [CCApplePurpleDark24]::new()
        $this.ColorMap[195] = [CCApplePurpleDark24]::new()
        $this.ColorMap[196] = [CCApplePurpleDark24]::new()
        $this.ColorMap[197] = [CCApplePurpleDark24]::new()
        $this.ColorMap[198] = [CCApplePurpleDark24]::new()
        $this.ColorMap[199] = [CCApplePinkDark24]::new()
        $this.ColorMap[200] = [CCApplePinkDark24]::new()
        $this.ColorMap[201] = [CCApplePinkDark24]::new()
        $this.ColorMap[202] = [CCApplePinkDark24]::new()
        $this.ColorMap[203] = [CCApplePinkDark24]::new()
        $this.ColorMap[204] = [CCApplePinkDark24]::new()
        $this.ColorMap[205] = [CCApplePinkDark24]::new()
        $this.ColorMap[206] = [CCApplePinkDark24]::new()
        $this.ColorMap[207] = [CCApplePinkDark24]::new()
        $this.ColorMap[208] = [CCApplePurpleDark24]::new()
        $this.ColorMap[209] = [CCApplePurpleDark24]::new()
        $this.ColorMap[210] = [CCApplePurpleDark24]::new()
        $this.ColorMap[211] = [CCApplePurpleDark24]::new()
        $this.ColorMap[212] = [CCApplePurpleDark24]::new()
        $this.ColorMap[213] = [CCApplePurpleDark24]::new()
        $this.ColorMap[214] = [CCApplePurpleDark24]::new()
        $this.ColorMap[215] = [CCApplePurpleDark24]::new()
        $this.ColorMap[216] = [CCApplePurpleDark24]::new()
        $this.ColorMap[217] = [CCApplePurpleDark24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCApplePurpleDark24]::new()
        $this.ColorMap[226] = [CCApplePurpleDark24]::new()
        $this.ColorMap[227] = [CCApplePurpleDark24]::new()
        $this.ColorMap[228] = [CCApplePurpleDark24]::new()
        $this.ColorMap[229] = [CCApplePurpleDark24]::new()
        $this.ColorMap[230] = [CCApplePurpleDark24]::new()
        $this.ColorMap[231] = [CCApplePurpleDark24]::new()
        $this.ColorMap[232] = [CCApplePurpleDark24]::new()
        $this.ColorMap[233] = [CCApplePurpleDark24]::new()
        $this.ColorMap[234] = [CCApplePurpleDark24]::new()
        $this.ColorMap[235] = [CCApplePurpleDark24]::new()
        $this.ColorMap[236] = [CCApplePinkDark24]::new()
        $this.ColorMap[237] = [CCApplePinkDark24]::new()
        $this.ColorMap[238] = [CCApplePinkDark24]::new()
        $this.ColorMap[239] = [CCApplePinkDark24]::new()
        $this.ColorMap[240] = [CCApplePinkDark24]::new()
        $this.ColorMap[241] = [CCApplePinkDark24]::new()
        $this.ColorMap[242] = [CCApplePinkDark24]::new()
        $this.ColorMap[243] = [CCApplePinkDark24]::new()
        $this.ColorMap[244] = [CCApplePinkDark24]::new()
        $this.ColorMap[245] = [CCApplePurpleDark24]::new()
        $this.ColorMap[246] = [CCApplePurpleDark24]::new()
        $this.ColorMap[247] = [CCApplePurpleDark24]::new()
        $this.ColorMap[248] = [CCApplePurpleDark24]::new()
        $this.ColorMap[249] = [CCApplePurpleDark24]::new()
        $this.ColorMap[250] = [CCApplePurpleDark24]::new()
        $this.ColorMap[251] = [CCApplePurpleDark24]::new()
        $this.ColorMap[252] = [CCApplePurpleDark24]::new()
        $this.ColorMap[253] = [CCApplePurpleDark24]::new()
        $this.ColorMap[254] = [CCApplePurpleDark24]::new()
        $this.ColorMap[255] = [CCApplePurpleDark24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCApplePurpleDark24]::new()
        $this.ColorMap[263] = [CCApplePurpleDark24]::new()
        $this.ColorMap[264] = [CCApplePurpleDark24]::new()
        $this.ColorMap[265] = [CCApplePurpleDark24]::new()
        $this.ColorMap[266] = [CCApplePurpleDark24]::new()
        $this.ColorMap[267] = [CCApplePurpleDark24]::new()
        $this.ColorMap[268] = [CCApplePurpleDark24]::new()
        $this.ColorMap[269] = [CCApplePurpleDark24]::new()
        $this.ColorMap[270] = [CCApplePurpleDark24]::new()
        $this.ColorMap[271] = [CCApplePurpleDark24]::new()
        $this.ColorMap[272] = [CCApplePurpleDark24]::new()
        $this.ColorMap[273] = [CCApplePinkDark24]::new()
        $this.ColorMap[274] = [CCApplePinkDark24]::new()
        $this.ColorMap[275] = [CCApplePinkDark24]::new()
        $this.ColorMap[276] = [CCApplePinkDark24]::new()
        $this.ColorMap[277] = [CCApplePinkDark24]::new()
        $this.ColorMap[278] = [CCApplePinkDark24]::new()
        $this.ColorMap[279] = [CCApplePinkDark24]::new()
        $this.ColorMap[280] = [CCApplePinkDark24]::new()
        $this.ColorMap[281] = [CCApplePinkDark24]::new()
        $this.ColorMap[282] = [CCApplePurpleDark24]::new()
        $this.ColorMap[283] = [CCApplePurpleDark24]::new()
        $this.ColorMap[284] = [CCApplePurpleDark24]::new()
        $this.ColorMap[285] = [CCApplePurpleDark24]::new()
        $this.ColorMap[286] = [CCApplePurpleDark24]::new()
        $this.ColorMap[287] = [CCApplePurpleDark24]::new()
        $this.ColorMap[288] = [CCApplePurpleDark24]::new()
        $this.ColorMap[289] = [CCApplePurpleDark24]::new()
        $this.ColorMap[290] = [CCApplePurpleDark24]::new()
        $this.ColorMap[291] = [CCApplePurpleDark24]::new()
        $this.ColorMap[292] = [CCApplePurpleDark24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCApplePurpleDark24]::new()
        $this.ColorMap[300] = [CCApplePurpleDark24]::new()
        $this.ColorMap[301] = [CCApplePurpleDark24]::new()
        $this.ColorMap[302] = [CCApplePurpleDark24]::new()
        $this.ColorMap[303] = [CCApplePurpleDark24]::new()
        $this.ColorMap[304] = [CCApplePurpleDark24]::new()
        $this.ColorMap[305] = [CCApplePurpleDark24]::new()
        $this.ColorMap[306] = [CCApplePurpleDark24]::new()
        $this.ColorMap[307] = [CCApplePurpleDark24]::new()
        $this.ColorMap[308] = [CCApplePurpleDark24]::new()
        $this.ColorMap[309] = [CCApplePurpleDark24]::new()
        $this.ColorMap[310] = [CCApplePinkDark24]::new()
        $this.ColorMap[311] = [CCApplePinkDark24]::new()
        $this.ColorMap[312] = [CCApplePinkDark24]::new()
        $this.ColorMap[313] = [CCApplePinkDark24]::new()
        $this.ColorMap[314] = [CCApplePinkDark24]::new()
        $this.ColorMap[315] = [CCApplePinkDark24]::new()
        $this.ColorMap[316] = [CCApplePinkDark24]::new()
        $this.ColorMap[317] = [CCApplePinkDark24]::new()
        $this.ColorMap[318] = [CCApplePinkDark24]::new()
        $this.ColorMap[319] = [CCApplePurpleDark24]::new()
        $this.ColorMap[320] = [CCApplePurpleDark24]::new()
        $this.ColorMap[321] = [CCApplePurpleDark24]::new()
        $this.ColorMap[322] = [CCApplePurpleDark24]::new()
        $this.ColorMap[323] = [CCApplePurpleDark24]::new()
        $this.ColorMap[324] = [CCApplePurpleDark24]::new()
        $this.ColorMap[325] = [CCApplePurpleDark24]::new()
        $this.ColorMap[326] = [CCApplePurpleDark24]::new()
        $this.ColorMap[327] = [CCApplePurpleDark24]::new()
        $this.ColorMap[328] = [CCApplePurpleDark24]::new()
        $this.ColorMap[329] = [CCApplePurpleDark24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCApplePurpleDark24]::new()
        $this.ColorMap[336] = [CCApplePurpleDark24]::new()
        $this.ColorMap[337] = [CCApplePurpleDark24]::new()
        $this.ColorMap[338] = [CCApplePurpleDark24]::new()
        $this.ColorMap[339] = [CCApplePurpleDark24]::new()
        $this.ColorMap[340] = [CCApplePurpleDark24]::new()
        $this.ColorMap[341] = [CCApplePurpleDark24]::new()
        $this.ColorMap[342] = [CCApplePurpleDark24]::new()
        $this.ColorMap[343] = [CCApplePurpleDark24]::new()
        $this.ColorMap[344] = [CCApplePurpleDark24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCApplePurpleDark24]::new()
        $this.ColorMap[348] = [CCApplePinkDark24]::new()
        $this.ColorMap[349] = [CCApplePinkDark24]::new()
        $this.ColorMap[350] = [CCApplePinkDark24]::new()
        $this.ColorMap[351] = [CCApplePinkDark24]::new()
        $this.ColorMap[352] = [CCApplePinkDark24]::new()
        $this.ColorMap[353] = [CCApplePinkDark24]::new()
        $this.ColorMap[354] = [CCApplePinkDark24]::new()
        $this.ColorMap[355] = [CCApplePurpleDark24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCApplePurpleDark24]::new()
        $this.ColorMap[359] = [CCApplePurpleDark24]::new()
        $this.ColorMap[360] = [CCApplePurpleDark24]::new()
        $this.ColorMap[361] = [CCApplePurpleDark24]::new()
        $this.ColorMap[362] = [CCApplePurpleDark24]::new()
        $this.ColorMap[363] = [CCApplePurpleDark24]::new()
        $this.ColorMap[364] = [CCApplePurpleDark24]::new()
        $this.ColorMap[365] = [CCApplePurpleDark24]::new()
        $this.ColorMap[366] = [CCApplePurpleDark24]::new()
        $this.ColorMap[367] = [CCApplePurpleDark24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCApplePurpleDark24]::new()
        $this.ColorMap[373] = [CCApplePurpleDark24]::new()
        $this.ColorMap[374] = [CCApplePurpleDark24]::new()
        $this.ColorMap[375] = [CCApplePurpleDark24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCApplePurpleDark24]::new()
        $this.ColorMap[379] = [CCApplePurpleDark24]::new()
        $this.ColorMap[380] = [CCApplePurpleDark24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCApplePinkDark24]::new()
        $this.ColorMap[386] = [CCApplePinkDark24]::new()
        $this.ColorMap[387] = [CCApplePinkDark24]::new()
        $this.ColorMap[388] = [CCApplePinkDark24]::new()
        $this.ColorMap[389] = [CCApplePinkDark24]::new()
        $this.ColorMap[390] = [CCApplePinkDark24]::new()
        $this.ColorMap[391] = [CCApplePinkDark24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCApplePurpleDark24]::new()
        $this.ColorMap[397] = [CCApplePurpleDark24]::new()
        $this.ColorMap[398] = [CCApplePurpleDark24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCApplePurpleDark24]::new()
        $this.ColorMap[402] = [CCApplePurpleDark24]::new()
        $this.ColorMap[403] = [CCApplePurpleDark24]::new()
        $this.ColorMap[404] = [CCApplePurpleDark24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCApplePurpleDark24]::new()
        $this.ColorMap[410] = [CCApplePurpleDark24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCApplePurpleDark24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCApplePinkDark24]::new()
        $this.ColorMap[424] = [CCApplePinkDark24]::new()
        $this.ColorMap[425] = [CCApplePinkDark24]::new()
        $this.ColorMap[426] = [CCApplePinkDark24]::new()
        $this.ColorMap[427] = [CCApplePinkDark24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCApplePurpleDark24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCApplePurpleDark24]::new()
        $this.ColorMap[441] = [CCApplePurpleDark24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCApplePurpleDark24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[459] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCApplePinkDark24]::new()
        $this.ColorMap[462] = [CCApplePinkDark24]::new()
        $this.ColorMap[463] = [CCApplePinkDark24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[466] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCApplePurpleDark24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCApplePinkDark24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleOrangeDark24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class EEIDarkfang : EEIInternalBase {
    EEIDarkfang() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[18]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[19]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[54]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[55]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[56]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[57]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[90]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[91]  = [CCAppleIndigoLight24]::new()
        $this.ColorMap[92]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[93]  = [CCAppleIndigoLight24]::new()
        $this.ColorMap[94]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[95]  = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[117] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[123] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[128] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[129] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[130] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[131] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[136] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[142] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[153] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[154] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[155] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[156] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[159] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[160] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[161] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[162] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[163] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[164] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[165] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[166] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[167] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[168] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[169] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[170] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[171] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[172] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[173] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[174] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[177] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[178] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[179] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[180] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[190] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[191] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[192] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[193] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[194] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[195] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[196] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[197] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[198] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[199] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[200] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[201] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[202] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[203] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[204] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[205] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[206] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[207] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[208] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[209] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[210] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[211] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[212] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[213] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[214] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[215] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[216] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[217] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[226] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[227] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[228] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[229] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[230] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[231] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[232] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[233] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[234] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[235] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[236] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[237] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[238] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[239] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[240] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[241] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[242] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[243] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[244] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[245] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[246] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[247] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[248] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[249] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[250] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[251] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[252] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[253] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[254] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[255] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[263] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[264] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[265] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[266] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[267] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[268] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[269] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[270] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[271] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[272] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[273] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[274] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[275] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[276] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[277] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[278] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[279] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[280] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[281] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[282] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[283] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[284] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[285] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[286] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[287] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[288] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[289] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[290] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[291] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[292] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[300] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[301] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[302] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[303] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[304] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[305] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[306] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[307] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[308] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[309] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[310] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[311] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[312] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[313] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[314] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[315] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[316] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[317] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[318] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[319] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[320] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[321] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[322] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[323] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[324] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[325] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[326] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[327] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[328] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[329] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[336] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[337] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[338] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[339] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[340] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[341] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[342] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[343] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[344] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[348] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[349] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[350] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[351] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[352] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[353] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[354] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[355] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[359] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[360] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[361] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[362] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[363] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[364] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[365] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[366] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[367] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[373] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[374] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[375] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[379] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[380] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[386] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[387] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[388] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[389] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[390] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[391] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[397] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[398] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[402] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[403] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[404] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[410] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleRedDark24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[424] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[425] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[426] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[427] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleRedDark24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[441] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleRedDark24]::new()
        $this.ColorMap[459] = [CCAppleRedDark24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[462] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[463] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleRedDark24]::new()
        $this.ColorMap[466] = [CCAppleRedDark24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCAppleGrey4Dark24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleRedDark24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleGrey6Dark24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleRedDark24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class EEINocturna : EEIInternalBase {
    EEINocturna() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[18]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[19]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[54]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[55]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[56]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[57]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[90]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[91]  = [CCAppleVPinkADark24]::new()
        $this.ColorMap[92]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[93]  = [CCAppleVPinkADark24]::new()
        $this.ColorMap[94]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[95]  = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCAppleVMintALight24]::new()
        $this.ColorMap[117] = [CCAppleVMintALight24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCAppleVMintALight24]::new()
        $this.ColorMap[123] = [CCAppleVMintALight24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[128] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[129] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[130] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[131] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCAppleVMintALight24]::new()
        $this.ColorMap[136] = [CCAppleVMintALight24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCAppleVMintALight24]::new()
        $this.ColorMap[142] = [CCAppleVMintALight24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCAppleVMintALight24]::new()
        $this.ColorMap[153] = [CCAppleVMintALight24]::new()
        $this.ColorMap[154] = [CCAppleVMintALight24]::new()
        $this.ColorMap[155] = [CCAppleVMintALight24]::new()
        $this.ColorMap[156] = [CCAppleVMintALight24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCAppleVMintALight24]::new()
        $this.ColorMap[159] = [CCAppleVMintALight24]::new()
        $this.ColorMap[160] = [CCAppleVMintALight24]::new()
        $this.ColorMap[161] = [CCAppleVMintALight24]::new()
        $this.ColorMap[162] = [CCAppleVMintALight24]::new()
        $this.ColorMap[163] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[164] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[165] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[166] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[167] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[168] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[169] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[170] = [CCAppleVMintALight24]::new()
        $this.ColorMap[171] = [CCAppleVMintALight24]::new()
        $this.ColorMap[172] = [CCAppleVMintALight24]::new()
        $this.ColorMap[173] = [CCAppleVMintALight24]::new()
        $this.ColorMap[174] = [CCAppleVMintALight24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCAppleVMintALight24]::new()
        $this.ColorMap[177] = [CCAppleVMintALight24]::new()
        $this.ColorMap[178] = [CCAppleVMintALight24]::new()
        $this.ColorMap[179] = [CCAppleVMintALight24]::new()
        $this.ColorMap[180] = [CCAppleVMintALight24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCAppleVMintALight24]::new()
        $this.ColorMap[190] = [CCAppleVMintALight24]::new()
        $this.ColorMap[191] = [CCAppleVMintALight24]::new()
        $this.ColorMap[192] = [CCAppleVMintALight24]::new()
        $this.ColorMap[193] = [CCAppleVMintALight24]::new()
        $this.ColorMap[194] = [CCAppleVMintALight24]::new()
        $this.ColorMap[195] = [CCAppleVMintALight24]::new()
        $this.ColorMap[196] = [CCAppleVMintALight24]::new()
        $this.ColorMap[197] = [CCAppleVMintALight24]::new()
        $this.ColorMap[198] = [CCAppleVMintALight24]::new()
        $this.ColorMap[199] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[200] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[201] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[202] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[203] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[204] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[205] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[206] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[207] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[208] = [CCAppleVMintALight24]::new()
        $this.ColorMap[209] = [CCAppleVMintALight24]::new()
        $this.ColorMap[210] = [CCAppleVMintALight24]::new()
        $this.ColorMap[211] = [CCAppleVMintALight24]::new()
        $this.ColorMap[212] = [CCAppleVMintALight24]::new()
        $this.ColorMap[213] = [CCAppleVMintALight24]::new()
        $this.ColorMap[214] = [CCAppleVMintALight24]::new()
        $this.ColorMap[215] = [CCAppleVMintALight24]::new()
        $this.ColorMap[216] = [CCAppleVMintALight24]::new()
        $this.ColorMap[217] = [CCAppleVMintALight24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCAppleVMintALight24]::new()
        $this.ColorMap[226] = [CCAppleVMintALight24]::new()
        $this.ColorMap[227] = [CCAppleVMintALight24]::new()
        $this.ColorMap[228] = [CCAppleVMintALight24]::new()
        $this.ColorMap[229] = [CCAppleVMintALight24]::new()
        $this.ColorMap[230] = [CCAppleVMintALight24]::new()
        $this.ColorMap[231] = [CCAppleVMintALight24]::new()
        $this.ColorMap[232] = [CCAppleVMintALight24]::new()
        $this.ColorMap[233] = [CCAppleVMintALight24]::new()
        $this.ColorMap[234] = [CCAppleVMintALight24]::new()
        $this.ColorMap[235] = [CCAppleVMintALight24]::new()
        $this.ColorMap[236] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[237] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[238] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[239] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[240] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[241] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[242] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[243] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[244] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[245] = [CCAppleVMintALight24]::new()
        $this.ColorMap[246] = [CCAppleVMintALight24]::new()
        $this.ColorMap[247] = [CCAppleVMintALight24]::new()
        $this.ColorMap[248] = [CCAppleVMintALight24]::new()
        $this.ColorMap[249] = [CCAppleVMintALight24]::new()
        $this.ColorMap[250] = [CCAppleVMintALight24]::new()
        $this.ColorMap[251] = [CCAppleVMintALight24]::new()
        $this.ColorMap[252] = [CCAppleVMintALight24]::new()
        $this.ColorMap[253] = [CCAppleVMintALight24]::new()
        $this.ColorMap[254] = [CCAppleVMintALight24]::new()
        $this.ColorMap[255] = [CCAppleVMintALight24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCAppleVMintALight24]::new()
        $this.ColorMap[263] = [CCAppleVMintALight24]::new()
        $this.ColorMap[264] = [CCAppleVMintALight24]::new()
        $this.ColorMap[265] = [CCAppleVMintALight24]::new()
        $this.ColorMap[266] = [CCAppleVMintALight24]::new()
        $this.ColorMap[267] = [CCAppleVMintALight24]::new()
        $this.ColorMap[268] = [CCAppleVMintALight24]::new()
        $this.ColorMap[269] = [CCAppleVMintALight24]::new()
        $this.ColorMap[270] = [CCAppleVMintALight24]::new()
        $this.ColorMap[271] = [CCAppleVMintALight24]::new()
        $this.ColorMap[272] = [CCAppleVMintALight24]::new()
        $this.ColorMap[273] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[274] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[275] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[276] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[277] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[278] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[279] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[280] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[281] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[282] = [CCAppleVMintALight24]::new()
        $this.ColorMap[283] = [CCAppleVMintALight24]::new()
        $this.ColorMap[284] = [CCAppleVMintALight24]::new()
        $this.ColorMap[285] = [CCAppleVMintALight24]::new()
        $this.ColorMap[286] = [CCAppleVMintALight24]::new()
        $this.ColorMap[287] = [CCAppleVMintALight24]::new()
        $this.ColorMap[288] = [CCAppleVMintALight24]::new()
        $this.ColorMap[289] = [CCAppleVMintALight24]::new()
        $this.ColorMap[290] = [CCAppleVMintALight24]::new()
        $this.ColorMap[291] = [CCAppleVMintALight24]::new()
        $this.ColorMap[292] = [CCAppleVMintALight24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCAppleVMintALight24]::new()
        $this.ColorMap[300] = [CCAppleVMintALight24]::new()
        $this.ColorMap[301] = [CCAppleVMintALight24]::new()
        $this.ColorMap[302] = [CCAppleVMintALight24]::new()
        $this.ColorMap[303] = [CCAppleVMintALight24]::new()
        $this.ColorMap[304] = [CCAppleVMintALight24]::new()
        $this.ColorMap[305] = [CCAppleVMintALight24]::new()
        $this.ColorMap[306] = [CCAppleVMintALight24]::new()
        $this.ColorMap[307] = [CCAppleVMintALight24]::new()
        $this.ColorMap[308] = [CCAppleVMintALight24]::new()
        $this.ColorMap[309] = [CCAppleVMintALight24]::new()
        $this.ColorMap[310] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[311] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[312] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[313] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[314] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[315] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[316] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[317] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[318] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[319] = [CCAppleVMintALight24]::new()
        $this.ColorMap[320] = [CCAppleVMintALight24]::new()
        $this.ColorMap[321] = [CCAppleVMintALight24]::new()
        $this.ColorMap[322] = [CCAppleVMintALight24]::new()
        $this.ColorMap[323] = [CCAppleVMintALight24]::new()
        $this.ColorMap[324] = [CCAppleVMintALight24]::new()
        $this.ColorMap[325] = [CCAppleVMintALight24]::new()
        $this.ColorMap[326] = [CCAppleVMintALight24]::new()
        $this.ColorMap[327] = [CCAppleVMintALight24]::new()
        $this.ColorMap[328] = [CCAppleVMintALight24]::new()
        $this.ColorMap[329] = [CCAppleVMintALight24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCAppleVMintALight24]::new()
        $this.ColorMap[336] = [CCAppleVMintALight24]::new()
        $this.ColorMap[337] = [CCAppleVMintALight24]::new()
        $this.ColorMap[338] = [CCAppleVMintALight24]::new()
        $this.ColorMap[339] = [CCAppleVMintALight24]::new()
        $this.ColorMap[340] = [CCAppleVMintALight24]::new()
        $this.ColorMap[341] = [CCAppleVMintALight24]::new()
        $this.ColorMap[342] = [CCAppleVMintALight24]::new()
        $this.ColorMap[343] = [CCAppleVMintALight24]::new()
        $this.ColorMap[344] = [CCAppleVMintALight24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCAppleVMintALight24]::new()
        $this.ColorMap[348] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[349] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[350] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[351] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[352] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[353] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[354] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[355] = [CCAppleVMintALight24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCAppleVMintALight24]::new()
        $this.ColorMap[359] = [CCAppleVMintALight24]::new()
        $this.ColorMap[360] = [CCAppleVMintALight24]::new()
        $this.ColorMap[361] = [CCAppleVMintALight24]::new()
        $this.ColorMap[362] = [CCAppleVMintALight24]::new()
        $this.ColorMap[363] = [CCAppleVMintALight24]::new()
        $this.ColorMap[364] = [CCAppleVMintALight24]::new()
        $this.ColorMap[365] = [CCAppleVMintALight24]::new()
        $this.ColorMap[366] = [CCAppleVMintALight24]::new()
        $this.ColorMap[367] = [CCAppleVMintALight24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCAppleVMintALight24]::new()
        $this.ColorMap[373] = [CCAppleVMintALight24]::new()
        $this.ColorMap[374] = [CCAppleVMintALight24]::new()
        $this.ColorMap[375] = [CCAppleVMintALight24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCAppleVMintALight24]::new()
        $this.ColorMap[379] = [CCAppleVMintALight24]::new()
        $this.ColorMap[380] = [CCAppleVMintALight24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[386] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[387] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[388] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[389] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[390] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[391] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCAppleVMintALight24]::new()
        $this.ColorMap[397] = [CCAppleVMintALight24]::new()
        $this.ColorMap[398] = [CCAppleVMintALight24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCAppleVMintALight24]::new()
        $this.ColorMap[402] = [CCAppleVMintALight24]::new()
        $this.ColorMap[403] = [CCAppleVMintALight24]::new()
        $this.ColorMap[404] = [CCAppleVMintALight24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCAppleVMintALight24]::new()
        $this.ColorMap[410] = [CCAppleVMintALight24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCAppleVMintALight24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[424] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[425] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[426] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[427] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCAppleVMintALight24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCAppleVMintALight24]::new()
        $this.ColorMap[441] = [CCAppleVMintALight24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCAppleVMintALight24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[459] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[462] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[463] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[466] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCAppleVMintALight24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleVPurpleALight24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleVGreyALight24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class EEIBloodswoop : EEIInternalBase {
    EEIBloodswoop() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[18]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[19]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[54]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[55]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[56]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[57]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[90]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[91]  = [CCAppleVYellowADark24]::new()
        $this.ColorMap[92]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[93]  = [CCAppleVYellowADark24]::new()
        $this.ColorMap[94]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[95]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCAppleVRedLight24]::new()
        $this.ColorMap[117] = [CCAppleVRedLight24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCAppleVRedLight24]::new()
        $this.ColorMap[123] = [CCAppleVRedLight24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[128] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[129] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[130] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[131] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCAppleVRedLight24]::new()
        $this.ColorMap[136] = [CCAppleVRedLight24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCAppleVRedLight24]::new()
        $this.ColorMap[142] = [CCAppleVRedLight24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCAppleVRedLight24]::new()
        $this.ColorMap[153] = [CCAppleVRedLight24]::new()
        $this.ColorMap[154] = [CCAppleVRedLight24]::new()
        $this.ColorMap[155] = [CCAppleVRedLight24]::new()
        $this.ColorMap[156] = [CCAppleVRedLight24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCAppleVRedLight24]::new()
        $this.ColorMap[159] = [CCAppleVRedLight24]::new()
        $this.ColorMap[160] = [CCAppleVRedLight24]::new()
        $this.ColorMap[161] = [CCAppleVRedLight24]::new()
        $this.ColorMap[162] = [CCAppleVRedLight24]::new()
        $this.ColorMap[163] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[164] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[165] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[166] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[167] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[168] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[169] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[170] = [CCAppleVRedLight24]::new()
        $this.ColorMap[171] = [CCAppleVRedLight24]::new()
        $this.ColorMap[172] = [CCAppleVRedLight24]::new()
        $this.ColorMap[173] = [CCAppleVRedLight24]::new()
        $this.ColorMap[174] = [CCAppleVRedLight24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCAppleVRedLight24]::new()
        $this.ColorMap[177] = [CCAppleVRedLight24]::new()
        $this.ColorMap[178] = [CCAppleVRedLight24]::new()
        $this.ColorMap[179] = [CCAppleVRedLight24]::new()
        $this.ColorMap[180] = [CCAppleVRedLight24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCAppleVRedLight24]::new()
        $this.ColorMap[190] = [CCAppleVRedLight24]::new()
        $this.ColorMap[191] = [CCAppleVRedLight24]::new()
        $this.ColorMap[192] = [CCAppleVRedLight24]::new()
        $this.ColorMap[193] = [CCAppleVRedLight24]::new()
        $this.ColorMap[194] = [CCAppleVRedLight24]::new()
        $this.ColorMap[195] = [CCAppleVRedLight24]::new()
        $this.ColorMap[196] = [CCAppleVRedLight24]::new()
        $this.ColorMap[197] = [CCAppleVRedLight24]::new()
        $this.ColorMap[198] = [CCAppleVRedLight24]::new()
        $this.ColorMap[199] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[200] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[201] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[202] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[203] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[204] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[205] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[206] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[207] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[208] = [CCAppleVRedLight24]::new()
        $this.ColorMap[209] = [CCAppleVRedLight24]::new()
        $this.ColorMap[210] = [CCAppleVRedLight24]::new()
        $this.ColorMap[211] = [CCAppleVRedLight24]::new()
        $this.ColorMap[212] = [CCAppleVRedLight24]::new()
        $this.ColorMap[213] = [CCAppleVRedLight24]::new()
        $this.ColorMap[214] = [CCAppleVRedLight24]::new()
        $this.ColorMap[215] = [CCAppleVRedLight24]::new()
        $this.ColorMap[216] = [CCAppleVRedLight24]::new()
        $this.ColorMap[217] = [CCAppleVRedLight24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCAppleVRedLight24]::new()
        $this.ColorMap[226] = [CCAppleVRedLight24]::new()
        $this.ColorMap[227] = [CCAppleVRedLight24]::new()
        $this.ColorMap[228] = [CCAppleVRedLight24]::new()
        $this.ColorMap[229] = [CCAppleVRedLight24]::new()
        $this.ColorMap[230] = [CCAppleVRedLight24]::new()
        $this.ColorMap[231] = [CCAppleVRedLight24]::new()
        $this.ColorMap[232] = [CCAppleVRedLight24]::new()
        $this.ColorMap[233] = [CCAppleVRedLight24]::new()
        $this.ColorMap[234] = [CCAppleVRedLight24]::new()
        $this.ColorMap[235] = [CCAppleVRedLight24]::new()
        $this.ColorMap[236] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[237] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[238] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[239] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[240] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[241] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[242] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[243] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[244] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[245] = [CCAppleVRedLight24]::new()
        $this.ColorMap[246] = [CCAppleVRedLight24]::new()
        $this.ColorMap[247] = [CCAppleVRedLight24]::new()
        $this.ColorMap[248] = [CCAppleVRedLight24]::new()
        $this.ColorMap[249] = [CCAppleVRedLight24]::new()
        $this.ColorMap[250] = [CCAppleVRedLight24]::new()
        $this.ColorMap[251] = [CCAppleVRedLight24]::new()
        $this.ColorMap[252] = [CCAppleVRedLight24]::new()
        $this.ColorMap[253] = [CCAppleVRedLight24]::new()
        $this.ColorMap[254] = [CCAppleVRedLight24]::new()
        $this.ColorMap[255] = [CCAppleVRedLight24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCAppleVRedLight24]::new()
        $this.ColorMap[263] = [CCAppleVRedLight24]::new()
        $this.ColorMap[264] = [CCAppleVRedLight24]::new()
        $this.ColorMap[265] = [CCAppleVRedLight24]::new()
        $this.ColorMap[266] = [CCAppleVRedLight24]::new()
        $this.ColorMap[267] = [CCAppleVRedLight24]::new()
        $this.ColorMap[268] = [CCAppleVRedLight24]::new()
        $this.ColorMap[269] = [CCAppleVRedLight24]::new()
        $this.ColorMap[270] = [CCAppleVRedLight24]::new()
        $this.ColorMap[271] = [CCAppleVRedLight24]::new()
        $this.ColorMap[272] = [CCAppleVRedLight24]::new()
        $this.ColorMap[273] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[274] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[275] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[276] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[277] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[278] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[279] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[280] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[281] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[282] = [CCAppleVRedLight24]::new()
        $this.ColorMap[283] = [CCAppleVRedLight24]::new()
        $this.ColorMap[284] = [CCAppleVRedLight24]::new()
        $this.ColorMap[285] = [CCAppleVRedLight24]::new()
        $this.ColorMap[286] = [CCAppleVRedLight24]::new()
        $this.ColorMap[287] = [CCAppleVRedLight24]::new()
        $this.ColorMap[288] = [CCAppleVRedLight24]::new()
        $this.ColorMap[289] = [CCAppleVRedLight24]::new()
        $this.ColorMap[290] = [CCAppleVRedLight24]::new()
        $this.ColorMap[291] = [CCAppleVRedLight24]::new()
        $this.ColorMap[292] = [CCAppleVRedLight24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCAppleVRedLight24]::new()
        $this.ColorMap[300] = [CCAppleVRedLight24]::new()
        $this.ColorMap[301] = [CCAppleVRedLight24]::new()
        $this.ColorMap[302] = [CCAppleVRedLight24]::new()
        $this.ColorMap[303] = [CCAppleVRedLight24]::new()
        $this.ColorMap[304] = [CCAppleVRedLight24]::new()
        $this.ColorMap[305] = [CCAppleVRedLight24]::new()
        $this.ColorMap[306] = [CCAppleVRedLight24]::new()
        $this.ColorMap[307] = [CCAppleVRedLight24]::new()
        $this.ColorMap[308] = [CCAppleVRedLight24]::new()
        $this.ColorMap[309] = [CCAppleVRedLight24]::new()
        $this.ColorMap[310] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[311] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[312] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[313] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[314] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[315] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[316] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[317] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[318] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[319] = [CCAppleVRedLight24]::new()
        $this.ColorMap[320] = [CCAppleVRedLight24]::new()
        $this.ColorMap[321] = [CCAppleVRedLight24]::new()
        $this.ColorMap[322] = [CCAppleVRedLight24]::new()
        $this.ColorMap[323] = [CCAppleVRedLight24]::new()
        $this.ColorMap[324] = [CCAppleVRedLight24]::new()
        $this.ColorMap[325] = [CCAppleVRedLight24]::new()
        $this.ColorMap[326] = [CCAppleVRedLight24]::new()
        $this.ColorMap[327] = [CCAppleVRedLight24]::new()
        $this.ColorMap[328] = [CCAppleVRedLight24]::new()
        $this.ColorMap[329] = [CCAppleVRedLight24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCAppleVRedLight24]::new()
        $this.ColorMap[336] = [CCAppleVRedLight24]::new()
        $this.ColorMap[337] = [CCAppleVRedLight24]::new()
        $this.ColorMap[338] = [CCAppleVRedLight24]::new()
        $this.ColorMap[339] = [CCAppleVRedLight24]::new()
        $this.ColorMap[340] = [CCAppleVRedLight24]::new()
        $this.ColorMap[341] = [CCAppleVRedLight24]::new()
        $this.ColorMap[342] = [CCAppleVRedLight24]::new()
        $this.ColorMap[343] = [CCAppleVRedLight24]::new()
        $this.ColorMap[344] = [CCAppleVRedLight24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCAppleVRedLight24]::new()
        $this.ColorMap[348] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[349] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[350] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[351] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[352] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[353] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[354] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[355] = [CCAppleVRedLight24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCAppleVRedLight24]::new()
        $this.ColorMap[359] = [CCAppleVRedLight24]::new()
        $this.ColorMap[360] = [CCAppleVRedLight24]::new()
        $this.ColorMap[361] = [CCAppleVRedLight24]::new()
        $this.ColorMap[362] = [CCAppleVRedLight24]::new()
        $this.ColorMap[363] = [CCAppleVRedLight24]::new()
        $this.ColorMap[364] = [CCAppleVRedLight24]::new()
        $this.ColorMap[365] = [CCAppleVRedLight24]::new()
        $this.ColorMap[366] = [CCAppleVRedLight24]::new()
        $this.ColorMap[367] = [CCAppleVRedLight24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCAppleVRedLight24]::new()
        $this.ColorMap[373] = [CCAppleVRedLight24]::new()
        $this.ColorMap[374] = [CCAppleVRedLight24]::new()
        $this.ColorMap[375] = [CCAppleVRedLight24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCAppleVRedLight24]::new()
        $this.ColorMap[379] = [CCAppleVRedLight24]::new()
        $this.ColorMap[380] = [CCAppleVRedLight24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[386] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[387] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[388] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[389] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[390] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[391] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCAppleVRedLight24]::new()
        $this.ColorMap[397] = [CCAppleVRedLight24]::new()
        $this.ColorMap[398] = [CCAppleVRedLight24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCAppleVRedLight24]::new()
        $this.ColorMap[402] = [CCAppleVRedLight24]::new()
        $this.ColorMap[403] = [CCAppleVRedLight24]::new()
        $this.ColorMap[404] = [CCAppleVRedLight24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCAppleVRedLight24]::new()
        $this.ColorMap[410] = [CCAppleVRedLight24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCAppleVRedLight24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleVRedALight24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[424] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[425] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[426] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[427] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleVRedALight24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCAppleVRedLight24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCAppleVRedLight24]::new()
        $this.ColorMap[441] = [CCAppleVRedLight24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCAppleVRedLight24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleVRedALight24]::new()
        $this.ColorMap[459] = [CCAppleVRedALight24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[462] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[463] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleVRedALight24]::new()
        $this.ColorMap[466] = [CCAppleVRedALight24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCAppleVRedLight24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleVRedALight24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleVRedALight24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

Class EEIDuskbane : EEIInternalBase {
    EEIDuskbane() : base() {
        $this.ColorMap[0]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[1]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[2]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[3]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[4]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[5]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[6]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[7]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[8]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[9]   = [ATBackgroundColor24None]::new()
        $this.ColorMap[10]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[11]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[12]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[13]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[14]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[15]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[16]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[17]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[18]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[19]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[20]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[21]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[22]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[23]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[24]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[25]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[26]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[27]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[28]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[29]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[30]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[31]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[32]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[33]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[34]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[35]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[36]  = [ATBackgroundColor24None]::new() # End Row 0
        $this.ColorMap[37]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[38]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[39]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[40]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[41]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[42]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[43]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[44]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[45]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[46]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[47]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[48]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[49]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[50]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[51]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[52]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[53]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[54]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[55]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[56]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[57]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[58]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[59]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[60]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[61]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[62]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[63]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[64]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[65]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[66]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[67]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[68]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[69]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[70]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[71]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[72]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[73]  = [ATBackgroundColor24None]::new() # End Row 1
        $this.ColorMap[74]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[75]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[76]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[77]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[78]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[79]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[80]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[81]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[82]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[83]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[84]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[85]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[86]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[87]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[88]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[89]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[90]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[91]  = [CCAppleVYellowADark24]::new()
        $this.ColorMap[92]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[93]  = [CCAppleVYellowADark24]::new()
        $this.ColorMap[94]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[95]  = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[96]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[97]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[98]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[99]  = [ATBackgroundColor24None]::new()
        $this.ColorMap[100] = [ATBackgroundColor24None]::new()
        $this.ColorMap[101] = [ATBackgroundColor24None]::new()
        $this.ColorMap[102] = [ATBackgroundColor24None]::new()
        $this.ColorMap[103] = [ATBackgroundColor24None]::new()
        $this.ColorMap[104] = [ATBackgroundColor24None]::new()
        $this.ColorMap[105] = [ATBackgroundColor24None]::new()
        $this.ColorMap[106] = [ATBackgroundColor24None]::new()
        $this.ColorMap[107] = [ATBackgroundColor24None]::new()
        $this.ColorMap[108] = [ATBackgroundColor24None]::new()
        $this.ColorMap[109] = [ATBackgroundColor24None]::new()
        $this.ColorMap[110] = [ATBackgroundColor24None]::new() # End Row 2
        $this.ColorMap[111] = [ATBackgroundColor24None]::new()
        $this.ColorMap[112] = [ATBackgroundColor24None]::new()
        $this.ColorMap[113] = [ATBackgroundColor24None]::new()
        $this.ColorMap[114] = [ATBackgroundColor24None]::new()
        $this.ColorMap[115] = [ATBackgroundColor24None]::new()
        $this.ColorMap[116] = [CCAppleVRedLight24]::new()
        $this.ColorMap[117] = [CCAppleVRedLight24]::new()
        $this.ColorMap[118] = [ATBackgroundColor24None]::new()
        $this.ColorMap[119] = [ATBackgroundColor24None]::new()
        $this.ColorMap[120] = [ATBackgroundColor24None]::new()
        $this.ColorMap[121] = [ATBackgroundColor24None]::new()
        $this.ColorMap[122] = [CCAppleVRedLight24]::new()
        $this.ColorMap[123] = [CCAppleVRedLight24]::new()
        $this.ColorMap[124] = [ATBackgroundColor24None]::new()
        $this.ColorMap[125] = [ATBackgroundColor24None]::new()
        $this.ColorMap[126] = [ATBackgroundColor24None]::new()
        $this.ColorMap[127] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[128] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[129] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[130] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[131] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[132] = [ATBackgroundColor24None]::new()
        $this.ColorMap[133] = [ATBackgroundColor24None]::new()
        $this.ColorMap[134] = [ATBackgroundColor24None]::new()
        $this.ColorMap[135] = [CCAppleVRedLight24]::new()
        $this.ColorMap[136] = [CCAppleVRedLight24]::new()
        $this.ColorMap[137] = [ATBackgroundColor24None]::new()
        $this.ColorMap[138] = [ATBackgroundColor24None]::new()
        $this.ColorMap[139] = [ATBackgroundColor24None]::new()
        $this.ColorMap[140] = [ATBackgroundColor24None]::new()
        $this.ColorMap[141] = [CCAppleVRedLight24]::new()
        $this.ColorMap[142] = [CCAppleVRedLight24]::new()
        $this.ColorMap[143] = [ATBackgroundColor24None]::new()
        $this.ColorMap[144] = [ATBackgroundColor24None]::new()
        $this.ColorMap[145] = [ATBackgroundColor24None]::new()
        $this.ColorMap[146] = [ATBackgroundColor24None]::new()
        $this.ColorMap[147] = [ATBackgroundColor24None]::new() # End Row 3
        $this.ColorMap[148] = [ATBackgroundColor24None]::new()
        $this.ColorMap[149] = [ATBackgroundColor24None]::new()
        $this.ColorMap[150] = [ATBackgroundColor24None]::new()
        $this.ColorMap[151] = [ATBackgroundColor24None]::new()
        $this.ColorMap[152] = [CCAppleVRedLight24]::new()
        $this.ColorMap[153] = [CCAppleVRedLight24]::new()
        $this.ColorMap[154] = [CCAppleVRedLight24]::new()
        $this.ColorMap[155] = [CCAppleVRedLight24]::new()
        $this.ColorMap[156] = [CCAppleVRedLight24]::new()
        $this.ColorMap[157] = [ATBackgroundColor24None]::new()
        $this.ColorMap[158] = [CCAppleVRedLight24]::new()
        $this.ColorMap[159] = [CCAppleVRedLight24]::new()
        $this.ColorMap[160] = [CCAppleVRedLight24]::new()
        $this.ColorMap[161] = [CCAppleVRedLight24]::new()
        $this.ColorMap[162] = [CCAppleVRedLight24]::new()
        $this.ColorMap[163] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[164] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[165] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[166] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[167] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[168] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[169] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[170] = [CCAppleVRedLight24]::new()
        $this.ColorMap[171] = [CCAppleVRedLight24]::new()
        $this.ColorMap[172] = [CCAppleVRedLight24]::new()
        $this.ColorMap[173] = [CCAppleVRedLight24]::new()
        $this.ColorMap[174] = [CCAppleVRedLight24]::new()
        $this.ColorMap[175] = [ATBackgroundColor24None]::new()
        $this.ColorMap[176] = [CCAppleVRedLight24]::new()
        $this.ColorMap[177] = [CCAppleVRedLight24]::new()
        $this.ColorMap[178] = [CCAppleVRedLight24]::new()
        $this.ColorMap[179] = [CCAppleVRedLight24]::new()
        $this.ColorMap[180] = [CCAppleVRedLight24]::new()
        $this.ColorMap[181] = [ATBackgroundColor24None]::new()
        $this.ColorMap[182] = [ATBackgroundColor24None]::new()
        $this.ColorMap[183] = [ATBackgroundColor24None]::new()
        $this.ColorMap[184] = [ATBackgroundColor24None]::new() # End Row 4
        $this.ColorMap[185] = [ATBackgroundColor24None]::new()
        $this.ColorMap[186] = [ATBackgroundColor24None]::new()
        $this.ColorMap[187] = [ATBackgroundColor24None]::new()
        $this.ColorMap[188] = [ATBackgroundColor24None]::new()
        $this.ColorMap[189] = [CCAppleVRedLight24]::new()
        $this.ColorMap[190] = [CCAppleVRedLight24]::new()
        $this.ColorMap[191] = [CCAppleVRedLight24]::new()
        $this.ColorMap[192] = [CCAppleVRedLight24]::new()
        $this.ColorMap[193] = [CCAppleVRedLight24]::new()
        $this.ColorMap[194] = [CCAppleVRedLight24]::new()
        $this.ColorMap[195] = [CCAppleVRedLight24]::new()
        $this.ColorMap[196] = [CCAppleVRedLight24]::new()
        $this.ColorMap[197] = [CCAppleVRedLight24]::new()
        $this.ColorMap[198] = [CCAppleVRedLight24]::new()
        $this.ColorMap[199] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[200] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[201] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[202] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[203] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[204] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[205] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[206] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[207] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[208] = [CCAppleVRedLight24]::new()
        $this.ColorMap[209] = [CCAppleVRedLight24]::new()
        $this.ColorMap[210] = [CCAppleVRedLight24]::new()
        $this.ColorMap[211] = [CCAppleVRedLight24]::new()
        $this.ColorMap[212] = [CCAppleVRedLight24]::new()
        $this.ColorMap[213] = [CCAppleVRedLight24]::new()
        $this.ColorMap[214] = [CCAppleVRedLight24]::new()
        $this.ColorMap[215] = [CCAppleVRedLight24]::new()
        $this.ColorMap[216] = [CCAppleVRedLight24]::new()
        $this.ColorMap[217] = [CCAppleVRedLight24]::new()
        $this.ColorMap[218] = [ATBackgroundColor24None]::new()
        $this.ColorMap[219] = [ATBackgroundColor24None]::new()
        $this.ColorMap[220] = [ATBackgroundColor24None]::new()
        $this.ColorMap[221] = [ATBackgroundColor24None]::new() # End Row 5
        $this.ColorMap[222] = [ATBackgroundColor24None]::new()
        $this.ColorMap[223] = [ATBackgroundColor24None]::new()
        $this.ColorMap[224] = [ATBackgroundColor24None]::new()
        $this.ColorMap[225] = [CCAppleVRedLight24]::new()
        $this.ColorMap[226] = [CCAppleVRedLight24]::new()
        $this.ColorMap[227] = [CCAppleVRedLight24]::new()
        $this.ColorMap[228] = [CCAppleVRedLight24]::new()
        $this.ColorMap[229] = [CCAppleVRedLight24]::new()
        $this.ColorMap[230] = [CCAppleVRedLight24]::new()
        $this.ColorMap[231] = [CCAppleVRedLight24]::new()
        $this.ColorMap[232] = [CCAppleVRedLight24]::new()
        $this.ColorMap[233] = [CCAppleVRedLight24]::new()
        $this.ColorMap[234] = [CCAppleVRedLight24]::new()
        $this.ColorMap[235] = [CCAppleVRedLight24]::new()
        $this.ColorMap[236] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[237] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[238] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[239] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[240] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[241] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[242] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[243] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[244] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[245] = [CCAppleVRedLight24]::new()
        $this.ColorMap[246] = [CCAppleVRedLight24]::new()
        $this.ColorMap[247] = [CCAppleVRedLight24]::new()
        $this.ColorMap[248] = [CCAppleVRedLight24]::new()
        $this.ColorMap[249] = [CCAppleVRedLight24]::new()
        $this.ColorMap[250] = [CCAppleVRedLight24]::new()
        $this.ColorMap[251] = [CCAppleVRedLight24]::new()
        $this.ColorMap[252] = [CCAppleVRedLight24]::new()
        $this.ColorMap[253] = [CCAppleVRedLight24]::new()
        $this.ColorMap[254] = [CCAppleVRedLight24]::new()
        $this.ColorMap[255] = [CCAppleVRedLight24]::new()
        $this.ColorMap[256] = [ATBackgroundColor24None]::new()
        $this.ColorMap[257] = [ATBackgroundColor24None]::new()
        $this.ColorMap[258] = [ATBackgroundColor24None]::new() # End Row 6
        $this.ColorMap[259] = [ATBackgroundColor24None]::new()
        $this.ColorMap[260] = [ATBackgroundColor24None]::new()
        $this.ColorMap[261] = [ATBackgroundColor24None]::new()
        $this.ColorMap[262] = [CCAppleVRedLight24]::new()
        $this.ColorMap[263] = [CCAppleVRedLight24]::new()
        $this.ColorMap[264] = [CCAppleVRedLight24]::new()
        $this.ColorMap[265] = [CCAppleVRedLight24]::new()
        $this.ColorMap[266] = [CCAppleVRedLight24]::new()
        $this.ColorMap[267] = [CCAppleVRedLight24]::new()
        $this.ColorMap[268] = [CCAppleVRedLight24]::new()
        $this.ColorMap[269] = [CCAppleVRedLight24]::new()
        $this.ColorMap[270] = [CCAppleVRedLight24]::new()
        $this.ColorMap[271] = [CCAppleVRedLight24]::new()
        $this.ColorMap[272] = [CCAppleVRedLight24]::new()
        $this.ColorMap[273] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[274] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[275] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[276] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[277] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[278] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[279] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[280] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[281] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[282] = [CCAppleVRedLight24]::new()
        $this.ColorMap[283] = [CCAppleVRedLight24]::new()
        $this.ColorMap[284] = [CCAppleVRedLight24]::new()
        $this.ColorMap[285] = [CCAppleVRedLight24]::new()
        $this.ColorMap[286] = [CCAppleVRedLight24]::new()
        $this.ColorMap[287] = [CCAppleVRedLight24]::new()
        $this.ColorMap[288] = [CCAppleVRedLight24]::new()
        $this.ColorMap[289] = [CCAppleVRedLight24]::new()
        $this.ColorMap[290] = [CCAppleVRedLight24]::new()
        $this.ColorMap[291] = [CCAppleVRedLight24]::new()
        $this.ColorMap[292] = [CCAppleVRedLight24]::new()
        $this.ColorMap[293] = [ATBackgroundColor24None]::new()
        $this.ColorMap[294] = [ATBackgroundColor24None]::new()
        $this.ColorMap[295] = [ATBackgroundColor24None]::new() # End Row 7
        $this.ColorMap[296] = [ATBackgroundColor24None]::new()
        $this.ColorMap[297] = [ATBackgroundColor24None]::new()
        $this.ColorMap[298] = [ATBackgroundColor24None]::new()
        $this.ColorMap[299] = [CCAppleVRedLight24]::new()
        $this.ColorMap[300] = [CCAppleVRedLight24]::new()
        $this.ColorMap[301] = [CCAppleVRedLight24]::new()
        $this.ColorMap[302] = [CCAppleVRedLight24]::new()
        $this.ColorMap[303] = [CCAppleVRedLight24]::new()
        $this.ColorMap[304] = [CCAppleVRedLight24]::new()
        $this.ColorMap[305] = [CCAppleVRedLight24]::new()
        $this.ColorMap[306] = [CCAppleVRedLight24]::new()
        $this.ColorMap[307] = [CCAppleVRedLight24]::new()
        $this.ColorMap[308] = [CCAppleVRedLight24]::new()
        $this.ColorMap[309] = [CCAppleVRedLight24]::new()
        $this.ColorMap[310] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[311] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[312] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[313] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[314] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[315] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[316] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[317] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[318] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[319] = [CCAppleVRedLight24]::new()
        $this.ColorMap[320] = [CCAppleVRedLight24]::new()
        $this.ColorMap[321] = [CCAppleVRedLight24]::new()
        $this.ColorMap[322] = [CCAppleVRedLight24]::new()
        $this.ColorMap[323] = [CCAppleVRedLight24]::new()
        $this.ColorMap[324] = [CCAppleVRedLight24]::new()
        $this.ColorMap[325] = [CCAppleVRedLight24]::new()
        $this.ColorMap[326] = [CCAppleVRedLight24]::new()
        $this.ColorMap[327] = [CCAppleVRedLight24]::new()
        $this.ColorMap[328] = [CCAppleVRedLight24]::new()
        $this.ColorMap[329] = [CCAppleVRedLight24]::new()
        $this.ColorMap[330] = [ATBackgroundColor24None]::new()
        $this.ColorMap[331] = [ATBackgroundColor24None]::new()
        $this.ColorMap[332] = [ATBackgroundColor24None]::new() # End Row 8
        $this.ColorMap[333] = [ATBackgroundColor24None]::new()
        $this.ColorMap[334] = [ATBackgroundColor24None]::new()
        $this.ColorMap[335] = [CCAppleVRedLight24]::new()
        $this.ColorMap[336] = [CCAppleVRedLight24]::new()
        $this.ColorMap[337] = [CCAppleVRedLight24]::new()
        $this.ColorMap[338] = [CCAppleVRedLight24]::new()
        $this.ColorMap[339] = [CCAppleVRedLight24]::new()
        $this.ColorMap[340] = [CCAppleVRedLight24]::new()
        $this.ColorMap[341] = [CCAppleVRedLight24]::new()
        $this.ColorMap[342] = [CCAppleVRedLight24]::new()
        $this.ColorMap[343] = [CCAppleVRedLight24]::new()
        $this.ColorMap[344] = [CCAppleVRedLight24]::new()
        $this.ColorMap[345] = [ATBackgroundColor24None]::new()
        $this.ColorMap[346] = [ATBackgroundColor24None]::new()
        $this.ColorMap[347] = [CCAppleVRedLight24]::new()
        $this.ColorMap[348] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[349] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[350] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[351] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[352] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[353] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[354] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[355] = [CCAppleVRedLight24]::new()
        $this.ColorMap[356] = [ATBackgroundColor24None]::new()
        $this.ColorMap[357] = [ATBackgroundColor24None]::new()
        $this.ColorMap[358] = [CCAppleVRedLight24]::new()
        $this.ColorMap[359] = [CCAppleVRedLight24]::new()
        $this.ColorMap[360] = [CCAppleVRedLight24]::new()
        $this.ColorMap[361] = [CCAppleVRedLight24]::new()
        $this.ColorMap[362] = [CCAppleVRedLight24]::new()
        $this.ColorMap[363] = [CCAppleVRedLight24]::new()
        $this.ColorMap[364] = [CCAppleVRedLight24]::new()
        $this.ColorMap[365] = [CCAppleVRedLight24]::new()
        $this.ColorMap[366] = [CCAppleVRedLight24]::new()
        $this.ColorMap[367] = [CCAppleVRedLight24]::new()
        $this.ColorMap[368] = [ATBackgroundColor24None]::new()
        $this.ColorMap[369] = [ATBackgroundColor24None]::new() # End Row 9
        $this.ColorMap[370] = [ATBackgroundColor24None]::new()
        $this.ColorMap[371] = [ATBackgroundColor24None]::new()
        $this.ColorMap[372] = [CCAppleVRedLight24]::new()
        $this.ColorMap[373] = [CCAppleVRedLight24]::new()
        $this.ColorMap[374] = [CCAppleVRedLight24]::new()
        $this.ColorMap[375] = [CCAppleVRedLight24]::new()
        $this.ColorMap[376] = [ATBackgroundColor24None]::new()
        $this.ColorMap[377] = [ATBackgroundColor24None]::new()
        $this.ColorMap[378] = [CCAppleVRedLight24]::new()
        $this.ColorMap[379] = [CCAppleVRedLight24]::new()
        $this.ColorMap[380] = [CCAppleVRedLight24]::new()
        $this.ColorMap[381] = [ATBackgroundColor24None]::new()
        $this.ColorMap[382] = [ATBackgroundColor24None]::new()
        $this.ColorMap[383] = [ATBackgroundColor24None]::new()
        $this.ColorMap[384] = [ATBackgroundColor24None]::new()
        $this.ColorMap[385] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[386] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[387] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[388] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[389] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[390] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[391] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[392] = [ATBackgroundColor24None]::new()
        $this.ColorMap[393] = [ATBackgroundColor24None]::new()
        $this.ColorMap[394] = [ATBackgroundColor24None]::new()
        $this.ColorMap[395] = [ATBackgroundColor24None]::new()
        $this.ColorMap[396] = [CCAppleVRedLight24]::new()
        $this.ColorMap[397] = [CCAppleVRedLight24]::new()
        $this.ColorMap[398] = [CCAppleVRedLight24]::new()
        $this.ColorMap[399] = [ATBackgroundColor24None]::new()
        $this.ColorMap[400] = [ATBackgroundColor24None]::new()
        $this.ColorMap[401] = [CCAppleVRedLight24]::new()
        $this.ColorMap[402] = [CCAppleVRedLight24]::new()
        $this.ColorMap[403] = [CCAppleVRedLight24]::new()
        $this.ColorMap[404] = [CCAppleVRedLight24]::new()
        $this.ColorMap[405] = [ATBackgroundColor24None]::new()
        $this.ColorMap[406] = [ATBackgroundColor24None]::new() # End Row 10
        $this.ColorMap[407] = [ATBackgroundColor24None]::new()
        $this.ColorMap[408] = [ATBackgroundColor24None]::new()
        $this.ColorMap[409] = [CCAppleVRedLight24]::new()
        $this.ColorMap[410] = [CCAppleVRedLight24]::new()
        $this.ColorMap[411] = [ATBackgroundColor24None]::new()
        $this.ColorMap[412] = [ATBackgroundColor24None]::new()
        $this.ColorMap[413] = [ATBackgroundColor24None]::new()
        $this.ColorMap[414] = [ATBackgroundColor24None]::new()
        $this.ColorMap[415] = [ATBackgroundColor24None]::new()
        $this.ColorMap[416] = [CCAppleVRedLight24]::new()
        $this.ColorMap[417] = [ATBackgroundColor24None]::new()
        $this.ColorMap[418] = [ATBackgroundColor24None]::new()
        $this.ColorMap[419] = [ATBackgroundColor24None]::new()
        $this.ColorMap[420] = [CCAppleVRedALight24]::new()
        $this.ColorMap[421] = [ATBackgroundColor24None]::new()
        $this.ColorMap[422] = [ATBackgroundColor24None]::new()
        $this.ColorMap[423] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[424] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[425] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[426] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[427] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[428] = [ATBackgroundColor24None]::new()
        $this.ColorMap[429] = [ATBackgroundColor24None]::new()
        $this.ColorMap[430] = [CCAppleVRedALight24]::new()
        $this.ColorMap[431] = [ATBackgroundColor24None]::new()
        $this.ColorMap[432] = [ATBackgroundColor24None]::new()
        $this.ColorMap[433] = [ATBackgroundColor24None]::new()
        $this.ColorMap[434] = [CCAppleVRedLight24]::new()
        $this.ColorMap[435] = [ATBackgroundColor24None]::new()
        $this.ColorMap[436] = [ATBackgroundColor24None]::new()
        $this.ColorMap[437] = [ATBackgroundColor24None]::new()
        $this.ColorMap[438] = [ATBackgroundColor24None]::new()
        $this.ColorMap[439] = [ATBackgroundColor24None]::new()
        $this.ColorMap[440] = [CCAppleVRedLight24]::new()
        $this.ColorMap[441] = [CCAppleVRedLight24]::new()
        $this.ColorMap[442] = [ATBackgroundColor24None]::new()
        $this.ColorMap[443] = [ATBackgroundColor24None]::new() # End Row 11
        $this.ColorMap[444] = [ATBackgroundColor24None]::new()
        $this.ColorMap[445] = [ATBackgroundColor24None]::new()
        $this.ColorMap[446] = [CCAppleVRedLight24]::new()
        $this.ColorMap[447] = [ATBackgroundColor24None]::new()
        $this.ColorMap[448] = [ATBackgroundColor24None]::new()
        $this.ColorMap[449] = [ATBackgroundColor24None]::new()
        $this.ColorMap[450] = [ATBackgroundColor24None]::new()
        $this.ColorMap[451] = [ATBackgroundColor24None]::new()
        $this.ColorMap[452] = [ATBackgroundColor24None]::new()
        $this.ColorMap[453] = [ATBackgroundColor24None]::new()
        $this.ColorMap[454] = [ATBackgroundColor24None]::new()
        $this.ColorMap[455] = [ATBackgroundColor24None]::new()
        $this.ColorMap[456] = [ATBackgroundColor24None]::new()
        $this.ColorMap[457] = [ATBackgroundColor24None]::new()
        $this.ColorMap[458] = [CCAppleVRedALight24]::new()
        $this.ColorMap[459] = [CCAppleVRedALight24]::new()
        $this.ColorMap[460] = [ATBackgroundColor24None]::new()
        $this.ColorMap[461] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[462] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[463] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[464] = [ATBackgroundColor24None]::new()
        $this.ColorMap[465] = [CCAppleVRedALight24]::new()
        $this.ColorMap[466] = [CCAppleVRedALight24]::new()
        $this.ColorMap[467] = [ATBackgroundColor24None]::new()
        $this.ColorMap[468] = [ATBackgroundColor24None]::new()
        $this.ColorMap[469] = [ATBackgroundColor24None]::new()
        $this.ColorMap[470] = [ATBackgroundColor24None]::new()
        $this.ColorMap[471] = [ATBackgroundColor24None]::new()
        $this.ColorMap[472] = [ATBackgroundColor24None]::new()
        $this.ColorMap[473] = [ATBackgroundColor24None]::new()
        $this.ColorMap[474] = [ATBackgroundColor24None]::new()
        $this.ColorMap[475] = [ATBackgroundColor24None]::new()
        $this.ColorMap[476] = [ATBackgroundColor24None]::new()
        $this.ColorMap[477] = [ATBackgroundColor24None]::new()
        $this.ColorMap[478] = [CCAppleVRedLight24]::new()
        $this.ColorMap[479] = [ATBackgroundColor24None]::new()
        $this.ColorMap[480] = [ATBackgroundColor24None]::new() # End Row 12
        $this.ColorMap[481] = [ATBackgroundColor24None]::new()
        $this.ColorMap[482] = [ATBackgroundColor24None]::new()
        $this.ColorMap[483] = [ATBackgroundColor24None]::new()
        $this.ColorMap[484] = [ATBackgroundColor24None]::new()
        $this.ColorMap[485] = [ATBackgroundColor24None]::new()
        $this.ColorMap[486] = [ATBackgroundColor24None]::new()
        $this.ColorMap[487] = [ATBackgroundColor24None]::new()
        $this.ColorMap[488] = [ATBackgroundColor24None]::new()
        $this.ColorMap[489] = [ATBackgroundColor24None]::new()
        $this.ColorMap[490] = [ATBackgroundColor24None]::new()
        $this.ColorMap[491] = [ATBackgroundColor24None]::new()
        $this.ColorMap[492] = [ATBackgroundColor24None]::new()
        $this.ColorMap[493] = [ATBackgroundColor24None]::new()
        $this.ColorMap[494] = [CCAppleVRedALight24]::new()
        $this.ColorMap[495] = [ATBackgroundColor24None]::new()
        $this.ColorMap[496] = [ATBackgroundColor24None]::new()
        $this.ColorMap[497] = [ATBackgroundColor24None]::new()
        $this.ColorMap[498] = [ATBackgroundColor24None]::new()
        $this.ColorMap[499] = [CCAppleNOrangeALight24]::new()
        $this.ColorMap[500] = [ATBackgroundColor24None]::new()
        $this.ColorMap[501] = [ATBackgroundColor24None]::new()
        $this.ColorMap[502] = [ATBackgroundColor24None]::new()
        $this.ColorMap[503] = [ATBackgroundColor24None]::new()
        $this.ColorMap[504] = [CCAppleVRedALight24]::new()
        $this.ColorMap[505] = [ATBackgroundColor24None]::new()
        $this.ColorMap[506] = [ATBackgroundColor24None]::new()
        $this.ColorMap[507] = [ATBackgroundColor24None]::new()
        $this.ColorMap[508] = [ATBackgroundColor24None]::new()
        $this.ColorMap[509] = [ATBackgroundColor24None]::new()
        $this.ColorMap[510] = [ATBackgroundColor24None]::new()
        $this.ColorMap[511] = [ATBackgroundColor24None]::new()
        $this.ColorMap[512] = [ATBackgroundColor24None]::new()
        $this.ColorMap[513] = [ATBackgroundColor24None]::new()
        $this.ColorMap[514] = [ATBackgroundColor24None]::new()
        $this.ColorMap[515] = [ATBackgroundColor24None]::new()
        $this.ColorMap[516] = [ATBackgroundColor24None]::new()
        $this.ColorMap[517] = [ATBackgroundColor24None]::new() # End Row 13
        $this.ColorMap[518] = [ATBackgroundColor24None]::new()
        $this.ColorMap[519] = [ATBackgroundColor24None]::new()
        $this.ColorMap[520] = [ATBackgroundColor24None]::new()
        $this.ColorMap[521] = [ATBackgroundColor24None]::new()
        $this.ColorMap[522] = [ATBackgroundColor24None]::new()
        $this.ColorMap[523] = [ATBackgroundColor24None]::new()
        $this.ColorMap[524] = [ATBackgroundColor24None]::new()
        $this.ColorMap[525] = [ATBackgroundColor24None]::new()
        $this.ColorMap[526] = [ATBackgroundColor24None]::new()
        $this.ColorMap[527] = [ATBackgroundColor24None]::new()
        $this.ColorMap[528] = [ATBackgroundColor24None]::new()
        $this.ColorMap[529] = [ATBackgroundColor24None]::new()
        $this.ColorMap[530] = [ATBackgroundColor24None]::new()
        $this.ColorMap[531] = [ATBackgroundColor24None]::new()
        $this.ColorMap[532] = [ATBackgroundColor24None]::new()
        $this.ColorMap[533] = [ATBackgroundColor24None]::new()
        $this.ColorMap[534] = [ATBackgroundColor24None]::new()
        $this.ColorMap[535] = [ATBackgroundColor24None]::new()
        $this.ColorMap[536] = [ATBackgroundColor24None]::new()
        $this.ColorMap[537] = [ATBackgroundColor24None]::new()
        $this.ColorMap[538] = [ATBackgroundColor24None]::new()
        $this.ColorMap[539] = [ATBackgroundColor24None]::new()
        $this.ColorMap[540] = [ATBackgroundColor24None]::new()
        $this.ColorMap[541] = [ATBackgroundColor24None]::new()
        $this.ColorMap[542] = [ATBackgroundColor24None]::new()
        $this.ColorMap[543] = [ATBackgroundColor24None]::new()
        $this.ColorMap[544] = [ATBackgroundColor24None]::new()
        $this.ColorMap[545] = [ATBackgroundColor24None]::new()
        $this.ColorMap[546] = [ATBackgroundColor24None]::new()
        $this.ColorMap[547] = [ATBackgroundColor24None]::new()
        $this.ColorMap[548] = [ATBackgroundColor24None]::new()
        $this.ColorMap[549] = [ATBackgroundColor24None]::new()
        $this.ColorMap[550] = [ATBackgroundColor24None]::new()
        $this.ColorMap[551] = [ATBackgroundColor24None]::new()
        $this.ColorMap[552] = [ATBackgroundColor24None]::new()
        $this.ColorMap[553] = [ATBackgroundColor24None]::new()
        $this.ColorMap[554] = [ATBackgroundColor24None]::new() # End Row 14

        $this.CreateImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

###############################################################################
#
# EE SPECIALIZATIONS
#
# THESE REPRESENT ACTUAL ENEMIES IN THE GAME THAT THE PLAYER COULD FIGHT 
# AGAINST. AS WITH OTHER COLLECTIONS, THE NAMES ARE SELF-DOCUMENTING.
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





###############################################################################
#
# MAP SUPPORT
#
# CLASSES THAT COALESCE INTO MAP FUNCTIONALITY.
#
###############################################################################

###############################################################################
#
# SCENE IMAGE
#
# DEFINES AN "IMAGE" THAT'S SHOWN ON THE NAVIGATION SCREEN. THIS LOOKS A LOT
# LIKE AN ENEMY IMAGE, JUST WITH DIFFERENT DIMENSIONS. SPECIALIZATIONS OF THIS
# ARE CREATED USING A SIMILAR PATTERN AS WELL.
#
###############################################################################
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

###############################################################################
#
# SI EMPTY
#
# A SYMBOLIC HOLDER FOR AN EMPTY SCENE IMAGE. THIS WOULD RARELY BE USED.
#
###############################################################################
Class SIEmpty : SceneImage {
    SIEmpty() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

###############################################################################
#
# SI INTERNAL BASE
#
# A SPECIALIZATION OF SCENE IMAGE THAT ADDS COLOR MAP DATA.
#
###############################################################################
Class SIInternalBase : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIInternalBase() : base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
    }

    SIInternalBase(
    [String]$JsonConfigPath
    ) : base() {
        [Hashtable]$JsonData = @{}
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

    If($(Test-Path $JsonConfigPath) -EQ $true) {
        $JsonData = Get-Content -Raw $JsonConfigPath | ConvertFrom-Json -AsHashtable

        # THIS JSON DATA WOULD CONTAIN ONLY ONE ELEMENT CALLED COLORDATA WHICH IS A SINGLE ARRAY
        # THAT CONTAINS EITHER A STRING, WHICH WOULD BE MAPPED TO A SPECIFIC COLOR DEFINED ABOVE,
        # OR AN ARRAY OF R, G, B VALUES WHICH WOULD CREATE A CUSTOM COLOR.
        [Int]$A = 0
        Foreach($B in $JsonData['ColorData']) {
        If($B -IS [String]) {
            [String]$C = [String]::Format("CC{0}24", $B)
            $this.ColorMap[$A] = New-Object "$($C)"
        } Elseif($B -IS [Array]) {
            $this.ColorMap[$A] = [ATBackgroundColor24]::new([ConsoleColor24]::new($B[0], $B[1], $B[2]))
        }
        $A++
        }

        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
    }
}

###############################################################################
#
# SI RANDOM NOISE
#
# A SPECIALIZATION OF SCENE IMAGE THAT GENERATES RANDOM NOISE PER CELL.
#
###############################################################################
Class SIRandomNoise : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIRandomNoise() : base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
        For($a = 0; $a -LT $this.ColorMap.Count; $a++) {
            $this.ColorMap[$a] = [CCRandom24]::new()
        }
        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}

###############################################################################
#
# SI MAP IMAGES
#
# THE FOLLOWING COLLECTION OF CLASSES ARE SCENERY "IMAGES" THAT ARE USED ON THE
# NAVIGATION SCREEN. THE NAMES ARE SELF-DOCUMENTING, AND THE PATTERN HERE IS
# THE SAME AS THE ENEMY IMAGES (HISTORICALLY, THESE WERE FIRST).
#
###############################################################################
Class SIFieldNorthRoad : SIInternalBase {
    SIFieldNorthRoad() : base("$(Get-Location)Image Data\SIFieldNorthRoadNew.json") {}
}

Class SIFieldPlainsNoRoad : SIInternalBase {
    SIFieldPlainsNoRoad() : base("$(Get-Location)Image Data\SIFieldPlainsNoRoad.json") {}
}

Class SIFieldPlainsRoadNorth : SIInternalBase {
    SIFieldPlainsRoadNorth() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorth.json") {}
}

Class SIFieldPlainsRoadSouth : SIInternalBase {
    SIFieldPlainsRoadSouth() : base("$(Get-Location)Image Data\SIFieldPlainsRoadSouth.json") {}
}

Class SIFieldPlainsRoadEast : SIInternalBase {
    SIFieldPlainsRoadEast() : base("$(Get-Location)Image Data\SIFieldPlainsRoadEast.json") {}
}

Class SIFieldPlainsRoadWest : SIInternalBase {
    SIFieldPlainsRoadWest() : base("$(Get-Location)Image Data\SIFieldPlainsRoadWest.json") {}
}

Class SIFieldPlainsRoadEastWest : SIInternalBase {
    SIFieldPlainsRoadEastWest() : base("$(Get-Location)Image Data\SIFieldPlainsRoadEastWest.json") {}
}

Class SIFieldPlainsRoadNorthEast : SIInternalBase {
    SIFieldPlainsRoadNorthEast() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorthEast.json") {}
}

Class SIFieldPlainsRoadNorthWest : SIInternalBase {
    SIFieldPlainsRoadNorthWest() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorthWest.json") {}
}

Class SIFieldPlainsRoadNorthSouth : SIInternalBase {
    SIFieldPlainsRoadNorthSouth() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorthSouth.json") {}
}

Class SIFieldPlainsRoadNorthSouthEast : SIInternalBase {
    SIFieldPlainsRoadNorthSouthEast() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorthSouthEast.json") {}
}

Class SIFieldPlainsRoadNorthSouthEastWest : SIInternalBase {
    SIFieldPlainsRoadNorthSouthEastWest() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorthSouthEastWest.json") {}
}

Class SIFieldPlainsRoadNorthSouthWest : SIInternalBase {
    SIFieldPlainsRoadNorthSouthWest() : base("$(Get-Location)Image Data\SIFieldPlainsRoadNorthSouthWest.json") {}
}

Class SIFieldNorthEastRoad : SIInternalBase {
    SIFieldNorthEastRoad() : base("$(Get-Location)Image Data\SIFieldNorthEastRoadNew.json") {}
}

Class SIRiverRoadSample : SIInternalBase {
    SIRiverRoadSample() : base("$(Get-Location)Image Data\SIRiverRoadSample.json") {}
}

Class SIRiverRoadEWNSSample : SIInternalBase {
    SIRiverRoadEWNSSample() : base("$(Get-Location)Image Data\SIRiverRoadEWNSSample.json") {}
}

Class SIRiverRoadEWSSSample : SIInternalBase {
    SIRiverRoadEWSSSample() : base("$(Get-Location)Image Data\SIRiverRoadEWSSSample.json") {}
}






###############################################################################
#
# MAP TILE OBJECT
#
# DESPITE THE NAME, THIS REPRESENTS AN OBJECT THAT THE PLAYER CAN INTERACT WITH
# EITHER DIRECTLY ON THE MAP OR BY OWNING IT IN THEIR ITEM INVENTORY. THESE ARE
# ALSO THE ITEMS THAT ARE GIVEN TO THE PLAYER AS SPOILS WHEN DEFEATING CERTAIN
# ENEMIES.
#
# IT'S WORTH MENTIONING THE TARGETOFFILTER PROPERTY.
#
###############################################################################
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

    MapTileObject() {
        $this.Name               = ''
        $this.MapObjName         = ''
        $this.Effect             = {}
        $this.CanAddToInventory  = $false
        $this.ExamineString      = ''
        $this.TargetOfFilter     = @()
        $this.PlayerEffectString = ''
        $this.KeyItem            = $false
        $this.BaseEffectCall     = {
            Param(
                [ValidateNotNullOrEmpty()]
                [String]$a0
            )

            Return $this.ValidateSourceInFilter($a0)
        }
    }

    [Boolean]ValidateSourceInFilter([String]$SourceItemClass) {
        Return ($SourceItemClass -IN $this.TargetOfFilter)
    }
}

###############################################################################
#
# MAP TILE
#
# A "PLACE" ON A MAP. ANY GIVEN COORDINATE PAIR VALUE RELATES TO A SINGLE MAP 
# TILE. MAP TILE NAVIGATION IS RESTRICTED TO CARDINAL DIRECTIONS, CONSEQUENTLY
# SOME DIRECTIONS ARE "EXITABLE" WHILE OTHERS AREN'T. MAP TILES HAVE A SINGLE
# "IMAGE" THAT IS DRAWN ON THE NAVIGATION SCREEN IN THE SCENE IMAGE WINDOW.
# MAP TILES CAN CONTAIN ZERO OR MORE MAP TILE OBJECTS THAT CAN BE INTERACTED
# WITH, EITHER BY EXAMINATION, AUGMENTATION, OR COLLECTION. EVERY MAP TILE
# OBJECT CAN BE EXAMINED, WHILE ONLY SELECT ONES CAN BE AUGMENTED OR COLLECTED.
# THIS IS DETERMINED BY A "TARGET OF" FILTER, WHICH IS DESCRIBED AT THE MAP
# TILE OBJECT DEFINITION.
#
# MAP TILES ALSO PLAY AN INTEGRAL PART OF THE COMBAT SYSTEM AS THEY SERVE AS 
# THE ENTRY POINT FOR THE COMBAT SUB-PROGRAM. THIS IS FACILITATED BY HAVING
# EACH TILE SPECIFIY THE FOLLOWING: IS BATTLE ALLOWED ON THIS TILE, WHAT IS
# THE EFFECTIVE ENCOUNTER RATE (OR CHANCE OF ENTERING A COMBAT SITUATION; THIS
# IS DETERMINED WHEN THE TILE IS CREATED AND DOESN'T CHANGE OVER TIME; IT 
# PROBABLY SHOULD! :)), AND A "REGION CODE" WHICH MAPS TO A HASHTABLE THAT
# CONTAINS ARRAYS THAT MAP TO REGION CODES. THESE ARRAYS SPECIFY WHICH KINDS OF
# ENEMIES CAN BE ENCOUNTERED IN THIS REGION.
#
###############################################################################
Class MapTile {
    Static [Int]$TileExitNorth = 0
    Static [Int]$TileExitSouth = 1
    Static [Int]$TileExitEast  = 2
    Static [Int]$TileExitWest  = 3

    [SceneImage]$BackgroundImage
    [List[MapTileObject]]$ObjectListing
    [Boolean[]]$Exits
    [Boolean]$BattleAllowed
    [Double]$EncounterRate
    [Int]$RegionCode

    MapTile() {
        $this.BackgroundImage = [SIEmpty]::new()
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits = @(
            $false,
            $false,
            $false,
            $false
        )
        $this.BattleAllowed = $false
        $this.EncounterRate = 0.5
        $this.RegionCode    = 0
    }

    MapTile(
        [SceneImage]$BackgroundImage,
        [MapTileObject[]]$ObjectListing,
        [Boolean[]]$Exits
    ) {
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits
        $this.BattleAllowed   = $false
        $this.EncounterRate   = 0.5
        $this.RegionCode      = 0
        Foreach($a In $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }

    MapTile(
        [SceneImage]$BackgroundImage,
        [MapTileObject[]]$ObjectListing,
        [Boolean[]]$Exits,
        [Boolean]$BattleAllowed,
        [Double]$EncounterRate,
        [Int]$RegionCode
    ) {
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits
        $this.BattleAllowed   = $BattleAllowed
        $this.EncounterRate   = $EncounterRate
        $this.RegionCode      = $RegionCode
        Foreach($a in $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }

    MapTile(
        [Hashtable]$JsonData
    ) {
        $this.BackgroundImage = $Script:TheSceneImages[$JsonData['BackgroundImage']]
        $this.Exits           = $JsonData['Exits']
        $this.BattleAllowed   = $JsonData['BattleAllowed']
        $this.EncounterRate   = $JsonData['EncounterRate']
        $this.RegionCode      = $JsonData['RegionCode']
        $this.ObjectListing   = [List[MapTileObject]]::new()

        Foreach($A in $JsonData['ObjectListing']) {
            $this.ObjectListing.Add($(New-Object -TypeName $A)) | Out-Null
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

    [Void]BattleStep() {
        If($this.BattleAllowed -EQ $true) {
            [Double]$BattleChance = Get-Random -Minimum 0.0 -Maximum 1.0
            If($BattleChance -GT $this.EncounterRate) {
                $Script:TheCurrentEnemy = New-Object -TypeName $($Script:BattleEncounterRegionTable[$this.RegionCode] | Get-Random)
                $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::BattleScreen
            }
        }
    }
}





###############################################################################
#
# MAP
#
###############################################################################
Class Map {
    [Int]$MapWidth
    [Int]$MapHeight
    [String]$Name
    [Boolean]$BoundaryWrap
    [MapTile[,]]$Tiles

    Map() {
        $this.MapWidth     = 0
        $this.MapHeight    = 0
        $this.Name         = ''
        $this.BoundaryWrap = $false

        # THIS LINE PRESENTS A PROBLEM WITH SPLATTING SINCE IT EVIDENTLY GETS CALLED BEFORE
        # ANY OF THE SPLATTED VALUES ARE APPLIED TO THE OBJECT.
        $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
    }

    Map(
        [String]$Name,
        [Int]$MapWidth,
        [Int]$MapHeight,
        [Boolean]$BoundaryWrap
    ) {
        $this.Name         = $Name
        $this.MapWidth     = $MapWidth
        $this.MapHeight    = $MapHeight
        $this.BoundaryWrap = $BoundaryWrap
        $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
    }

    Map(
        [String]$JsonConfigPath
    ) {
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
                # [Hashtable]$A = $JsonData['Tiles'][$Y][$X]
                $this.Tiles[$Y, $X] = [MapTile]::new($JsonData['Tiles'][$Y][$X])
            }
        }
    }

    [Void]CreateMapTiles() {
        If($this.MapWidth -GT 0 -AND $this.MapHeight -GT 0) {
            $this.Tiles = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
        }
    }

    [MapTile]GetTileAtPlayerCoordinates() {
        Return $this.Tiles[$Script:ThePlayer.MapCoordinates.Row, $Script:ThePlayer.MapCoordinates.Column]
    }
}





###############################################################################
#
# FAST NOISE LITE IMPLEMENTATION
#
###############################################################################
Class FastNoiseLite {
    Static [Int64]$PRIMEX         = 501125321
    Static [Int64]$PRIMEY         = 1136930381
    Static [Int64]$PRIMEZ         = 1720413743
    Static [Int64]$HASH_MAGIC     = 0x27D4EB2D
    Static [Int64]$HASHCALC_MAGIC = 2147483648
    Static [Int64]$SEEDADD_MAGIC  = 1293373
    Static [Int64]$APRIMEXMULT2   = [FastNoiseLite]::PRIMEX * 2
    Static [Int64]$APRIMEYMULT2   = [FastNoiseLite]::PRIMEY * 2
    Static [Int64]$APRIMEZMULT2   = [FastNoiseLite]::PRIMEZ * 2
    
    Static [Single]$SQRT3                     = 1.7320508075688772935274463415059
    Static [Single]$PLANARIMPROVEA_MAGIC      = 0.211324865405187
    Static [Single]$PLANARIMPROVEZSCALE_MAGIC = 0.577350269189626
    Static [Single]$SIMPLEXVALMODA_MAGIC      = 32.69428253173828125
    Static [Single]$A2DIV3                    = 2 / 3

    Static [Single[]]$GRADIENTS2D = @(
        0.130526192220052,  0.99144486137381,   0.38268343236509,   0.923879532511287,  0.608761429008721,  0.793353340291235,  0.793353340291235,  0.608761429008721,
        0.923879532511287,  0.38268343236509,   0.99144486137381,   0.130526192220051,  0.99144486137381,  -0.130526192220051,  0.923879532511287, -0.38268343236509,
        0.793353340291235, -0.60876142900872,   0.608761429008721, -0.793353340291235,  0.38268343236509,  -0.923879532511287,  0.130526192220052, -0.99144486137381,
        -0.130526192220052, -0.99144486137381,  -0.38268343236509,  -0.923879532511287, -0.608761429008721, -0.793353340291235, -0.793353340291235, -0.608761429008721,
        -0.923879532511287, -0.38268343236509,  -0.99144486137381,  -0.130526192220052, -0.99144486137381,   0.130526192220051, -0.923879532511287,  0.38268343236509,
        -0.793353340291235,  0.608761429008721, -0.608761429008721,  0.793353340291235, -0.38268343236509,   0.923879532511287, -0.130526192220052,  0.99144486137381,
        0.130526192220052,  0.99144486137381,   0.38268343236509,   0.923879532511287,  0.608761429008721,  0.793353340291235,  0.793353340291235,  0.608761429008721,
        0.923879532511287,  0.38268343236509,   0.99144486137381,   0.130526192220051,  0.99144486137381,  -0.130526192220051,  0.923879532511287, -0.38268343236509,
        0.793353340291235, -0.60876142900872,   0.608761429008721, -0.793353340291235,  0.38268343236509,  -0.923879532511287,  0.130526192220052, -0.99144486137381,
        -0.130526192220052, -0.99144486137381,  -0.38268343236509,  -0.923879532511287, -0.608761429008721, -0.793353340291235, -0.793353340291235, -0.608761429008721,
        -0.923879532511287, -0.38268343236509,  -0.99144486137381,  -0.130526192220052, -0.99144486137381,   0.130526192220051, -0.923879532511287,  0.38268343236509,
        -0.793353340291235,  0.608761429008721, -0.608761429008721,  0.793353340291235, -0.38268343236509,   0.923879532511287, -0.130526192220052,  0.99144486137381,
        0.130526192220052,  0.99144486137381,   0.38268343236509,   0.923879532511287,  0.608761429008721,  0.793353340291235,  0.793353340291235,  0.608761429008721,
        0.923879532511287,  0.38268343236509,   0.99144486137381,   0.130526192220051,  0.99144486137381,  -0.130526192220051,  0.923879532511287, -0.38268343236509,
        0.793353340291235, -0.60876142900872,   0.608761429008721, -0.793353340291235,  0.38268343236509,  -0.923879532511287,  0.130526192220052, -0.99144486137381,
        -0.130526192220052, -0.99144486137381,  -0.38268343236509,  -0.923879532511287, -0.608761429008721, -0.793353340291235, -0.793353340291235, -0.608761429008721,
        -0.923879532511287, -0.38268343236509,  -0.99144486137381,  -0.130526192220052, -0.99144486137381,   0.130526192220051, -0.923879532511287,  0.38268343236509,
        -0.793353340291235,  0.608761429008721, -0.608761429008721,  0.793353340291235, -0.38268343236509,   0.923879532511287, -0.130526192220052,  0.99144486137381,
        0.130526192220052,  0.99144486137381,   0.38268343236509,   0.923879532511287,  0.608761429008721,  0.793353340291235,  0.793353340291235,  0.608761429008721,
        0.923879532511287,  0.38268343236509,   0.99144486137381,   0.130526192220051,  0.99144486137381,  -0.130526192220051,  0.923879532511287, -0.38268343236509,
        0.793353340291235, -0.60876142900872,   0.608761429008721, -0.793353340291235,  0.38268343236509,  -0.923879532511287,  0.130526192220052, -0.99144486137381,
        -0.130526192220052, -0.99144486137381,  -0.38268343236509,  -0.923879532511287, -0.608761429008721, -0.793353340291235, -0.793353340291235, -0.608761429008721,
        -0.923879532511287, -0.38268343236509,  -0.99144486137381,  -0.130526192220052, -0.99144486137381,   0.130526192220051, -0.923879532511287,  0.38268343236509,
        -0.793353340291235,  0.608761429008721, -0.608761429008721,  0.793353340291235, -0.38268343236509,   0.923879532511287, -0.130526192220052,  0.99144486137381,
        0.130526192220052,  0.99144486137381,   0.38268343236509,   0.923879532511287,  0.608761429008721,  0.793353340291235,  0.793353340291235,  0.608761429008721,
        0.923879532511287,  0.38268343236509,   0.99144486137381,   0.130526192220051,  0.99144486137381,  -0.130526192220051,  0.923879532511287, -0.38268343236509,
        0.793353340291235, -0.60876142900872,   0.608761429008721, -0.793353340291235,  0.38268343236509,  -0.923879532511287,  0.130526192220052, -0.99144486137381,
        -0.130526192220052, -0.99144486137381,  -0.38268343236509,  -0.923879532511287, -0.608761429008721, -0.793353340291235, -0.793353340291235, -0.608761429008721,
        -0.923879532511287, -0.38268343236509,  -0.99144486137381,  -0.130526192220052, -0.99144486137381,   0.130526192220051, -0.923879532511287,  0.38268343236509,
        -0.793353340291235,  0.608761429008721, -0.608761429008721,  0.793353340291235, -0.38268343236509,   0.923879532511287, -0.130526192220052,  0.99144486137381,
        0.38268343236509,   0.923879532511287,  0.923879532511287,  0.38268343236509,   0.923879532511287, -0.38268343236509,   0.38268343236509,  -0.923879532511287,
        -0.38268343236509,  -0.923879532511287, -0.923879532511287, -0.38268343236509,  -0.923879532511287,  0.38268343236509,  -0.38268343236509,   0.923879532511287
    )

    Static [Single[]]$RANDVECS2D = @(
        -0.2700222198, -0.9628540911, 0.3863092627, -0.9223693152, 0.04444859006, -0.999011673, -0.5992523158, -0.8005602176, -0.7819280288, 0.6233687174, 0.9464672271, 0.3227999196, -0.6514146797, -0.7587218957, 0.9378472289, 0.347048376,
        -0.8497875957, -0.5271252623, -0.879042592, 0.4767432447, -0.892300288, -0.4514423508, -0.379844434, -0.9250503802, -0.9951650832, 0.0982163789, 0.7724397808, -0.6350880136, 0.7573283322, -0.6530343002, -0.9928004525, -0.119780055,
        -0.0532665713, 0.9985803285, 0.9754253726, -0.2203300762, -0.7665018163, 0.6422421394, 0.991636706, 0.1290606184, -0.994696838, 0.1028503788, -0.5379205513, -0.84299554, 0.5022815471, -0.8647041387, 0.4559821461, -0.8899889226,
        -0.8659131224, -0.5001944266, 0.0879458407, -0.9961252577, -0.5051684983, 0.8630207346, 0.7753185226, -0.6315704146, -0.6921944612, 0.7217110418, -0.5191659449, -0.8546734591, 0.8978622882, -0.4402764035, -0.1706774107, 0.9853269617,
        -0.9353430106, -0.3537420705, -0.9992404798, 0.03896746794, -0.2882064021, -0.9575683108, -0.9663811329, 0.2571137995, -0.8759714238, -0.4823630009, -0.8303123018, -0.5572983775, 0.05110133755, -0.9986934731, -0.8558373281, -0.5172450752,
        0.09887025282, 0.9951003332, 0.9189016087, 0.3944867976, -0.2439375892, -0.9697909324, -0.8121409387, -0.5834613061, -0.9910431363, 0.1335421355, 0.8492423985, -0.5280031709, -0.9717838994, -0.2358729591, 0.9949457207, 0.1004142068,
        0.6241065508, -0.7813392434, 0.662910307, 0.7486988212, -0.7197418176, 0.6942418282, -0.8143370775, -0.5803922158, 0.104521054, -0.9945226741, -0.1065926113, -0.9943027784, 0.445799684, -0.8951327509, 0.105547406, 0.9944142724,
        -0.992790267, 0.1198644477, -0.8334366408, 0.552615025, 0.9115561563, -0.4111755999, 0.8285544909, -0.5599084351, 0.7217097654, -0.6921957921, 0.4940492677, -0.8694339084, -0.3652321272, -0.9309164803, -0.9696606758, 0.2444548501,
        0.08925509731, -0.996008799, 0.5354071276, -0.8445941083, -0.1053576186, 0.9944343981, -0.9890284586, 0.1477251101, 0.004856104961, 0.9999882091, 0.9885598478, 0.1508291331, 0.9286129562, -0.3710498316, -0.5832393863, -0.8123003252,
        0.3015207509, 0.9534596146, -0.9575110528, 0.2883965738, 0.9715802154, -0.2367105511, 0.229981792, 0.9731949318, 0.955763816, -0.2941352207, 0.740956116, 0.6715534485, -0.9971513787, -0.07542630764, 0.6905710663, -0.7232645452,
        -0.290713703, -0.9568100872, 0.5912777791, -0.8064679708, -0.9454592212, -0.325740481, 0.6664455681, 0.74555369, 0.6236134912, 0.7817328275, 0.9126993851, -0.4086316587, -0.8191762011, 0.5735419353, -0.8812745759, -0.4726046147,
        0.9953313627, 0.09651672651, 0.9855650846, -0.1692969699, -0.8495980887, 0.5274306472, 0.6174853946, -0.7865823463, 0.8508156371, 0.52546432, 0.9985032451, -0.05469249926, 0.1971371563, -0.9803759185, 0.6607855748, -0.7505747292,
        -0.03097494063, 0.9995201614, -0.6731660801, 0.739491331, -0.7195018362, -0.6944905383, 0.9727511689, 0.2318515979, 0.9997059088, -0.0242506907, 0.4421787429, -0.8969269532, 0.9981350961, -0.061043673, -0.9173660799, -0.3980445648,
        -0.8150056635, -0.5794529907, -0.8789331304, 0.4769450202, 0.0158605829, 0.999874213, -0.8095464474, 0.5870558317, -0.9165898907, -0.3998286786, -0.8023542565, 0.5968480938, -0.5176737917, 0.8555780767, -0.8154407307, -0.5788405779,
        0.4022010347, -0.9155513791, -0.9052556868, -0.4248672045, 0.7317445619, 0.6815789728, -0.5647632201, -0.8252529947, -0.8403276335, -0.5420788397, -0.9314281527, 0.363925262, 0.5238198472, 0.8518290719, 0.7432803869, -0.6689800195,
        -0.985371561, -0.1704197369, 0.4601468731, 0.88784281, 0.825855404, 0.5638819483, 0.6182366099, 0.7859920446, 0.8331502863, -0.553046653, 0.1500307506, 0.9886813308, -0.662330369, -0.7492119075, -0.668598664, 0.743623444,
        0.7025606278, 0.7116238924, -0.5419389763, -0.8404178401, -0.3388616456, 0.9408362159, 0.8331530315, 0.5530425174, -0.2989720662, -0.9542618632, 0.2638522993, 0.9645630949, 0.124108739, -0.9922686234, -0.7282649308, -0.6852956957,
        0.6962500149, 0.7177993569, -0.9183535368, 0.3957610156, -0.6326102274, -0.7744703352, -0.9331891859, -0.359385508, -0.1153779357, -0.9933216659, 0.9514974788, -0.3076565421, -0.08987977445, -0.9959526224, 0.6678496916, 0.7442961705,
        0.7952400393, -0.6062947138, -0.6462007402, -0.7631674805, -0.2733598753, 0.9619118351, 0.9669590226, -0.254931851, -0.9792894595, 0.2024651934, -0.5369502995, -0.8436138784, -0.270036471, -0.9628500944, -0.6400277131, 0.7683518247,
        -0.7854537493, -0.6189203566, 0.06005905383, -0.9981948257, -0.02455770378, 0.9996984141, -0.65983623, 0.751409442, -0.6253894466, -0.7803127835, -0.6210408851, -0.7837781695, 0.8348888491, 0.5504185768, -0.1592275245, 0.9872419133,
        0.8367622488, 0.5475663786, -0.8675753916, -0.4973056806, -0.2022662628, -0.9793305667, 0.9399189937, 0.3413975472, 0.9877404807, -0.1561049093, -0.9034455656, 0.4287028224, 0.1269804218, -0.9919052235, -0.3819600854, 0.924178821,
        0.9754625894, 0.2201652486, -0.3204015856, -0.9472818081, -0.9874760884, 0.1577687387, 0.02535348474, -0.9996785487, 0.4835130794, -0.8753371362, -0.2850799925, -0.9585037287, -0.06805516006, -0.99768156, -0.7885244045, -0.6150034663,
        0.3185392127, -0.9479096845, 0.8880043089, 0.4598351306, 0.6476921488, -0.7619021462, 0.9820241299, 0.1887554194, 0.9357275128, -0.3527237187, -0.8894895414, 0.4569555293, 0.7922791302, 0.6101588153, 0.7483818261, 0.6632681526,
        -0.7288929755, -0.6846276581, 0.8729032783, -0.4878932944, 0.8288345784, 0.5594937369, 0.08074567077, 0.9967347374, 0.9799148216, -0.1994165048, -0.580730673, -0.8140957471, -0.4700049791, -0.8826637636, 0.2409492979, 0.9705377045,
        0.9437816757, -0.3305694308, -0.8927998638, -0.4504535528, -0.8069622304, 0.5906030467, 0.06258973166, 0.9980393407, -0.9312597469, 0.3643559849, 0.5777449785, 0.8162173362, -0.3360095855, -0.941858566, 0.697932075, -0.7161639607,
        -0.002008157227, -0.9999979837, -0.1827294312, -0.9831632392, -0.6523911722, 0.7578824173, -0.4302626911, -0.9027037258, -0.9985126289, -0.05452091251, -0.01028102172, -0.9999471489, -0.4946071129, 0.8691166802, -0.2999350194, 0.9539596344,
        0.8165471961, 0.5772786819, 0.2697460475, 0.962931498, -0.7306287391, -0.6827749597, -0.7590952064, -0.6509796216, -0.907053853, 0.4210146171, -0.5104861064, -0.8598860013, 0.8613350597, 0.5080373165, 0.5007881595, -0.8655698812,
        -0.654158152, 0.7563577938, -0.8382755311, -0.545246856, 0.6940070834, 0.7199681717, 0.06950936031, 0.9975812994, 0.1702942185, -0.9853932612, 0.2695973274, 0.9629731466, 0.5519612192, -0.8338697815, 0.225657487, -0.9742067022,
        0.4215262855, -0.9068161835, 0.4881873305, -0.8727388672, -0.3683854996, -0.9296731273, -0.9825390578, 0.1860564427, 0.81256471, 0.5828709909, 0.3196460933, -0.9475370046, 0.9570913859, 0.2897862643, -0.6876655497, -0.7260276109,
        -0.9988770922, -0.047376731, -0.1250179027, 0.992154486, -0.8280133617, 0.560708367, 0.9324863769, -0.3612051451, 0.6394653183, 0.7688199442, -0.01623847064, -0.9998681473, -0.9955014666, -0.09474613458, -0.81453315, 0.580117012,
        0.4037327978, -0.9148769469, 0.9944263371, 0.1054336766, -0.1624711654, 0.9867132919, -0.9949487814, -0.100383875, -0.6995302564, 0.7146029809, 0.5263414922, -0.85027327, -0.5395221479, 0.841971408, 0.6579370318, 0.7530729462,
        0.01426758847, -0.9998982128, -0.6734383991, 0.7392433447, 0.639412098, -0.7688642071, 0.9211571421, 0.3891908523, -0.146637214, -0.9891903394, -0.782318098, 0.6228791163, -0.5039610839, -0.8637263605, -0.7743120191, -0.6328039957
    )

    Static [Single[]]$GRADIENTS3D = @(
        0, 1, 1, 0,  0,-1, 1, 0,  0, 1,-1, 0,  0,-1,-1, 0,
        1, 0, 1, 0, -1, 0, 1, 0,  1, 0,-1, 0, -1, 0,-1, 0,
        1, 1, 0, 0, -1, 1, 0, 0,  1,-1, 0, 0, -1,-1, 0, 0,
        0, 1, 1, 0,  0,-1, 1, 0,  0, 1,-1, 0,  0,-1,-1, 0,
        1, 0, 1, 0, -1, 0, 1, 0,  1, 0,-1, 0, -1, 0,-1, 0,
        1, 1, 0, 0, -1, 1, 0, 0,  1,-1, 0, 0, -1,-1, 0, 0,
        0, 1, 1, 0,  0,-1, 1, 0,  0, 1,-1, 0,  0,-1,-1, 0,
        1, 0, 1, 0, -1, 0, 1, 0,  1, 0,-1, 0, -1, 0,-1, 0,
        1, 1, 0, 0, -1, 1, 0, 0,  1,-1, 0, 0, -1,-1, 0, 0,
        0, 1, 1, 0,  0,-1, 1, 0,  0, 1,-1, 0,  0,-1,-1, 0,
        1, 0, 1, 0, -1, 0, 1, 0,  1, 0,-1, 0, -1, 0,-1, 0,
        1, 1, 0, 0, -1, 1, 0, 0,  1,-1, 0, 0, -1,-1, 0, 0,
        0, 1, 1, 0,  0,-1, 1, 0,  0, 1,-1, 0,  0,-1,-1, 0,
        1, 0, 1, 0, -1, 0, 1, 0,  1, 0,-1, 0, -1, 0,-1, 0,
        1, 1, 0, 0, -1, 1, 0, 0,  1,-1, 0, 0, -1,-1, 0, 0,
        1, 1, 0, 0,  0,-1, 1, 0, -1, 1, 0, 0,  0,-1,-1, 0
    )

    Static [Single[]]$RANDVECS3D = @(
        -0.7292736885, -0.6618439697, 0.1735581948, 0, 0.790292081, -0.5480887466, -0.2739291014, 0, 0.7217578935, 0.6226212466, -0.3023380997, 0, 0.565683137, -0.8208298145, -0.0790000257, 0, 0.760049034, -0.5555979497, -0.3370999617, 0, 0.3713945616, 0.5011264475, 0.7816254623, 0, -0.1277062463, -0.4254438999, -0.8959289049, 0, -0.2881560924, -0.5815838982, 0.7607405838, 0,
        0.5849561111, -0.662820239, -0.4674352136, 0, 0.3307171178, 0.0391653737, 0.94291689, 0, 0.8712121778, -0.4113374369, -0.2679381538, 0, 0.580981015, 0.7021915846, 0.4115677815, 0, 0.503756873, 0.6330056931, -0.5878203852, 0, 0.4493712205, 0.601390195, 0.6606022552, 0, -0.6878403724, 0.09018890807, -0.7202371714, 0, -0.5958956522, -0.6469350577, 0.475797649, 0,
        -0.5127052122, 0.1946921978, -0.8361987284, 0, -0.9911507142, -0.05410276466, -0.1212153153, 0, -0.2149721042, 0.9720882117, -0.09397607749, 0, -0.7518650936, -0.5428057603, 0.3742469607, 0, 0.5237068895, 0.8516377189, -0.02107817834, 0, 0.6333504779, 0.1926167129, -0.7495104896, 0, -0.06788241606, 0.3998305789, 0.9140719259, 0, -0.5538628599, -0.4729896695, -0.6852128902, 0,
        -0.7261455366, -0.5911990757, 0.3509933228, 0, -0.9229274737, -0.1782808786, 0.3412049336, 0, -0.6968815002, 0.6511274338, 0.3006480328, 0, 0.9608044783, -0.2098363234, -0.1811724921, 0, 0.06817146062, -0.9743405129, 0.2145069156, 0, -0.3577285196, -0.6697087264, -0.6507845481, 0, -0.1868621131, 0.7648617052, -0.6164974636, 0, -0.6541697588, 0.3967914832, 0.6439087246, 0,
        0.6993340405, -0.6164538506, 0.3618239211, 0, -0.1546665739, 0.6291283928, 0.7617583057, 0, -0.6841612949, -0.2580482182, -0.6821542638, 0, 0.5383980957, 0.4258654885, 0.7271630328, 0, -0.5026987823, -0.7939832935, -0.3418836993, 0, 0.3202971715, 0.2834415347, 0.9039195862, 0, 0.8683227101, -0.0003762656404, -0.4959995258, 0, 0.791120031, -0.08511045745, 0.6057105799, 0,
        -0.04011016052, -0.4397248749, 0.8972364289, 0, 0.9145119872, 0.3579346169, -0.1885487608, 0, -0.9612039066, -0.2756484276, 0.01024666929, 0, 0.6510361721, -0.2877799159, -0.7023778346, 0, -0.2041786351, 0.7365237271, 0.644859585, 0, -0.7718263711, 0.3790626912, 0.5104855816, 0, -0.3060082741, -0.7692987727, 0.5608371729, 0, 0.454007341, -0.5024843065, 0.7357899537, 0,
        0.4816795475, 0.6021208291, -0.6367380315, 0, 0.6961980369, -0.3222197429, 0.641469197, 0, -0.6532160499, -0.6781148932, 0.3368515753, 0, 0.5089301236, -0.6154662304, -0.6018234363, 0, -0.1635919754, -0.9133604627, -0.372840892, 0, 0.52408019, -0.8437664109, 0.1157505864, 0, 0.5902587356, 0.4983817807, -0.6349883666, 0, 0.5863227872, 0.494764745, 0.6414307729, 0,
        0.6779335087, 0.2341345225, 0.6968408593, 0, 0.7177054546, -0.6858979348, 0.120178631, 0, -0.5328819713, -0.5205125012, 0.6671608058, 0, -0.8654874251, -0.0700727088, -0.4960053754, 0, -0.2861810166, 0.7952089234, 0.5345495242, 0, -0.04849529634, 0.9810836427, -0.1874115585, 0, -0.6358521667, 0.6058348682, 0.4781800233, 0, 0.6254794696, -0.2861619734, 0.7258696564, 0,
        -0.2585259868, 0.5061949264, -0.8227581726, 0, 0.02136306781, 0.5064016808, -0.8620330371, 0, 0.200111773, 0.8599263484, 0.4695550591, 0, 0.4743561372, 0.6014985084, -0.6427953014, 0, 0.6622993731, -0.5202474575, -0.5391679918, 0, 0.08084972818, -0.6532720452, 0.7527940996, 0, -0.6893687501, 0.0592860349, 0.7219805347, 0, -0.1121887082, -0.9673185067, 0.2273952515, 0,
        0.7344116094, 0.5979668656, -0.3210532909, 0, 0.5789393465, -0.2488849713, 0.7764570201, 0, 0.6988182827, 0.3557169806, -0.6205791146, 0, -0.8636845529, -0.2748771249, -0.4224826141, 0, -0.4247027957, -0.4640880967, 0.777335046, 0, 0.5257722489, -0.8427017621, 0.1158329937, 0, 0.9343830603, 0.316302472, -0.1639543925, 0, -0.1016836419, -0.8057303073, -0.5834887393, 0,
        -0.6529238969, 0.50602126, -0.5635892736, 0, -0.2465286165, -0.9668205684, -0.06694497494, 0, -0.9776897119, -0.2099250524, -0.007368825344, 0, 0.7736893337, 0.5734244712, 0.2694238123, 0, -0.6095087895, 0.4995678998, 0.6155736747, 0, 0.5794535482, 0.7434546771, 0.3339292269, 0, -0.8226211154, 0.08142581855, 0.5627293636, 0, -0.510385483, 0.4703667658, 0.7199039967, 0,
        -0.5764971849, -0.07231656274, -0.8138926898, 0, 0.7250628871, 0.3949971505, -0.5641463116, 0, -0.1525424005, 0.4860840828, -0.8604958341, 0, -0.5550976208, -0.4957820792, 0.667882296, 0, -0.1883614327, 0.9145869398, 0.357841725, 0, 0.7625556724, -0.5414408243, -0.3540489801, 0, -0.5870231946, -0.3226498013, -0.7424963803, 0, 0.3051124198, 0.2262544068, -0.9250488391, 0,
        0.6379576059, 0.577242424, -0.5097070502, 0, -0.5966775796, 0.1454852398, -0.7891830656, 0, -0.658330573, 0.6555487542, -0.3699414651, 0, 0.7434892426, 0.2351084581, 0.6260573129, 0, 0.5562114096, 0.8264360377, -0.0873632843, 0, -0.3028940016, -0.8251527185, 0.4768419182, 0, 0.1129343818, -0.985888439, -0.1235710781, 0, 0.5937652891, -0.5896813806, 0.5474656618, 0,
        0.6757964092, -0.5835758614, -0.4502648413, 0, 0.7242302609, -0.1152719764, 0.6798550586, 0, -0.9511914166, 0.0753623979, -0.2992580792, 0, 0.2539470961, -0.1886339355, 0.9486454084, 0, 0.571433621, -0.1679450851, -0.8032795685, 0, -0.06778234979, 0.3978269256, 0.9149531629, 0, 0.6074972649, 0.733060024, -0.3058922593, 0, -0.5435478392, 0.1675822484, 0.8224791405, 0,
        -0.5876678086, -0.3380045064, -0.7351186982, 0, -0.7967562402, 0.04097822706, -0.6029098428, 0, -0.1996350917, 0.8706294745, 0.4496111079, 0, -0.02787660336, -0.9106232682, -0.4122962022, 0, -0.7797625996, -0.6257634692, 0.01975775581, 0, -0.5211232846, 0.7401644346, -0.4249554471, 0, 0.8575424857, 0.4053272873, -0.3167501783, 0, 0.1045223322, 0.8390195772, -0.5339674439, 0,
        0.3501822831, 0.9242524096, -0.1520850155, 0, 0.1987849858, 0.07647613266, 0.9770547224, 0, 0.7845996363, 0.6066256811, -0.1280964233, 0, 0.09006737436, -0.9750989929, -0.2026569073, 0, -0.8274343547, -0.542299559, 0.1458203587, 0, -0.3485797732, -0.415802277, 0.840000362, 0, -0.2471778936, -0.7304819962, -0.6366310879, 0, -0.3700154943, 0.8577948156, 0.3567584454, 0,
        0.5913394901, -0.548311967, -0.5913303597, 0, 0.1204873514, -0.7626472379, -0.6354935001, 0, 0.616959265, 0.03079647928, 0.7863922953, 0, 0.1258156836, -0.6640829889, -0.7369967419, 0, -0.6477565124, -0.1740147258, -0.7417077429, 0, 0.6217889313, -0.7804430448, -0.06547655076, 0, 0.6589943422, -0.6096987708, 0.4404473475, 0, -0.2689837504, -0.6732403169, -0.6887635427, 0,
        -0.3849775103, 0.5676542638, 0.7277093879, 0, 0.5754444408, 0.8110471154, -0.1051963504, 0, 0.9141593684, 0.3832947817, 0.131900567, 0, -0.107925319, 0.9245493968, 0.3654593525, 0, 0.377977089, 0.3043148782, 0.8743716458, 0, -0.2142885215, -0.8259286236, 0.5214617324, 0, 0.5802544474, 0.4148098596, -0.7008834116, 0, -0.1982660881, 0.8567161266, -0.4761596756, 0,
        -0.03381553704, 0.3773180787, -0.9254661404, 0, -0.6867922841, -0.6656597827, 0.2919133642, 0, 0.7731742607, -0.2875793547, -0.5652430251, 0, -0.09655941928, 0.9193708367, -0.3813575004, 0, 0.2715702457, -0.9577909544, -0.09426605581, 0, 0.2451015704, -0.6917998565, -0.6792188003, 0, 0.977700782, -0.1753855374, 0.1155036542, 0, -0.5224739938, 0.8521606816, 0.02903615945, 0,
        -0.7734880599, -0.5261292347, 0.3534179531, 0, -0.7134492443, -0.269547243, 0.6467878011, 0, 0.1644037271, 0.5105846203, -0.8439637196, 0, 0.6494635788, 0.05585611296, 0.7583384168, 0, -0.4711970882, 0.5017280509, -0.7254255765, 0, -0.6335764307, -0.2381686273, -0.7361091029, 0, -0.9021533097, -0.270947803, -0.3357181763, 0, -0.3793711033, 0.872258117, 0.3086152025, 0,
        -0.6855598966, -0.3250143309, 0.6514394162, 0, 0.2900942212, -0.7799057743, -0.5546100667, 0, -0.2098319339, 0.85037073, 0.4825351604, 0, -0.4592603758, 0.6598504336, -0.5947077538, 0, 0.8715945488, 0.09616365406, -0.4807031248, 0, -0.6776666319, 0.7118504878, -0.1844907016, 0, 0.7044377633, 0.312427597, 0.637304036, 0, -0.7052318886, -0.2401093292, -0.6670798253, 0,
        0.081921007, -0.7207336136, -0.6883545647, 0, -0.6993680906, -0.5875763221, -0.4069869034, 0, -0.1281454481, 0.6419895885, 0.7559286424, 0, -0.6337388239, -0.6785471501, -0.3714146849, 0, 0.5565051903, -0.2168887573, -0.8020356851, 0, -0.5791554484, 0.7244372011, -0.3738578718, 0, 0.1175779076, -0.7096451073, 0.6946792478, 0, -0.6134619607, 0.1323631078, 0.7785527795, 0,
        0.6984635305, -0.02980516237, -0.715024719, 0, 0.8318082963, -0.3930171956, 0.3919597455, 0, 0.1469576422, 0.05541651717, -0.9875892167, 0, 0.708868575, -0.2690503865, 0.6520101478, 0, 0.2726053183, 0.67369766, -0.68688995, 0, -0.6591295371, 0.3035458599, -0.6880466294, 0, 0.4815131379, -0.7528270071, 0.4487723203, 0, 0.9430009463, 0.1675647412, -0.2875261255, 0,
        0.434802957, 0.7695304522, -0.4677277752, 0, 0.3931996188, 0.594473625, 0.7014236729, 0, 0.7254336655, -0.603925654, 0.3301814672, 0, 0.7590235227, -0.6506083235, 0.02433313207, 0, -0.8552768592, -0.3430042733, 0.3883935666, 0, -0.6139746835, 0.6981725247, 0.3682257648, 0, -0.7465905486, -0.5752009504, 0.3342849376, 0, 0.5730065677, 0.810555537, -0.1210916791, 0,
        -0.9225877367, -0.3475211012, -0.167514036, 0, -0.7105816789, -0.4719692027, -0.5218416899, 0, -0.08564609717, 0.3583001386, 0.929669703, 0, -0.8279697606, -0.2043157126, 0.5222271202, 0, 0.427944023, 0.278165994, 0.8599346446, 0, 0.5399079671, -0.7857120652, -0.3019204161, 0, 0.5678404253, -0.5495413974, -0.6128307303, 0, -0.9896071041, 0.1365639107, -0.04503418428, 0,
        -0.6154342638, -0.6440875597, 0.4543037336, 0, 0.1074204368, -0.7946340692, 0.5975094525, 0, -0.3595449969, -0.8885529948, 0.28495784, 0, -0.2180405296, 0.1529888965, 0.9638738118, 0, -0.7277432317, -0.6164050508, -0.3007234646, 0, 0.7249729114, -0.00669719484, 0.6887448187, 0, -0.5553659455, -0.5336586252, 0.6377908264, 0, 0.5137558015, 0.7976208196, -0.3160000073, 0,
        -0.3794024848, 0.9245608561, -0.03522751494, 0, 0.8229248658, 0.2745365933, -0.4974176556, 0, -0.5404114394, 0.6091141441, 0.5804613989, 0, 0.8036581901, -0.2703029469, 0.5301601931, 0, 0.6044318879, 0.6832968393, 0.4095943388, 0, 0.06389988817, 0.9658208605, -0.2512108074, 0, 0.1087113286, 0.7402471173, -0.6634877936, 0, -0.713427712, -0.6926784018, 0.1059128479, 0,
        0.6458897819, -0.5724548511, -0.5050958653, 0, -0.6553931414, 0.7381471625, 0.159995615, 0, 0.3910961323, 0.9188871375, -0.05186755998, 0, -0.4879022471, -0.5904376907, 0.6429111375, 0, 0.6014790094, 0.7707441366, -0.2101820095, 0, -0.5677173047, 0.7511360995, 0.3368851762, 0, 0.7858573506, 0.226674665, 0.5753666838, 0, -0.4520345543, -0.604222686, -0.6561857263, 0,
        0.002272116345, 0.4132844051, -0.9105991643, 0, -0.5815751419, -0.5162925989, 0.6286591339, 0, -0.03703704785, 0.8273785755, 0.5604221175, 0, -0.5119692504, 0.7953543429, -0.3244980058, 0, -0.2682417366, -0.9572290247, -0.1084387619, 0, -0.2322482736, -0.9679131102, -0.09594243324, 0, 0.3554328906, -0.8881505545, 0.2913006227, 0, 0.7346520519, -0.4371373164, 0.5188422971, 0,
        0.9985120116, 0.04659011161, -0.02833944577, 0, -0.3727687496, -0.9082481361, 0.1900757285, 0, 0.91737377, -0.3483642108, 0.1925298489, 0, 0.2714911074, 0.4147529736, -0.8684886582, 0, 0.5131763485, -0.7116334161, 0.4798207128, 0, -0.8737353606, 0.18886992, -0.4482350644, 0, 0.8460043821, -0.3725217914, 0.3814499973, 0, 0.8978727456, -0.1780209141, -0.4026575304, 0,
        0.2178065647, -0.9698322841, -0.1094789531, 0, -0.1518031304, -0.7788918132, -0.6085091231, 0, -0.2600384876, -0.4755398075, -0.8403819825, 0, 0.572313509, -0.7474340931, -0.3373418503, 0, -0.7174141009, 0.1699017182, -0.6756111411, 0, -0.684180784, 0.02145707593, -0.7289967412, 0, -0.2007447902, 0.06555605789, -0.9774476623, 0, -0.1148803697, -0.8044887315, 0.5827524187, 0,
        -0.7870349638, 0.03447489231, 0.6159443543, 0, -0.2015596421, 0.6859872284, 0.6991389226, 0, -0.08581082512, -0.10920836, -0.9903080513, 0, 0.5532693395, 0.7325250401, -0.396610771, 0, -0.1842489331, -0.9777375055, -0.1004076743, 0, 0.0775473789, -0.9111505856, 0.4047110257, 0, 0.1399838409, 0.7601631212, -0.6344734459, 0, 0.4484419361, -0.845289248, 0.2904925424, 0
    )

    [Int64]$Seed                                           = 1337
    [Int64]$Octaves                                        = 3
    [Single]$Frequency                                     = 0.01
    [Single]$Lacunarity                                    = 2
    [Single]$Gain                                          = 0.5
    [Single]$WeightedStrength                              = 0
    [Single]$PingPongStrength                              = 2
    [Single]$FractalBounding                               = 1 / 1.75
    [Single]$CellularJitterModifier                        = 1
    [Single]$DomainWarpAmp                                 = 1
    [FnlNoiseType]$NoiseType                               = [FnlNoiseType]::OpenSimplex2
    [FnlRotationType3D]$RotationType3D                     = [FnlRotationType3D]::None
    [FnlTransformType3D]$TransformType3D                   = [FnlTransformType3D]::DefaultOpenSimplex2
    [FnlTransformType3D]$WarpTransformType3D               = [FnlTransformType3D]::DefaultOpenSimplex2
    [FnlFractalType]$FractalType                           = [FnlFractalType]::None
    [FnlCellularDistanceFunction]$CellularDistanceFunction = [FnlCellularDistanceFunction]::EuclideanSq
    [FnlCellularReturnType]$CellularReturnType             = [FnlCellularReturnType]::Distance
    [FnlDomainWarpType]$DomainWarpType                     = [FnlDomainWarpType]::OpenSimplex2

    FastNoiseLite() {}

    ###########################################################################
    #
    # NOTE THAT THE FOLLOWING METHODS WERE INLINED IN THE C# SOURCE.
    # POWERSHELL DOESN'T SUPPORT INLINING, SO THERE *MAY* BE SOME PERFORMANCE
    # DECAY HERE.
    #
    ###########################################################################
    Static [Single]FastMin(
        [Single]$A,
        [Single]$B
    ) {
        Return $A -LT $B ? $A : $B
    }

    Static [Single]FastMax(
        [Single]$A,
        [Single]$B
    ) {
        Return $A -GT $B ? $A : $B
    }

    Static [Single]FastAbs(
        [Single]$F
    ) {
        Return $F -LT 0 ? $F * -1 : $F
    }

    Static [Single]FastSqrt(
        [Single]$F
    ) {
        Return ([Single]([System.Math]::Sqrt($F))) # SQRT RETURNS DOUBLE, SO THIS CAST MAY MAKE SENSE, BUT WE MAY LOSE RESOLUTION
    }

    Static [Int64]FastFloor(
        [Single]$F
    ) {
        Return $F -GE 0 ? ([Int64]$F) : ([Int64]$F) - 1
    }

    Static [Int64]FastRound(
        [Single]$F
    ) {
        Return $F -GE 0 ? ([Int64]($F + 0.5)) : ([Int64]($F - 0.5))
    }

    Static [Single]Lerp(
        [Single]$A,
        [Single]$B,
        [Single]$T
    ) {
        Return $A + $T * ($B - $A)
    }

    Static [Single]InterpHermite(
        [Single]$T
    ) {
        Return $T * $T * (3 - 2 * $T)
    }

    Static [Single]InterpQuintic(
        [Single]$T
    ) {
        Return $T * $T * $T * ($T * ($T * 6 - 15) + 10)
    }

    Static [Single]CubicLerp(
        [Single]$A,
        [Single]$B,
        [Single]$C,
        [Single]$D,
        [Single]$T
    ) {
        [Single]$P = ($D - $C) - ($A - $B)

        Return $T * $T * $T * $P + $T * $T * (($A - $B) - $P) + $T * ($C - $A) + $B
    }

    Static [Int64]Hash(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed
    ) {
        [Int64]$Hash  = $ASeed -BXOR $XPrimed -BXOR $YPrimed
        $Hash        *= [FastNoiseLite]::HASH_MAGIC

        Return $Hash
    }

    Static [Int64]Hash(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Int64]$ZPrimed
    ) {
        [Int64]$Hash  = $ASeed -BXOR $XPrimed -BXOR $YPrimed -BXOR $ZPrimed
        $Hash        *= [FastNoiseLite]::HASH_MAGIC

        Return $Hash
    }

    Static [Single]ValCoord(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed
    ) {
        [Int64]$Hash  = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
        $Hash        *= $Hash
        $Hash         = $Hash -BXOR ($Hash -SHL 19) # ORIGINAL STATEMENT WAS hash ^= hash << 19;

        Return $Hash * (1 / [FastNoiseLite]::HASHCALC_MAGIC)
    }

    Static [Single]ValCoord(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Int64]$ZPrimed
    ) {
        [Int64]$Hash  = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed, $ZPrimed)
        $Hash        *= $Hash
        $Hash         = $Hash -BXOR ($Hash -SHL 19) # ORIGINAL STATEMENT WAS hash ^= hash << 19;

        Return $Hash * (1 / [FastNoiseLite]::HASHCALC_MAGIC)
    }

    Static [Single]GradCoord(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Single]$Xd,
        [Single]$Yd
    ) {
        [Int64]$Hash = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
        $Hash        = $Hash -BXOR ($Hash -SHR 15) # ORIGINAL STATEMENT WAS hash ^= hash >> 15;
        $Hash        = $Hash -BAND (127 -SHL 1) # ORIGINAL STATEMENT WAS  hash &= 127 << 1;

        [Single]$Xg = [FastNoiseLite]::GRADIENTS2D[$Hash]
        [Single]$Yg = [FastNoiseLite]::GRADIENTS2D[($Hash -BOR 1)]

        Return $Xd * $Xg + $Yd * $Yg
    }

    Static [Single]GradCoord(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Int64]$ZPrimed,
        [Single]$Xd,
        [Single]$Yd,
        [Single]$Zd
    ) {
        [Int64]$Hash = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed, $ZPrimed)
        $Hash        = $Hash -BXOR ($Hash -SHR 15) # ORIGINAL STATEMENT WAS hash ^= hash >> 15;
        $Hash        = $Hash -BAND (63 -SHL 2) # ORIGINAL STATEMENT WAS  hash &= 63 << 2;

        [Single]$Xg = [FastNoiseLite]::GRADIENTS3D[$Hash]
        [Single]$Yg = [FastNoiseLite]::GRADIENTS3D[($Hash -BOR 1)]
        [Single]$Zg = [FastNoiseLite]::GRADIENTS3D[($Hash -BOR 2)]

        Return $Xd * $Xg + $Yd * $Yg + $Zd * $Zg
    }

    ###########################################################################
    #
    # THE ORIGINAL SOURCE FOR THIS METHOD IS AS FOLLOWS:
    #
    #     private static void GradCoordOut(int seed, int xPrimed, int yPrimed, out Single xo, out Single yo)
    #     {
    #     int hash = Hash(seed, xPrimed, yPrimed) & (255 << 1);
    #
    #     xo = RandVecs2D[hash];
    #     yo = RandVecs2D[hash | 1];
    #     }
    #
    # USING REF ARGS IN LIEU OF OUT SHOULD BE SATISFACTORY HERE
    #
    ###########################################################################
    Static [Void]GradCoordOut(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Ref]$Xo,
        [Ref]$Yo
    ) {
        [Int64]$Hash = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed) -BAND (255 -SHL 1)

        $Xo.Value = [FastNoiseLite]::RANDVECS2D[$Hash]
        $Yo.Value = [FastNoiseLite]::RANDVECS2D[($Hash -BOR 1)]
    }

    Static [Void]GradCoordOut(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Int64]$ZPrimed,
        [Ref]$Xo,
        [Ref]$Yo,
        [Ref]$Zo
    ) {
        [Int64]$Hash = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed) -BAND (255 -SHL 2)

        $Xo.Value = [FastNoiseLite]::RANDVECS2D[$Hash]
        $Yo.Value = [FastNoiseLite]::RANDVECS2D[($Hash -BOR 1)]
        $Zo.Value = [FastNoiseLite]::RANDVECS2D[($Hash -BOR 2)]
    }

    Static [Void]GradCoordDual(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Single]$Xd,
        [Single]$Yd,
        [Ref]$Xo,
        [Ref]$Yo
    ) {
        [Int64]$Hash   = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
        [Int64]$Index1 = $Hash -BAND (127 -SHL 1)
        [Int64]$Index2 = ($Hash -SHR 7) -BAND (255 -SHL 1)
        [Single]$Xg    = [FastNoiseLite]::GRADIENTS2D[$Index1]
        [Single]$Yg    = [FastNoiseLite]::GRADIENTS2D[($Index1 -BOR 1)]
        [Single]$Xgo   = [FastNoiseLite]::RANDVECS2D[$Index2]
        [Single]$Ygo   = [FastNoiseLite]::RANDVECS2D[($Index2 -BOR 1)]
        [Single]$Value = $Xd * $Xg + $Yd * $Yg

        $Xo.Value = $Value * $Xgo
        $Yo.Value = $Value * $Ygo
    }

    Static [Void]GradCoordDual(
        [Int64]$ASeed,
        [Int64]$XPrimed,
        [Int64]$YPrimed,
        [Int64]$ZPrimed,
        [Single]$Xd,
        [Single]$Yd,
        [Single]$Zd,
        [Ref]$Xo,
        [Ref]$Yo,
        [Ref]$Zo
    ) {
        [Int64]$Hash   = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed, $ZPrimed)
        [Int64]$Index1 = $Hash -BAND (63 -SHL 2)
        [Int64]$Index2 = ($Hash -SHR 6) -BAND (255 -SHL 2)
        [Single]$Xg    = [FastNoiseLite]::GRADIENTS3D[$Index1]
        [Single]$Yg    = [FastNoiseLite]::GRADIENTS3D[($Index1 -BOR 1)]
        [Single]$Zg    = [FastNoiseLite]::GRADIENTS2D[($Index1 -BOR 2)]
        [Single]$Xgo   = [FastNoiseLite]::RANDVECS3D[$Index2]
        [Single]$Ygo   = [FastNoiseLite]::RANDVECS3D[($Index2 -BOR 1)]
        [Single]$Zgo   = [FastNoiseLite]::RANDVECS3D[($Index2 -BOR 2)]
        [Single]$Value = $Xd * $Xg + $Yd * $Yg + $Zd * $Zg

        $Xo.Value = $Value * $Xgo
        $Yo.Value = $Value * $Ygo
        $Zo.Value = $Value * $Zgo
    }

    [Void]SetNoiseType(
        [FnlNoiseType]$NoiseType
    ) {
        $this.NoiseType = $NoiseType
        $this.UpdateTransformType3D()
    }

    [Void]SetRotationType3D(
        [FnlRotationType3D]$RotationType3D
    ) {
        $this.RotationType3D = $RotationType3D
        $this.UpdateTransformType3D()
        $this.UpdateWarpTransformType3D()
    }

    [Void]SetFractalOctaves(
        [Int64]$Octaves
    ) {
        $this.Octaves = $Octaves
        $this.CalculateFractalBounding()
    }

    [Void]SetFractalGain(
        [Single]$Gain
    ) {
        $this.Gain = $Gain
        $this.CalculateFractalBounding()
    }

    [Void]SetDomainWarpType(
        [FnlDomainWarpType]$DomainWarpType
    ) {
        $this.DomainWarpType = $DomainWarpType
        $this.UpdateWarpTransformType3D()
    }

    [Single]GetNoise(
        [Single]$X,
        [Single]$Y
    ) {
        $this.TransformNoiseCoordinate(([Ref]$X), ([Ref]$Y))

        Switch($this.FractalType) {
            ([FnlFractalType]::FBm) {
                Return $this.GenFractalFBm($X, $Y)
            }

            ([FnlFractalType]::Ridged) {
                Return $this.GenFractalRidged($X, $Y)
            }

            ([FnlFractalType]::PingPong) {
                Return $this.GenFractalPingPong($X, $Y)
            }

            Default {
                Return $this.GenNoiseSingle($this.Seed, $X, $Y)
            }
        }

        # THIS CODE PATH ISN'T CONSIDERED IN THE ORIGINAL SOURCE, SO I'LL JUST INCLUDE THE DEFAULT CASE HERE
        # THIS IS MORE SO THE LINTER WILL SHUT UP, BUT JUSTIN CASE
        Return $this.GenNoiseSingle($this.Seed, $X, $Y)
    }

    [Single]GetNoise(
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        $this.TransformNoiseCoordinate(([Ref]$X), ([Ref]$Y), ([Ref]$Z))

        Switch($this.FractalType) {
            ([FnlFractalType]::FBm) {
                Return $this.GenFractalFBm($X, $Y, $Z)
            }

            ([FnlFractalType]::Ridged) {
                Return $this.GenFractalRidged($X, $Y, $Z)
            }

            ([FnlFractalType]::PingPong) {
                Return $this.GenFractalPingPong($X, $Y, $Z)
            }

            Default {
                Return $this.GenNoiseSingle($this.Seed, $X, $Y, $Z)
            }
        }

        # THIS CODE PATH ISN'T CONSIDERED IN THE ORIGINAL SOURCE, SO I'LL JUST INCLUDE THE DEFAULT CASE HERE
        # THIS IS MORE SO THE LINTER WILL SHUT UP, BUT JUSTIN CASE
        Return $this.GenNoiseSingle($this.Seed, $X, $Y, $Z)
    }

    [Void]DomainWarp(
        [Ref]$X,
        [Ref]$Y
    ) {
        Switch($this.FractalType) {
            ([FnlFractalType]::DomainWarpProgressive) {
                $this.DomainWarpFractalProgressive($X, $Y)

                Break
            }

            ([FnlFractalType]::DomainWarpIndependent) {
                $this.DomainWarpFractalIndependent($X, $Y)

                Break
            }

            Default {
                $this.DomainWarpSingle($X, $Y)

                Break
            }
        }

        $this.DomainWarpSingle($X, $Y)
    }

    [Void]DomainWarp(
        [Ref]$X,
        [Ref]$Y,
        [Ref]$Z
    ) {
        Switch($this.FractalType) {
            ([FnlFractalType]::DomainWarpProgressive) {
                $this.DomainWarpFractalProgressive($X, $Y, $Z)

                Break
            }

            ([FnlFractalType]::DomainWarpIndependent) {
                $this.DomainWarpFractalIndependent($X, $Y, $Z)

                Break
            }

            Default {
                $this.DomainWarpSingle($X, $Y, $Z)

                Break
            }
        }

        $this.DomainWarpSingle($X, $Y, $Z)
    }

    [Single]PingPong(
        [Single]$T
    ) {
        $T = $T - ([Int64]($T * 0.5)) * 2

        Return $T -LT 1 ? $T : 2 - $T
    }

    [Void]CalculateFractalBounding() {
        [Single]$LGain       = [FastNoiseLite]::FastAbs($this.Gain)
        [Single]$LAmp        = $LGain
        [Single]$LAmpFractal = 1

        For([Int64]$I = 1; $I -LT $this.Octaves; $I++) {
            $LAmpFractal += $LAmp
            $LAmp        *= $LGain
        }

        $this.FractalBounding = 1 / $LAmpFractal
    }

    [Single]GenNoiseSingle(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        Switch($this.NoiseType) {
            ([FnlNoiseType]::OpenSimplex2) {
                Return $this.SingleSimplex($ASeed, $X, $Y)
            }

            ([FnlNoiseType]::OpenSimplex2S) {
                Return $this.SingleOpenSimplex2S($ASeed, $X, $Y)
            }

            ([FnlNoiseType]::Cellular) {
                Return $this.SingleCellular($ASeed, $X, $Y)
            }

            ([FnlNoiseType]::Perlin) {
                Return $this.SinglePerlin($ASeed, $X, $Y)
            }

            ([FnlNoiseType]::ValueCubic) {
                Return $this.SingleValueCubic($ASeed, $X, $Y)
            }

            ([FnlNoiseType]::Value) {
                Return $this.SingleValue($ASeed, $X, $Y)
            }

            Default {
                Return 0
            }
        }

        Return 0
    }

    [Single]GenNoiseSingle(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        Switch($this.NoiseType) {
            ([FnlNoiseType]::OpenSimplex2) {
                Return $this.SingleSimplex($ASeed, $X, $Y, $Z)
            }

            ([FnlNoiseType]::OpenSimplex2S) {
                Return $this.SingleOpenSimplex2S($ASeed, $X, $Y, $Z)
            }

            ([FnlNoiseType]::Cellular) {
                Return $this.SingleCellular($ASeed, $X, $Y, $Z)
            }

            ([FnlNoiseType]::Perlin) {
                Return $this.SinglePerlin($ASeed, $X, $Y, $Z)
            }

            ([FnlNoiseType]::ValueCubic) {
                Return $this.SingleValueCubic($ASeed, $X, $Y, $Z)
            }

            ([FnlNoiseType]::Value) {
                Return $this.SingleValue($ASeed, $X, $Y, $Z)
            }

            Default {
                Return 0
            }
        }

        Return 0
    }

    [Void]TransformNoiseCoordinate(
        [Ref]$X,
        [Ref]$Y
    ) {
        $X.Value *= $this.Frequency
        $Y.Value *= $this.Frequency

        Switch($this.NoiseType) {
            ($_ -EQ [FnlNoiseType]::OpenSimplex2 -OR $_ -EQ [FnlNoiseType]::OpenSimplex2S) {
                [Single]$F2 = 0.5 * ([FastNoiseLite]::SQRT3 - 1)
                [Single]$T  = ($X.Value + $Y.Value) * $F2

                $X.Value += $T
                $Y.Value += $T

                Break
            }

            Default {
                Break
            }
        }

        Return
    }

    [Void]TransformNoiseCoordinate(
        [Ref]$X,
        [Ref]$Y,
        [Ref]$Z
    ) {
        $X.Value *= $this.Frequency
        $Y.Value *= $this.Frequency
        $Z.Value *= $this.Frequency

        Switch($this.TransformType3D) {
            ([FnlTransformType3D]::ImproveXYPlanes) {
                [Single]$Xy = $X.Value + $Y.Value
                [Single]$S2 = $Xy * -[FastNoiseLite]::PLANARIMPROVEA_MAGIC

                $Z.Value *= [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC
                $X.Value += $S2 - $Z.Value
                $Y.Value += $S2 - $Z.Value
                $Z.Value += $Xy * [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC

                Break
            }

            ([FnlTransformType3D]::ImproveXZPlanes) {
                [Single]$Xz = $X.Value + $Z.Value
                [Single]$S2 = $Xz * -[FastNoiseLite]::PLANARIMPROVEA_MAGIC

                $Y.Value *= [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC
                $X.Value += $S2 - $Z.Value
                $Y.Value += $S2 - $Z.Value
                $Z.Value += $Xz * [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC

                Break
            }

            ([FnlTransformType3D]::DefaultOpenSimplex2) {
                [Single]$R = ($X.Value + $Y.Value + $Z.Value) * [FastNoiseLite]::A2DIV3

                $X.Value = $R - $X.Value
                $Y.Value = $R - $Y.Value
                $Z.Value = $R - $Z.Value

                Break
            }

            Default {
                Break
            }
        }

        Return
    }

    [Void]UpdateTransformType3D() {
        Switch($this.RotationType3D) {
            ([FnlRotationType3D]::ImproveXYPlanes) {
                $this.TransformType3D = [FnlTransformType3D]::ImproveXYPlanes

                Break
            }

            ([FnlRotationType3D]::ImproveXZPlanes) {
                $this.TransformType3D = [FnlTransformType3D]::ImproveXZPlanes

                Break
            }

            Default {
                Switch($this.NoiseType) {
                    ($_ -EQ [FnlNoiseType]::OpenSimplex2 -OR $_ -EQ [FnlNoiseType]::OpenSimplex2S) {
                        $this.TransformType3D = [FnlTransformType3D]::DefaultOpenSimplex2

                        Break
                    }

                    Default {
                        $this.TransformType3D = [FnlTransformType3D]::None

                        Break
                    }
                }

                Break
            }
        }

        Return
    }

    [Void]TransformDomainWarpCoordinate(
        [Ref]$X,
        [Ref]$Y
    ) {
        Switch($this.DomainWarpType) {
            ($_ -EQ [FnlDomainWarpType]::OpenSimplex2 -OR $_ -EQ [FnlDomainWarpType]::OpenSimplex2Reduced) {
                [Single]$F2 = 0.5 * ([FastNoiseLite]::SQRT3 - 1)
                [Single]$T  = ($X.Value + $Y.Value) * $F2

                $X.Value += $T
                $Y.Value += $T

                Break
            }

            Default {
                Break
            }
        }

        Return
    }

    [Void]TransformDomainWarpCoordinate(
        [Ref]$X,
        [Ref]$Y,
        [Ref]$Z
    ) {
        Switch($this.WarpTransformType3D) {
            ([FnlTransformType3D]::ImproveXYPlanes) {
                [Single]$Xy = $X.Value + $Y.Value
                [Single]$S2 = $Xy * -[FastNoiseLite]::PLANARIMPROVEA_MAGIC

                $Z.Value *= [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC
                $X.Value += $S2 - $Z.Value
                $Y.Value += $S2 - $Z.Value
                $Z.Value += $Xy * [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC

                Break
            }

            ([FnlTransformType3D]::ImproveXZPlanes) {
                [Single]$Xz = $X.Value + $Z.Value
                [Single]$S2 = $Xz * -[FastNoiseLite]::PLANARIMPROVEA_MAGIC

                $Y.Value *= [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC
                $X.Value += $S2 - $Y.Value
                $Z.Value += $S2 - $Y.Value
                $Y.Value += $Xz * [FastNoiseLite]::PLANARIMPROVEZSCALE_MAGIC

                Break
            }

            ([FnlTransformType3D]::DefaultOpenSimplex2) {
                [Single]$R = ($X.Value + $Y.Value + $Z.Value) * [FastNoiseLite]::A2DIV3

                $X.Value = $R - $X.Value
                $Y.Value = $R - $Y.Value
                $Z.Value = $R - $Z.Value

                Break
            }

            Default {
                Break
            }
        }

        Return
    }

    [Void]UpdateWarpTransformType3D() {
        Switch($this.RotationType3D) {
            ([FnlRotationType3D]::ImproveXYPlanes) {
                $this.WarpTransformType3D = [FnlTransformType3D]::ImproveXYPlanes

                Break
            }

            ([FnlRotationType3D]::ImproveXZPlanes) {
                $this.WarpTransformType3D = [FnlTransformType3D]::ImproveXZPlanes

                Break
            }

            Default {
                Switch($this.DomainWarpType) {
                    ($_ -EQ [FnlDomainWarpType]::OpenSimplex2 -OR $_ -EQ [FnlDomainWarpType]::OpenSimplex2Reduced) {
                        $this.WarpTransformType3D = [FnlTransformType3D]::DefaultOpenSimplex2

                        Break
                    }

                    Default {
                        $this.WarpTransformType3D = [FnlTransformType3D]::None

                        Break
                    }
                }

                Break
            }
        }

        Return
    }

    [Single]GenFractalFBm(
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Sum  = 0
        [Single]$Amp  = $this.FractalBounding

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Noise = $this.GenNoiseSingle($ASeed++, $X, $Y)

            $Sum += $Noise * $Amp
            $Amp *= $this.Lerp(1, [FastNoiseLite]::FastMin($Noise + 1, 2) * 0.5, $this.WeightedStrength)
            $X   *= $this.Lacunarity
            $Y   *= $this.Lacunarity
            $Amp *= $this.Gain
        }

        Return $Sum
    }

    [Single]GenFractalFBm(
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Sum  = 0
        [Single]$Amp  = $this.FractalBounding

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Noise = $this.GenNoiseSingle($ASeed++, $X, $Y, $Z)

            $Sum += $Noise * $Amp
            $Amp *= $this.Lerp(1, [FastNoiseLite]::FastMin($Noise + 1, 2) * 0.5, $this.WeightedStrength)
            $X   *= $this.Lacunarity
            $Y   *= $this.Lacunarity
            $Z   *= $this.Lacunarity
            $Amp *= $this.Gain
        }

        Return $Sum
    }

    [Single]GenFractalRidged(
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Sum  = 0
        [Single]$Amp  = $this.FractalBounding

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Noise = [FastNoiseLite]::FastAbs($this.GenNoiseSingle($ASeed++, $X, $Y))

            $Sum += ($Noise * -2 + 1) * $Amp
            $Amp *= $this.Lerp(1, 1 - $Noise, $this.WeightedStrength)
            $X   *= $this.Lacunarity
            $Y   *= $this.Lacunarity
            $Amp *= $this.Gain
        }

        Return $Sum
    }

    [Single]GenFractalRidged(
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Sum  = 0
        [Single]$Amp  = $this.FractalBounding

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Noise = [FastNoiseLite]::FastAbs($this.GenNoiseSingle($ASeed++, $X, $Y, $Z))

            $Sum += ($Noise * -2 + 1) * $Amp
            $Amp *= $this.Lerp(1, 1 - $Noise, $this.WeightedStrength)
            $X   *= $this.Lacunarity
            $Y   *= $this.Lacunarity
            $Z   *= $this.Lacunarity
            $Amp *= $this.Gain
        }

        Return $Sum
    }

    [Single]GenFractalPingPong(
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Sum  = 0
        [Single]$Amp  = $this.FractalBounding

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Noise = $this.PingPong(($this.GenNoiseSingle($ASeed++, $X, $Y) + 1) * $this.PingPongStrength)

            $Sum += ($Noise - 0.5) * 2 * $Amp
            $Amp *= $this.Lerp(1, $Noise, $this.WeightedStrength)
            $X   *= $this.Lacunarity
            $Y   *= $this.Lacunarity
            $Amp *= $this.Gain
        }

        Return $Sum
    }

    [Single]GenFractalPingPong(
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Sum  = 0
        [Single]$Amp  = $this.FractalBounding

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Noise = $this.PingPong(($this.GenNoiseSingle($ASeed++, $X, $Y, $Z) + 1) * $this.PingPongStrength)

            $Sum += ($Noise - 0.5) * 2 * $Amp
            $Amp *= $this.Lerp(1, $Noise, $this.WeightedStrength)
            $X   *= $this.Lacunarity
            $Y   *= $this.Lacunarity
            $Z   *= $this.Lacunarity
            $Amp *= $this.Gain
        }

        Return $Sum
    }

    [Single]SingleSimplex(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        [Single]$G2   = (3 - [FastNoiseLite]::SQRT3) / 6
        [Single]$G2m1 = $G2 - 1
        [Single]$G2a1 = 1 - 2 * $G2
        [Single]$G2a2 = 2 * $G2m1
        [Int64]$I     = [FastNoiseLite]::FastFloor($X)
        [Int64]$J     = [FastNoiseLite]::FastFloor($Y)
        [Single]$Xi   = ([Single]($X - $I))
        [Single]$Yi   = ([Single]($Y - $J))
        [Single]$T    = ($Xi + $Yi) * $G2
        [Single]$X0   = $Xi - $T
        [Single]$Y0   = $Yi - $T
        [Single]$N0   = 0
        [Single]$N1   = 0
        [Single]$N2   = 0

        $I *= [FastNoiseLite]::PRIMEX
        $J *= [FastNoiseLite]::PRIMEY

        [Single]$A  = 0.5 - $X0 * $X0 - $Y0 * $Y0

        If($A -LE 0) {
            $N0 = 0
        } Else {
            $N0 = $A * $A * $A * $A * [FastNoiseLite]::GradCoord($ASeed, $I, $J, $X0, $Y0)
        }

        [Single]$C  = ([Single](2 * $G2a1 * (1 / $G2 - 2)) * $T + ([Single](-2 * $G2a1 * $G2a1) + $A))

        If($C -LE 0) {
            $N2 = 0
        } Else {
            [Single]$X2 = $X0 + $G2a2
            [Single]$Y2 = $Y0 + $G2a2

            $N2 = $C * $C * $C * $C * [FastNoiseLite]::GradCoord($ASeed, $I + [FastNoiseLite]::PRIMEX, $J + [FastNoiseLite]::PRIMEY, $X2, $Y2)
        }

        If($Y0 -GT $X0) {
            [Single]$X1 = $X0 + $G2
            [Single]$Y1 = $Y0 + $G2m1
            [Single]$B  = 0.5 - $X1 * $X1 - $Y1 * $Y1

            If($B -LE 0) {
                $N1 = 0
            } Else {
                $N1 = $B * $B * $B * $B * [FastNoiseLite]::GradCoord($ASeed, $I, $J + [FastNoiseLite]::PRIMEY, $X1, $Y1)
            }
        } Else {
            [Single]$X1 = $X0 + $G2m1
            [Single]$Y1 = $Y0 + $G2
            [Single]$B  = 0.5 - $X1 * $X1 - $Y1 * $Y1

            If($B -LE 0) {
                $N1 = 0
            } Else {
                $N1 = $B * $B * $B * $B * [FastNoiseLite]::GradCoord($ASeed, $I + [FastNoiseLite]::PRIMEX, $J, $X1, $Y1)
            }
        }

        Return ($N0 + $N1 + $N2) * 99.83685446303647
    }

    [Single]SingleOpenSimplex2(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$I      = [FastNoiseLite]::FastRound($X)
        [Int64]$J      = [FastNoiseLite]::FastRound($Y)
        [Int64]$K      = [FastNoiseLite]::FastRound($Z)
        [Single]$X0    = ([Single]($X - $I))
        [Single]$Y0    = ([Single]($Y - $J))
        [Single]$Z0    = ([Single]($Z - $K))
        [Int64]$XNSign = ([Int64](-1 - $X0) -BOR 1)
        [Int64]$YNSign = ([Int64](-1 - $Y0) -BOR 1)
        [Int64]$ZNSign = ([Int64](-1 - $Z0) -BOR 1)
        [Single]$Ax0   = $XNSign * -$X0
        [Single]$Ay0   = $YNSign * -$Y0
        [Single]$Az0   = $ZNSign * -$Z0
    
        $I *= [FastNoiseLite]::PRIMEX
        $J *= [FastNoiseLite]::PRIMEY
        $K *= [FastNoiseLite]::PRIMEZ
    
        [Single]$Value = 0
        [Single]$A     = (0.6 - $X0 * $X0) - ($Y0 * $Y0 + $Z0 * $Z0)
    
        For([Int64]$L = 0; ; $L++) {
            If($A -GT 0) {
                $Value += $A * $A * $A * $A * [FastNoiseLite]::GradCoord($ASeed, $I, $J, $K, $X0, $Y0, $Z0)
            }

            If($Ax0 -GE $Ay0 -AND $Ax0 -GE $Az0) {
                [Single]$B  = $A + $Ax0 + $Ax0

                If($B -GT 1) {
                    $B     -= 1
                    $Value += $B * $B * $B * $B * [FastNoiseLite]::GradCoord($ASeed, $I - $XNSign * [FastNoiseLite]::PRIMEX, $J, $K, $X0 + $XNSign, $Y0, $Z0)
                }
            } Elseif($Ay0 -GT $Ax0 -AND $Ay0 -GE $Az0) {
                [Single]$B  = $A + $Ay0 + $Ay0

                If($B -GT 1) {
                    $B     -= 1
                    $Value += $B * $B * $B * $B * [FastNoiseLite]::GradCoord($ASeed, $I, $J - $YNSign * [FastNoiseLite]::PRIMEY, $K, $X0, $Y0 + $YNSign, $Z0)
                }
            } Else {
                [Single]$B  = $A + $Az0 + $Az0

                If($B -GT 1) {
                    $B     -= 1
                    $Value += $B * $B * $B * $B * [FastNoiseLite]::GradCoord($ASeed, $I, $J, $K - $ZNSign * [FastNoiseLite]::PRIMEZ, $X0, $Y0, $Z0 + $ZNSign)
                }
            }

            If($L == 1) {
                Break
            }

            $Ax0     = 0.5 - $Ax0
            $Ay0     = 0.5 - $Ay0
            $Az0     = 0.5 - $Az0
            $X0      = $XNSign * $Ax0
            $Y0      = $YNSign * $Ay0
            $Z0      = $ZNSign * $Az0
            $A      += (0.75 - $Ax0) - ($Ay0 + $Az0)
            $I      += ($XNSign -SHR 1) -BAND [FastNoiseLite]::PRIMEX
            $J      += ($YNSign -SHR 1) -BAND [FastNoiseLite]::PRIMEY
            $K      += ($ZNSign -SHR 1) -BAND [FastNoiseLite]::PRIMEZ
            $XNSign  = -$XNSign
            $YNSign  = -$YNSign
            $ZNSign  = -$ZNSign
            $ASeed   = -BNOT $ASeed
        }

        Return $Value * [FastNoiseLite]::SIMPLEXVALMODA_MAGIC
    }

    [Single]SingleOpenSimplex2S(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        [Single]$G2   = (3 - [FastNoiseLite]::SQRT3) / 6
        [Single]$G2m1 = $G2 - 1
        [Single]$G2a1 = 1 - 2 * $G2
        [Int64]$I     = [FastNoiseLite]::FastFloor($X)
        [Int64]$J     = [FastNoiseLite]::FastFloor($Y)
        [Single]$Xi   = ([Single]($X - $I))
        [Single]$Yi   = ([Single]($Y - $J))

        $I *= [FastNoiseLite]::PRIMEX
        $J *= [FastNoiseLite]::PRIMEY

        [Int64]$I1     = $I + [FastNoiseLite]::PRIMEX
        [Int64]$J1     = $J + [FastNoiseLite]::PRIMEY
        [Single]$T     = ($Xi + $Yi) * $G2
        [Single]$X0    = $Xi - $T
        [Single]$Y0    = $Yi - $T
        [Single]$A0    = [FastNoiseLite]::A2DIV3 - $X0 * $X0 - $Y0 * $Y0
        [Single]$Value = $A0 * $A0 * $A0 * $A0 * [FastNoiseLite]::GradCoord($ASeed, $I, $J, $X0, $Y0)
        [Single]$A1    = ([Single](2 * $G2a1 * (1 / $G2 - 2)) * $T + ([Single](-2 * $G2a1 * $G2a1) + $A0))
        [Single]$X1    = $X0 - $G2a1
        [Single]$Y1    = $Y0 - $G2a1

        $Value += $A1 * $A1 * $A1 * $A1 * [FastNoiseLite]::GradCoord($ASeed, $I1, $J1, $X1, $Y1)

        [Single]$Xmyi = $Xi - $Yi

        If($T -GT $G2) {
            If($Xi + $Xmyi -GT 1) {
                [Single]$X2  = $X0 + (3 * $G2 - 2)
                [Single]$Y2  = $Y0 + (3 * $G2 - 1)
                [Single]$A2  = [FastNoiseLite]::A2DIV3 - $X2 * $X2 - $Y2 * $Y2

                If($A2 -GT 0) {
                    $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord($ASeed, $I + ([FastNoiseLite]::PRIMEX -SHL 1), $J + [FastNoiseLite]::PRIMEY, $X2, $Y2)
                }
            } Else {
                [Single]$X2  = $X0 + $G2
                [Single]$Y2  = $Y0 + $G2m1
                [Single]$A2  = [FastNoiseLite]::A2DIV3 - $X2 * $X2 - $Y2 * $Y2

                If($A2 -GT 0) {
                    $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord($ASeed, $I, $J + [FastNoiseLite]::PRIMEY, $X2, $Y2)
                }
            }

            If($Yi - $Xmyi -GT 1) {
                [Single]$X3  = $X0 + $G2m1
                [Single]$Y3  = $Y0 + $G2
                [Single]$A3  = [FastNoiseLite]::A2DIV3 - $X3 * $X3 - $Y3 * $Y3

                If($A3 -GT 0) {
                    $Value += $A3 * $A3 * $A3 * $A3 * [FastNoiseLite]::GradCoord($ASeed, $I + [FastNoiseLite]::PRIMEX, $J, $X3, $Y3)
                }
            }
        } Else {
            If($Xi + $Xmyi -LT 0) {
                [Single]$X2  = $X0 + $G2m1
                [Single]$Y2  = $Y0 - $G2
                [Single]$A2  = [FastNoiseLite]::A2DIV3 - $X2 * $X2 - $Y2 * $Y2

                If($A2 -GT 0) {
                    $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord($ASeed, $I - [FastNoiseLite]::PRIMEX, $J, $X2, $Y2)
                }
            } Else {
                [Single]$X2  = $X0 + $G2m1
                [Single]$Y2  = $Y0 - $G2
                [Single]$A2  = [FastNoiseLite]::A2DIV3 - $X2 * $X2 - $Y2 * $Y2

                If($A2 -GT 0) {
                    $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord($ASeed, $I + [FastNoiseLite]::PRIMEX, $J, $X2, $Y2)
                }
            }

            If($Yi -LT $Xmyi) {
                [Single]$X2  = $X0 - $G2
                [Single]$Y2  = $Y0 - $G2m1
                [Single]$A2  = [FastNoiseLite]::A2DIV3 - $X2 * $X2 - $Y2 * $Y2

                If($A2 -GT 0) {
                    $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord($ASeed, $I, $J - [FastNoiseLite]::PRIMEY, $X2, $Y2)
                }
            } Else {
                [Single]$X2  = $X0 + $G2
                [Single]$Y2  = $Y0 + $G2m1
                [Single]$A2  = [FastNoiseLite]::A2DIV3 - $X2 * $X2 - $Y2 * $Y2

                If($A2 -GT 0) {
                    $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord($ASeed, $I, $J + [FastNoiseLite]::PRIMEY, $X2, $Y2)
                }
            }
        }

        Return $Value * 18.24196194486065
    }

    [Single]SingleOpenSimplex2S(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$I   = [FastNoiseLite]::FastFloor($X)
        [Int64]$J   = [FastNoiseLite]::FastFloor($Y)
        [Int64]$K   = [FastNoiseLite]::FastFloor($Z)
        [Single]$Xi = ([Single]($X - $I))
        [Single]$Yi = ([Single]($Y - $J))
        [Single]$Zi = ([Single]($Z - $K))

        $I *= [FastNoiseLite]::PRIMEX
        $J *= [FastNoiseLite]::PRIMEY
        $K *= [FastNoiseLite]::PRIMEZ

        [Int64]$Seed2  = $ASeed + [FastNoiseLite]::SEEDADD_MAGIC
        [Int64]$XNMask = ([Int64](0.5 - $Xi))
        [Int64]$YNMask = ([Int64](0.5 - $Yi))
        [Int64]$ZNMask = ([Int64](0.5 - $Zi))
        [Single]$X0    = $Xi + $XNMask
        [Single]$Y0    = $Yi + $YNMask
        [Single]$Z0    = $Zi + $ZNMask
        [Single]$A0    = 0.75 - $X0 * $X0 - $Y0 * $Y0 - $Z0 * $Z0
        [Single]$Value = $A0 * $A0 * $A0 * $A0 * [FastNoiseLite]::GradCoord(
            $ASeed,
            $I + ($XNMask -BAND [FastNoiseLite]::PRIMEX),
            $J + ($YNMask -BAND [FastNoiseLite]::PRIMEY),
            $K + ($ZNMask -BAND [FastNoiseLite]::PRIMEZ),
            $X0, $Y0, $Z0
        )

        [Single]$X1   = $Xi - 0.5
        [Single]$Y1   = $Yi - 0.5
        [Single]$Z1   = $Zi - 0.5
        [Single]$A1   = 0.75 - $X1 * $X1 - $Y1 * $Y1 - $Z1 * $Z1
        $Value       += $A1 * $A1 * $A1 * $A1 * [FastNoiseLite]::GradCoord(
            $Seed2,
            $I + [FastNoiseLite]::PRIMEX,
            $J + [FastNoiseLite]::PRIMEY,
            $K + [FastNoiseLite]::PRIMEZ,
            $X1, $Y1, $Z1
        )

        [Single]$XAFlipMask0 = (($XNMask -BOR 1) -SHL 1) * $X1
        [Single]$YAFlipMask0 = (($YNMask -BOR 1) -SHL 1) * $Y1
        [Single]$ZAFlipMask0 = (($ZNMask -BOR 1) -SHL 1) * $Z1
        [Single]$XAFlipMask1 = (-2 - ($XNMask -SHL 2)) * $X1 - 1
        [Single]$YAFlipMask1 = (-2 - ($YNMask -SHL 2)) * $Y1 - 1
        [Single]$ZAFlipMask1 = (-2 - ($ZNMask -SHL 2)) * $Z1 - 1
        [Boolean]$Skip5      = $false
        [Single]$A2          = $XAFlipMask0 + $A0

        If($A2 -GT 0) {
            [Single]$X2 = $X0 - ($XNMask -BOR 1)
            [Single]$Y2 = $Y0
            [Single]$Z2 = $Z0

            $Value += $A2 * $A2 * $A2 * $A2 * [FastNoiseLite]::GradCoord(
                $ASeed,
                $I + (-BNOT $XNMask -BAND [FastNoiseLite]::PRIMEX),
                $J + ($YNMask -BAND [FastNoiseLite]::PRIMEY),
                $K + ($ZNMask -BAND [FastNoiseLite]::PRIMEZ),
                $X2, $Y2, $Z2
            )
        } Else {
            [Single]$A3  = $YAFlipMask0 + $ZAFlipMask0 + $A0

            If($A3 -GT 0) {
                [Single]$X3 = $X0
                [Single]$Y3 = $Y0 - ($YNMask -BOR 1)
                [Single]$Z3 = $Z0 - ($ZNMask -BOR 1)

                $Value += $A3 * $A3 * $A3 * $A3 * [FastNoiseLite]::GradCoord(
                    $ASeed,
                    $I + ($XNMask -BAND [FastNoiseLite]::PRIMEX),
                    $J + (-BNOT $YNMask -BAND [FastNoiseLite]::PRIMEY),
                    $K + (-BNOT $ZNMask -BAND [FastNoiseLite]::PRIMEZ),
                    $X3, $Y3, $Z3
                )
            }

            [Single]$A4  = $XAFlipMask1 + $A1

            If($A4 -GT 0) {
                [Single]$X4 = ($XNMask -BOR 1) + $X1
                [Single]$Y4 = $Y1
                [Single]$Z4 = $Z1

                $Value += $A4 * $A4 * $A4 * $A4 * [FastNoiseLite]::GradCoord(
                    $Seed2,
                    $I + ($XNMask -BAND [FastNoiseLite]::APRIMEXMULT2),
                    $J + [FastNoiseLite]::PRIMEY,
                    $K + [FastNoiseLite]::PRIMEZ,
                    $X4, $Y4, $Z4
                )
                $Skip5 = $true
            }
        }

        [Boolean]$Skip9 = $false
        [Single]$A6     = $YAFlipMask0 + $A0

        If($A6 -GT 0) {
            [Single]$X6 = $X0
            [Single]$Y6 = $Y0 - ($YNMask -BOR 1)
            [Single]$Z6 = $Z0

            $Value += $A6 * $A6 * $A6 * $A6 * [FastNoiseLite]::GradCoord(
                $ASeed,
                $I + ($XNMask -BAND [FastNoiseLite]::PRIMEX),
                $J + (-BNOT $YNMask -BAND [FastNoiseLite]::PRIMEY),
                $K + ($ZNMask -BAND [FastNoiseLite]::PRIMEZ),
                $X6, $Y6, $Z6
            )
        } Else {
            [Single]$A7  = $XAFlipMask0 + $ZAFlipMask0 + $A0

            If($A7 -GT 0) {
                [Single]$X7 = $X0 - ($XNMask -BOR 1)
                [Single]$Y7 = $Y0
                [Single]$Z7 = $Z0 - ($ZNMask -BOR 1)

                $Value += $A7 * $A7 * $A7 * $A7 * [FastNoiseLite]::GradCoord(
                    $ASeed,
                    $I + (-BNOT $XNMask -BAND [FastNoiseLite]::PRIMEX),
                    $J + ($YNMask -BAND [FastNoiseLite]::PRIMEY),
                    $K + (-BNOT $ZNMask -BAND [FastNoiseLite]::PRIMEZ),
                    $X7, $Y7, $Z7
                )
            }

            [Single]$A8  = $YAFlipMask1 + $A1

            If($A8 -GT 0) {
                [Single]$X8 = $X1
                [Single]$Y8 = ($YNMask -BOR 1) + $Y1
                [Single]$Z8 = $Z1

                $Value += $A8 * $A8 * $A8 * $A8 * [FastNoiseLite]::GradCoord(
                    $Seed2,
                    $I + [FastNoiseLite]::PRIMEX,
                    $J + ($YNMask -BAND ([FastNoiseLite]::PRIMEY -SHL 1)),
                    $K + [FastNoiseLite]::PRIMEZ,
                    $X8, $Y8, $Z8
                )
                $Skip9 = $true
            }
        }

        [Boolean]$SkipD = $false
        [Single]$Aa     = $ZAFlipMask0 + $A0

        If($Aa -GT 0) {
            [Single]$Xa = $X0
            [Single]$Ya = $Y0
            [Single]$Za = $Z0 - ($ZNMask -BOR 1)

            $Value += $Aa * $Aa * $Aa * $Aa * [FastNoiseLite]::GradCoord(
                $ASeed,
                $I + ($XNMask -BAND [FastNoiseLite]::PRIMEX),
                $J + ($YNMask -BAND [FastNoiseLite]::PRIMEY),
                $K + (-BNOT $ZNMask -BAND [FastNoiseLite]::PRIMEZ),
                $Xa, $Ya, $Za
            )
        } Else {
            [Single]$Ab  = $XAFlipMask0 + $YAFlipMask0 + $A0

            If($Ab -GT 0) {
                [Single]$Xb = $X0 - ($XNMask -BOR 1)
                [Single]$Yb = $Y0 - ($YNMask -BOR 1)
                [Single]$Zb = $Z0

                $Value += $Ab * $Ab * $Ab * $Ab * [FastNoiseLite]::GradCoord(
                    $ASeed,
                    $I + (-BNOT $XNMask -BAND [FastNoiseLite]::PRIMEX),
                    $J + (-BNOT $YNMask -BAND [FastNoiseLite]::PRIMEY),
                    $K + ($ZNMask -BAND [FastNoiseLite]::PRIMEZ),
                    $Xb, $Yb, $Zb
                )
            }

            [Single]$Ac  = $ZAFlipMask1 + $A1

            If($Ac -GT 0) {
                [Single]$Xc = $X1
                [Single]$Yc = $Y1
                [Single]$Zc = ($ZNMask -BOR 1) + $Z1

                $Value += $Ac * $Ac * $Ac * $Ac * [FastNoiseLite]::GradCoord(
                    $Seed2,
                    $I + [FastNoiseLite]::PRIMEX,
                    $J + [FastNoiseLite]::PRIMEY,
                    $K + ($ZNMask -BAND ([FastNoiseLite]::PRIMEZ -SHL 1)),
                    $Xc, $Yc, $Zc
                )
                $SkipD = $true
            }
        }

        If(-NOT $Skip5) {
            [Single]$A5  = $YAFlipMask1 + $ZAFlipMask1 + $A1

            If($A5 -GT 0) {
                [Single]$X5 = $X1
                [Single]$Y5 = ($YNMask -BOR 1) + $Y1
                [Single]$Z5 = ($ZNMask -BOR 1) + $Z1

                $Value += $A5 * $A5 * $A5 * $A5 * [FastNoiseLite]::GradCoord(
                    $Seed2,
                    $I + [FastNoiseLite]::PRIMEX,
                    $J + ($YNMask -BAND ([FastNoiseLite]::PRIMEY -SHL 1)),
                    $K + ($ZNMask -BAND ([FastNoiseLite]::PRIMEZ -SHL 1)),
                    $X5, $Y5, $Z5
                )
            }
        }

        If(-NOT $Skip9) {
            [Single]$A9  = $XAFlipMask1 + $ZAFlipMask1 + $A1

            If($A9 -GT 0) {
                [Single]$X9 = ($XNMask -BOR 1) + $X1
                [Single]$Y9 = $Y1
                [Single]$Z9 = ($ZNMask -BOR 1) + $Z1

                $Value += $A9 * $A9 * $A9 * $A9 * [FastNoiseLite]::GradCoord(
                    $Seed2,
                    $I + ($XNMask -BAND [FastNoiseLite]::APRIMEXMULT2),
                    $J + [FastNoiseLite]::PRIMEY,
                    $K + ($ZNMask -BAND ([FastNoiseLite]::PRIMEZ -SHL 1)),
                    $X9, $Y9, $Z9
                )
            }
        }

        If(-NOT $SkipD) {
            [Single]$Ad  = $XAFlipMask1 + $YAFlipMask1 + $A1

            If($Ad -GT 0) {
                [Single]$Xd = ($XNMask -BOR 1) + $X1
                [Single]$Yd = ($YNMask -BOR 1) + $Y1
                [Single]$Zd = $Z1

                $Value += $Ad * $Ad * $Ad * $Ad * [FastNoiseLite]::GradCoord(
                    $Seed2,
                    $I + ($XNMask -BAND ([FastNoiseLite]::PRIMEX -SHL 1)),
                    $J + ($YNMask -BAND ([FastNoiseLite]::PRIMEY -SHL 1)),
                    $K + [FastNoiseLite]::PRIMEZ,
                    $Xd, $Yd, $Zd
                )
            }
        }

        Return $Value * 9.046026385208288
    }

    [Single]SingleCellular(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$Xr              = [FastNoiseLite]::FastRound($X)
        [Int64]$Yr              = [FastNoiseLite]::FastRound($Y)
        [Int64]$ClosestHash     = 0
        [Int64]$XPrimed         = ($Xr - 1) * [FastNoiseLite]::PRIMEX
        [Int64]$YPrimedBase     = ($Yr - 1) * [FastNoiseLite]::PRIMEY
        [Single]$Distance0      = [Single]::MaxValue
        [Single]$Distance1      = [Single]::MaxValue
        [Single]$CellularJitter = 0.43701595 * $this.CellularJitterModifier

        Switch($this.CellularDistanceFunction) {
            { $_ -EQ [FnlCellularDistanceFunction]::Euclidean -OR $_ -EQ [FnlCellularDistanceFunction]::EuclideanSq } {
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr + 1; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr - 1; $Yi++) {
                        [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
                        [Int64]$Idx          = $AHash -BAND (255 -SHL 1)
                        [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS2D[$Idx] * $CellularJitter)
                        [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS2D[$Idx -BOR 1] * $CellularJitter)
                        [Single]$NewDistance = $VecX * $VecX + $VecY * $VecY

                        $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance1, $NewDistance), $Distance0)
                        If($NewDistance -LT $Distance0) {
                            $Distance0   = $NewDistance
                            $ClosestHash = $AHash
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }

            ([FnlCellularDistanceFunction]::Manhattan) {
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr + 1; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr + 1; $Yi++) {
                        [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
                        [Int64]$Idx          = $AHash -BAND (255 -SHL 1)
                        [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS2D[$Idx] * $CellularJitter)
                        [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS2D[$Idx -BOR 1] * $CellularJitter)
                        [Single]$NewDistance = [FastNoiseLite]::FastAbs($VecX) + [FastNoiseLite]::FastAbs($VecY)

                        $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance1, $NewDistance), $Distance0)
                        If($NewDistance -LT $Distance0) {
                            $Distance0   = $NewDistance
                            $ClosestHash = $AHash
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }

            ([FnlCellularDistanceFunction]::Hybrid) {
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr + 1; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr + 1; $Yi++) {
                        [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
                        [Int64]$Idx          = $AHash -BAND (255 -SHL 1)
                        [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS2D[$Idx] * $CellularJitter)
                        [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS2D[$Idx -BOR 1] * $CellularJitter)
                        [Single]$NewDistance = ([FastNoiseLite]::FastAbs($VecX) + [FastNoiseLite]::FastAbs($VecY)) + ($VecX * $VecX + $VecY * $VecY)

                        $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance0))
                        If($NewDIstance -LT $Distance0) {
                            $Distance0   = $NewDistance
                            $ClosestHash = $AHash
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }

            Default { # SAME AS FIRST CASE
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr + 1; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr - 1; $Yi++) {
                        [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed)
                        [Int64]$Idx          = $AHash -BAND (255 -SHL 1)
                        [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS2D[$Idx] * $CellularJitter)
                        [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS2D[$Idx -BOR 1] * $CellularJitter)
                        [Single]$NewDistance = $VecX * $VecX + $VecY * $VecY

                        $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance1, $NewDistance), $Distance0)
                        If($NewDistance -LT $Distance0) {
                            $Distance0   = $NewDistance
                            $ClosestHash = $AHash
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }
        }

        If($this.CellularDistanceFunction -EQ [FnlCellularDistanceFunction]::Euclidean -AND $this.CellularReturnType -GE [FnlCellularReturnType]::Distance) {
            $Distance0 = [FastNoiseLite]::FastSqrt($Distance0)

            If($this.CellularReturnType -GE [FnlCellularReturnType]::Distance2) {
                $Distance1 = [FastNoiseLite]::FastSqrt($Distance1)
            }
        }

        Switch($this.CellularReturnType) {
            ([FnlCellularReturnType]::CellValue) {
                Return $ClosestHash * (1 / [FastNoiseLite]::HASHCALC_MAGIC)
            }

            ([FnlCellularReturnType]::Distance) {
                Return $Distance0 - 1
            }

            ([FnlCellularReturnType]::Distance2) {
                Return $Distance1 - 1
            }

            ([FnlCellularReturnType]::Distance2Add) {
                Return ($Distance1 + $Distance0) * 0.5 - 1
            }

            ([FnlCellularReturnType]::Distance2Sub) {
                Return $Distance1 - $Distance0 - 1
            }

            ([FnlCellularReturnType]::Distance2Mul) {
                Return $Distance1 * $Distance0 * 0.5 - 1
            }

            ([FnlCellularReturnType]::Distance2Div) {
                Return $Distance0 / $Distance1 - 1
            }

            Default {
                Return 0
            }
        }

        Return 0
    }

    [Single]SingleCellular(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$Xr              = [FastNoiseLite]::FastRound($X)
        [Int64]$Yr              = [FastNoiseLite]::FastRound($Y)
        [Int64]$Zr              = [FastNoiseLite]::FastRound($Z)
        [Int64]$ClosestHash     = 0
        [Single]$Distance0      = [Single]::MaxValue
        [Single]$Distance1      = [Single]::MaxValue
        [Single]$CellularJitter = 0.39614353 * $this.CellularJitterModifier
        [Int64]$XPrimed         = ($Xr - 1) * [FastNoiseLite]::PRIMEX
        [Int64]$YPrimedBase     = ($Yr - 1) * [FastNoiseLite]::PRIMEY
        [Int64]$ZPrimedBase     = ($Zr - 1) * [FastNoiseLite]::PRIMEZ

        Switch($this.CellularDistanceFunction) {
            { $_ -EQ [FnlCellularDistanceFunction]::Euclidean -OR $_ -EQ [FnlCellularDistanceFunction]::EuclideanSq } {
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr; $Yi++) {
                        [Int64]$ZPrimed = $ZPrimedBase

                        For([Int64]$Zi = $Zr - 1; $Zi -LE $Zr; $Zi++) {
                            [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed, $ZPrimed)
                            [Int64]$Idx          = $AHash -BAND (255 -SHL 2)
                            [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS3D[$Idx] * $CellularJitter)
                            [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS3D[$Idx -BOR 1] * $CellularJitter)
                            [Single]$VecZ        = ([Single]($Zi - $Z) + [FastNoiseLite]::RANDVECS3D[$Idx -BOR 2] * $CellularJitter)
                            [Single]$NewDistance = $VecX * $VecX + $VecY * $VecY + $VecZ * $VecZ

                            $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance1, $NewDistance), $Distance0)
                            If($NewDistance -LT $Distance0) {
                                $Distance0   = $NewDistance
                                $ClosestHash = $AHash
                            }

                            $ZPrimed += [FastNoiseLite]::PRIMEZ
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }

            ([FnlCellularDistanceFunction]::Manhattan) {
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr; $Yi++) {
                        [Int64]$ZPrimed = $ZPrimedBase

                        For([Int64]$Zi = $Zr - 1; $Zi -LE $Zr + 1; $Zi++) {
                            [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed, $ZPrimed)
                            [Int64]$Idx          = $AHash -BAND (255 -SHL 2)
                            [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS3D[$Idx] * $CellularJitter)
                            [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS3D[$Idx -BOR 1] * $CellularJitter)
                            [Single]$VecZ        = ([Single]($Zi - $Z) + [FastNoiseLite]::RANDVECS3D[$Idx -BOR 2] * $CellularJitter)
                            [Single]$NewDistance = [FastNoiseLite]::FastAbs($VecX) + [FastNoiseLite]::FastAbs($VecY) + [FastNoiseLite]::FastAbs($VecZ)

                            $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance1, $NewDistance), $Distance0)
                            If($NewDistance -LT $Distance0) {
                                $Distance0   = $NewDistance
                                $ClosestHash = $AHash
                            }

                            $ZPrimed += [FastNoiseLite]::PRIMEZ
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }

            ([FnlCellularDistanceFunction]::Hybrid) {
                For([Int64]$Xi = $Xr - 1; $Xi -LE $Xr + 1; $Xi++) {
                    [Int64]$YPrimed = $YPrimedBase

                    For([Int64]$Yi = $Yr - 1; $Yi -LE $Yr + 1; $Yi++) {
                        [Int64]$ZPrimed = $ZPrimedBase

                        For([Int64]$Zi = $Zr - 1; $Zi -LE $Zr + 1; $Zi++) {
                            [Int64]$AHash        = [FastNoiseLite]::Hash($ASeed, $XPrimed, $YPrimed, $ZPrimed)
                            [Int64]$Idx          = $AHash -BAND (255 -SHL 2)
                            [Single]$VecX        = ([Single]($Xi - $X) + [FastNoiseLite]::RANDVECS3D[$Idx] * $CellularJitter)
                            [Single]$VecY        = ([Single]($Yi - $Y) + [FastNoiseLite]::RANDVECS3D[$Idx -BOR 1] * $CellularJitter)
                            [Single]$VecZ        = ([Single]($Zi - $Z) + [FastNoiseLite]::RANDVECS3D[$Idx -BOR 2] * $CellularJitter)
                            [Single]$NewDistance = (
                                [FastNoiseLite]::FastAbs($VecX) +
                                [FastNoiseLite]::FastAbs($VecY) +
                                [FastNoiseLite]::FastAbs($VecZ)
                            ) + (
                                $VecX * $VecX +
                                $VecY * $VecY +
                                $VecZ * $VecZ
                            )

                            $Distance1 = [FastNoiseLite]::FastMax([FastNoiseLite]::FastMin($Distance1, $NewDistance), $Distance0)
                            If($NewDistance -LT $Distance0) {
                                $Distance0   = $NewDistance
                                $ClosestHash = $AHash
                            }

                            $Zprimed += [FastNoiseLite]::PRIMEZ
                        }

                        $YPrimed += [FastNoiseLite]::PRIMEY
                    }

                    $XPrimed += [FastNoiseLite]::PRIMEX
                }

                Break
            }

            Default {
                Break
            }
        }

        If($this.CellularDistanceFunction -EQ [FnlCellularDistanceFunction]::Euclidean -AND $this.CellularReturnType -GE [FnlCellularReturnType]::Distance) {
            $Distance0 = [FastNoiseLite]::FastSqrt($Distance0)

            If($this.CellularReturnType -GE [FnlCellularReturnType].Distance2) {
                $Distance1 = [FastNoiseLite]::FastSqrt($Distance1)
            }
        }

        Switch($this.CellularReturnType) {
            ([FnlCellularReturnType]::CellValue) {
                Return $ClosestHash * (1 / [FastNoiseLite]::HASHCALC_MAGIC)
            }

            ([FnlCellularReturnType]::Distance) {
                Return $Distance0 - 1
            }

            ([FnlCellularReturnType]::Distance2) {
                Return $Distance1 - 1
            }

            ([FnlCellularReturnType]::Distance2Add) {
                Return ($Distance1 + $Distance0) * 0.5 - 1
            }

            ([FnlCellularReturnType]::Distance2Sub) {
                Return $Distance1 - $Distance0 - 1
            }

            ([FnlCellularReturnType]::Distance2Mul) {
                Return $Distance1 * $Distance0 * 0.5 - 1
            }

            ([FnlCellularReturnType]::Distance2Div) {
                Return $Distance0 / $Distance1 - 1
            }

            Default {
                Return 0
            }
        }

        Return 0
    }

    [Single]SinglePerlin(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$X0   = [FastNoiseLite]::FastFloor($X)
        [Int64]$Y0   = [FastNoiseLite]::FastFloor($Y)
        [Single]$Xd0 = ([Single]($X - $X0))
        [Single]$Yd0 = ([Single]($Y - $Y0))
        [Single]$Xd1 = $Xd0 - 1
        [Single]$Yd1 = $Yd0 - 1
        [Single]$Xs  = [FastNoiseLite]::InterpQuintic($Xd0)
        [Single]$Ys  = [FastNoiseLite]::InterpQuintic($Yd0)

        $X0 *= [FastNoiseLite]::PRIMEX
        $Y0 *= [FastNoiseLite]::PRIMEY

        [Int64]$X1 = $X0 + [FastNoiseLite]::PRIMEX
        [Int64]$Y1 = $Y0 + [FastNoiseLite]::PRIMEY

        [Single]$Xf0 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::GradCoord($ASeed, $X0, $Y0, $Xd0, $Yd0),
            [FastNoiseLite]::GradCoord($ASeed, $X1, $Y0, $Xd1, $Yd0),
            $Xs
        )
        [Single]$Xf1 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::GradCoord($ASeed, $X0, $Y1, $Xd0, $Yd1),
            [FastNoiseLite]::GradCoord($ASeed, $X1, $Y1, $Xd1, $Yd1),
            $Xs
        )

        Return [FastNoiseLite]::Lerp($Xf0, $Xf1, $Ys) * 1.4247691104677813
    }

    [Single]SinglePerlin(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$X0   = [FastNoiseLite]::FastFloor($X)
        [Int64]$Y0   = [FastNoiseLite]::FastFloor($Y)
        [Int64]$Z0   = [FastNoiseLite]::FastFloor($Z)
        [Single]$Xd0 = ([Single]($X - $X0))
        [Single]$Yd0 = ([Single]($Y - $Y0))
        [Single]$Zd0 = ([Single]($Z - $Z0))
        [Single]$Xd1 = $Xd0 - 1
        [Single]$Yd1 = $Yd0 - 1
        [Single]$Zd1 = $Zd0 - 1
        [Single]$Xs  = [FastNoiseLite]::InterpQuintic($Xd0)
        [Single]$Ys  = [FastNoiseLite]::InterpQuintic($Yd0)
        [Single]$Zs  = [FastNoiseLite]::InterpQuintic($Zd0)

        $X0 *= [FastNoiseLite]::PRIMEX
        $Y0 *= [FastNoiseLite]::PRIMEY
        $Z0 *= [FastNoiseLite]::PRIMEZ

        [Int64]$X1 = $X0 + [FastNoiseLite]::PRIMEX
        [Int64]$Y1 = $Y0 + [FastNoiseLite]::PRIMEY
        [Int64]$Z1 = $Z0 + [FastNoiseLite]::PRIMEZ

        [Single]$Xf00 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X0, $Y0, $Z0,
                $Xd0, $Yd0, $Zd0
            ),
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X1, $Y0, $Z0,
                $Xd1, $Yd0, $Zd0
            ),
            $Xs
        )
        [Single]$Xf10 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X0, $Y1, $Z0,
                $Xd0, $Yd1, $Zd0
            ),
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X1, $Y1, $Z0,
                $Xd1, $Yd1, $Zd0
            ),
            $Xs
        )
        [Single]$Xf01 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X0, $Y0, $Z1,
                $Xd0, $Yd0, $Zd1
            ),
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X1, $Y0, $Z1,
                $Xd1, $Yd0, $Zd1
            ),
            $Xs
        )
        [Single]$Xf11 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X0, $Y1, $Z1,
                $Xd0, $Yd1, $Zd1
            ),
            [FastNoiseLite]::GradCoord(
                $ASeed,
                $X1, $Y1, $Z1,
                $Xd1, $Yd1, $Zd1
            ),
            $Xs
        )

        [Single]$Yf0 = [FastNoiseLite]::Lerp($Xf00, $Xf10, $Ys)
        [Single]$Yf1 = [FastNoiseLite]::Lerp($Xf01, $Xf11, $Ys)

        Return [FastNoiseLite]::Lerp($Yf0, $Yf1, $Zs) * 0.964921414852142333984375
    }

    [Single]SingleValueCubic(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$X1  = [FastNoiseLite]::FastFloor($X)
        [Int64]$Y1  = [FastNoiseLite]::FastFloor($Y)
        [Single]$Xs = ([Single]($X - $X1))
        [Single]$Ys = ([Single]($Y - $Y1))

        $X1 *= [FastNoiseLite]::PRIMEX
        $Y1 *= [FastNoiseLite]::PRIMEY

        [Int64]$X0 = $X1 - [FastNoiseLite]::PRIMEX
        [Int64]$Y0 = $Y1 - [FastNoiseLite]::PRIMEY
        [Int64]$X2 = $X1 + [FastNoiseLite]::PRIMEX
        [Int64]$Y2 = $Y1 + [FastNoiseLite]::PRIMEY
        
        # THE FOLLOWING TWO STATEMENTS ORIGINALLY USED UNCHECKED STATEMENTS IN THE ARITHMETIC.
        # POWERSHELL DOESN'T REALLY OFFER THIS, SO A FIXED CEILING COMPENSATING CONTROL IS
        # USED (WHICH WOULD LIKELY BE THE SAME RESULT IN C# GIVEN THE BEHAVIOR OF THE UNCHECKED OPERATION,
        # SAVE THE LACK OF A THROWN EXCEPTION).
        #
        # ANOTHER SANITY CHECK HERE IS TO USE INT64 RATHER THAN INT. INT MASKS TO INT32, AND AN OVERFLOW WILL THROW
        # AN EXCEPTION IN POWERSHELL (SYSTEM.OVERFLOWEXCEPTION).
        [Int64]$X3 = $X1 + (([FastNoiseLite]::APRIMEXMULT2 -GT [Int64]::MaxValue) ? [Int64]::MaxValue : [FastNoiseLite]::APRIMEXMULT2)
        [Int64]$Y3 = $Y1 + (([FastNoiseLite]::APRIMEYMULT2 -GT [Int64]::MaxValue) ? [Int64]::MaxValue : [FastNoiseLite]::APRIMEYMULT2)

        Return [FastNoiseLite]::CubicLerp(
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0),
                [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0),
                [FastNoiseLite]::ValCoord($ASeed, $X2, $Y0),
                [FastNoiseLite]::ValCoord($ASeed, $X3, $Y0),
                $Xs
            ),
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1),
                [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1),
                [FastNoiseLite]::ValCoord($ASeed, $X2, $Y1),
                [FastNoiseLite]::ValCoord($ASeed, $X3, $Y1),
                $Xs
            ),
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::ValCoord($ASeed, $X0, $Y2),
                [FastNoiseLite]::ValCoord($ASeed, $X1, $Y2),
                [FastNoiseLite]::ValCoord($ASeed, $X2, $Y2),
                [FastNoiseLite]::ValCoord($ASeed, $X3, $Y2),
                $Xs
            ),
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::ValCoord($ASeed, $X0, $Y3),
                [FastNoiseLite]::ValCoord($ASeed, $X1, $Y3),
                [FastNoiseLite]::ValCoord($ASeed, $X2, $Y3),
                [FastNoiseLite]::ValCoord($ASeed, $X3, $Y3),
                $Xs
            ),
            $Ys
        ) * (1 / (1.5 * 1.5))
    }

    [Single]SingleValueCubic(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$X1  = [FastNoiseLite]::FastFloor($X)
        [Int64]$Y1  = [FastNoiseLite]::FastFloor($Y)
        [Int64]$Z1  = [FastNoiseLite]::FastFloor($Z)
        [Single]$Xs = ([Single]($X - $X1))
        [Single]$Ys = ([Single]($Y - $Y1))
        [Single]$Zs = ([Single]($Z - $Z1))

        $X1 *= [FastNoiseLite]::PRIMEX
        $Y1 *= [FastNoiseLite]::PRIMEY
        $Z1 *= [FastNoiseLite]::PRIMEZ

        [Int64]$X0 = $X1 - [FastNoiseLite]::PRIMEX
        [Int64]$Y0 = $Y1 - [FastNoiseLite]::PRIMEY
        [Int64]$Z0 = $Z1 - [FastNoiseLite]::PRIMEZ
        [Int64]$X2 = $X1 + [FastNoiseLite]::PRIMEX
        [Int64]$Y2 = $Y1 + [FastNoiseLite]::PRIMEY
        [Int64]$Z2 = $Z1 + [FastNoiseLite]::PRIMEZ

        # THE FOLLOWING THREE STATEMENTS ORIGINALLY USED UNCHECKED STATEMENTS IN THE ARITHMETIC.
        # POWERSHELL DOESN'T REALLY OFFER THIS, SO A FIXED CEILING COMPENSATING CONTROL IS
        # USED (WHICH WOULD LIKELY BE THE SAME RESULT IN C# GIVEN THE BEHAVIOR OF THE UNCHECKED OPERATION,
        # SAVE THE LACK OF A THROWN EXCEPTION).
        #
        # ANOTHER SANITY CHECK HERE IS TO USE INT64 RATHER THAN INT. INT MASKS TO INT32, AND AN OVERFLOW WILL THROW
        # AN EXCEPTION IN POWERSHELL (SYSTEM.OVERFLOWEXCEPTION).
        [Int64]$X3 = $X1 + (([FastNoiseLite]::APRIMEXMULT2 -GT [Int64]::MaxValue) ? [Int64]::MaxValue : [FastNoiseLite]::APRIMEXMULT2)
        [Int64]$Y3 = $Y1 + (([FastNoiseLite]::APRIMEYMULT2 -GT [Int64]::MaxValue) ? [Int64]::MaxValue : [FastNoiseLite]::APRIMEYMULT2)
        [Int64]$Z3 = $Z1 + (([FastNoiseLite]::APRIMEZMULT2 -GT [Int64]::MaxValue) ? [Int64]::MaxValue : [FastNoiseLite]::APRIMEZMULT2)

        Return [FastNoiseLite]::CubicLerp(
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y0, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y0, $Z0),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y1, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y1, $Z0),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y2, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y2, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y2, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y2, $Z0),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y3, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y3, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y3, $Z0),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y3, $Z0),
                    $Xs
                ),
                $Ys
            ),
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y0, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y0, $Z1),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y1, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y1, $Z1),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y2, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y2, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y2, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y2, $Z1),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y3, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y3, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y3, $Z1),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y3, $Z1),
                    $Xs
                ),
                $Ys
            ),
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y0, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y0, $Z2),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y1, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y1, $Z2),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y2, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y2, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y2, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y2, $Z2),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y3, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y3, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y3, $Z2),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y3, $Z2),
                    $Xs
                ),
                $Ys
            ),
            [FastNoiseLite]::CubicLerp(
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y0, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y0, $Z3),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y1, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y1, $Z3),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y2, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y2, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y2, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y2, $Z3),
                    $Xs
                ),
                [FastNoiseLite]::CubicLerp(
                    [FastNoiseLite]::ValCoord($ASeed, $X0, $Y3, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X1, $Y3, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X2, $Y3, $Z3),
                    [FastNoiseLite]::ValCoord($ASeed, $X3, $Y3, $Z3),
                    $Xs
                ),
                $Ys
            ),
            $Zs
        ) * (1 / (1.5 * 1.5 * 1.5))
    }

    [Single]SingleValue(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y
    ) {
        [Int64]$X0  = [FastNoiseLite]::FastFloor($X)
        [Int64]$Y0  = [FastNoiseLite]::FastFloor($Y)
        [Single]$Xs = [FastNoiseLite]::InterpHermite(([Single]($X - $X0)))
        [Single]$Ys = [FastNoiseLite]::InterpHermite(([Single]($Y - $Y0)))

        $X0 *= [FastNoiseLite]::PRIMEX
        $Y0 *= [FastNoiseLite]::PRIMEY

        [Int64]$X1 = $X0 + [FastNoiseLite]::PRIMEX
        [Int64]$Y1 = $Y0 + [FastNoiseLite]::PRIMEY

        [Single]$Xf0 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0),
            [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0),
            $Xs
        )
        [Single]$Xf1 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1),
            [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1),
            $Xs
        )

        Return [FastNoiseLite]::Lerp($Xf0, $Xf1, $Ys)
    }

    [Single]SingleValue(
        [Int64]$ASeed,
        [Single]$X,
        [Single]$Y,
        [Single]$Z
    ) {
        [Int64]$X0  = [FastNoiseLite]::FastFloor($X)
        [Int64]$Y0  = [FastNoiseLite]::FastFloor($Y)
        [Int64]$Z0  = [FastNoiseLite]::FastFloor($Z)
        [Single]$Xs = [FastNoiseLite]::InterpHermite(([Single]($X - $X0)))
        [Single]$Ys = [FastNoiseLite]::InterpHermite(([Single]($Y - $Y0)))
        [Single]$Zs = [FastNoiseLite]::InterpHermite(([Single]($Z - $Z0)))

        $X0 *= [FastNoiseLite]::PRIMEX
        $Y0 *= [FastNoiseLite]::PRIMEY
        $Z0 *= [FastNoiseLite]::PRIMEZ

        [Int64]$X1 = $X0 + [FastNoiseLite]::PRIMEX
        [Int64]$Y1 = $Y0 + [FastNoiseLite]::PRIMEY
        [Int64]$Z1 = $Z0 + [FastNoiseLite]::PRIMEZ

        [Single]$Xf00 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0, $Z0),
            [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0, $Z0),
            $Xs
        )
        [Single]$Xf10 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1, $Z0),
            [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1, $Z0),
            $Xs
        )
        [Single]$Xf01 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::ValCoord($ASeed, $X0, $Y0, $Z1),
            [FastNoiseLite]::ValCoord($ASeed, $X1, $Y0, $Z1),
            $Xs
        )
        [Single]$Xf11 = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::ValCoord($ASeed, $X0, $Y1, $Z1),
            [FastNoiseLite]::ValCoord($ASeed, $X1, $Y1, $Z1),
            $Xs
        )

        [Single]$Yf0 = [FastNoiseLite]::Lerp($Xf00, $Xf10, $Ys)
        [Single]$Yf1 = [FastNoiseLite]::Lerp($Xf01, $Xf11, $Ys)

        Return [FastNoiseLite]::Lerp($Yf0, $Yf1, $Zs)
    }

    [Void]DoSingleDomainWarp(
        [Int64]$ASeed,
        [Single]$Amp,
        [Single]$Freq,
        [Single]$X,
        [Single]$Y,
        [Ref]$Xr,
        [Ref]$Yr

    ) {
        Switch($this.DomainWarpType) {
            ([FnlDomainWarpType]::OpenSimplex2) {
                $this.SingleDomainWarpOpenSimplex2Gradient($ASeed, $Amp * [FastNoiseLite]::SIMPLEXVALMODA_MAGIC, $Freq, $X, $Y, $Xr, $Yr, $false)

                Break
            }

            ([FnlDomainWarpType]::OpenSimplex2Reduced) {
                $this.SingleDomainWarpSimplexGradient($ASeed, $Amp * 16.0, $Freq, $X, $Y, $Xr, $Yr, $true)

                Break
            }

            ([FnlDomainWarpType]::BasicGrid) {
                $this.SingleDomainWarpBasicGrid($ASeed, $Amp, $Freq, $X, $Y, $Xr, $Yr)

                Break
            }

            Default {
                Break
            }
        }
    }

    [Void]DoSingleDomainWarp(
        [Int64]$ASeed,
        [Single]$Amp,
        [Single]$Freq,
        [Single]$X,
        [Single]$Y,
        [Single]$Z,
        [Ref]$Xr,
        [Ref]$Yr,
        [Ref]$Zr
    ) {
        Switch($this.DomainWarpType) {
            ([FnlDomainWarpType]::OpenSimplex2) {
                $this.SingleDomainWarpOpenSimplex2Gradient($ASeed, $Amp * [FastNoiseLite]::SIMPLEXVALMODA_MAGIC, $Freq, $X, $Y, $Z, $Xr, $Yr, $Zr, $false)

                Break
            }

            ([FnlDomainWarpType]::OpenSimplex2Reduced) {
                $this.SingleDomainWarpOpenSimplex2Gradient($ASeed, $Amp * 7.71604938271605, $Freq, $X, $Y, $Z, $Xr, $Yr, $Zr, $true)

                Break
            }

            ([FnlDomainWarpType]::BasicGrid) {
                $this.SingleDomainWarpBasicGrid($ASeed, $Amp, $Freq, $X, $Y, $Z, $Xr, $Yr, $Zr)

                Break
            }

            Default {
                Break
            }
        }
    }

    [Void]DomainWarpSingle(
        [Ref]$X,
        [Ref]$Y
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Amp  = $this.DomainWarpAmp * $this.FractalBounding
        [Single]$Freq = $this.Frequency
        [Single]$Xs   = $X.Value
        [Single]$Ys   = $Y.Value

        $this.TransformDomainWarpCoordinate(([Ref]$Xs), ([Ref]$Ys))
        $this.DoSingleDomainWarp($ASeed, $Amp, $Freq, $Xs, $Ys, $X, $Y)
    }

    [Void]DomainWarpSingle(
        [Ref]$X,
        [Ref]$Y,
        [Ref]$Z
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Amp  = $this.DomainWarpAmp * $this.FractalBounding
        [Single]$Freq = $this.Frequency
        [Single]$Xs   = $X.Value
        [Single]$Ys   = $Y.Value
        [Single]$Zs   = $Z.Value

        $this.TransformDomainWarpCoordinate(([Ref]$Xs), ([Ref]$Ys), ([Ref]$Zs))
        $this.DoSingleDomainWarp($ASeed, $Amp, $Freq, $Xs, $Ys, $Zs, $X, $Y, $Z)
    }

    [Void]DomainWarpFractalProgressive(
        [Ref]$X,
        [Ref]$Y
    ) {
        [Int64]$Aseed = $this.Seed
        [Single]$Amp  = $this.DomainWarpAmp * $this.FractalBounding
        [Single]$Freq = $this.Frequency

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Xs = $X.Value
            [Single]$Ys = $Y.Value

            $this.TransformDomainWarpCoordinate(([Ref]$Xs), ([Ref]$Ys))
            $this.DoSingleDomainWarp($ASeed, $Amp, $Freq, $Xs, $Ys, $X, $Y)

            $ASeed++
            $Amp  *= $this.Gain
            $Freq *= $this.Lacunarity
        }
    }

    [Void]DomainWarpFractalProgressive(
        [Ref]$X,
        [Ref]$Y,
        [Ref]$Z
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Amp  = $this.DomainWarpAmp * $this.FractalBounding
        [Single]$Freq = $this.Frequency

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            [Single]$Xs = $X.Value
            [Single]$Ys = $Y.Value
            [Single]$Zs = $Z.Value

            $this.TransformDomainWarpCoordinate(([Ref]$Xs), ([Ref]$Ys), ([Ref]$Zs))
            $this.DoSingleDomainWarp($ASeed, $Amp, $Freq, $Xs, $Ys, $Zs, $X, $Y, $Z)

            $ASeed++
            $Amp  *= $this.Gain
            $Freq *= $this.Lacunarity
        }
    }

    [Void]DomainWarpFractalIndependent(
        [Ref]$X,
        [Ref]$Y
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Xs   = $X.Value
        [Single]$Ys   = $Y.Value
        [Single]$Amp  = $this.DomainWarpAmp * $this.FractalBounding
        [Single]$Freq = $this.Frequency

        $this.TransformDomainWarpCoordinate(([Ref]$Xs), ([Ref]$Ys))

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            $this.DoSingleDomainWarp($ASeed, $Amp, $Freq, $Xs, $Ys, $X, $Y)

            $ASeed++
            $Amp  *= $this.Gain
            $Freq *= $this.Lacunarity
        }
    }

    [Void]DomainWarpFractalIndependent(
        [Ref]$X,
        [Ref]$Y,
        [Ref]$Z
    ) {
        [Int64]$ASeed = $this.Seed
        [Single]$Xs   = $X.Value
        [Single]$Ys   = $Y.Value
        [Single]$Zs   = $Z.Value
        [Single]$Amp  = $this.DomainWarpAmp * $this.FractalBounding
        [Single]$Freq = $this.Frequency

        $this.TransformDomainWarpCoordinate(([Ref]$Xs), ([Ref]$Ys), ([Ref]$Zs))

        For([Int64]$I = 0; $I -LT $this.Octaves; $I++) {
            $this.DoSingleDomainWarp($ASeed, $Amp, $Freq, $Xs, $Ys, $Zs, $X, $Y, $Z)

            $ASeed++
            $Amp  *= $this.Gain
            $Freq *= $this.Lacunarity
        }
    }

    [Void]SingleDomainWarpBasicGrid(
        [Int64]$ASeed,
        [Single]$WarpAmp,
        [Single]$AFrequency,
        [Single]$X,
        [Single]$Y,
        [Ref]$Xr,
        [Ref]$Yr
    ) {
        [Single]$Xf = $X * $AFrequency
        [Single]$Yf = $Y * $AFrequency
        [Int64]$X0  = [FastNoiseLite]::FastFloor($Xf)
        [Int64]$Y0  = [FastNoiseLite]::FastFloor($Yf)
        [Single]$Xs = [FastNoiseLite]::InterpHermite(([Single]($Xf - $X0)))
        [Single]$Ys = [FastNoiseLite]::InterpHermite(([Single]($Yf - $Y0)))

        $X0 *= [FastNoiseLite]::PRIMEX
        $Y0 *= [FastNoiseLite]::PRIMEY

        [Int64]$X1    = $X0 + [FastNoiseLite]::PRIMEX
        [Int64]$Y1    = $Y0 + [FastNoiseLite]::PRIMEY
        [Int64]$Hash0 = [FastNoiseLite]::Hash($ASeed, $X0, $Y0) -BAND (255 -SHL 1)
        [Int64]$Hash1 = [FastNoiseLite]::Hash($ASeed, $X1, $Y1) -BAND (255 -SHL 1)

        [Single]$Lx0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS2D[$Hash0],
            [FastNoiseLite]::RANDVECS2D[$Hash1],
            $Xs
        )
        [Single]$Ly0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS2D[$Hash0 -BOR 1],
            [FastNoiseLite]::RANDVECS2D[$Hash1 -BOR 1],
            $Xs
        )

        $Hash0 = [FastNoiseLite]::Hash($ASeed, $X0, $Y1) -BAND (255 -SHL 1)
        $Hash1 = [FastNoiseLite]::Hash($Aseed, $X1, $Y1) -BAND (255 -SHL 1)

        [Single]$Lx1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS2D[$Hash0],
            [FastNoiseLite]::RANDVECS2D[$Hash1],
            $Xs
        )
        [Single]$Ly1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS2D[$Hash0 -BOR 1],
            [FastNoiseLite]::RANDVECS2D[$Hash1 -BOR 1],
            $Xs
        )

        $Xr.Value += [FastNoiseLite]::Lerp($Lx0x, $Lx1x, $Ys) * $WarpAmp
        $Yr.Value += [FastNoiseLite]::Lerp($Ly0x, $Ly1x, $Ys) * $WarpAmp
    }

    [Void]SingleDomainWarpBasicGrid(
        [Int64]$ASeed,
        [Single]$WarpAmp,
        [Single]$AFrequency,
        [Single]$X,
        [Single]$Y,
        [Single]$Z,
        [Ref]$Xr,
        [Ref]$Yr,
        [Ref]$Zr
    ) {
        [Single]$Xf = $X * $AFrequency
        [Single]$Yf = $Y * $AFrequency
        [Single]$Zf = $Z * $AFrequency
        [Int64]$X0  = [FastNoiseLite]::FastFloor($Xf)
        [Int64]$Y0  = [FastNoiseLite]::FastFloor($Yf)
        [Int64]$Z0  = [FastNoiseLite]::FastFloor($Zf)
        [Single]$Xs = [FastNoiseLite]::InterpHermite(([Single]($Xf - $X0)))
        [Single]$Ys = [FastNoiseLite]::InterpHermite(([Single]($Yf - $Y0)))
        [Single]$Zs = [FastNoiseLite]::InterpHermite(([Single]($Zf - $Z0)))

        $X0 *= [FastNoiseLite]::PRIMEX
        $Y0 *= [FastNoiseLite]::PRIMEY
        $Z0 *= [FastNoiseLite]::PRIMEZ

        [Int64]$X1    = $X0 + [FastNoiseLite]::PRIMEX
        [Int64]$Y1    = $Y0 + [FastNoiseLite]::PRIMEY
        [Int64]$Z1    = $Z0 + [FastNoiseLite]::PRIMEZ
        [Int64]$Hash0 = [FastNoiseLite]::Hash($ASeed, $X0, $Y0, $Z0) -BAND (255 -SHL 2)
        [Int64]$Hash1 = [FastNoiseLite]::Hash($ASeed, $X1, $Y0, $Z0) -BAND (255 -SHL 2)

        [Single]$Lx0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0],
            [FastNoiseLite]::RANDVECS3D[$Hash1],
            $Xs
        )
        [Single]$Ly0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 1],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 1],
            $Xs
        )
        [Single]$Lz0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 2],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 2],
            $Xs
        )

        $Hash0 = [FastNoiseLite]::Hash($ASeed, $X0, $Y1, $Z0) -BAND (255 -SHL 2)
        $Hash1 = [FastNoiseLite]::Hash($Aseed, $X1, $Y1, $Z0) -BAND (255 -SHL 2)

        [Single]$Lx1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0],
            [FastNoiseLite]::RANDVECS3D[$Hash1],
            $Xs
        )
        [Single]$Ly1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 1],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 1],
            $Xs
        )
        [Single]$Lz1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 2],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 2],
            $Xs
        )

        [Single]$Lx0y = [FastNoiseLite]::Lerp($Lx0x, $Lx1x, $Ys)
        [Single]$Ly0y = [FastNoiseLite]::Lerp($Ly0x, $Ly1x, $Ys)
        [Single]$Lz0y = [FastNoiseLite]::Lerp($Lz0x, $Lz1x, $Ys)

        $Hash0 = [FastNoiseLite]::Hash($ASeed, $X0, $Y0, $Z1) -BAND (255 -SHL 2)
        $Hash1 = [FastNoiseLite]::Hash($ASeed, $X1, $Y0, $Z1) -BAND (255 -SHL 2)

        $Lx0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0],
            [FastNoiseLite]::RANDVECS3D[$Hash1],
            $Xs
        )
        $Ly0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 1],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 1],
            $Xs
        )
        $Lz0x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 2],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 2],
            $Xs
        )

        $Hash0 = [FastNoiseLite]::Hash($ASeed, $X0, $Y1, $Z1) -BAND (255 -SHL 2)
        $Hash1 = [FastNoiseLite]::Hash($ASeed, $X1, $Y1, $Z1) -BAND (255 -SHL 2)

        $Lx1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0],
            [FastNoiseLite]::RANDVECS3D[$Hash1],
            $Xs
        )
        $Ly1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 1],
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 1],
            $Xs
        )
        $Lz1x = [FastNoiseLite]::Lerp(
            [FastNoiseLite]::RANDVECS3D[$Hash0 -BOR 2],
            [FastNoiseLite]::RANDVECS3D[$Hash1 -BOR 2],
            $Xs
        )

        $Xr.Value += [FastNoiseLite]::Lerp(
            $Lx0y,
            [FastNoiseLite]::Lerp(
                $Lx0x,
                $Lx1x,
                $Ys
            ),
            $Zs
        ) * $WarpAmp
        $Yr.Value += [FastNoiseLite]::Lerp(
            $Ly0y,
            [FastNoiseLite]::Lerp(
                $Ly0x,
                $Ly1x,
                $Ys
            ),
            $Zs
        ) * $WarpAmp
        $Zr.Value += [FastNoiseLite]::Lerp(
            $Lz0y,
            [FastNoiseLite]::Lerp(
                $Ly0x,
                $Lz1x,
                $Ys
            ),
            $Zs
        ) * $WarpAmp
    }

    [Void]SingleDomainWarpSimplexGradient(
        [Int64]$ASeed,
        [Single]$WarpAmp,
        [Single]$AFrequency,
        [Single]$X,
        [Single]$Y,
        [Ref]$Xr,
        [Ref]$Yr,
        [Boolean]$OutGradOnly
    ) {
        [Single]$G2   = (3 - [FastNoiseLite]::SQRT3) / 6
        [Single]$G2m1 = $G2 - 1
        [Single]$G2a1 = 1 - 2 * $G2

        $X *= $AFrequency
        $Y *= $AFrequency

        [Int64]$I   = [FastNoiseLite]::FastFloor($X)
        [Int64]$J   = [FastNoiseLite]::FastFloor($Y)
        [Single]$Xi = ([Single]($X - $I))
        [Single]$Yi = ([Single]($Y - $J))
        [Single]$T  = ($Xi + $Yi) * $G2
        [Single]$X0 = $Xi - $T
        [Single]$Y0 = $Yi - $T

        $I *= [FastNoiseLite]::PRIMEX
        $J *= [FastNoiseLite]::PRIMEY

        [Single]$Vx = 0
        [Single]$Vy = 0
        [Single]$A  = 0.5 - $X0 * $X0 - $Y0 * $Y0
        [Single]$A2 = $A * $A

        If($A -GT 0) {
            [Single]$Aaaa = $A2 * $A2
            [Single]$Xo   = 0
            [Single]$Yo   = 0

            If($OutGradOnly -EQ $true) {
                [FastNoiseLite]::GradCoordOut($ASeed, $I, $J, ([Ref]$Xo), ([Ref]$Yo))
            } Else {
                [FastNoiseLite]::GradCoordDual($ASeed, $I, $J, $X0, $Y0, ([Ref]$Xo), ([Ref]$Yo))
            }
            $Vx += $Aaaa * $Xo
            $Vy += $Aaaa * $Yo
        }

        [Single]$C = ([Single](
            2 * $G2a1 * (1 / $G2 - 2)) * $T +
            ([Single](-2 * $G2a1 * $G2a1) + $A)
        )
        [Single]$C2 = $C * $C

        If($C -GT 0) {
            [Single]$X2   = $X0 + (2 * $G2m1)
            [Single]$Y2   = $Y0 + (2 * $G2m1)
            [Single]$Cccc = $C2 * $C2
            [Single]$Xo   = 0
            [Single]$Yo   = 0

            If($OutGradOnly -EQ $true) {
                [FastNoiseLite]::GradCoordOut($ASeed, $I + [FastNoiseLite]::PRIMEX, $J + [FastNoiseLite]::PRIMEY, ([Ref]$Xo), ([Ref]$Yo))
            } Else {
                [FastNoiseLite]::GradCoordDual($ASeed, $I + [FastNoiseLite]::PRIMEX, $J + [FastNoiseLite]::PRIMEY, $X2, $Y2, ([Ref]$Xo), ([Ref]$Yo))
            }

            $Vx += $Cccc * $Xo
            $Vy += $Cccc * $Yo
        }

        If($Y0 -GT $X0) {
            [Single]$X1 = $X0 + $G2
            [Single]$Y1 = $Y0 + $G2m1
            [Single]$B  = 0.5 - $X1 * $X1 - $Y1 * $Y1
            [Single]$B2 = $B * $B

            If($B -GT 0) {
                [Single]$Bbbb = $B2 * $B2
                [Single]$Xo   = 0
                [Single]$Yo   = 0

                If($OutGradOnly -EQ $true) {
                    [FastNoiseLite]::GradCoordOut($ASeed, $I, $J + [FastNoiseLite]::PRIMEY, ([Ref]$Xo), ([Ref]$Yo))
                } Else {
                    [FastNoiseLite]::GradCoordDual($ASeed, $I, $J + [FastNoiseLite]::PRIMEY, $X1, $Y1, ([Ref]$Xo), ([Ref]$Yo))
                }

                $Vx += $Bbbb * $Xo
                $Vy += $Bbbb * $Yo
            }
        } Else {
            [Single]$X1 = $X0 + $G2m1
            [Single]$Y1 = $Y0 + $G2
            [Single]$B  = 0.5 - $X1 * $X1 - $Y1 * $Y1
            [Single]$B2 = $B * $B

            If($B -GT 0) {
                [Single]$Bbbb = $B2 * $B2
                [Single]$Xo   = 0
                [Single]$Yo   = 0

                If($OutGradOnly -EQ $true) {
                    [FastNoiseLite]::GradCoordOut($ASeed, $I + [FastNoiseLite]::PRIMEX, $J, ([Ref]$Xo), ([Ref]$Yo))
                } Else {
                    [FastNoiseLite]::GradCoordDual($ASeed, $I + [FastNoiseLite]::PRIMEX, $J, $X1, $Y1, ([Ref]$Xo), ([Ref]$Yo))
                }

                $Vx += $Bbbb * $Xo
                $Vy += $Bbbb * $Yo
            }
        }

        $Xr.Value += $Vx * $WarpAmp
        $Yr.Value += $Vy * $WarpAmp
    }

    [Void]SingleDomainWarpOpenSimplex2Gradient(
        [Int64]$ASeed,
        [Single]$WarpAmp,
        [Single]$AFrequency,
        [Single]$X,
        [Single]$Y,
        [Single]$Z,
        [Ref]$Xr,
        [Ref]$Yr,
        [Ref]$Zr,
        [Boolean]$OutGradOnly
    ) {
        $X *= $AFrequency
        $Y *= $AFrequency
        $Z *= $AFrequency

        [Int64]$I      = [FastNoiseLite]::FastRound($X)
        [Int64]$J      = [FastNoiseLite]::FastRound($Y)
        [Int64]$K      = [FastNoiseLite]::FastRound($Z)
        [Single]$X0    = ([Single]($X - $I))
        [Single]$Y0    = ([Single]($Y - $J))
        [Single]$Z0    = ([Single]($Z - $K))
        [Int64]$XNSign = ([Int64](-$X0 - 1) -BOR 1)
        [Int64]$YNSign = ([Int64](-$Y0 - 1) -BOR 1)
        [Int64]$ZNSign = ([Int64](-$Z0 - 1) -BOR 1)
        [Single]$Ax0   = $XNSign * -$X0
        [Single]$Ay0   = $YNSign * -$Y0
        [Single]$Az0   = $ZNSign * -$Z0

        $I *= [FastNoiseLite]::PRIMEX
        $J *= [FastNoiseLite]::PRIMEY
        $K *= [FastNoiseLite]::PRIMEZ

        [Single]$Vx = 0
        [Single]$Vy = 0
        [Single]$Vz = 0
        [Single]$A  = (0.6 - $X0 * $X0)- ($Y0 * $Y0 + $Z0 * $Z0)
        [Single]$A2 = $A * $A

        For([Int64]$L = 0; ; $L++) {
            If($A -GT 0) {
                [Single]$Aaaa = $A2 * $A2
                [Single]$Xo   = 0
                [Single]$Yo   = 0
                [Single]$Zo   = 0

                If($OutGradOnly -EQ $true) {
                    [FastNoiseLite]::GradCoordOut($ASeed, $I, $J, $K, ([Ref]$Xo), ([Ref]$Yo), ([Ref]$Zo))
                } Else {
                    [FastNoiseLite]::GradCoordDual($ASeed, $I, $J, $K, $X0, $Y0, $Z0, ([Ref]$Xo), ([Ref]$Yo), ([Ref]$Zo))
                }

                $Vx += $Aaaa * $Xo
                $Vy += $Aaaa * $Yo
                $Vz += $Aaaa * $Zo
            }

            [Int64]$I1  = $I
            [Int64]$J1  = $J
            [Int64]$K1  = $K
            [Single]$B  = $A
            [Single]$B2 = $B * $B
            [Single]$X1 = $X0
            [Single]$Y1 = $Y0
            [Single]$Z1 = $Z0

            If($Ax0 -GE $Ay0 -AND $Ax0 -GE $Az0) {
                $X1 += $XNSign
                $B  += $Ax0 + $Ax0
                $I1 -= $XNSign + [FastNoiseLite]::PRIMEX
            } Elseif($Ay0 -GT $Ax0 -AND $Ay0 -GE $Az0) {
                $Y1 += $YNSign
                $B  += $Ay0 + $Ay0
                $J1 -= $YNSign * [FastNoiseLite]::PRIMEY
            } Else {
                $Z1 += $ZNSign
                $B  += $Az0 + $Az0
                $K1 -= $ZNSign * [FastNoiseLite]::PRIMEZ
            }

            If($B -GT 1) {
                $B -= 1

                [Single]$Bbbb = $B2 * $B2
                [Single]$Xo   = 0
                [Single]$Yo   = 0
                [Single]$Zo   = 0

                If($OutGradOnly -EQ $true) {
                    [FastNoiseLite]::GradCoordOut($ASeed, $I, $J, $K, ([Ref]$Xo), ([Ref]$Yo), ([Ref]$Zo))
                } Else {
                    [FastNoiseLite]::GradCoordDual($ASeed, $I1, $J1, $K1, $X1, $Y1, $Z1, ([Ref]$Xo), ([Ref]$Yo), ([Ref]$Zo))
                }

                $Vx += $Bbbb * $Xo
                $Vy += $Bbbb * $Yo
                $Vz += $Bbbb * $Zo
            }

            If($L -EQ 1) {
                Break
            }

            $Ax0     = 0.5 - $Ax0
            $Ay0     = 0.5 - $Ay0
            $Az0     = 0.5 - $Az0
            $X0      = $XNSign * $Ax0
            $Y0      = $YNSign * $Ay0
            $Z0      = $ZNSign * $Az0
            $A      += (0.75 - $Ax0) - ($Ay0 + $Az0)
            $I      += ($XNSign -SHR 1) -BAND [FastNoiseLite]::PRIMEX
            $J      += ($YNSign -SHR 1) -BAND [FastNoiseLite]::PRIMEY
            $K      += ($ZNSign -SHR 1) -BAND [FastNoiseLite]::PRIMEZ
            $XNSign  = -$XNSign
            $YNSign  = -$YNSign
            $ZNSign  = -$ZNSign
            $ASeed  += [FastNoiseLite]::SEEDADD_MAGIC
        }

        $Xr.Value += $Vx * $WarpAmp
        $Yr.Value += $Vy * $WarpAmp
        $Zr.Value += $Vz * $WarpAmp
    }
}






###############################################################################
#
# MAP TILE OBJECT ABSTRACTIONS
#
# THESE ABSTRACTIONS SERVE TO BUILD UP ACTUAL ITEMS THAT THE PLAYER CAN 
# INTERACT WITH. THESE CONSTRUCTS CAN BE A LITTLE CUMBERSOME TO SETUP.
#
###############################################################################
Class MTOTree : MapTileObject {
    [Boolean]$HasRopeTied

    MTOTree() {
        $this.Name              = 'Tree'
        $this.MapObjName        = 'tree'
        $this.CanAddToInventory = $false
        $this.ExamineString     = 'It''s a tree. Looks like all the other ones.'
        $this.Effect = {
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
                    $Script:TheMessageWindow.WriteTiedRopeToTreeMessage()

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
        }
        $this.TargetOfFilter = @(
            'MTORope'
        )
        $this.HasRopeTied = $false
    }
}

Class MTOLadder : MapTileObject {
    MTOLadder() {
        $this.Name              = 'Ladder'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $false
        $this.ExamineString     = 'Used to climb things. Just don''t walk under one.'
    }
}

Class MTORope : MapTileObject {
    MTORope() {
        $this.Name              = 'Rope'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'It''s not a snake. Hopefully.'
    }
}

Class MTOStairs : MapTileObject {
    MTOStairs() {
        $this.Name              = 'Stairs'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'A faithful ally for elevating one''s position.'
    }
}

Class MTOPole : MapTileObject {
    MTOPole() {
        $this.Name              = 'Pole'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $false
        $this.ExamineString     = 'Not the north or the south one.'
    }
}

Class MTOBacon : MapTileObject {
    MTOBacon() {
        $this.Name              = 'Bacon'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'Shredded swine flesh. Cholesterol never tasted so good.'
        $this.KeyItem           = $true
    }
}

Class MTOApple : MapTileObject {
    MTOApple() {
        $this.Name              = 'Apple'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'A big, juicy, red apple. Worm not included.'
    }
}

Class MTOStick : MapTileObject {
    MTOStick() {
        $this.Name              = 'Stick'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'Be careful not to poke your eye out with it.'
    }
}

Class MTOYogurt : MapTileObject {
    MTOYogurt() {
        $this.Name              = 'Yogurt'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'For some reason, people enjoy this spoiled milk.'
    }
}

Class MTORock : MapTileObject {
    MTORock() {
        $this.Name              = 'Rock'
        $this.MapObjName        = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString     = 'A garden variety rock. Good for taunting raccoons with.'
    }
}

Class MTOMilk : MapTileObject {
    [Int]$PlayerHpBonus
    [Boolean]$IsSpoiled

    MTOMilk() {
        $this.Name = 'Milk'
        $this.MapObjName = $this.Name.ToLower()
        $this.CanAddToInventory = $true
        $this.ExamineString = '2%. We don''t take kindly to whole milk ''round here.'
        $this.Effect = {
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
                            $Script:TheMessageWindow.WriteMilkUseSpoiledMessage()
                            $Source.RemoveInventoryItemByName($Self.Name)
                        } Else {
                            $Script:TheMessageWindow.WriteMilkUseNotNowMessage()
                        }
                    } Else {
                        # The milk isn't spoiled - attempt to increment the Player's Hp by the Hp Bonus
                        # Attempt to increment the Player's HP by the Hp Bonus
                        If($Script:ThePlayer.IncrementHitPoints($Self.PlayerHpBonus) -EQ $true) {
                            $Script:TheMessageWindow.WriteMilkUseOkayMessage()
                            $Script:ThePlayer.RemoveInventoryItemByName($Self.Name)
                        } Else {
                            $Script:TheMessageWindow.WriteMilkUseNotNowMessage()
                        }
                    }
                }
            }
        }

        # THIS LOOKS STRANGE, BUT NOW WE'RE STILL IN THE CTOR AND THIS SETS, RANDOMLY, SOME STUFF ABOUT THE MLIK
        $a                  = $(Get-Random -Minimum 0 -Maximum 10)
        $this.PlayerHpBonus = 75
        $this.IsSpoiled     = $($a -GE 6 ? $true : $false)
        
        If($this.IsSpoiled -EQ $true) {
            $this.ExamineString      = 'This looks funny. Should I really be drinking this?'
            $this.PlayerEffectString = "-$($this.PlayerHpBonus) HP, 10% chance to inflict Poison"
        } Else {
            $this.PlayerEffectString = "+$($this.PlayerHpBonus) HP"
        }
    }
}

Class MTOWarpable : MapTileObject {
    [Ref]$WarpToReference
    [Int]$WarpToX
    [Int]$WarpToY

    MTOWarpable() {
        $this.WarpToReference = $null
        $this.WarpToX         = 0
        $this.WarpToY         = 0
        $this.Effect          = $Script:MapWarpHandler
    }
}

Class MTODoor : MTOWarpable {
    MTODoor() {
        $this.Name       = 'Door'
        $this.MapObjName = 'door'
    }
}

Class MTODoor00001 : MTODoor {
    MTODoor00001() {
        $this.WarpToReference = ([Ref]$Script:SampleWarpMap02)
    }
}

Class MTODoor00002 : MTODoor {
    MTODoor00002() {
        $this.WarpToReference = ([Ref]$Script:SampleWarpMap01)
        $this.WarpToX         = 3
    }
}





###############################################################################
#
# BUFFER MANAGER CLASS
#
# MANAGES A SET OF BUFFER STORES TO KEEP THE STATE OF THE GAME BUFFER IN.
#
###############################################################################
Class BufferManager {
    [BufferCell[,]]$ScreenBufferA
    [BufferCell[,]]$ScreenBufferB

    BufferManager() {
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





###############################################################################
#
# WINDOW BASE
#
# INTENDED TO BE USED AS THE FOUNDATION FOR MORE SPECIFIC "WINDOWS". THIS CLASS
# ISN'T INTENDED TO BE INSTANTIATED DIRECTLY FOR ANY REASON OTHER THAN TESTING.
#
# THE VERSION SHOWN HERE IS DERIVED FROM BURNT LATTE. IT EXTENDS THE ORIGINAL
# DESIGN BY ADDING SUPPORT FOR INDEPENDENT LEFT AND RIGHT BORDER CHARACTERS,
# AS WELL AS ADDING A TITLE. LEGACY DERIVED CLASSES WILL BE REQUIRED TO CHANGE
# CERTAIN INITIALIZATION PROCESSES TO FACILITATE DERIVATION FROM THIS VERSION.
#
# THE INCLUSION OF THE SECONDARY CONSTRUCTOR IS FOR POSTERITY. IT'S CURRENTLY
# UNCLEAR IF THIS CONSTRUCTOR IS USED. THIS SHOULD BE CLEANED UP LATER.
#
###############################################################################
Class WindowBase {
    Static [Int]$BorderDrawColorTop    = 0
    Static [Int]$BorderDrawColorBottom = 1
    Static [Int]$BorderDrawColorLeft   = 2
    Static [Int]$BorderDrawColorRight  = 3
    Static [Int]$BorderDirtyTop        = 0
    Static [Int]$BorderDirtyBottom     = 1
    Static [Int]$BorderDirtyLeft       = 2
    Static [Int]$BorderDirtyRight      = 3
    Static [Int]$BorderStringTop       = 0
    Static [Int]$BorderStringBottom    = 1
    Static [Int]$BorderStringLeft      = 2
    Static [Int]$BorderStringRight     = 3

    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[]]$BorderDrawColors
    [String[]]$BorderStrings
    [Boolean[]]$BorderDrawDirty
    [Int]$Width
    [Int]$Height

    [String]$Title
    [Boolean]$UseTitle
    [Boolean]$TitleDirty
    [ConsoleColor24]$TitleColor

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
            '',
            '',
            ''
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.Title      = ''
        $this.UseTitle   = $false
        $this.TitleDirty = $false
        $this.TitleColor = [CCTextDefault24]::new()
        $this.UpdateDimensions()
    }

    # WindowBase(
    #     [ATCoordinates]$LeftTop,
    #     [ATCoordinates]$RightBottom,
    #     [ConsoleColor24[]]$BorderDrawColors,
    #     [String[]]$BorderStrings,
    #     [Boolean[]]$BorderDrawDirty
    # ) {
    #     $this.LeftTop          = $LeftTop
    #     $this.RightBottom      = $RightBottom
    #     $this.BorderDrawColors = $BorderDrawColors
    #     $this.BorderStrings    = $BorderStrings
    #     $this.BorderDrawDirty  = $BorderDrawDirty
    #     $this.Title            = ''
    #     $this.UseTitle         = $false
    #     $this.TitleDirty       = $false
    #     $this.TitleColor       = [CCTextDefault24]::new()
    #     $this.UpdateDimensions()
    # }

    [Void]Draw() {
        [ATString]$bt = [ATStringNone]::new()
        [ATString]$bb = [ATStringNone]::new()
        [ATString]$bl = [ATStringNone]::new()
        [ATString]$br = [ATStringNone]::new()

        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] -EQ $true) {
            $bt = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop]
                    Coordinates     = $this.LeftTop
                }
                UserData = "$($this.BorderStrings[[WindowBase]::BorderStringTop])"
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
        }
        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] -EQ $true) {
            $bb = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom]
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.RightBottom.Row
                        Column = $this.LeftTop.Column
                    }
                }
                UserData = "$($this.BorderStrings[[WindowBase]::BorderStringBottom])"
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
        }
        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] -EQ $true) {
            $bl = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft]
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column
                    }
                }
                UserData = $(
                    Invoke-Command -ScriptBlock {
                        [String]$temp = ''

                        For($a = 0; $a -LT $this.Height; $a++) {
                            [ATCoordinates]$b = [ATCoordinates]@{
                                Row    = ($this.LeftTop.Row + 1) + $a
                                Column = $this.LeftTop.Column
                            }
                            $temp += "$($this.BorderStrings[[WindowBase]::BorderStringLeft])$($b.ToAnsiControlSequenceString())"
                        }

                        Return $temp
                    }
                )
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
        }
        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] -EQ $true) {
            $br = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight]
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.RightBottom.Column + 1
                    }
                }
                UserData = $(
                    Invoke-Command -ScriptBlock {
                        [String]$temp = ''

                        For($a = 0; $a -LT $this.Height; $a++) {
                            [ATCoordinates]$b = [ATCoordinates]@{
                                Row    = ($this.LeftTop.Row + 1) + $a
                                Column = $this.RightBottom.Column + 1
                            }
                            $temp += "$($this.BorderStrings[[WindowBase]::BorderStringRight])$($b.ToAnsiControlSequenceString())"
                        }

                        Return $temp
                    }
                )
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
        }

        Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"

        If($this.UseTitle -EQ $true) {
            If($this.TitleDirty -EQ $true) {
                [ATString]$a = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $this.TitleColor
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UserData   = $this.Title
                    UseATReset = $true
                }

                Write-Host "$($a.ToAnsiControlSequenceString())"
                $this.TitleDirty = $false
            }
        }
    }

    [Void]UpdateDimensions() {
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }

    [Void]SetupTitle(
        [String]$Title,
        [ConsoleColor24]$Color
    ) {
        $this.UseTitle   = $true
        $this.TitleDirty = $true
        $this.Title      = $Title
        $this.TitleColor = $Color
    }
}





###############################################################################
#
# STATUS WINDOW
#
# USED IN THE WORLD NAVIGATION STATE/SCREEN, THIS WINDOW SHOWS VERY BASIC
# STATISTICS ABOUT THE PLAYER. THE NAME OF THIS OBJECT SHOULD REALLY BE 
# CHANGED TO BETTER REFLECT ITS INTENDED USE. THIS NAME IS A VESTIGE FROM THE
# ORIGINAL CODE BASE.
#
# THIS CODE HAS ALSO BEEN DRAMATICALLY SIMPLIFIED FROM ITS ORIGINAL DESIGN.
# ONE OF THE MAJOR COMPONENTS THAT'S BEEN REMOVED IS CROSS PLATFORM SUPPORT
# IN THE DRAW METHOD. THIS VESTIGE IS NO LONGER NECESSARY SINCE THE CODE WILL
# NO LONGER BE PORTABLE BY DESIGN.
#
###############################################################################
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

    Static [String]$WindowBorderHorizontal = '@--~---~---~---~---@'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'

    Static [String]$LineBlank = '                '

    Static [ATCoordinates]$PlayerNameDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerNameDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerHpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerMpDrawCoordinates   = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawRow, [StatusWindow]::PlayerStatDrawColumn)
    Static [ATCoordinates]$PlayerGoldDrawCoordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawRow, [StatusWindow]::PlayerStatDrawColumn)

    [Boolean]$PlayerNameDrawDirty
    [Boolean]$PlayerHpDrawDirty
    [Boolean]$PlayerMpDrawDirty
    [Boolean]$PlayerGoldDrawDirty

    [ATString]$LineBlankActual

    StatusWindow() : base() {
        $this.LeftTop          = [ATCoordinates]::new([StatusWindow]::WindowLTRow, [StatusWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([StatusWindow]::WindowRBRow, [StatusWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCTextDefault24]::new(),
            [CCTextDefault24]::new(),
            [CCTextDefault24]::new(),
            [CCTextDefault24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusWindow]::WindowBorderHorizontal,
            [StatusWindow]::WindowBorderHorizontal,
            [StatusWindow]::WindowBorderLeft,
            [StatusWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        $this.PlayerNameDrawDirty = $true
        $this.PlayerHpDrawDirty   = $true
        $this.PlayerMpDrawDirty   = $true
        $this.PlayerGoldDrawDirty = $true
        $this.LineBlankActual     = [ATString]@{
            Prefix = [ATStringPrefix]@{
                Coordinates = [ATCoordinates]::new()
            }
            UserData   = "$([StatusWindow]::LineBlank)"
            UseATReset = $true
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.PlayerNameDrawDirty -EQ $true) {
            [ATString]$a = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:ThePlayer.NameDrawColor
                    Coordinates     = [StatusWindow]::PlayerNameDrawCoordinates
                }
                UserData   = $Script:ThePlayer.Name
                UseATReset = $true
            }
            $this.LineBlankActual.Prefix.Coordinates = [StatusWindow]::PlayerNameDrawCoordinates
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.PlayerNameDrawDirty = $false
        }

        If($this.PlayerHpDrawDirty -EQ $true) {
            [String]$a = ''

            Switch($Script:ThePlayer.Stats[[StatId]::HitPoints].State) {
                ([StatNumberState]::Normal) {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerHpDrawCoordinates
                        }
                        UserData = 'H '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"

                    Break
                }

                ([StatNumberState]::Caution) {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerHpDrawCoordinates
                        }
                        UserData = 'H '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"

                    Break
                }

                ([StatNumberState]::Danger) {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerHpDrawCoordinates
                        }
                        UserData = 'H '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                            Decorations     = [ATDecoration]@{
                                Blink = $true
                            }
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                            Decorations     = [ATDecoration]@{
                                Blink = $true
                            }
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"

                    Break
                }

                Default {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerHpDrawCoordinates
                        }
                        UserData = 'H '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::HitPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"

                    Break
                }
            }

            ###################################################################
            #
            # MAKE A FUCKING MENTAL NOTE THAT THIS IS ABSOLUTELY NECESSARY!!!
            #
            # I TOTALLY FORGOT WHY I NEEDED THIS, AND NOW I REMEMBER!
            #
            # IF LINEBLANKACTUAL.PREFIX.COORDINATES IS ASSIGNED TO PLAYERHPDRAWCOORDINATES,
            # THE STATEMENT THAT POSTFIXES THE ROW VALUE WILL MODIFY PLAYERHPDRAWCOORDINATES
            # AND CAUSE SUBSEQUENT DRAWS TO TRAIL DOWN THE SCREEN, WHICH IS TOTAL BULLSHIT!!!
            # IMPLICIT COPY IS TOO MUCH TO ASK EVIDENTLY.
            #
            ###################################################################
            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawCoordinates)
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())"
            $this.LineBlankActual.Prefix.Coordinates.Row++
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($a)"
            $this.PlayerHpDrawDirty = $false
        }

        If($this.PlayerMpDrawDirty -EQ $true) {
            Switch($Script:ThePlayer.Stats[[StatId]::MagicPoints].State) {
                ([StatNumberState]::Normal) {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerMpDrawCoordinates
                        }
                        UserData = 'M '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                }

                ([StatNumberState]::Caution) {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerMpDrawCoordinates
                        }
                        UserData = 'M '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorCaution
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)"
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                }

                ([StatNumberState]::Danger) {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerMpDrawCoordinates
                        }
                        UserData = 'M '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                            Decorations     = [ATDecoration]@{
                                Blink = $true
                            }
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorDanger
                            Decorations     = [ATDecoration]@{
                                Blink = $true
                            }
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                }

                Default {
                    [ATString]$p1 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                            Coordinates     = [StatusWindow]::PlayerMpDrawCoordinates
                        }
                        UserData = 'M '
                    }
                    [ATString]$p2 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base)`n`t"
                    }
                    [ATString]$p3 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [CCTextDefault24]::new()
                        }
                        UserData = '/ '
                    }
                    [ATString]$p4 = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            ForegroundColor = [BattleEntityProperty]::StatNumDrawColorSafe
                        }
                        UserData   = "$($Script:ThePlayer.Stats[[StatId]::MagicPoints].Max)"
                        UseATReset = $true
                    }
                    $a += "$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())$($p3.ToAnsiControlSequenceString())$($p4.ToAnsiControlSequenceString())"
                }
            }

            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawCoordinates)
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())"
            $this.LineBlankActual.Prefix.Coordinates.Row++
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($a)"
            $this.PlayerMpDrawDirty = $false
        }

        If($this.PlayerGoldDrawDirty -EQ $true) {
            [ATString]$p1 = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [Player]::GoldDrawColor
                    Coordinates     = [StatusWindow]::PlayerGoldDrawCoordinates
                }
                UserData = "$($Script:ThePlayer.CurrentGold)"
            }
            [ATString]$p2 = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'G'
                UseATReset = $true
            }

            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawCoordinates)
            Write-Host "$($this.LineBlankActual.ToAnsiControlSequenceString())$($p1.ToAnsiControlSequenceString())$($p2.ToAnsiControlSequenceString())"
            $this.PlayerGoldDrawDirty = $false
        }
    }
}





###############################################################################
#
# COMMAND WINDOW
#
# THIS IS THE WINDOW THAT ALLOWS THE USER TO INPUT COMMANDS AND ALSO SHOWS THE
# COMMAND HISTORY (FIVE MOST RECENT COMMANDS). 
#
###############################################################################
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
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'
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
        $this.LeftTop          = [ATCoordinates]::new([CommandWindow]::WindowLTRow, [CommandWindow]::WindowLTColumn)
        $this.RightBottom      = [ATCoordinates]::new([CommandWindow]::WindowRBRow, [CommandWindow]::WindowRBColumn)
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )

        $this.BorderStrings = [String[]](
            [CommandWindow]::WindowBorderHorizontal,
            [CommandWindow]::WindowBorderHorizontal,
            [CommandWindow]::WindowBorderLeft,
            [CommandWindow]::WindowBorderRight
        )

        $this.UpdateDimensions()

        $this.CommandDivDirty     = $true
        $this.CommandHistoryDirty = $false
        [Int]$rowBase             = $this.RightBottom.Row
        [Int]$columnBase          = $this.LeftTop.Column + [CommandWindow]::DrawColumnOffset

        [CommandWindow]::CommandDivDrawCoordinates = [ATCoordinates]@{
            Row    = ($rowBase - [CommandWindow]::DrawDivRowOffset)
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryEDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryERowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryDDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryDRowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryCDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryCRowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryBDrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryBRowOffset
            Column = $columnBase
        }
        [CommandWindow]::CommandHistoryADrawCoordinates = [ATCoordinates]@{
            Row    = $rowBase - [CommandWindow]::DrawHistoryARowOffset
            Column = $columnBase
        }

        [CommandWindow]::CommandDiv = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CommandWindow]::CommandDivDrawColor
                Coordinates     = [CommandWindow]::CommandDivDrawCoordinates
            }
            UserData   = [CommandWindow]::WindowCommandDiv
            UseATReset = $true
        }
        [CommandWindow]::CommandBlank = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CommandWindow]::HistoryBlankColor
            }
            UserData   = '                  '
            UseATReset = $true
        }
        [CommandWindow]::CommandHistBlank = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CommandWindow]::HistoryBlankColor
            }
            UserData   = '                  '
            UseATReset = $true
        }

        $this.CommandActual                                       = [ATStringNone]::new()
        $this.CommandHistory                                      = New-Object 'ATString[]' 5
        $this.CommandHistory[[CommandWindow]::CommandHistoryARef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryADrawCoordinates
            }
            UserData   = [CommandWindow]::CommandBlank.UserData
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryBRef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryBDrawCoordinates
            }
            UserData   = [CommandWindow]::CommandBlank.UserData
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryCRef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryCDrawCoordinates
            }
            UserData   = [CommandWindow]::CommandBlank.UserData
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryDRef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryDDrawCoordinates
            }
            UserData   = [CommandWindow]::CommandBlank.UserData
            UseATReset = $true
        }
        $this.CommandHistory[[CommandWindow]::CommandHistoryERef] = [ATString]@{
            Prefix = [ATStringPrefix]@{
                ForegroundColor = [CCTextDefault24]::new()
                Coordinates     = [CommandWindow]::CommandHistoryEDrawCoordinates
            }
            UserData   = [CommandWindow]::CommandBlank.UserData
            UseATReset = $true
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        If($this.CommandDivDirty -EQ $true) {
            Write-Host "$([CommandWindow]::CommandDiv.ToAnsiControlSequenceString())"
            $this.CommandDivDirty = $false
        }
        If($this.CommandHistoryDirty -EQ $true) {
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryDDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryDRef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryCDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryCRef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryBDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryBRef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryADrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryARef].ToAnsiControlSequenceString())"
            [CommandWindow]::CommandHistBlank.Prefix.Coordinates = [CommandWindow]::CommandHistoryEDrawCoordinates
            Write-Host "$([CommandWindow]::CommandHistBlank.ToAnsiControlSequenceString())$($this.CommandHistory[[CommandWindow]::CommandHistoryERef].ToAnsiControlSequenceString())"
            $this.CommandHistoryDirty = $false
        }
    }

    [Void]HandleInput() {
        $Script:Rui.CursorPosition = $Script:DefaultCursorCoordinates.ToAutomationCoordinates()
        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        While($keyCap.VirtualKeyCode -NE 13) {
            $cpx = $Script:Rui.CursorPosition.X
            If($cpx -GE 19) {
                Break
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
        If([String]::IsNullOrEmpty($this.CommandActual.UserData.Trim()) -EQ $true) {
            $Script:TheMessageWindow.WriteBadCommandRetortMessage()
            $this.CommandActual.UserData = ''

            Return
        } Else {
            $cmdactSplit = $this.CommandActual.UserData.Trim()
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
                        $Script:TheMessageWindow.WriteBadCommandRetortMessage()
                    }
                }
            } Else {
                $Script:TheCommandWindow.UpdateCommandHistory($false)
                $Script:TheMessageWindow.WriteBadCommandRetortMessage()

                Return
            }
        }
    }

    ###########################################################################
    #
    # THIS CLASS ORIGINALLY HAD SEVERAL FUNCTIONS THAT WOULD PROVIDE ACTIONS.
    # THE CODE FOR THIS HAS BEEN REMOVED AND REPLACED INTO THE ACTION TABLE.
    #
    ###########################################################################

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
            $this.CommandHistory[[CommandWindow]::CommandHistoryDRef].Prefix.Decorations = [ATDecoration]@{
                Blink = $true
            }
        }
        $this.CommandActual.UserData = ''
        $this.CommandHistoryDirty    = $true
    }
}





###############################################################################
#
# SCENE WINDOW
#
# THIS WINDOW DISPLAYS AN IMAGE FOR THE CURRENT MAP TILE. THIS IS A VISUAL
# HACK TO GIVE A VISUAL FLAIR TO THE PROGRAM.
#
###############################################################################
Class SceneWindow : WindowBase {
    Static [Int]$WindowLTRow           = 1
    Static [Int]$WindowLTColumn        = 30
    Static [Int]$WindowRBRow           = 20
    Static [Int]$WindowRBColumn        = 78
    Static [Int]$ImageDrawRowOffset    = [SceneWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [SceneWindow]::WindowLTColumn + 1


    Static [String]$WindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'

    Static [ATCoordinates]$SceneImageDrawCoordinates = [ATCoordinatesNone]::new()

    [Boolean]$SceneImageDirty
    [SceneImage]$Image

    SceneWindow() : base() {
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
            [SceneWindow]::WindowBorderHorizontal,
            [SceneWindow]::WindowBorderLeft,
            [SceneWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        $this.SceneImageDirty = $true
        $this.Image           = [SIEmpty]::new()

        [SceneWindow]::SceneImageDrawCoordinates = [ATCoordinates]@{
            Row    = [SceneWindow]::ImageDrawRowOffset
            Column = [SceneWindow]::ImageDrawColumnOffset
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.SceneImageDirty -EQ $true) {
            # THRE MAY BE AN OPPORTUNITY TO DO SOMETHING A BIT DIFFERENT HERE
            $this.Image = $Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.SceneImageDirty = $false
        }
    }

    [Void]UpdateCurrentImage(
        [SceneImage]$NewImage
    ) {
        $this.Image           = $NewImage
        $this.SceneImageDirty = $true
    }
}





###############################################################################
#
# MESSAGE WINDOW
#
# THIS WINDOW DISPLAYS MESSAGES IN THE MAP NAVIGATION SCREEN.
#
###############################################################################
Class MessageWindow : WindowBase {
    Static [Int]$MessageHistoryARef = 0
    Static [Int]$MessageHistoryBRef = 1
    Static [Int]$MessageHistoryCRef = 2
    Static [Int]$WindowLTRow        = 21
    Static [Int]$WindowLTColumn     = 1
    Static [Int]$WindowBRRow        = 26
    Static [Int]$WindowBRColumn     = 80

    Static [String]$WindowBorderHorizontal = '-------------------------------------------------------------------------------'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'

    Static [ATCoordinates]$MessageADrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageCDrawCoordinates = [ATCoordinatesNone]::new()

    Static [ATString]$MessageWindowBlank = [ATStringNone]::new()

    [ATStringComposite[]]$MessageHistory

    [Boolean]$MessageADirty
    [Boolean]$MessageBDirty
    [Boolean]$MessageCDirty

    MessageWindow() : base() {
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
            [MessageWindow]::WindowBorderHorizontal,
            [MessageWindow]::WindowBorderLeft,
            [MessageWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        [MessageWindow]::MessageCDrawCoordinates = [ATCoordinates]@{
            Row    = ($this.RightBottom.Row - 1)
            Column = ($this.LeftTop.Column + 1)
        }
        [MessageWindow]::MessageBDrawCoordinates = [ATCoordinates]@{
            Row    = ([MessageWindow]::MessageCDrawCoordinates.Row - 1)
            Column = ($this.LeftTop.Column + 1)
        }
        [MessageWindow]::MessageADrawCoordinates = [ATCoordinates]@{
            Row    = ([MessageWindow]::MessageBDrawCoordinates.Row - 1)
            Column = ($this.LeftTop.Column + 1)
        }
        [MessageWindow]::MessageWindowBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = '                                                                             '
            UseATReset = $true
        }
        $this.MessageHistory = @(
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new()
        )
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].CompositeActual[0].Prefix.Coordinates = [MessageWindow]::MessageADrawCoordinates
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].CompositeActual[0].Prefix.Coordinates = [MessageWindow]::MessageBDrawCoordinates
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].CompositeActual[0].Prefix.Coordinates = [MessageWindow]::MessageCDrawCoordinates
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.MessageADirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = [MessageWindow]::MessageADrawCoordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())$([MessageWindow]::MessageADrawCoordinates.ToAnsiControlSequenceString())$($this.MessageHistory[[MessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"
            $this.MessageADirty = $false
        }
        If($this.MessageBDirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = [MessageWindow]::MessageBDrawCoordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())$([MessageWindow]::MessageBDrawCoordinates.ToAnsiControlSequenceString())$($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"
            $this.MessageBDirty = $false
        }
        If($this.MessageCDirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = [MessageWindow]::MessageCDrawCoordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())$([MessageWindow]::MessageCDrawCoordinates.ToAnsiControlSequenceString())$($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"
            $this.MessageCDirty = $false
        }
    }

    ###########################################################################
    #
    # THIS METHOD IS LIKELY COMPLETELY DEPRECATED IN FAVOR OF
    # WRITEMESSAGECOMPOSITE. IT'S KEPT UNTIL COVERAGE IS CONFIRMED.
    #
    ###########################################################################
    [Void]WriteMessage(
        [String]$Message,
        [ATForegroundColor24]$ForegroundColor,
        [ATDecoration]$Decoration
    ) {
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].UserData               = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.Decorations     = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].Prefix.ForegroundColor = $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].UserData               = $Message
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.ForegroundColor = $ForegroundColor
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].Prefix.Decorations     = $Decoration
        $this.MessageADirty                                                              = $true
        $this.MessageBDirty                                                              = $true
        $this.MessageCDirty                                                              = $true
    }

    [Void]WriteMessageComposite(
        [ATString[]]$Composite
    ) {
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].CompositeActual)
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].CompositeActual)
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].CompositeActual = [List[ATString]]::new($Composite)
        $this.MessageADirty                                                       = $true
        $this.MessageBDirty                                                       = $true
        $this.MessageCDirty                                                       = $true
    }

    ###########################################################################
    #
    # THE FOLLOWING METHODS ARE CONVENIENCE ABSTRACTIONS FOR 
    # WRITEMESSAGECOMPOSITE THAT ARE INTENDED TO BE USED IN VERY SPECIFIC
    # SITUATIONS. NOTE THAT AT THIS TIME, THE CONTINUED USE OF 
    # ATSTRINGCOMPOSITESC IS SUBJECT TO SCRUTINY.
    #
    ###########################################################################
    [Void]WriteBadCommandMessage(
        [String]$Command
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = "$($Command)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' isn''t a valid command.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBadArg0Message(
        [String]$Command,
        [String]$Arg0
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'We can''t '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = "$($Command)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' with a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = "$($Arg0)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBadArg1Message(
        [String]$Command,
        [String]$Arg0,
        [String]$Arg1
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'We can''t '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Command)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' with a(n) '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Arg0)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' and a(n) '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Arg1)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = '.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteSomethingBadMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'I''m God, and I don''t know what just happened...'
				UseATReset = $true
			}
		))
    }

    [Void]WriteInvisibleWallEncounteredMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'The invisible wall blocks your path...'
				UseATReset = $true
			}
		))
    }

    [Void]WriteYouShallNotPassMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'The path you asked for is impossible...'
				UseATReset = $true
			}
		))
    }

    [Void]WriteMapNoItemsFoundMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'There''s nothing of interest here.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteMapInvalidItemMessage(
        [String]$ItemName
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'There''s no '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ItemName)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' here.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteItemTakenMessage(
        [String]$ItemName
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'I''ve taken the '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ItemName)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' and put it in my pocket.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteItemCantTakeMessage(
        [String]$ItemName
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'It''s not possible to take the '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ItemName)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = '.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteCmdExtraArgsWarning(
        [String]$Command,
        [String[]]$ExtraArgs
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleNPinkLight24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Command)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' has garbage: '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleNYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ExtraArgs)"
				UseATReset = $true
			}
		))
    }

    [Void]WriteBadCommandRetortMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNRedDark24]::new()
                }
                UserData   = "$($Script:BadCommandRetorts | Get-Random)"
                UseATReset = $true
            }
        ))
    }

    [Void]WriteCantUseItemMessage(
        [String]$Source,
        [String]$Target
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'Can''t use a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Source)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' on a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Target)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteCantUseItemOnSelfMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'I can''t use '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($ItemName)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' on myself.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteNoItemInInvMessage(
        [String]$DesiredItem
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'There ain''t no '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($DesiredItem)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' in your pockets guv''.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteNoItemTargetMessage(
        [String]$Source
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'You need to tell me what you want to use the '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Source)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' on.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteItemUseUnsureMessage(
        [String]$Target
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'I have no idea how to use a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Target)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteCantDropMultMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = 'Can''t drop all those items at once, bruh.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteItemDroppedMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Dropped '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($ItemName)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' from your inventory.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteMilkUseOkayMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Hmmm. Delicious cow juice.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteMilkUseSpoiledMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Now that wasn''t very smart, was it?'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteMilkUseNotNowMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'There''s no need to drink this now.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteTiedRopeToTreeMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'I''ve tied the '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = 'Rope'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' to the '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = 'Tree'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteLookMessage(
        [String]$ItemSetA,
        [String]$ItemSetB,
        [Boolean]$UseSetB
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'I can see the following things here:'
                UseATReset = $true
            }
        ))
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                }
                UserData   = "$($ItemSetA)"
                UseATReset = $true
            }
        ))
        If($UseSetB -EQ $true) {
            $this.WriteMessageComposite(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleYellowLight24]::new()
                    }
                    UserData   = "$($ItemSetB)"
                    UseATReset = $true
                }
            ))
        }
    }

    [Void]WriteItemExamineMessage(
        [String]$ExamineString
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleMintDark24]::new()
                }
                UserData   = "$($ExamineString)"
                UseATReset = $true
            }
        ))
    }
}





###############################################################################
#
# INVENTORY WINDOW
#
# AS WITH OTHER CLASSES, THE NAME OF THIS CLASS IS A BIT OF A MISNOMER.
# SPECIFICALLY, THIS CLASS INCORPORATES MULTIPLE WINDOWS TOGETHER INTO A SINGLE
# SCREEN. ALSO, THIS INVENTORY COVERS THE PLAYER'S ITEM INVENTORY AND NOT THE
# BATTLE ACTION INVENTORY, SO THERE'S A BIT TO BE DESIRED HERE. THIS WILL BE
# WORKED ON AFTER COVERAGE IS COMPLETED.
#
###############################################################################
Class InventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowBRRow    = 20
    Static [Int]$WindowBRColumn = 79

    Static [String]$WindowBorderHorizontal = '********************************************************************************'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'

    Static [String]$IChevronCharacter           = '>'
    Static [String]$IChevronBlankCharacter      = ' '
    Static [String]$PagingChevronRightCharacter = '>'
    Static [String]$PagingChevronLeftCharacter  = '<'
    Static [String]$PagingChevronBlankCharater  = ' '

    Static [String]$DivLineHorizontalString = '----------------------------------------------------------------------------'
    Static [String]$ZpLineBlank             = '                                                                             '
    Static [String]$DescLineBlank           = '                                                                          '
    Static [String]$ItemLabelBlank          = '               '

    Static [ATString]$PagingChevronRight = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 78
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronRightCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeft = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 3
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronLeftCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronRightBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleMintLight24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 2
                Column = 78
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronBlankCharater)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeftBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            Coordinates = [ATCoordinates]@{
                Row    = 2
                Column = 3
            }
        }
        UserData   = "$([InventoryWindow]::PagingChevronBlankCharater)"
        UseATReset = $true
    }
    Static [ATString]$DivLineHorizontal = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
            Coordinates     = [ATCoordinates]@{
                Row    = 13
                Column = 3
            }
        }
        UserData   = "$([InventoryWindow]::DivLineHorizontalString)"
        UseATReset = $true
    }

    Static [Boolean]$DebugMode     = $false
    Static [Int]$MoronCounter      = 0
    Static [String]$ZeroPagePrompt = 'You have no items in your inventory.'

    [Boolean]$PlayerChevronDirty
    [Boolean]$PagingChevronRightDirty
    [Boolean]$PagingChevronLeftDirty
    [Boolean]$ItemsListDirty
    [Boolean]$CurrentPageDirty
    [Boolean]$PlayerChevronVisible
    [Boolean]$PagingChevronRightVisible
    [Boolean]$PagingChevronLeftVisible
    [Boolean]$ZeroPageActive
    [Boolean]$MoronPageActive
    [Boolean]$BookDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$DivLineDirty
    [Boolean]$ItemDescDirty
    [Boolean]$ZpBlankedDirty
    [Boolean]$ZpPromptDirty

    [Int]$ItemsPerPage
    [Int]$NumPages
    [Int]$CurrentPage
    [Int]$ActiveIChevronIndex
    [List[MapTileObject]]$PageRefs
    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks

    InventoryWindow() : base() {
        $this.LeftTop          = [ATCoordinates]@{
            Row    = [InventoryWindow]::WindowLTRow
            Column = [InventoryWindow]::WindowLTColumn
        }
        $this.RightBottom      = [ATCoordinates]@{
            Row    = [InventoryWindow]::WindowBRRow
            Column = [InventoryWindow]::WindowBRColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [InventoryWindow]::WindowBorderHorizontal,
            [InventoryWindow]::WindowBorderHorizontal,
            [InventoryWindow]::WindowBorderLeft,
            [InventoryWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        $this.PlayerChevronDirty        = $true
        $this.PagingChevronRightDirty   = $true
        $this.PagingChevronLeftDirty    = $true
        $this.ItemsListDirty            = $true
        $this.CurrentPageDirty          = $true
        $this.PlayerChevronVisible      = $true
        $this.PagingChevronRightVisible = $false
        $this.PagingChevronLeftVisible  = $false
        $this.ZeroPageActive            = $false
        $this.MoronPageActive           = $false
        $this.BookDirty                 = $true
        $this.ActiveItemBlinking        = $false
        $this.DivLineDirty              = $true
        $this.ItemDescDirty             = $true
        $this.ZpBlankedDirty            = $true
        $this.ZpPromptDirty             = $true
        $this.ItemsPerPage              = 10
        $this.NumPages                  = 1
        $this.CurrentPage               = 1
        $this.PageRefs                  = [List[MapTileObject]]::new()

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
            If(($this.PlayerChevronVisible -EQ $true) -AND ($this.PlayerChevronDirty -EQ $true)) {
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
                        $this.PagingChevronLeftDirty   = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                } Elseif(($this.CurrentPage -GT 1) -AND ($this.CurrentPage -LT $this.NumPages)) {
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        $this.PagingChevronRightVisible = $true
                    }
                    If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightDirty = $false
                    }
                    If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                } Elseif($this.CurrentPage -GE $this.NumPages) {
                    If($this.PagingChevronRightVisible -EQ $true) {
                        Write-Host "$([InventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                        $this.PagingChevronRightVisible = $false
                        $this.PagingChevronRightDirty   = $true
                    }
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        $this.PagingChevronLeftVisible = $true
                    }
                    If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                        Write-Host "$([InventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                        $this.PagingChevronLeftDirty = $false
                    }
                }
            } Elseif($this.NumPages -EQ 1) {
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
            If($this.ActiveItemBlinking -EQ $false) {
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
                    Blink = $true
                }
                $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCListItemCurrentHighlight24]::new()
                $this.ItemsListDirty                                               = $true
                $this.ActiveItemBlinking                                           = $true
            }
            If($this.ItemsListDirty -EQ $true) {
                $this.WriteItemLabels()
                Write-Host "$([ATControlSequences]::CursorHide)"
                $this.ItemsListDirty = $false
            }
            If($this.ItemDescDirty -EQ $true) {
                [ATString]$b = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 15
                            Column = 4
                        }
                    }
                    UserData   = [InventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$d = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 15
                            Column = 4
                        }
                    }
                    UserData   = $this.PageRefs[$this.ActiveIChevronIndex].ExamineString
                    UseATReset = $true
                }
                [ATString]$f = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 16
                            Column = 4
                        }
                    }
                    UserData   = [InventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$e = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCApplePinkLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 16
                            Column = 4
                        }
                    }
                    UserData   = $this.PageRefs[$this.ActiveIChevronIndex].PlayerEffectString
                    UseATReset = $true
                }
                [ATString]$h = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = 17
                            Column = 4
                        }
                    }
                    UserData   = [InventoryWindow]::DescLineBlank
                    UseATReset = $true
                }
                [ATString]$i = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleYellowLight24]::new()
                        Decorations     = [ATDecoration]@{
                            Blink  = $true
                            Italic = $true
                        }
                        Coordinates = [ATCoordinates]@{
                            Row    = 17
                            Column = 4
                        }
                    }
                    UserData   = ($this.PageRefs[$this.ActiveIChevronIndex].KeyItem -EQ $true ? 'KEY ITEM' : '')
                    UseATReset = $true
                }
                Write-Host "$($b.ToAnsiControlSequenceString())$($d.ToAnsiControlSequenceString())$($f.ToAnsiControlSequenceString())$($e.ToAnsiControlSequenceString())$($h.ToAnsiControlSequenceString())$($i.ToAnsiControlSequenceString())"
            }
        }
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 3
                        Column = 15
                    }
                }
                UserData   = [InventoryWindow]::IChevronCharacter
                UseATReset = $true
            },
            $true
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 5
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates      = [ATCoordinates]@{
                        Row    = 7
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 9
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 11
                        Column = 15
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 3
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 5
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 7
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 9
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = 11
                        Column = 50
                    }
                }
                UserData = [InventoryWindow]::IChevronBlankCharacter
            },
            $false
        ))
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c          = 0

        Foreach($i in $this.PageRefs) {
            $this.ItemLabels.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.IChevrons[$c].Item1.Prefix.Coordinates.Row
                            Column = $this.IChevrons[$c].Item1.Prefix.Coordinates.Column + 2
                        }
                    }
                    UserData = $i.Name
                    UseATReset = $true
                }
            )
            $c++ # FYI - This was intentional
        }
        $this.ResetIChevronPosition()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 3
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 5
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 7
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 9
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 11
                        Column = 17
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 3
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 5
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 7
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 9
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = 11
                        Column = 52
                    }
                }
                UserData   = [InventoryWindow]::ItemLabelBlank
                UseATReset = $true
            }
        )
    }

    [Void]CalculateNumPages() {
        $pp = $Script:ThePlayer.Inventory.Count / $this.ItemsPerPage
        If($pp -LT 1) {
            $this.NumPages = 1
        } Else {
            $this.NumPages = [Math]::Ceiling($pp)
        }
        If($this.CurrentPage -GT $this.NumPages) {
            $this.CurrentPage = $this.NumPages
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
        $this.ActiveIChevronIndex                        = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2 = $true

        Return $this.IChevrons[$this.ActiveIChevronIndex].Item1
    }

    [Void]WriteZeroInventoryPage() {
        If($this.ZpBlankedDirty -EQ $true) {
            Foreach($a in 2..19) {
                [ATString]$b = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $a
                            Column = 2
                        }
                    }
                    UserData   = [InventoryWindow]::ZpLineBlank
                    UseATReset = $true
                }
                Write-Host "$($b.ToAnsiControlSequenceString())"
            }
            $this.ZpBlankedDirty = $false
        }
        If($this.ZpPromptDirty -EQ $true) {
            [ATString]$a = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.Height / 2
                        Column = ($this.Width / 2) - ([InventoryWindow]::ZeroPagePrompt.Length / 2)
                    }
                }
                UserData   = [InventoryWindow]::ZeroPagePrompt
                UseATReset = $true
            }
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
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
            Blink = $true
        }
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        $this.PlayerChevronDirty                                           = $true
        $this.ActiveItemBlinking                                           = $false
        $this.ItemDescDirty                                                = $true
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')

        #######################################################################
        #
        # BECAUSE POWERSHELL HAS BEEN REALLY WEIRD ABOUT MAPPING THE VALUE
        # OF VIRTUALKEYCODE TO AN ENUMERATION, TYPED OR OTHERWISE, I SHOULD
        # COMMENT THE MAPPINGS HERE SO THAT IT'S OBVIOUS WHAT KEY IS DOING
        # WHAT.
        #
        #######################################################################
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
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
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
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty                                               = $true
                $this.ActiveItemBlinking                                               = $false
                $this.ItemDescDirty                                                    = $true
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
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty                                               = $true
                $this.ActiveItemBlinking                                               = $false
                $this.ItemDescDirty                                                    = $true
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
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty                                               = $true
                $this.ActiveItemBlinking                                               = $false
                $this.ItemDescDirty                                                    = $true
            }

            68 {
                $this.TurnPageForward()
            }

            65 {
                $this.TurnPageBackward()
            }

            83 {
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
                        [Int]$a               = ((10 * ($this.CurrentPage - 1)) + $this.ActiveIChevronIndex)
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





###############################################################################
#
# BATTLE ENTITY STATUS WINDOW
#
# THIS IS THE STATUS WINDOW THAT DISPLAYS THE STATUS OF A BATTLE ENTITY IN THE
# BATTLE SCREEN.
#
# BECAUSE IN THE BATTLE SCREEN MULTIPLE INSTANCES OF THIS WINDOW EXIST, THERE
# ARE SOME ANTI-PATTERNS EXHIBITED HERE IN RELATION TO THE OTHER WINDOWS. THE
# FOLLOWING VARIABLES ARE DEMOTED FROM STATIC TO INSTANCE MEMBERS:
#
# WINDOWLTROW
# WINDOWLTCOLUMN
# WINDOWRBROW
# WINDOWRBCOLUMN
#
###############################################################################
Class BattleEntityStatusWindow : WindowBase {
    Static [String]$WindowBorderHorizontal = '*------------------*'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'
    Static [String]$FullLineBlankActual    = '                 '

    [ATCoordinates]$NameDrawCoordinates
    [ATCoordinates]$HpDrawCoordinates
    [ATCoordinates]$MpDrawCoordinates
    [ATCoordinates]$StatL1DrawCoordinates
    [ATCoordinates]$StatL2DrawCoordinates
    [ATCoordinates]$StatL3DrawCoordinates
    [ATCoordinates]$StatL4DrawCoordinates
    [Int]$WindowLTRow
    [Int]$WindowLTColumn
    [Int]$WindowRBRow
    [Int]$WindowRBColumn
    [Boolean]$NameDrawDirty
    [Boolean]$HpDrawDirty
    [Boolean]$MpDrawDirty
    [Boolean]$StatL1DrawDirty
    [Boolean]$StatL2DrawDirty
    [Boolean]$StatL3DrawDirty
    [Boolean]$StatL4DrawDirty
    [Boolean]$EntityBattlePhaseActive
    [Boolean]$HasSetEntityActive
    [ATString]$FullLineBlank
    [ATStringComposite]$NameDrawString
    [ATStringComposite]$HpDrawString
    [ATStringComposite]$MpDrawString
    [ATStringComposite]$StatL1DrawString
    [ATStringComposite]$StatL2DrawString
    [ATStringComposite]$StatL3DrawString
    [ATStringComposite]$StatL4DrawString
    [BattleEntity]$BERef

    BattleEntityStatusWindow() : base() {
        $this.WindowLTRow    = 1
        $this.WindowLTColumn = 1
        $this.WindowRBRow    = 1
        $this.WindowRBColumn = 1
        $this.LeftTop = [ATCoordinates]@{
            Row    = $this.WindowLTRow
            Column = $this.WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = $this.WindowRBRow
            Column = $this.WindowRBColumn
        }
        $this.BorderDrawColors = @(
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = @(
            [BattleEntityStatusWindow]::WindowBorderHorizontal,
            [BattleEntityStatusWindow]::WindowBorderHorizontal,
            [BattleEntityStatusWindow]::WindowBorderLeft,
            [BattleEntityStatusWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        [Int]$ColDef = $this.LeftTop.Column + 2
        $this.NameDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $ColDef
        }
        $this.HpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.NameDrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.MpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 5
            Column = $ColDef
        }
        $this.StatL1DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 9
            Column = $ColDef
        }
        $this.StatL2DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 11
            Column = $ColDef
        }
        $this.StatL3DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 13
            Column = $ColDef
        }
        $this.StatL4DrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 15
            Column = $ColDef
        }
        $this.NameDrawDirty           = $true
        $this.HpDrawDirty             = $true
        $this.MpDrawDirty             = $true
        $this.StatL1DrawDirty         = $true
        $this.StatL2DrawDirty         = $true
        $this.StatL3DrawDirty         = $true
        $this.StatL4DrawDirty         = $true
        $this.EntityBattlePhaseActive = $false
        $this.HasSetEntityActive      = $false
        $this.BERef                   = $null
        $this.FullLineBlank           = [ATString]@{
            UserData   = [BattleEntityStatusWindow]::FullLineBlankActual
            UseATReset = $true
        }
    }

    BattleEntityStatusWindow(
        [Int]$WindowLTRow,
        [Int]$WindowLTColumn,
        [Int]$WindowRBRow,
        [Int]$WindowRBColumn,
        [BattleEntity]$BERef
    ) : base() {
        $this.WindowLTRow    = $WindowLTRow
        $this.WindowLTColumn = $WindowLTColumn
        $this.WindowRBRow    = $WindowRBRow
        $this.WindowRBColumn = $WindowRBColumn
        $this.LeftTop = [ATCoordinates]@{
            Row    = $this.WindowLTRow
            Column = $this.WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = $this.WindowRBRow
            Column = $this.WindowRBColumn
        }
        $this.BorderDrawColors = @(
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = @(
            [BattleEntityStatusWindow]::WindowBorderHorizontal,
            [BattleEntityStatusWindow]::WindowBorderHorizontal,
            [BattleEntityStatusWindow]::WindowBorderLeft,
            [BattleEntityStatusWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        [Int]$ColDef = $this.LeftTop.Column + 2
        $this.NameDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $ColDef
        }
        $this.HpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.NameDrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.MpDrawCoordinates = [ATCoordinates]@{
            Row    = $this.HpDrawCoordinates.Row + 3
            Column = $ColDef
        }
        $this.StatL1DrawCoordinates = [ATCoordinates]@{
            Row    = $this.MpDrawCoordinates.Row + 3
            Column = $ColDef
        }
        $this.StatL2DrawCoordinates = [ATCoordinates]@{
            Row    = $this.StatL1DrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.StatL3DrawCoordinates = [ATCoordinates]@{
            Row    = $this.StatL2DrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.StatL4DrawCoordinates = [ATCoordinates]@{
            Row    = $this.StatL3DrawCoordinates.Row + 2
            Column = $ColDef
        }
        $this.NameDrawDirty           = $true
        $this.HpDrawDirty             = $true
        $this.MpDrawDirty             = $true
        $this.StatL1DrawDirty         = $true
        $this.StatL2DrawDirty         = $true
        $this.StatL3DrawDirty         = $true
        $this.StatL4DrawDirty         = $true
        $this.EntityBattlePhaseActive = $false
        $this.HasSetEntityActive      = $false
        $this.BERef                   = $BERef
        $this.FullLineBlank           = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = [BattleEntityStatusWindow]::FullLineBlankActual
            UseATReset = $true
        }
    }

    [Void]Draw() {
        If(($this.EntityBattlePhaseActive -EQ $true) -AND ($this.HasSetEntityActive -EQ $false)) {
            $this.BorderDrawColors = [ConsoleColor24[]](
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new(),
                [CCAppleYellowDark24]::new()
            )
            $this.BorderDrawDirty = [Boolean[]](
                $true,
                $true,
                $true,
                $true
            )
            $this.HasSetEntityActive = $true
        } Elseif($this.EntityBattlePhaseActive -EQ $false) {
            $this.BorderDrawColors = [ConsoleColor24[]](
                [CCWhite24]::new(),
                [CCWhite24]::new(),
                [CCWhite24]::new(),
                [CCWhite24]::new()
            )
            $this.BorderDrawDirty = [Boolean[]](
                $true,
                $true,
                $true,
                $true
            )
            $this.HasSetEntityActive = $false
        }

        ([WindowBase]$this).Draw()
        If($this.NameDrawDirty -EQ $true) {
            $this.CreateNameDrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.NameDrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.NameDrawString.ToAnsiControlSequenceString())"
            $this.NameDrawDirty = $false
        }
        If($this.HpDrawDirty -EQ $true) {
            $this.CreateHpDrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.HpDrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            $this.FullLineBlank.Prefix.Coordinates.Row++
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.HpDrawString.ToAnsiControlSequenceString())"
            $this.HpDrawDirty = $false
        }
        If($this.MpDrawDirty -EQ $true) {
            $this.CreateMpDrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.MpDrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.MpDrawString.ToAnsiControlSequenceString())"
            $this.MpDrawDirty = $false
        }
        If($this.StatL1DrawDirty -EQ $true) {
            $this.CreateStatL1DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL1DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL1DrawString.ToAnsiControlSequenceString())"
            $this.StatL1DrawDirty = $false
        }
        If($this.StatL2DrawDirty -EQ $true) {
            $this.CreateStatL2DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL2DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL2DrawString.ToAnsiControlSequenceString())"
            $this.StatL2DrawDirty = $false
        }
        If($this.StatL3DrawDirty -EQ $true) {
            $this.CreateStatL3DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL3DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL3DrawString.ToAnsiControlSequenceString())"
            $this.StatL3DrawDirty = $false
        }
        If($this.StatL4DrawDirty -EQ $true) {
            $this.CreateStatL4DrawString()
            $this.FullLineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatL4DrawCoordinates)
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL4DrawString.ToAnsiControlSequenceString())"
            $this.StatL4DrawDirty = $false
        }
    }

    [Void]CreateNameDrawString() {
        $this.NameDrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$this.BERef.Affinity].Item2
                    Coordinates     = $this.NameDrawCoordinates
                }
                UserData   = "$($Script:BATADornmentCharTable[$this.BERef.Affinity].Item1)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BERef.NameDrawColor
                }
                UserData   = " $($this.BERef.Name)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateHpDrawString() {
        [ConsoleColor24]$NumDrawColor = [CCTextDefault24]::new()
        [ATDecoration]$NumDeco        = [ATDecorationNone]::new()

        Switch($this.BERef.Stats[[StatId]::HitPoints].State) {
            ([StatNumberState]::Normal) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }

            ([StatNumberState]::Caution) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorCaution
            }

            ([StatNumberState]::Danger) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
                $NumDeco      = [ATDecoration]@{
                    Blink = $true
                }
            }

            Default {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }
        }

        $this.HpDrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.HpDrawCoordinates
                }
                UserData = 'H '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData = "$($this.BERef.Stats[[StatId]::HitPoints].Base)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.HpDrawCoordinates.Row + 1
                        Column = $this.HpDrawCoordinates.Column + 6
                    }
                }
                UserData = '/ '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData   = "$($this.BERef.Stats[[StatId]::HitPoints].Max)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateMpDrawString() {
        [ConsoleColor24]$NumDrawColor = [CCTextDefault24]::new()
        [ATDecoration]$NumDeco        = [ATDecorationNone]::new()

        Switch($this.BERef.Stats[[StatId]::MagicPoints].State) {
            ([StatNumberState]::Normal) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }

            ([StatNumberState]::Caution) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorCaution
            }

            ([StatNumberState]::Danger) {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorDanger
                $NumDeco      = [ATDecoration]@{
                    Blink = $true
                }
            }

            Default {
                $NumDrawColor = [BattleEntityProperty]::StatNumDrawColorSafe
            }
        }

        $this.MpDrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.MpDrawCoordinates
                }
                UserData = 'M '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData = "$($this.BERef.Stats[[StatId]::MagicPoints].Base)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.MpDrawCoordinates.Row + 1
                        Column = $this.MpDrawCoordinates.Column + 6
                    }
                }
                UserData = '/ '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $NumDrawColor
                    Decorations     = $NumDeco
                }
                UserData   = "$($this.BERef.Stats[[StatId]::MagicPoints].Max)"
                UseATReset = $true
            }
        ))
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
                    $AtkDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $AtkStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $AtkDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $AtkStatSignStr = '-'
                }

                Default {
                    $AtkDrawColor   = [CCTextDefault24]::new()
                    $AtkStatSignStr = ' '
                }
            }
        } Else {
            $AtkDrawColor   = [CCTextDefault24]::new()
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
                    $DefDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $DefStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $DefDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
                    $DefStatSignStr = '-'
                }

                Default {
                    $DefDrawColor   = [CCTextDefault24]::new()
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

        $this.StatL1DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL1DrawCoordinates
                }
                UserData = 'ATK '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AtkDrawColor
                }
                UserData = "$($AtkStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AtkDrawColor
                }
                UserData = "$($AtkStatFmtStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' DEF '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $DefDrawColor
                }
                UserData = "$($DefStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $DefDrawColor
                }
                UserData   = "$($DefStatFmtStr)"
                UseATReset = $true
            }
        ))
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
                    $MatDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $MatStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $MatDrawColor = [BattleEntityProperty]::StatAugDrawColorNegative
                    $MatStatSignStr = '-'
                }

                Default {
                    $MatDrawColor   = [CCTextDefault24]::new()
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
                    $MdfDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $MdfStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $MdfDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
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

        $this.StatL2DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL2DrawCoordinates
                }
                UserData = 'MAT '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MatDrawColor
                }
                UserData = "$($MatStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MatDrawColor
                }
                UserData = "$($MatStatFmtStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' MDF '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MdfDrawColor
                }
                UserData = "$($MdfStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $MdfDrawColor
                }
                UserData   = "$($MdfStatFmtStr)"
                UseATReset = $true
            }
        ))
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
                    $SpdDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $SpdStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $SpdDrawColor = [BattleEntityProperty]::StatAugDrawColorNegative
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
                    $AccDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $AccStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $AccDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
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

        $this.StatL3DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL3DrawCoordinates
                }
                UserData = 'SPD '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $SpdDrawColor
                }
                UserData = "$($SpdStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $SpdDrawColor
                }
                UserData = "$($SpdStatFmtStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' ACC '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AccDrawColor
                }
                UserData = "$($AccStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $AccDrawColor
                }
                UserData   = "$($AccStatFmtStr)"
                UseATReset = $true
            }
        ))
    }

    [Void]CreateStatL4DrawString() {
        [BattleEntityProperty]$LckStat = $this.BERef.Stats[[StatId]::Luck]
        [ConsoleColor24]$LckDrawColor  = [CCTextDefault24]::new()
        [String]$LckStatSignStr        = ''
        [String]$LckStatFmtStr         = ''

        If($LckStat.AugmentTurnDuration -GT 0) {
            Switch($LckStat.BaseAugmentValue) {
                { $_ -GT 0 } {
                    $LckDrawColor   = [BattleEntityProperty]::StatAugDrawColorPositive
                    $LckStatSignStr = '+'
                }

                { $_ -LT 0 } {
                    $LckDrawColor   = [BattleEntityProperty]::StatAugDrawColorNegative
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

        $this.StatL4DrawString = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = $this.StatL4DrawCoordinates
                }
                UserData = 'LCK '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $LckDrawColor
                }
                UserData = "$($LckStatSignStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $LckDrawColor
                }
                UserData   = "$($LckStatFmtStr)"
                UseATReset = $true
            }
        ))
    }

    [Void]SetAllFlagsDirty() {
        $this.NameDrawDirty   = $true
        $this.HpDrawDirty     = $true
        $this.MpDrawDirty     = $true
        $this.StatL1DrawDirty = $true
        $this.StatL2DrawDirty = $true
        $this.StatL3DrawDirty = $true
        $this.StatL4DrawDirty = $true
    }
}





###############################################################################
#
# BATTLE PLAYER ACTION WINDOW
#
###############################################################################
Class BattlePlayerActionWindow : WindowBase {
    Static [Int]$WindowLTRow    = 18
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 23
    Static [Int]$WindowRBCOlumn = 19

    Static [String]$WindowBorderHorizontal      = '*------------------*'
    Static [String]$WindowBorderLeft            = '|'
    Static [String]$WindowBorderRight           = '|'
    Static [String]$PlayerChevronCharacter      = '>'
    Static [String]$PlayerChevronBlankCharacter = ' '

    Static [ATString]$PlayerChevron = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
        }
        UserData   = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PlayerChevronBlank = [ATString]@{
        UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
        UseATReset = $true
    }

    [Int]$ActiveChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$ActionADrawDirty
    [Boolean]$ActionBDrawDirty
    [Boolean]$ActionCDrawDirty
    [Boolean]$ActionDDrawDirty
    [ATCoordinates]$ActionADrawCoords
    [ATCoordinates]$ActionBDrawCoords
    [ATCoordinates]$ActionCDrawCoords
    [ATCoordinates]$ActionDDrawCoords
    [List[ValueTuple[[ATString], [Boolean]]]]$Chevrons

    BattlePlayerActionWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [BattlePlayerActionWindow]::WindowLTRow
            Column = [BattlePlayerActionWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [BattlePlayerActionWindow]::WindowRBRow
            Column = [BattlePlayerActionWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            "$([BattlePlayerActionWindow]::WindowBorderHorizontal)",
            "$([BattlePlayerActionWindow]::WindowBorderHorizontal)",
            "$([BattlePlayerActionWindow]::WindowBorderLeft)",
            "$([BattlePlayerActionWindow]::WindowBorderRight)"
        )
        $this.UpdateDimensions()

        $this.ActiveChevronIndex = 0
        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ActionADrawDirty   = $true
        $this.ActionBDrawDirty   = $true
        $this.ActionCDrawDirty   = $true
        $this.ActionDDrawDirty   = $true
        $this.ActionADrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 3
        }
        $this.ActionBDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionADrawCoords.Row + 1
            Column = $this.ActionADrawCoords.Column
        }
        $this.ActionCDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionBDrawCoords.Row + 1
            Column = $this.ActionBDrawCoords.Column
        }
        $this.ActionDDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionCDrawCoords.Row + 1
            Column = $this.ActionCDrawCoords.Column
        }
        $this.CreateChevrons()
    }

    [Void]CreateChevrons() {
        $this.Chevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionADrawCoords.Row
                            Column = $this.ActionADrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                    UseATReset = $true
                },
                $true
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionBDrawCoords.Row
                            Column = $this.ActionBDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionCDrawCoords.Row
                            Column = $this.ActionCDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionDDrawCoords.Row
                            Column = $this.ActionDDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
    }

    [ATString]GetActiveChevron() {
        Foreach($a in $this.Chevrons) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
        }
        $this.ActiveChevronIndex                       = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2 = $true

        Return $this.Chevrons[$this.ActiveChevronIndex].Item1
    }

    [Void]ResetChevronPosition() {
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
        $this.ActiveChevronIndex                                = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.ActionADrawDirty -EQ $true) {
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::A].Type].Item2
                        Coordinates     = $this.ActionADrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::A].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::A].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionADrawDirty = $false
        }
        If($this.ActionBDrawDirty -EQ $true) {
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::B].Type].Item2
                        Coordinates     = $this.ActionBDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::B].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::B].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionBDrawDirty = $false
        }
        If($this.ActionCDrawDirty -EQ $true) {
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::C].Type].Item2
                        Coordinates     = $this.ActionCDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::C].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::C].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionCDrawDirty = $false
        }
        If($this.ActionDDrawDirty -EQ $true) {
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::D].Type].Item2
                        Coordinates     = $this.ActionDDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::D].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::D].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ActionDDrawDirty = $false
        }
        If($this.PlayerChevronDirty -EQ $true) {
            Foreach($c in $this.Chevrons) {
                Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
            }
            $this.PlayerChevronDirty = $false
        }
    }

    [BattleAction]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 {
                Switch($this.ActiveChevronIndex) {
                    0 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::A].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::A].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::A]
                    }

                    1 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::B].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::B].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::B]
                    }

                    2 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::C].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::C].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::C]
                    }

                    3 {
                        If(($Script:ThePlayer.ActionListing[[ActionSlot]::D].MpCost -GT 0) -AND ($Script:ThePlayer.Stats[[StatId]::MagicPoints].Base -LT $Script:ThePlayer.ActionListing[[ActionSlot]::D].MpCost)) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBattleNem)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteNotEnoughMpMessage()
                            $Script:TheBattleStatusMessageWindow.Draw()

                            Return $null
                        }

                        Return $Script:ThePlayer.ActionListing[[ActionSlot]::D]
                    }

                    Default {
                        Return $null
                    }
                }
            }

            38 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up'
                }
                If(($this.ActiveChevronIndex - 1) -LT 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 3
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex--
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }

            40 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up'
                }
                If(($this.ActiveChevronIndex + 1) -GT 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 0
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex + 1) -LE 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex++
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([BattlePlayerActionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }
        }

        Return $null
    }

    [Void]SetAllActionDrawDirty() {
        $this.ActionADrawDirty = $true
        $this.ActionBDrawDirty = $true
        $this.ActionCDrawDirty = $true
        $this.ActionDDrawDirty = $true
    }
}





###############################################################################
#
# BATTLE STATUS MESSAGE WINDOW
#
###############################################################################
Class BattleStatusMessageWindow : WindowBase {
    Static [Int]$MessageHistoryARef = 0
    Static [Int]$MessageHistoryBRef = 1
    Static [Int]$MessageHistoryCRef = 2
    Static [Int]$MessageHistoryDRef = 3
    Static [Int]$MessageHistoryERef = 4
    Static [Int]$WindowLTRow        = 18
    Static [Int]$WindowLTColumn     = 22
    Static [Int]$WindowRBRow        = 24
    Static [Int]$WindowRBColumn     = 80

    Static [String]$WindowBorderHorizontal = '*----------------------------------------------------------*'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'
    Static [String]$MessageBlankActual     = '                                                          '

    Static [Single]$MessageSleepTime = 0.2

    [Boolean]$MessageADirty
    [Boolean]$MessageBDirty
    [Boolean]$MessageCDirty
    [Boolean]$MessageDDirty
    [Boolean]$MessageEDirty
    [ATString]$MessageBlank
    [ATCoordinates]$MessageADrawCoords
    [ATCoordinates]$MessageBDrawCoords
    [ATCoordinates]$MessageCDrawCoords
    [ATCoordinates]$MessageDDrawCoords
    [ATCoordinates]$MessageEDrawCoords
    [ATStringComposite[]]$MessageHistory

    BattleStatusMessageWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [BattleStatusMessageWindow]::WindowLTRow
            Column = [BattleStatusMessageWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [BattleStatusMessageWindow]::WindowRBRow
            Column = [BattleStatusMessageWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            "$([BattleStatusMessageWindow]::WindowBorderHorizontal)",
            "$([BattleStatusMessageWindow]::WindowBorderHorizontal)",
            "$([BattleStatusMessageWindow]::WindowBorderLeft)",
            "$([BattleStatusMessageWindow]::WindowBorderRight)"
        )
        $this.UpdateDimensions()

        $this.MessageADirty = $false
        $this.MessageBDirty = $false
        $this.MessageCDirty = $false
        $this.MessageDDirty = $false
        $this.MessageEDirty = $false

        $this.MessageBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = "$([BattleStatusMessageWindow]::MessageBlankActual)"
            UseATReset = $true
        }

        $this.MessageADrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 1
        }
        $this.MessageBDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageADrawCoords.Row + 1
            Column = $this.MessageADrawCoords.Column
        }
        $this.MessageCDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageBDrawCoords.Row + 1
            Column = $this.MessageBDrawCoords.Column
        }
        $this.MessageDDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageCDrawCoords.Row + 1
            Column = $this.MessageCDrawCoords.Column
        }
        $this.MessageEDrawCoords = [ATCoordinates]@{
            Row    = $this.MessageDDrawCoords.Row + 1
            Column = $this.MessageDDrawCoords.Column
        }

        $this.MessageHistory = [ATStringComposite[]](
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new()
        )
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryARef].CompositeActual[0].Prefix.Coordinates = $this.MessageADrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].CompositeActual[0].Prefix.Coordinates = $this.MessageBDrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].CompositeActual[0].Prefix.Coordinates = $this.MessageCDrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].CompositeActual[0].Prefix.Coordinates = $this.MessageDDrawCoords
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef].CompositeActual[0].Prefix.Coordinates = $this.MessageEDrawCoords
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.MessageEDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageEDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageEDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef].ToAnsiControlSequenceString())"
            $this.MessageEDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageDDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageDDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageDDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].ToAnsiControlSequenceString())"
            $this.MessageDDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageCDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageCDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageCDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"
            $this.MessageCDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageBDirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageBDrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageBDrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"
            $this.MessageBDirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime)
        }
        If($this.MessageADirty -EQ $true) {
            $this.MessageBlank.Prefix.Coordinates = $this.MessageADrawCoords
            Write-Host "$($this.MessageBlank.ToAnsiControlSequenceString())$($this.MessageADrawCoords.ToAnsiControlSequenceString())$($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"
            $this.MessageADirty = $false
            Start-Sleep -Seconds $([BattleStatusMessageWindow]::MessageSleepTime + 0.4)
        }
    }

    [Void]WriteMessageComposite(
        [ATString[]]$ATComposite
    ) {
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryARef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryBRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryCRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryDRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef].CompositeActual)
        $this.MessageHistory[[BattleStatusMessageWindow]::MessageHistoryERef]                 = [ATStringComposite]::new($ATComposite)

        $this.MessageADirty = $true
        $this.MessageBDirty = $true
        $this.MessageCDirty = $true
        $this.MessageDDirty = $true
        $this.MessageEDirty = $true
    }

    [Void]WriteNotEnoughMpMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleVYellowADark24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'Not enough MP!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteEntityUsesMessage(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' uses '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarSwc(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' was successful! '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'CRITICAL!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarAff(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' was successful! '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'AFFINITY!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarCritAff(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = ' was successful! '
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                    Decorations = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = 'CRIT AND AFFINITY!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarSuccess(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' was successful!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarFailMissed(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' missed!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBarFailFailed(
        [BattleAction]$Action
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Action.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' failed!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatPhysical(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' hit '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalFire(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' burned '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalWater(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' soaked '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalEarth(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' stoned '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalWind(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' sheared '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalLight(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' cast holy power on '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalDark(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' cast unholy power on '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatElementalIce(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' froze '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicPoison(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' poisoned '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATSTringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' for '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Action.Type].Item2
                }
                UserData   = "$($Result.ActionEffectSum)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' damage.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicConfuse(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' confused '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicSleep(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' put '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' to sleep!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicAging(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData   = "$($Originator.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' made '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Target.NameDrawColor
                }
                UserData   = "$($Target.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' grow old!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBatMagicHealing(
        [BattleEntity]$Originator,
        [BattleEntity]$Target,
        [BattleAction]$Action,
        [BattleActionResult]$Result
    ) {
        If($Originator == $Target) {
            # Healed themselves
            $this.WriteMessageComposite(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Originator.NameDrawColor
                    }
                    UserData   = "$($Originator.Name)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = ' healed themself '
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                    }
                    UserData   = "$($Result.ActionEfffectSum)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = '!'
                    UseATReset = $true
                }
            ))
        } Else {
            # Healed Target
            $this.WriteMessageComposite(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Originator.NameDrawColor
                    }
                    UserData   = "$($Originator.Name)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = ' healed '
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Target.NameDrawColor
                    }
                    UserData   = "$($Target.Name)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = ' for '
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleGreenLight24]::new()
                    }
                    UserData   = "$($Result.ActionEfffectSum)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = '!'
                    UseATReset = $true
                }
            ))
        }
    }

    [Void]WriteEntityCantActMessage(
        [BattleEntity]$Originator
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Originator.NameDrawColor
                }
                UserData = "$($Originator.Name)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' is unable to act!'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBattleWonMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'You''ve won the battle!'
                UseATReset = $true
            }
        ))
    }
	
	[Void]WriteBattleLostMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'You''ve lost the battle.'
				UseATReset = $true
			}
		))
	}
	
	[Void]WriteGameOverMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'GAME OVER'
				UseATReset = $true
			}
		))
	}

    [Void]WriteBattleEndPrompt() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Press ''Enter'' to exit.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteSpoilsMessage(
        [EnemyBattleEntity]$Opponent
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Opponent.NameDrawColor
                }
                UserData   = "$($Opponent.Name)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' dropped '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Opponent.SpoilsGold)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' gold.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteItemsFoundMessage(
        [String]$ItemNames
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Also found '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($ItemNames)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }
}





###############################################################################
#
# BATTLE ENEMY IMAGE WINDOW
#
###############################################################################
Class BattleEnemyImageWindow : WindowBase {
    Static [Int]$WindowLTRow           = 1
    Static [Int]$WindowLTColumn        = 43
    Static [Int]$WindowRBRow           = 17
    Static [Int]$WindowRBColumn        = 80
    Static [Int]$ImageDrawRowOffset    = [BattleEnemyImageWindow]::WindowLTRow + 1
    Static [Int]$ImageDrawColumnOffset = [BattleEnemyImageWindow]::WindowLTColumn + 1

    Static [String]$WindowBorderHorizontal = '*-------------------------------------*'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'

    [Boolean]$ImageDirty
    [ATCoordinates]$ImageDrawCoords
    [EnemyEntityImage]$Image

    BattleEnemyImageWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [BattleEnemyImageWindow]::WindowLTRow
            Column = [BattleEnemyImageWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [BattleEnemyImageWindow]::WindowRBRow
            Column = [BattleEnemyImageWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            "$([BattleEnemyImageWindow]::WindowBorderHorizontal)",
            "$([BattleEnemyImageWindow]::WindowBorderHorizontal)",
            "$([BattleEnemyImageWindow]::WindowBorderLeft)",
            "$([BattleEnemyImageWindow]::WindowBorderRight)"
        )
        $this.UpdateDimensions()

        $this.ImageDirty      = $true
        $this.Image           = [EEIEmpty]::new()
        $this.ImageDrawCoords = [ATCoordinates]@{
            Row    = [BattleEnemyImageWindow]::ImageDrawRowOffset
            Column = [BattleEnemyImageWindow]::ImageDrawColumnOffset
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
        If($this.ImageDirty -EQ $true) {
            $this.Image = $Script:TheCurrentEnemy.Image
            Write-Host "$($this.Image.ToAnsiControlSequenceString())"
            $this.ImageDirty = $false
        }
    }
}





###############################################################################
#
# STATUS HUD WINDOW
#
###############################################################################
Class StatusHudWindow : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 3
    Static [Int]$WindowRBColumn = 80

    Static [String]$WindowBorderHorizontal = '*-------------------------------------------------------------------------------*'
    Static [String]$WindowBorderLeft       = '|'
    Static [String]$WindowBorderRight      = '|'
    Static [String]$LineBlankStr           = '                                                                              '

    [Boolean]$StatLineDrawDirty
    [ATString]$LineBlank
    [ATCoordinates]$StatLineDrawCoords
    [ATCoordinates]$StatSeparatorDrawCoords
    [ATStringComposite]$StatLineActual

    StatusHudWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusHudWindow]::WindowLTRow
            Column = [StatusHudWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusHudWindow]::WindowRBRow
            Column = [StatusHudWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusHudWindow]::WindowBorderHorizontal,
            [StatusHudWindow]::WindowBorderHorizontal,
            [StatusHudWindow]::WindowBorderLeft,
            [StatusHudWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        $this.StatLineDrawDirty = $true
        $this.LineBlank = [ATString]@{
            UserData   = [StatusHudWindow]::LineBlankStr
            UseATReset = $true
        }
        $this.StatLineDrawCoords = [ATCoordinates]@{
            Row    = 2
            Column = 3
        }
        $this.StatSeparatorDrawCoords = [ATCoordinates]@{
            Row    = 2
            Column = [StatusHudWindow]::WindowRBColumn - 48
        }
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.StatLineDrawDirty -EQ $true) {
            $this.ComposeStatLineString()
            $this.LineBlank.Prefix.Coordinates = [ATCoordinates]::new($this.StatLineDrawCoords)
            Write-Host "$($this.LineBlank.ToAnsiControlSequenceString())$($this.StatLineActual.ToAnsiControlSequenceString())"
            $this.StatLineDrawDirty = $false
        }
    }

    [Void]ComposeStatLineString() {
        [String]$AtkStatFmtStr = ''
        [String]$DefStatFmtStr = ''
        [String]$MatStatFmtStr = ''
        [String]$MdfStatFmtStr = ''
        [String]$SpdStatFmtStr = ''
        [String]$AccStatFmtStr = ''
        [String]$LckStatFmtStr = ''
        [String]$AtkDispStr    = 'ATK:'
        [String]$DefDispStr    = 'DEF:'
        [String]$MatDispStr    = 'MAT:'
        [String]$MdfDispStr    = 'MDF:'
        [String]$SpdDispStr    = 'SPD:'
        [String]$AccDispStr    = 'ACC:'
        [String]$LckDispStr    = 'LCK:'

        If($Script:ThePlayer.Stats[[StatId]::Attack].Base -LT 10) {
            $AtkStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Attack].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Attack].Base -GE 10) {
            $AtkStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Attack].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Defense].Base -LT 10) {
            $DefStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Defense].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Defense].Base -GE 10) {
            $DefStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Defense].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::MagicAttack].Base -LT 10) {
            $MatStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::MagicAttack].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::MagicAttack].Base -GE 10) {
            $MatStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::MagicAttack].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::MagicDefense].Base -LT 10) {
            $MdfStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::MagicDefense].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::MagicDefense].Base -GE 10) {
            $MdfStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::MagicDefense].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Speed].Base -LT 10) {
            $SpdStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Speed].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Speed].Base -GE 10) {
            $SpdStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Speed].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Accuracy].Base -LT 10) {
            $AccStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Accuracy].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Accuracy].Base -GE 10) {
            $AccStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Accuracy].Base)"
        }
        If($Script:ThePlayer.Stats[[StatId]::Luck].Base -LT 10) {
            $LckStatFmtStr = "{0:d2}" -F $Script:ThePlayer.Stats[[StatId]::Luck].Base
        } Elseif($Script:ThePlayer.Stats[[StatId]::Luck].Base -GE 10) {
            $LckStatFmtStr = "$($Script:ThePlayer.Stats[[StatId]::Luck].Base)"
        }

        $this.StatLineActual = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.Affinity].Item2
                    Coordinates     = [ATCoordinates]::new($this.StatLineDrawCoords)
                }
                UserData = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.Affinity].Item1) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($Script:ThePlayer.Name)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]::new($this.StatSeparatorDrawCoords)
                }
                UserData = "$($AtkDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($AtkStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($DefDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($DefStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MatDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MatStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MdfDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($MdfStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($SpdDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($SpdStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundCOlor = [CCTextDefault24]::new()
                }
                UserData = "$($AccDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($AccStatFmtStr) "
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData = "$($LckDispStr)"
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = "$($LckStatFmtStr)"
                UseATReset = $true
            }
        ))
    }
}





###############################################################################
#
# STATUS TECHNIQUE SELECTION WINDOW
#
###############################################################################
Class StatusTechniqueSelectionWindow : WindowBase {
    Static [Int]$WindowLTRow    = 4
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 9
    Static [Int]$WindowRBColumn = 19

    Static [String]$WindowBorderHorizontal      = '*------------------*'
    Static [String]$WindowBorderLeft            = '|'
    Static [String]$WindowBorderRight           = '|'
    Static [String]$PlayerChevronCharacter      = '>'
    Static [String]$PlayerChevronBlankCharacter = ' '
    Static [String]$NameBlank                   = '               '

    Static [ATString]$PlayerChevron = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
        }
        UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PlayerChevronBlank = [ATString]@{
        UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
        UseATReset = $true
    }
    Static [ATString]$BaNameBlank = [ATString]@{
        Prefix     = [ATStringPrefix]::new()
        UserData   = "$([StatusTechniqueSelectionWindow]::NameBlank)"
        UseATReset = $true
    }

    [Int]$ActiveChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$ActionADrawDirty
    [Boolean]$ActionBDrawDirty
    [Boolean]$ActionCDrawDirty
    [Boolean]$ActionDDrawDirty
    [Boolean]$IsActive
    [ATCoordinates]$ActionADrawCoords
    [ATCoordinates]$ActionBDrawCoords
    [ATCoordinates]$ActionCDrawCoords
    [ATCoordinates]$ActionDDrawCoords
    [List[ValueTuple[[ATString], [Boolean]]]]$Chevrons

    StatusTechniqueSelectionWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusTechniqueSelectionWindow]::WindowLTRow
            Column = [StatusTechniqueSelectionWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusTechniqueSelectionWindow]::WindowRBRow
            Column = [StatusTechniqueSelectionWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusTechniqueSelectionWindow]::WindowBorderHorizontal,
            [StatusTechniqueSelectionWindow]::WindowBorderHorizontal,
            [StatusTechniqueSelectionWindow]::WindowBorderLeft,
            [StatusTechniqueSelectionWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        $this.ActiveChevronIndex = 0
        $this.PlayerChevronDirty = $true
        $this.ActiveItemBlinking = $false
        $this.ActionADrawDirty   = $true
        $this.ActionBDrawDirty   = $true
        $this.ActionCDrawDirty   = $true
        $this.ActionDDrawDirty   = $true
        $this.IsActive           = $true
        $this.ActionADrawCoords = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 3
        }
        $this.ActionBDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionADrawCoords.Row + 1
            Column = $this.ActionADrawCoords.Column
        }
        $this.ActionCDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionBDrawCoords.Row + 1
            Column = $this.ActionBDrawCoords.Column
        }
        $this.ActionDDrawCoords = [ATCoordinates]@{
            Row    = $this.ActionCDrawCoords.Row + 1
            Column = $this.ActionCDrawCoords.Column
        }
        $this.CreateChevrons()
    }

    [Void]CreateChevrons() {
        $this.Chevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionADrawCoords.Row
                            Column = $this.ActionADrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                    UseATReset = $true
                },
                $true
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionBDrawCoords.Row
                            Column = $this.ActionBDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionCDrawCoords.Row
                            Column = $this.ActionCDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
        $this.Chevrons.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAPpleGreenLight24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.ActionDDrawCoords.Row
                            Column = $this.ActionDDrawCoords.Column - 2
                        }
                    }
                    UserData   = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    UseATReset = $true
                },
                $false
            )
        )
    }

    [ATString]GetActiveChevron() {
        Foreach($a in $this.Chevrons) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
        }
        $this.ActiveChevronIndex                       = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2 = $true

        Return $this.Chevrons[$this.ActiveChevronIndex].Item1
    }

    [Void]ResetChevronPosition() {
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
        $this.ActiveChevronIndex                                = 0
        $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
        $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.ActionADrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionADrawCoords.Row
                Column = $this.ActionADrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::A].Type].Item2
                        Coordinates     = $this.ActionADrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::A].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::A].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionADrawDirty = $false
        }
        If($this.ActionBDrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionBDrawCoords.Row
                Column = $this.ActionBDrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::B].Type].Item2
                        Coordinates     = $this.ActionBDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::B].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::B].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionBDrawDirty = $false
        }
        If($this.ActionCDrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionCDrawCoords.Row
                Column = $this.ActionCDrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::C].Type].Item2
                        Coordinates     = $this.ActionCDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::C].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::C].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionCDrawDirty = $false
        }
        If($this.ActionDDrawDirty -EQ $true) {
            [StatusTechniqueSelectionWindow]::BaNameBlank.Prefix.Coordinates = [ATCoordinates]@{
                Row    = $this.ActionDDrawCoords.Row
                Column = $this.ActionDDrawCoords.Column + 1
            }
            [ATStringComposite]$a = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::D].Type].Item2
                        Coordinates     = $this.ActionDDrawCoords
                    }
                    UserData   = "$($Script:BATAdornmentCharTable[$Script:ThePlayer.ActionListing[[ActionSlot]::D].Type].Item1)"
                    UseATReset = $true
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                    }
                    UserData   = " $($Script:ThePlayer.ActionListing[[ActionSlot]::D].Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$([StatusTechniqueSelectionWindow]::BaNameBlank.ToAnsiControlSequenceString())$($a.ToAnsiControlSequenceString())"
            $this.ActionDDrawDirty = $false
        }
        If($this.PlayerChevronDirty -EQ $true) {
            If($this.IsActive -EQ $true) {
                Foreach($c in $this.Chevrons) {
                    $c.Item1.Prefix.ForegroundColor = [CCAppleNGreenLight24]::new()
                    Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
                }
            } Else {
                Foreach($c in $this.Chevrons) {
                    $c.Item1.Prefix.ForegroundColor = [CCAppleNOrangeLight24]::new()
                    Write-Host "$($c.Item1.ToAnsiControlSequenceString())"
                }
            }
            $this.PlayerChevronDirty = $false
        }
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 {
                Switch($this.ActiveChevronIndex) {
                    0 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::A
                    }

                    1 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::B
                    }

                    2 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::C
                    }

                    3 {
                        $Script:StatusEsSelectedSlot = [ActionSlot]::D
                    }
                }
                $Script:StatusScreenMode = [StatusScreenMode]::TechInventorySelection
            }

            27 {
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen
            }

            38 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }

                If(($this.ActiveChevronIndex - 1) -LT 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 3
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex--
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }

            40 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up'
                }
                If(($this.ActiveChevronIndex + 1) -GT 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex                                = 0
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                } Elseif(($this.ActiveChevronIndex + 1) -LE 3) {
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $false
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronBlankCharacter)"
                    $this.ActiveChevronIndex++
                    $this.Chevrons[$this.ActiveChevronIndex].Item2          = $true
                    $this.Chevrons[$this.ActiveChevronIndex].Item1.UserData = "$([StatusTechniqueSelectionWindow]::PlayerChevronCharacter)"
                }
                $this.PlayerChevronDirty = $true
            }
        }
    }

    [Void]SetAllActionDrawDirty() {
        $this.ActionADrawDirty = $true
        $this.ActionBDrawDirty = $true
        $this.ActionCDrawDirty = $true
        $this.ActionDDrawDirty = $true
    }
}





###############################################################################
#
# STATUS TECHNIQUE INVENTORY WINDOW
#
###############################################################################
Class StatusTechniqueInventoryWindow : WindowBase {
    Static [Int]$WindowLTRow    = 4
    Static [Int]$WindowLTColumn = 22
    Static [Int]$WindowRBRow    = 16
    Static [Int]$WindowRBColumn = 80

    Static [String]$WindowBorderHorizontal      = '*----------------------------------------------------------*'
    Static [String]$WindowBorderLeft            = '|'
    Static [String]$WindowBorderRight           = '|'
    Static [String]$IChevronCharacter           = '>'
    Static [String]$IChevronCharacterBlank      = ' '
    Static [String]$PagingChevronRightCharacter = '>'
    Static [String]$PagingChevronLeftCharacter  = '<'
    Static [String]$PagingChevronBlankCharacter = ' '
    Static [String]$DivLineHorizontalString     = '----------------------------------------------------------'
    Static [String]$ZpLineBlank                 = '                                                          '
    Static [String]$DescLineBlank               = '                                                          '
    Static [String]$ZeroPagePrompt              = 'You have no techniques in your inventory.'

    Static [ATString]$PagingChevronRight = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
        }
        UserData   = "$([StatusTechniqueInventoryWindow]::PagingChevronRightCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeft = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCAppleYellowLight24]::new()
        }
        UserData   = "$([StatusTechniqueInventoryWindow]::PagingChevronLeftCharacter)"
        UseATReset = $true
    }
    Static [ATString]$PagingChevronRightBlank = [ATStringNone]::new()
    Static [ATString]$PagingChevronLeftBlank = [ATStringNone]::new()
    Static [ATString]$DivLineHorizontal = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCTextDefault24]::new()
        }
        UserData   = "$([StatusTechniqueInventoryWindow]::DivLineHorizontalString)"
        UseATReset = $true
    }

    Static [Boolean]$DebugMode = $false

    [Int]$ItemsPerPage
    [Int]$NumPages
    [Int]$CurrentPage
    [Int]$ActiveIChevronIndex
    [Boolean]$PlayerChevronDirty
    [Boolean]$PagingChevronRightDirty
    [Boolean]$PagingChevronLeftDirty
    [Boolean]$ItemsListDirty
    [Boolean]$CurrentPageDirty
    [Boolean]$PlayerChevronVisible
    [Boolean]$PagingChevronRightVisible
    [Boolean]$PagingChevronLeftVisible
    [Boolean]$ZeroPageActive
    [Boolean]$BookDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$DivLineDirty
    [Boolean]$ItemDescDirty
    [Boolean]$ZpBlankedDirty
    [Boolean]$ZpPromptDirty
    [Boolean]$IsActive
    [Boolean]$IsBlanked
    [List[ATString]]$ItemLabels
    [List[ATString]]$ItemLabelBlanks
    [List[BattleAction]]$PageRefs
    [List[ValueTuple[[ATString], [Boolean]]]]$IChevrons

    StatusTechniqueInventoryWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusTechniqueInventoryWindow]::WindowLTRow
            Column = [StatusTechniqueInventoryWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusTechniqueInventoryWindow]::WindowRBRow
            Column = [StatusTechniqueInventoryWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [StatusTechniqueInventoryWindow]::WindowBorderHorizontal,
            [StatusTechniqueInventoryWindow]::WindowBorderHorizontal,
            [StatusTechniqueInventoryWindow]::WindowBorderLeft,
            [StatusTechniqueInventoryWindow]::WindowBorderRight
        )
        $this.UpdateDimensions()

        $this.ItemsPerPage              = 10
        $this.NumPages                  = 1
        $this.CurrentPage               = 1
        $this.ActiveIChevronIndex       = 0
        $this.PlayerChevronDirty        = $true
        $this.PagingChevronRightDirty   = $true
        $this.PagingChevronLeftDirty    = $true
        $this.ItemsListDirty            = $true
        $this.CurrentPageDirty          = $true
        $this.PlayerChevronVisible      = $true
        $this.PagingChevronRightVisible = $false
        $this.PagingChevronLeftVisible  = $false
        $this.ZeroPageActive            = $false
        $this.BookDirty                 = $true
        $this.ActiveItemBlinking        = $false
        $this.DivLineDirty              = $true
        $this.ItemDescDirty             = $true
        $this.ZpBlankedDirty            = $true
        $this.ZpPromptDirty             = $true
        $this.IsActive                  = $false
        $this.IsBlanked                 = $false
        $this.PageRefs                  = $null

        $this.CreateIChevrons()
        $this.ConfigurePagingChevrons()
        $this.ConfigureDivLine()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.IsActive -EQ $true) {
            $this.IsBlanked = $false
            If($this.BookDirty -EQ $true) {
                $this.CalculateNumPages()
                $this.BookDirty = $false
            }
            If($this.CurrentPageDirty -EQ $true) {
                $this.PopulatePage()
            }
            If($this.ZeroPageActive -EQ $true) {
                $this.WriteZeroInventoryPage()
            } Else {
                If($this.DivLineDirty -EQ $true) {
                    Write-Host "$([StatusTechniqueInventoryWindow]::DivLineHorizontal.ToAnsiControlSequenceString())"
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
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                            $this.PagingChevronLeftVisible = $false
                            $this.PagingChevronLeftDirty   = $true
                        }
                        If($this.PagingChevronRightVisible -EQ $false) {
                            $this.PagingChevronRightVisible = $true
                        }
                        If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                            $this.PagingChevronRightDirty = $false
                        }
                    } Elseif(($this.CurrentPage -GT 1) -AND ($this.CurrentPage -LT $this.NumPages)) {
                        If($this.PagingChevronLeftVisible -EQ $false) {
                            $this.PagingChevronLeftVisible = $true
                        }
                        If($this.PagingChevronRightVisible -EQ $false) {
                            $this.PagingChevronRightVisible = $true
                        }
                        If(($this.PagingChevronRightVisible -EQ $true) -AND ($this.PagingChevronRightDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                            $this.PagingChevronRightDirty = $false
                        }
                        If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRight.ToAnsiControlSequenceString())"
                            $this.PagingChevronLeftDirty = $false
                        }
                    } Elseif($this.CurrentPage -GE $this.NumPages) {
                        If($this.PagingChevronRightVisible -EQ $true) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                            $this.PagingChevronRightVisible = $false
                            $this.PagingChevronRightDirty   = $true
                        }
                        If($this.PagingChevronLeftVisible -EQ $false) {
                            $this.PagingChevronLeftVisible = $true
                        }
                        If(($this.PagingChevronLeftVisible -EQ $true) -AND ($this.PagingChevronLeftDirty -EQ $true)) {
                            Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeft.ToAnsiControlSequenceString())"
                            $this.PagingChevronLeftDirty = $false
                        }
                    }
                } Elseif($this.NumPages -EQ 1) {
                    If($this.PagingChevronLeftVisible -EQ $true) {
                        $this.PagingChevronLeftVisible = $false
                    }
                    If($this.PagingChevronRightVisible -EQ $true) {
                        $this.PagingChevronRightVisible = $false
                    }
                    If($this.PagingChevronLeftVisible -EQ $false) {
                        Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronLeftBlank.ToAnsiControlSequenceString())"
                    }
                    If($this.PagingChevronRightVisible -EQ $false) {
                        Write-Host "$([StatusTechniqueInventoryWindow]::PagingChevronRightBlank.ToAnsiControlSequenceString())"
                    }
                }
                If($this.ActiveItemBlinking -EQ $false) {
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCListItemCurrentHighlight24]::new()
                    $this.ItemsListDirty                                               = $true
                    $this.ActiveItemBlinking                                           = $true
                }
                If($this.ItemsListDirty -EQ $true) {
                    $this.WriteItemLabels()
                    Write-Host "$([ATControlSequences]::CursorHide)"
                    $this.ItemsListDirty = $false
                }
                If($this.ItemDescDirty -EQ $true) {
                    [ATStringComposite]$a = [ATStringComposite]::new(@(
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 3
                                    Column = $this.LeftTop.Column + 1
                                }
                            }
                            UserData   = "$([StatusTechniqueInventoryWindow]::DescLineBlank)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 3
                                    Column = $this.LeftTop.Column + 2
                                }
                            }
                            UserData   = "$($this.PageRefs[$this.ActiveIChevronIndex].Description)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 1
                                    Column = $this.LeftTop.Column + 1
                                }
                            }
                            UserData   = "$([StatusTechniqueInventoryWindow]::DescLineBlank)"
                            UseATReset = $true
                        },
                        [ATString]@{
                            Prefix = [ATStringPrefix]@{
                                ForegroundColor = [CCTextDefault24]::new()
                                Coordinates     = [ATCoordinates]@{
                                    Row    = $this.RightBottom.Row - 1
                                    Column = $this.LeftTop.Column + 2
                                }
                            }
                            UserData   = "PWR: $($this.PageRefs[$this.ActiveIChevronIndex].EffectValue)   MP COST: $("{0:d2}" -F $this.PageRefs[$this.ActiveIChevronIndex].MpCost)   CHANCE: $("{0:f0}" -F ($this.PageRefs[$this.ActiveIChevronIndex].Chance * 100))%"
                            UseATReset = $true
                        }
                    ))
                    Write-Host "$($a.ToAnsiControlSequenceString())"
                }
            }
        } Else {
            If($this.IsBlanked -EQ $false) {
                Foreach($Row in 5..15) {
                    [ATString]$a = [ATString]@{
                        Prefix = [ATStringPrefix]@{
                            Coordinates = [ATCoordinates]@{
                                Row    = $Row
                                Column = $this.LeftTop.Column + 1
                            }
                        }
                        UserData   = "$([StatusTechniqueInventoryWindow]::ZpLineBlank)"
                        UseATReset = $true
                    }
                    Write-Host "$($a.ToAnsiControlSequenceString())"
                }
                $this.IsBlanked = $true
            }
        }
    }

    [Void]CreateIChevrons() {
        $this.IChevrons = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                UseATReset = $true
            },
            $true
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + 1
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
        $this.IChevrons.Add([ValueTuple]::Create(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleGreenLight24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.RightBottom.Column - 17
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                UseATReset = $true
            },
            $false
        ))
    }

    [Void]CreateItemLabels() {
        $this.ItemLabels = [List[ATString]]::new()
        [Int]$c = 0

        Foreach($i in $this.PageRefs) {
            $this.ItemLabels.Add(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.IChevrons[$c].Item1.Prefix.Coordinates.Row
                            Column = $this.IChevrons[$c].Item1.Prefix.Coordinates.Column + 2
                        }
                    }
                    UserData   = "$($i.Name)"
                    UseATReset = $true
                }
            )
            $c++ # TOTALLY A PROGRAMMER JOKE
        }
        $this.ResetIChevronPositions()
        $this.CreateItemLabelBlanks()
    }

    [Void]CreateItemLabelBlanks() {
        $this.ItemLabelBlanks = [List[ATString]]::new()
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.LeftTop.Column + 2
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 2
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 3
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 4
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 5
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
        $this.ItemLabelBlanks.Add(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 6
                        Column = $this.RightBottom.Column - 16
                    }
                }
                UserData   = '               '
                UseATReset = $true
            }
        )
    }

    [Void]CalculateNumPages() {
        $pp = $Script:ThePlayer.ActionInventory.Listing.Count / $this.ItemsPerPage
        If($pp -LT 1) {
            $this.NumPages = 1
        } Else {
            $this.NumPages = [Math]::Ceiling($pp)
        }
        If($this.CurrentPage -GT $this.NumPages) {
            $this.CurrentPage = $this.NumPages
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
        If($Script:ThePlayer.ActionInventory.Listing.Count -LE 0) {
            $this.ZeroPageActive   = $true
            $this.CurrentPageDirty = $false
            $this.ZpPromptDirty    = $true
            $this.ZpBlankedDirty   = $true
        } Else {
            $this.PageRefs       = [List[BattleAction]]::new()
            $this.ZeroPageActive = $false
            $rs                  = (($this.CurrentPage * $this.ItemsPerPage) - $this.ItemsPerPage)
            $rs                  = [Math]::Clamp($rs, 0, [Int]::MaxValue)
            $re                  = 10
            
            Try {
                $this.PageRefs = $Script:ThePlayer.ActionInventory.Listing.GetRange($rs, $re)
            } Catch {
                $this.PageRefs = $Script:ThePlayer.ActionInventory.Listing.GetRange($rs, ($Script:ThePlayer.ActionInventory.Listing.Count - $rs))
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
        $this.ActiveIChevronIndex                        = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2 = $true

        Return $this.IChevrons[$this.ActiveIChevronIndex].Item1
    }

    [Void]WriteZeroInventoryPage() {
        If($this.ZpBlankedDirty -EQ $true) {
            Foreach($a in 5..15) {
                [ATString]$b = [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        BackgroundColor = [CCAppleBlueDark24]::new()
                        Coordinates = [ATCoordinates]@{
                            Row    = $a
                            Column = $this.LeftTop.Column + 1
                        }
                    }
                    UserData   = "$([StatusTechniqueInventoryWindow]::ZpLineBlank)"
                    UseATReset = $true
                }
                Write-Host "$($b.ToAnsiControlSequenceString())"
            }
            $this.ZpBlankedDirty = $false
        }
        If($this.ZpPromptDirty -EQ $true) {
            [ATString]$a = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + ($this.Height / 2)
                        Column = $this.LeftTop.Column + (($this.Width / 2) - ([StatusTechniqueInventoryWindow]::ZeroPagePrompt.Length / 2))
                    }
                }
                UserData   = "$([StatusTechniqueInventoryWindow]::ZeroPagePrompt)"
                UseATReset = $true
            }
            Write-Host "$($a.ToAnsiControlSequenceString())"
            $this.ZpPromptDirty = $false
        }
    }

    [Void]WriteMoronPage() {}

    [Void]ResetIChevronPositions() {
        $this.IChevrons[$this.ActiveIChevronIndex].Item2          = $false
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
        Try {
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
            $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
        } Catch {}
        $this.ActiveIChevronIndex                                      = 0
        $this.IChevrons[$this.ActiveIChevronIndex].Item2               = $true
        $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData      = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations = [ATDecoration]@{
            Blink = $true
        }
        $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
        $this.PlayerChevronDirty                                           = $true
        $this.ActiveItemBlinking                                           = $false
        $this.ItemDescDirty                                                = $true
    }

    [Void]HandleInput() {
        $keyCap = $(Get-Host).UI.RawUI.ReadKey('IncludeKeyDown, NoEcho')
        Switch($keyCap.VirtualKeyCode) {
            13 {
                $Script:StatusIsSelected      = $this.PageRefs[$this.ActiveIChevronIndex]
                [BattleAction]$EquippedAction = $Script:ThePlayer.ActionListing[$Script:StatusEsSelectedSlot]
                If($null -EQ $EquippedAction) {
                    $Script:ThePlayer.ActionListing[$Script:StatusEsSelectedSlot] = [BattleAction]::new($Script:StatusIsSelected)
                    $Script:ThePlayer.ActionInventory.RemoveActionByName($Script:StatusIsSelected.Name)
                } Else {
                    [Int]$RootCollectionIndex = $this.CurrentPage -EQ 1 ? $this.ActiveIChevronIndex : ((($this.CurrentPage - 1) * $this.ItemsPerPage) + $this.ActiveIChevronIndex)
                    $Script:ThePlayer.ActionListing[$Script:StatusEsSelectedSlot]   = [BattleAction]::new($Script:StatusIsSelected)
                    $Script:ThePlayer.ActionInventory.Listing[$RootCollectionIndex] = [BattleAction]::new($EquippedAction)
                }
                $Script:StatusScreenMode = [StatusScreenMode]::EquippedTechSelection
            }

            27 {
                $Script:StatusScreenMode = [StatusScreenMode]::EquippedTechSelection
            }

            38 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex -1) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex--
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            40 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex + 1) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex++
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            39 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex + 5) -LT $this.PageRefs.Count) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex += 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCApplePinkLight24]::new()
                }
                $this.PlayerChevronDirty = $true
                $this.ActiveItemBlinking = $false
                $this.ItemDescDirty      = $true
            }

            37 {
                Try {
                    $Script:TheSfxMPlayer.Open($Script:SfxUiChevronMove)
                    $Script:TheSfxMPlayer.Play()
                } Catch {
                    Write-Host 'Blew up.'
                }
                If(($this.ActiveIChevronIndex - 5) -GE 0) {
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $false
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacterBlank)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecorationNone]::new()
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.ForegroundColor = [CCTextDefault24]::new()
                    $this.ActiveIChevronIndex -= 5
                    $this.IChevrons[$this.ActiveIChevronIndex].Item2                   = $true
                    $this.IChevrons[$this.ActiveIChevronIndex].Item1.UserData          = "$([StatusTechniqueInventoryWindow]::IChevronCharacter)"
                    $this.ItemLabels[$this.ActiveIChevronIndex].Prefix.Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
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
        }
    }

    [Void]ConfigurePagingChevrons() {
        [StatusTechniqueInventoryWindow]::PagingChevronRight.Prefix.Coordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.RightBottom.Column - 1
        }
        [StatusTechniqueInventoryWindow]::PagingChevronRightBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = ' '
            UseATReset = $true
        }
        [StatusTechniqueInventoryWindow]::PagingChevronRightBlank.Prefix.Coordinates = [ATCoordinates]::new([StatusTechniqueInventoryWindow]::PagingChevronRight.Prefix.Coordinates)
        [StatusTechniqueInventoryWindow]::PagingChevronLeft.Prefix.Coordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 2
        }
        [StatusTechniqueInventoryWindow]::PagingChevronLeftBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = ' '
            UseATReset = $true
        }
        [StatusTechniqueInventoryWindow]::PagingChevronLeftBlank.Prefix.Coordinates = [ATCoordinates]::new([StatusTechniqueInventoryWindow]::PagingChevronLeft.Prefix.Coordinates)
    }

    [Void]ConfigureDivLine() {
        [StatusTechniqueInventoryWindow]::DivLineHorizontal.Prefix.Coordinates = [ATCoordinates]@{
            Row    = $this.RightBottom.Row - 4
            Column = $this.LeftTop.Column + 1
        }
    }

    [Void]SetFlagsDirty() {
        $this.BookDirty        = $true
        $this.CurrentPageDirty = $true
        $this.DivLineDirty     = $true
        $this.CurrentPage      = 1
    }
}





###############################################################################
#
# BATTLE PHASE INDICATOR
#
###############################################################################
Class BattlePhaseIndicator {
    [Boolean]$IndicatorDrawDirty
    [ATCoordinates]$IndicatorDrawCoords
    [ATStringComposite]$IndicatorStringActual
    [ATStringComposite]$IndicatorStringBlank

    BattlePhaseIndicator() {
        $this.IndicatorDrawCoords = [ATCoordinates]@{
            Row    = 24
            Column = 1
        }
    }

    [Void]Draw(
        [BattleEntity]$ActingEntity
    ) {
        If($this.IndicatorDrawDirty -EQ $true) {
            $this.IndicatorStringBlank = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCApplePinkLight24]::new()
                        Coordinates     = $this.IndicatorDrawCoords
                    }
                    UserData = 'Turn: '
                },
                [ATString]@{
                    UserData   = '              '
                    UseATReset = $true
                }
            ))
            $this.IndicatorStringActual = [ATStringComposite]::new(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCApplePinkLight24]::new()
                        Coordinates     = $this.IndicatorDrawCoords
                    }
                    UserData = 'Turn: '
                },
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = $ActingEntity.NameDrawColor
                    }
                    UserData   = "$($ActingEntity.Name)"
                    UseATReset = $true
                }
            ))
            Write-Host "$($this.IndicatorStringBlank.ToAnsiControlSequenceString())$($this.IndicatorStringActual.ToAnsiControlSequenceString())"
            # I'M OMITTING THE ORIGINAL CALL I MADE HERE TO RESET THE CURSOR POSITION TO ORIGIN - SEEMS LIKE A SHIT CALL TO MAKE
            $this.IndicatorDrawDirty = $true
        }
    }
}





###############################################################################
#
# BATTLE MANAGER
#
# THIS CLASS IS SUBJECT TO SERIOUS REFACTORING AT THIS POINT. MOST OF THE CODE
# HERE IS TOTAL GARBAGE.
#
###############################################################################
Class BattleManager {
    [Int]$TurnCounter
    [Int]$TurnLimit
    [BattleEntity]$PhaseOneEntity
    [BattleEntity]$PhaseTwoEntity
    [BattleManagerState]$State

    # AT THIS POINT, I'VE OMITTED THE TWO ACTION FLAGS (THESE SHOULD COME FROM THE ENTITIES THEMSELVES)
    # AND THE SPOILS ACTION MEMBER; NOT SURE WHAT THE FUCK I NEEDED THAT THING FOR. I PROBABLY STILL
    # NEED IT, BUT I'LL WORK AROUND IT.

    BattleManager() {
        # THIS CTOR DID A WHOLE BUNCH OF CRAP THAT REALLY SHOULD BE IN THE STATE TABLE. I'M NOT DOING
        # THAT STUFF HERE.
    }

    [Void]Update() {
        # MAKE PRELIMINARY OUT-OF-BAND DRAW CALLS TO ENSURE THAT THE VISUAL DISPLAY IS KOSHER
        $Script:ThePlayer.Update()
        $Script:TheCurrentEnemy.Update()
        $Script:ThePlayerBattleStatWindow.Draw()
        $Script:TheEnemyBattleStatWindow.Draw()
        $Script:TheBattleEnemyImageWindow.Draw()
        $Script:ThePlayerBattleActionWindow.Draw()
        $Script:TheBattleStatusMessageWindow.Draw()
        $Script:Rui.CursorPosition = $([ATCoordinates]::new(0, 0)).ToAutomationCoordinates()

        # HERE COMES THE HONKER BLOCK
        # THESE CASES WERE ORIGINALLY UNSCOPED, WHICH IS FUCKING LAZY ON MY PART
        Switch($this.State) {
            ([BattleManagerState]::TurnIncrement) {
                If($this.TurnLimit -GT 0) {
                    If(($this.TurnCounter + 1) -GT $this.TurnLimit) {
                        $this.State = [BattleManagerState]::BattleLost

                        Return
                    }
                }
                $this.TurnCounter++
                $this.State = [BattleManagerState]::PhaseOrdering

                Return
            }

            ([BattleManagerState]::PhaseOrdering) {
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

            ([BattleManagerState]::PhaseAExecution) {
                # THE FIRST OF THE NASTY BLOCKS
                # DESPITE THIS BEING A SECOND PASS AT THIS CODE, I'LL BE COMMENTING ALONG THE WAY

                # BEFORE DOING ANYTHING, MAKE SURE THAT WE DON'T NEED TO CHANGE OUT TO THE CALCULATION STATE
                # THIS HELPS FACILITATE, PRIMARILY, THAT AN ENTITY CAN'T ACT IF THEY'RE ACTUALLY "DEAD"
                If(($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }

                # UPDATE THE PHASE INDICATOR
                $Script:TheBattlePhaseIndicator.IndicatorDrawDirty = $true
                $Script:TheBattlePhaseIndicator.Draw($this.PhaseOneEntity)

                # ENSURE THAT THE CORRESPONDING STATUS WINDOW HAS A HIGHLIGHT AROUND THE BORDER
                If($this.PhaseOneEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()

                # CHECK TO SEE IF THE PHASE ONE ENTITY CAN ACTUALLY ACT
                # REASONS THEY COULDN'T INCLUDE, BUT AREN'T LIMITED TO, STATUS AILMENTS LIKE SLEEP OR PARALYSIS
                If($this.PhaseOneEntity.CanAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    # DETERMINE IF THE PHASE ONE ENTITY IS THE PLAYER OR NOT
                    # DIFFERENT LOGIC NEEDS TO OCCUR DEPENDING UPON THIS DECISION
                    # IF IT'S THE PLAYER, WE NEED TO BLOCK LOOP ON THE BATTLE ACTION
                    # SELECTION WINDOW SO THE PLAYER CAN CHOOSE AN ATTACK TO EXECUTE.
                    If($this.PhaseOneEntity -IS [Player]) {
                        # REFRESH THE BATTLE ACTION SELECTION WINDOW AND BLOCK LOOP ON IT
                        # THE RESULT OF THE SELECTION IS STORED IN TOEXECUTE
                        # NOTE THAT THIS IMPLEMENTATION OF HANDLEINPUT IS AN ANTI-PATTERN
                        # BUT IS REQUIRED
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }

                        # THIS IS WHERE THINGS START GETTING HAIRY
                        # A LITANY OF CALLS TO WRITECOMPOSITEMESSAGE ON THE BATTLESTATUSMESSAGEWINDOW
                        # OCCUR FOLLOWING. I'M GOING TO ATTEMPT TO CONDENSE THESE CALLS.
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseOneEntity,
                            $this.PhaseTwoEntity,
                            $ToExecute
                        )

                        # ACTUALLY EXECUTE THE SELECTED COMMAND
                        # PS DOES SOME GOOFY SHIT WITH DISPATCHING THESE CALLS TO ICM, BUT THIS HASN'T CAUSED ANY PROBLEMS AFTER MANY HOURS
                        # OF TESTING THUS FAR.
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)

                        # REFRESH THE PLAYER BATTLE STATUS WINDOW
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        # THE PHASE ONE ENTITY IS THE ENEMY
                        # THE ACTION THE ENEMY USES IS SELECTED FROM THE "MARBLE BAG", SO NO DELAY IS NEEDED HERE.
                        [ActionSlot]$SelectedSlot = $($this.PhaseOneEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseOneEntity.ActionListing[$SelectedSlot]

                        # NOTIFY THE BATTLE STATUS MESSAGE WINDOW
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseOneEntity,
                            $this.PhaseTwoEntity,
                            $ToExecute
                        )

                        # EXECUTE THE ACTION AND UPDATE THE ENEMY'S BATTLE STATUS WINDOW
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }

                    # WE NEED TO EXAMINE THE ACTION RESULT TO SEE WHAT HAPPENED AS A CONSEQUENCE OF RUNNING THE SELECTED ACTION
                    # THIS IS DONE FIRST BY LOOKING AT THE VALUE OF THE TYPE PROPERTY
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSwc($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarCritAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSuccess($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailMissed($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailFailed($ToExecute)

                            Break
                        }
                    }

                    # NEXT WE NEED TO EXAMINE THE TYPE OF THE ACTION EXECUTED TO DO PROVIDE SOME
                    # ADDITIONAL FEEDBACK
                    Switch($ToExecute.Type) {
                        ([BattleActionType]::Physical) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatPhysical(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalFire) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalFire(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWater) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWater(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalEarth) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalEarth(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWind) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWind(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalLight) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalLight(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalDark) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalDark(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalIce) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalIce(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicPoison) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicConfuse) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicSleep) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicSleep(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicAging) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicAging(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicHealing) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicHealing(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicStatAugment) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            # TODO: I'M NOT SURE I'VE CODIFIED IN THE BATTLE RESULT FOR STAT AUGS.

                            Break
                        }
                    }
                } Else {
                    # THE PHASE ONE ENTITY CAN'T ACT AT THIS TIME
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}

                    $Script:TheBattleStatusMessageWindow.WriteEntityCantActMessage(
                        $this.PhaseOneEntity
                    )
                }

                # FACILITATE THE UPDATE OF AUGMENTS AT THE END OF THE TURN
                Foreach($Stat in $this.PhaseOneEntity.Stats.Values) {
                    $Stat.Update()
                    If($Stat.AugmentTurnDuration -EQ 0) {
                        If($this.PhaseOneEntity -IS [Player]) {
                            $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                            $Script:ThePlayerBattleStatWindow.Draw()
                        } Else {
                            $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                            $Script:TheEnemyBattleStatWindow.Draw()
                        }
                    }
                }

                # CHANGE STATE TO PHASE B
                $this.State = [BattleManagerState]::PhaseBExecution

                Break
            }

            ([BattleManagerState]::PhaseBExecution) {
                # THE SECOND OF THE NASTY BLOCKS
                # THIS IS A CARBON COPY OF PHASE A, EXCEPT THAT THE ENTITY CONSIDERED IS THE PHASETWOENTITY

                # BEFORE DOING ANYTHING, MAKE SURE THAT WE DON'T NEED TO CHANGE OUT TO THE CALCULATION STATE
                # THIS HELPS FACILITATE, PRIMARILY, THAT AN ENTITY CAN'T ACT IF THEY'RE ACTUALLY "DEAD"
                If(($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }

                # UPDATE THE PHASE INDICATOR
                $Script:TheBattlePhaseIndicator.IndicatorDrawDirty = $true
                $Script:TheBattlePhaseIndicator.Draw($this.PhaseTwoEntity)

                # ENSURE THAT THE CORRESPONDING STATUS WINDOW HAS A HIGHLIGHT AROUND THE BORDER
                If($this.PhaseTwoEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()

                # CHECK TO SEE IF THE PHASE TWO ENTITY CAN ACTUALLY ACT
                # REASONS THEY COULDN'T INCLUDE, BUT AREN'T LIMITED TO, STATUS AILMENTS LIKE SLEEP OR PARALYSIS
                If($this.PhaseTwoEntity.CanAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    # DETERMINE IF THE PHASE TWO ENTITY IS THE PLAYER OR NOT
                    # DIFFERENT LOGIC NEEDS TO OCCUR DEPENDING UPON THIS DECISION
                    # IF IT'S THE PLAYER, WE NEED TO BLOCK LOOP ON THE BATTLE ACTION
                    # SELECTION WINDOW SO THE PLAYER CAN CHOOSE AN ATTACK TO EXECUTE.
                    If($this.PhaseTwoEntity -IS [Player]) {
                        # REFRESH THE BATTLE ACTION SELECTION WINDOW AND BLOCK LOOP ON IT
                        # THE RESULT OF THE SELECTION IS STORED IN TOEXECUTE
                        # NOTE THAT THIS IMPLEMENTATION OF HANDLEINPUT IS AN ANTI-PATTERN
                        # BUT IS REQUIRED
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }

                        # THIS IS WHERE THINGS START GETTING HAIRY
                        # A LITANY OF CALLS TO WRITECOMPOSITEMESSAGE ON THE BATTLESTATUSMESSAGEWINDOW
                        # OCCUR FOLLOWING. I'M GOING TO ATTEMPT TO CONDENSE THESE CALLS.
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseTwoEntity,
                            $this.PhaseOneEntity,
                            $ToExecute
                        )

                        # ACTUALLY EXECUTE THE SELECTED COMMAND
                        # PS DOES SOME GOOFY SHIT WITH DISPATCHING THESE CALLS TO ICM, BUT THIS HASN'T CAUSED ANY PROBLEMS AFTER MANY HOURS
                        # OF TESTING THUS FAR.
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)

                        # REFRESH THE PLAYER BATTLE STATUS WINDOW
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        # THE PHASE TWO ENTITY IS THE ENEMY
                        # THE ACTION THE ENEMY USES IS SELECTED FROM THE "MARBLE BAG", SO NO DELAY IS NEEDED HERE.
                        [ActionSlot]$SelectedSlot = $($this.PhaseTwoEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseTwoEntity.ActionListing[$SelectedSlot]

                        # NOTIFY THE BATTLE STATUS MESSAGE WINDOW
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseTwoEntity,
                            $this.PhaseOneEntity,
                            $ToExecute
                        )

                        # EXECUTE THE ACTION AND UPDATE THE ENEMY'S BATTLE STATUS WINDOW
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }

                    # WE NEED TO EXAMINE THE ACTION RESULT TO SEE WHAT HAPPENED AS A CONSEQUENCE OF RUNNING THE SELECTED ACTION
                    # THIS IS DONE FIRST BY LOOKING AT THE VALUE OF THE TYPE PROPERTY
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSwc($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarCritAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSuccess($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailMissed($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailFailed($ToExecute)

                            Break
                        }
                    }

                    # NEXT WE NEED TO EXAMINE THE TYPE OF THE ACTION EXECUTED TO DO PROVIDE SOME
                    # ADDITIONAL FEEDBACK
                    Switch($ToExecute.Type) {
                        ([BattleActionType]::Physical) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatPhysical(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalFire) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalFire(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWater) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWater(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalEarth) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalEarth(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWind) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWind(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalLight) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalLight(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalDark) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalDark(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalIce) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalIce(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicPoison) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicConfuse) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicSleep) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicSleep(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicAging) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicAging(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicHealing) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicHealing(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicStatAugment) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            # TODO: I'M NOT SURE I'VE CODIFIED IN THE BATTLE RESULT FOR STAT AUGS.

                            Break
                        }
                    }
                } Else {
                    # THE PHASE ONE ENTITY CAN'T ACT AT THIS TIME
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}

                    $Script:TheBattleStatusMessageWindow.WriteEntityCantActMessage(
                        $this.PhaseTwoEntity
                    )
                }

                # FACILITATE THE UPDATE OF AUGMENTS AT THE END OF THE TURN
                Foreach($Stat in $this.PhaseTwoEntity.Stats.Values) {
                    $Stat.Update()
                    If($Stat.AugmentTurnDuration -EQ 0) {
                        If($this.PhaseOneEntity -IS [Player]) {
                            $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                            $Script:ThePlayerBattleStatWindow.Draw()
                        } Else {
                            $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                            $Script:TheEnemyBattleStatWindow.Draw()
                        }
                    }
                }

                # CHANGE STATE TO TURN INCREMENT
                $this.State = [BattleManagerState]::TurnIncrement

                Break
            }

            ([BattleManagerState]::Calculation) {
                # GIVEN HOW THIS STATE IS ENTERED, THIS MAY BE A REDUNDANT CHECK, BUT I DON'T CARE
                If($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseOneEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        # $this.SpoilsAction = $this.PhaseTwoEntity.SpoilsEffect
                        $this.State = [BattleManagerState]::BattleWon

                        Break
                    }
                } Elseif($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseTwoEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        # $this.SpoilsAction = $this.PhaseOneEntity.SpoilsEffect
                        $this.State = [BattleManagerState]::BattleWon

                        Break
                    }
                }

                # DO NOTHING, TRANSITION BACK TO TURN INCREMENT STATE
                $this.State = [BattleManagerState]::BattleWon

                Break
            }

            ([BattleManagerState]::BattleWon) {
                $Script:TheBgmMPlayer.Stop() # STOP PLAYING THE BATTLE BGM
                
                # CHECK TO SEE IF THE BATTLE WON CHIME HAS PLAYED
                # PLAY IT IF IT HASN'T
                If($Script:HasBattleWonChimePlayed -EQ $false) {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBattlePlayerWin)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:HasBattleWonChimePlayed = $true
                }

                # THE FOLLOWING CODE WILL WRITE TWO OUT-OF-BAND MESSAGES TO THE STATUS WINDOW
                # OUT-OF-BAND MEANING THAT EXPLICIT CALLS TO THE DRAW FUNCTION ARE MADE BECAUSE
                # THE NORMAL SEQUENCING WOULD CAUSE THESE TO NOT BE DRAWN IN TIME
                
                # WRITE THE WON MESSAGE TO THE STATUS WINDOW
                $Script:TheBattleStatusMessageWindow.WriteBattleWonMessage()
                $Script:TheBattleStatusMessageWindow.Draw()

                # RUN THE SPOILS EFFECT; NEED TO DETERMINE WHICH ENTITY IS THE PLAYER
                If($this.PhaseOneEntity -IS [Player]) {
                    # THE ORIGINAL CODE RESET THE SPOILSACTION MEMBER; NOT SURE WHY
                    # THE LIKELY CAUSE IS I'M AN IDIOT
                    Invoke-Command $this.PhaseTwoEntity.SpoilsEffect -ArgumentList ([Player]$this.PhaseOneEntity), ([EnemyBattleEntity]$this.PhaseTwoEntity)
                } Elseif($this.PhaseTwoEntity -IS [Player]) {
                    Invoke-Command $this.PhaseOneEntity.SpoilsEffect -ArgumentList ([Player]$this.PhaseTwoEntity), ([EnemyBattleEntity]$this.PhaseOneEntity)
                }

                # WRITE THE BATTLE END PROMPT
                $Script:TheBattleStatusMessageWindow.WriteBattleEndPrompt()
                $Script:TheBattleStatusMessageWindow.Draw()

                # BLOCK FOR THE ENTER KEY (ACKSHUALEE ENTER KEY)
                $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                While($a.VirtualKeyCode -NE 13) {
                    $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                }

                # CHANGE GLOBAL STATE
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen

                Break
            }

            ([BattleManagerState]::BattleLost) {
				$Script:TheBgmMPlayer.Stop() # STOP PLAYING THE BATTLE BGM
				
				# CHECK TO SEE IF THE BATTLE LOST CHIME HAS PLAYED
				# PLAY IT IF IT HASN'T
				If($Script:HasBattleLostChimePlayed -EQ $false) {
					Try {
						$Script:TheSfxMPlayer.Open($Script:SfxBattlePlayerLose)
						$Script:TheSfxMPlayer.Play()
					} Catch {}
					$Script:HasBattleLostChimPlayed = $true
				}
				
				# WRITE THE LOST MESSAGE TO THE STATUS WINDOW
				$Script:TheBattleStatusMessageWindow.WriteBattleLostMessage()
				$Script:TheBattleStatusMessageWindow.Draw()
				$Script:TheBattleStatusMessageWindow.WriteGameOverMessage()
				$Script:TheBattleStatusMessageWindow.Draw()
				
				# SLEEP THEN DIE
				Start-Sleep -Seconds 5
				Clear-Host
				
				Exit
			}

            Default {}
        }
    }

    [Void]Cleanup() {
        $Script:BattleCursorVisible          = $false
        $Script:HasBattleIntroPlayed         = $false
        $Script:IsBattleBgmPlaying           = $false
        $Script:HasBattleWonChimePlayed      = $false
        $Script:HasBattleLostChimePlayed     = $false
    }
}





###############################################################################
#
# GAME CORE
#
# ENTRY POINT FOR THE GAME PROGRAM
#
###############################################################################
Class GameCore {
    [Boolean]$GameRunning

    GameCore() {
        $this.GameRunning          = $true
        $Script:TheGlobalGameState = [GameStatePrimary]::GamePlayScreen
    }

    [Void]Run() {
        While($this.GameRunning -EQ $true) {
            $this.Logic()
        }
    }

    [Void]Logic() {
        Invoke-Command $Script:TheGlobalStateBlockTable[$Script:TheGlobalGameState]
        $Script:Rui.FlushInputBuffer()
    }
}





###############################################################################
#
# DUMMY SETUP CODE
#
###############################################################################
Clear-Host

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
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOLadder]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStairs]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOPole]::new()) | Out-Null
# $Script:ThePlayer.Inventory.Add([MTOBacon]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOApple]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOStick]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOYogurt]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORock]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTORope]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOTree]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOMilk]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOMilk]::new()) | Out-Null
$Script:ThePlayer.Inventory.Add([MTOMilk]::new()) | Out-Null

$Script:ThePlayer.ActionInventory.Add([BASwordStab]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAPunch]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAKick]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAKarateChop]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAKarateKick]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAFlamePunch]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAFlameKick]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BASwordStab]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAPunch]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAKick]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAKarateChop]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAKarateKick]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAFlamePunch]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAFlameKick]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BASeafoamBolt]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BATyphoon]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BATerraStrike]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BABoulderBash]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAIcicleStrike]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BAGaleStrike]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BARadiance]::new()) | Out-Null
$Script:ThePlayer.ActionInventory.Add([BASunfire]::new()) | Out-Null

# $Script:SampleMap.CreateMapTiles()
# $Script:SampleMap.Tiles[0, 0] = [MapTile]::new(
#     $Script:FieldNorthEastRoadImage,
#     @(
#         [MTOApple]::new(),
#         [MTOTree]::new(),
#         [MTOLadder]::new(),
#         [MTORope]::new(),
#         [MTOStairs]::new(),
#         [MTOPole]::new()
#     ),
#     @(
#         $true,
#         $false,
#         $true,
#         $false
#     ),
#     $true,
#     0.5,
#     0
# )
# $Script:SampleMap.Tiles[0, 1] = [MapTile]::new(
#     $Script:FieldNorthWestRoadImage,
#     @(
#         [MTOApple]::new()
#     ),
#     @(
#         $true,
#         $false,
#         $false,
#         $true
#     ),
#     $true,
#     0.5,
#     0
# )
# $Script:SampleMap.Tiles[1, 0] = [MapTile]::new(
#     $Script:FieldSouthEastRoadImage,
#     @(
#         [MTOTree]::new()
#     ),
#     @(
#         $false,
#         $true,
#         $true,
#         $false
#     ),
#     $true,
#     0.5,
#     0
# )
# $Script:SampleMap.Tiles[1, 1] = [MapTile]::new(
#     $Script:FieldSouthWestRoadImage,
#     @(
#         [MTOTree]::new()
#     ),
#     @(
#         $false,
#         $true,
#         $false,
#         $true
#     ),
#     $true,
#     0.5,
#     0
# )

$Script:TheGameCore.Run()
