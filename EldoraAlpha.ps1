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
$Script:Rui = $(Get-Host).UI.RawUI





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

    [GameStatePrimary]::GamePlayScreen = {}

    [GameStatePrimary]::InventoryScreen = {}

    [GameStatePrimary]::BattleScreen = {}

    [GameStatePrimary]::PlayerStatusScreen = {}

    [GameStatePrimary]::Cleanup = {}
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
        $this.Effect      = $null
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

    # BattleAction(
    #     [BattleAction]$Copy
    # ) {
    #     $this.Name        = $Copy.Name
    #     $this.Type        = $Copy.Type
    #     $this.Effect      = $Copy.Effect
    #     $this.PreCalc     = $Copy.PreCalc
    #     $this.PostCalc    = $Copy.PostCalc
    #     $this.MpCost      = $Copy.MpCost
    #     $this.EffectValue = $Copy.EffectValue
    #     $this.Chance      = $Copy.Chance
    #     $this.Description = $Copy.Description
    # }
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

    EnemyBattleEntity() : base() {
        $this.Image = $null
        $this.SpoilsGold = 0
        $this.SpoilsItems = @()
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
        $this.Image       = $Image
        $this.SpoilsGold  = 0
        $this.SpoilsItems = @()

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

    #     Foreach($a in $TargetOfFilter) {
    #         $this.TargetOfFilter.Add($a) | Out-Null
    #     }
    # }

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
        $this.Listing.Add([BattleAction]::new($ActionToAdd))

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
    SIFieldNorthRoad() : base() {
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
    SIFieldNorthEastRoad() : base() {
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
    SIFieldNorthWestRoad() : base() {
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
    SIFieldNorthEastWestRoad() : base() {
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
    SIFieldSouthRoad() : base() {
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
    SIFieldSouthEastRoad() : base() {
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
    SIFieldSouthWestRoad() : base() {
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
    SIFieldSouthEastWestRoad() : base() {
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
                    $Script:TheMessageWindow.WriteMessageComposite(
                        @(
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                'I''ve tied the '
                            ),
                            [ATStringCompositeSc]::new(
                                [CCAppleYellowDark24]::new(),
                                [ATDecoration]@{
                                    Blink     = $true
                                    Italic    = $true
                                    Underline = $true
                                },
                                'Rope'
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' to the '
                            ),
                            [ATStringCompositeSc]::new(
                                [CCAppleYellowDark24]::new(),
                                [ATDecoration]@{
                                    Blink     = $true
                                    Italic    = $true
                                    Underline = $true
                                },
                                'Tree'
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                '.'
                            )
                        )
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
                            $Script:TheMessageWindow.WriteMessageComposite(
                                @(
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'Now that wasn''t very smart, was it?'
                                    )
                                )
                            )
                            $Source.RemoveInventoryItemByName($Self.Name)
                        } Else {
                            $Script:TheMessageWindow.WriteMessageComposite(
                                @(
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'There''s no need to drink this now.'
                                    )
                                )
                            )
                        }
                    } Else {
                        # The milk isn't spoiled - attempt to increment the Player's Hp by the Hp Bonus
                        # Attempt to increment the Player's HP by the Hp Bonus
                        If($Script:ThePlayer.IncrementHitPoints($Self.PlayerHpBonus) -EQ $true) {
                            $Script:TheMessageWindow.WriteMessageComposite(
                                @(
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'Hmmm. Delicious cow juice.'
                                    )
                                )
                            )
                            $Script:ThePlayer.RemoveInventoryItemByName($Self.Name)
                        } Else {
                            $Script:TheMessageWindow.WriteMessageComposite(
                                @(
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'There''s no need to drink this now.'
                                    )
                                )
                            )
                        }
                    }
                }
            }
        }

        $a = $(Get-Random -Minimum 0 -Maximum 10)
        $this.PlayerHpBonus = 75
        $this.IsSpoiled = $($a -GE 6 ? $true : $false)
        If($this.IsSpoiled -EQ $true) {
            $this.ExamineString      = 'This looks funny. Should I really be drinking this?'
            $this.PlayerEffectString = "-$($this.PlayerHpBonus) HP, 10% chance to inflict Poison"
        } Else {
            $this.PlayerEffectString = "+$($this.PlayerHpBonus) HP"
        }
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
            UserData   = [StatusWindow]::LineBlank
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
                }
            }
            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerHpDrawCoordinates.Row, [StatusWindow]::PlayerHpDrawCoordinates.Column)
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

            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerMpDrawCoordinates.Row, [StatusWindow]::PlayerHpDrawCoordinates.Column)
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
            $this.LineBlankActual.Prefix.Coordinates = [ATCoordinates]::new([StatusWindow]::PlayerGoldDrawCoordinates.Row, [StatusWindow]::PlayerGoldDrawCoordinates.Column)
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

    CommandWindow() {
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
            [CommandWindow]::WindowBorderVertical
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
            $Script:TheMessageWindow.WriteMessageComposite(
                @(
                    [ATStringCompositeSc]::new(
                        [CCAppleNRedDark24]::new(),
                        [ATDecorationNone]::new(),
                        "$($Script:BadCommandRetorts | Get-Random)"
                    )
                )
            )
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

    SceneWindow() {
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

    MessageWindow() {
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
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCAppleRedDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $Command
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    ' isn''t a valid command.'
                )
            )
        )
    }

    [Void]WriteBadArg0Message(
        [String]$Command,
        [String]$Arg0
    ) {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'We can''t '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $Command
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    ' with a(n) '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink     = $true
                        Italic    = $true
                        Underline = $true
                    },
                    $Arg0
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    '.'
                )
            )
        )
    }

    [Void]WriteBadArg1Message(
        [String]$Command,
        [String]$Arg0,
        [String]$Arg1
    ) {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'We can''t '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $Command
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    ' with a(n) '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink     = $true
                        Italic    = $true
                        Underline = $true
                    },
                    $Arg0
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    ' and a(n) '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink     = $true
                        Italic    = $true
                        Underline = $true
                    },
                    $Arg1
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    '.'
                )
            )
        )
    }

    [Void]WriteSomethingBadMessage() {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'I''m God, and I don''t know what just happened...'
                )
            )
        )
    }

    [Void]WriteInvisibleWallEncounteredMessage() {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'The invisible wall blocks your path...'
                )
            )
        )
    }

    [Void]WriteYouShallNotPassMessage() {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'The path you asked for is impossible...'
                )
            )
        )
    }

    [Void]WriteMapNoItemsFoundMessage() {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'There''s nothing of interest here.'
                )
            )
        )
    }

    [Void]WriteMapInvalidItemMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'There''s no '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $ItemName
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    ' here.'
                )
            )
        )
    }

    [Void]WriteItemTakenMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'I''ve taken the '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $ItemName
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    ' and put it in my pocket.'
                )
            )
        )
    }

    [Void]WriteItemCantTakeMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    'It''s not possible to take the '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $ItemName
                ),
                [ATStringCompositeSc]::new(
                    [CCTextDefault24]::new(),
                    [ATDecorationNone]::new(),
                    '.'
                )
            )
        )
    }

    [Void]WriteCmdExtraArgsWarning(
        [String]$Command,
        [String[]]$ExtraArgs
    ) {
        $this.WriteMessageComposite(
            @(
                [ATStringCompositeSc]::new(
                    [CCAppleNPinkLight24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $Command
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleNYellowLight24]::new(),
                    [ATDecorationNone]::new(),
                    ' has garbage: '
                ),
                [ATStringCompositeSc]::new(
                    [CCAppleNYellowDark24]::new(),
                    [ATDecoration]@{
                        Blink = $true
                    },
                    $ExtraArgs
                )
            )
        )
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
        UserData   = [InventoryWindow]::PagingChevronRightCharacter
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
        UserData   = [InventoryWindow]::PagingChevronLeftCharacter
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
        UserData   = [InventoryWindow]::PagingChevronBlankCharacter
        UseATReset = $true
    }
    Static [ATString]$PagingChevronLeftBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            Coordinates = [ATCoordinates]@{
                Row    = 2
                Column = 3
            }
        }
        UserData   = [InventoryWindow]::PagingChevronBlankCharacter
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

    InventoryWindow() {
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
                    Coordinats      = [ATCoordinates]@{
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
    [Int]$WindowBRRow
    [Int]$WindowBRColumn
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

    BattleEntityStatusWindow() {
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
            Row    = $this.LeftTop.Row + 2
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
            $this.FullLineBlank.Prefix.Coordinates = $this.NameDrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.NameDrawString.ToAnsiControlSequenceString())"
            $this.NameDrawDirty = $false
        }
        If($this.HpDrawDirty -EQ $true) {
            $this.CreateHpDrawString()
            $this.FullLineBlank.Prefix.Coordinates = $this.HpDrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())"
            $this.FullLineBlank.Prefix.Coordinates.Row++
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.MpDrawString.ToAnsiControlSequenceString())"
            $this.HpDrawDirty = $false
        }
        If($this.MpDrawDirty -EQ $true) {
            $this.CreateMpDrawString()
            $this.FullLineBlank.Prefix.Coordinates = $this.MpDrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.MpDrawString.ToAnsiControlSequenceString())"
            $this.MpDrawDirty = $false
        }
        If($this.StatL1DrawDirty -EQ $true) {
            $this.CreateStatL1DrawString()
            $this.FullLineBlank.Prefix.Coordinates = $this.StatL1DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL1DrawString.ToAnsiControlSequenceString())"
            $this.StatL1DrawDirty = $false
        }
        If($this.StatL2DrawDirty -EQ $true) {
            $this.CreateStatL2DrawString()
            $this.FullLineBlank.Prefix.Coordinates = $this.StatL2DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL2DrawString.ToAnsiControlSequenceString())"
            $this.StatL2DrawDirty = $false
        }
        If($this.StatL3DrawDirty -EQ $true) {
            $this.CreateStatL3DrawString()
            $this.FullLineBlank.Prefix.Coordinates = $this.StatL3DrawCoordinates
            Write-Host "$($this.FullLineBlank.ToAnsiControlSequenceString())$($this.StatL3DrawString.ToAnsiControlSequenceString())"
            $this.StatL3DrawDirty = $false
        }
        If($this.StatL4DrawDirty -EQ $true) {
            $this.CreateStatL4DrawString()
            $this.FullLineBlank.Prefix.Coordinats = $this.StatL4DrawCoordinates
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
                        Row    = $this.HpDrawCoordinates.Row + 2
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
                        Row    = $this.MpDrawCoordinates.Row + 2
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