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