using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host
using namespace System.Media

Add-Type -AssemblyName PresentationCore





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