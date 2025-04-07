. "$PSScriptRoot\Enums.ps1"

Set-StrictMode -Version Latest

<#
.SYNOPSIS
Sets a variable in the global scope with the prefix ELD:.

.PARAMETER Name
The name of the variable. This name will automatically have the ELD: prefix prepended to it.

.PARAMETER Value
The value to assign to this variable. It's System.Object so that it can be anything.

.PARAMETER ReadOnly
Specify if this variable is intended to be readonly.
#>
Function Set-EldVar {
    [CmdletBinding()]
    Param(
        [String]$Name,
        [Object]$Value,
        [Switch]$ReadOnly
    )

    Process {
        If($ReadOnly) {
            Set-Variable -Name "ELD:$Name" -Value $Value -Option ReadOnly -Scope Global
        } Else {
            Set-Variable -Name "ELD:$Name" -Value $Value -Scope Global
        }
    }
}

<#
.SYNOPSIS
Removes all variables in the global scope with an ELD: prefix.
#>
Function Remove-EldVars {
    Process {
        $Vars = Get-ChildItem -Path Variable: | Where-Object { $_.Name -LIKE 'ELD:*' }
        Foreach($V in $Vars) {
            Remove-Variable -Name $V.Name -Scope Global -Force
        }
    }
}

<#
.SYNOPSIS
Retreives a specific variable with an ELD: prefix.

.PARAMETER Name
The name of the ELD: variable to get, not including the ELD: prefix.

.OUTPUTS
PSVariable or throws System.Exception
#>
Function Get-EldVar {
    [CmdletBinding()]
    Param(
        [String]$Name
    )

    Process {
        $VarVal = Get-Variable -Name "ELD:$Name" -Scope Global
        If($VarVal) {
            Return $VarVal
        } Else {
            Throw [System.Exception]::new("Failed to find variable ELD:$Name in the global scope.")
        }
    }
}

<#
.SYNOPSIS
Initializes all the Eldoria variables in the global scope.

.DESCRIPTION
This is largely a translation from the collection of script-level variables in the original game script. All this is doing is placing the variables
in the Variable PSDrive in the global scope rather than, as was the case with the single script, at script level.
#>
Function Initialize-EldVars {
    Process {
        Set-EldVar -Name 'SceneImagesToLoad' -Value ($(Get-ChildItem "$($PSScriptRoot)\..\Data\Image Data").Count) -ReadOnly
        Set-EldVar -Name 'SceneImagesLoaded' -Value 0
        Set-EldVar -Name 'SfxUiChevronMove' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\UI Chevron Move.wav" -ReadOnly
        Set-EldVar -Name 'SfxUiSelectionValid' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\UI Selection Valid.wav" -ReadOnly
        Set-EldVar -Name 'SfxBaPhysicalStrikeA' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\BA Physical Strike 0001.wav" -ReadOnly
        Set-EldVar -Name 'SfxBaMissFail' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\BA Miss Fail.wav" -ReadOnly
        Set-EldVar -Name 'SfxBaActionDisabled' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\BA Action Disabled.wav" -ReadOnly
        Set-EldVar -Name 'SfxBaFireStrikeA' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\BA Fire Strike 0001.wav" -ReadOnly
        Set-EldVar -Name 'SfxBattleIntro' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\Battle Intro.wav" -ReadOnly
        Set-EldVar -Name 'SfxBattlePlayerWin' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\Battle Player Win.wav" -ReadOnly
        Set-EldVar -Name 'SfxBattlePlayerLose' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\Battle Player Lose.wav" -ReadOnly
        Set-EldVar -Name 'BgmBattleThemeA' -Value "$($PSScriptRoot)\..\Data\Assets\BGM\Battle Theme A.wav" -ReadOnly
        Set-EldVar -Name 'SfxBattleNem' -Value "$($PSScriptRoot)\..\Data\Assets\SFX\UI Selection NEM.wav" -ReadOnly
        Set-EldVar -Name 'BadCommandRetorts' -Value @()
        Set-EldVar -Name 'TheStatusWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheCommandWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheSceneWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheMessageWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheInventoryWindow' -Value ([Object]::new())
        Set-EldVar -Name 'DefaultCursorCoordinates' -Value ([Object]::new())
        Set-EldVar -Name 'ThePlayerBattleStatWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheEnemyBattleStatWindow' -Value ([Object]::new())
        Set-EldVar -Name 'ThePlayerBattleActionWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheBattleStatusMessageWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheBattleEnemyImageWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheBattlePhaseIndicator' -Value ([Object]::new())
        Set-EldVar -Name 'TheStatusHudWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheStatusTechSelectionWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheStatusTechInventoryWindow' -Value ([Object]::new())
        Set-EldVar -Name 'TheBufferManager' -Value ([Object]::new())
        Set-EldVar -Name 'TheGameCore' -Value ([Object]::new())
        Set-EldVar -Name 'TheCurrentEnemy' -Value ([Object]::new())
        Set-EldVar -Name 'TheBattleManager' -Value ([Object]::new())
        Set-EldVar -Name 'TheSfxMachine' -Value ([Object]::new())
        Set-EldVar -Name 'TheBgmMachine' -Value ([Object]::new())
        Set-EldVar -Name 'IsBattleBgmPlaying' -Value $false
        Set-EldVar -Name 'HasBattleIntroPlayed' -Value $false
        Set-EldVar -Name 'HasBattleWonChimePlayed' -Value $false
        Set-EldVar -Name 'HasBattleLostChimePlayed' -Value $false
        Set-EldVar -Name 'GpsRestoredFromInvBackup' -Value $true
        Set-EldVar -Name 'GpsRestoredFromBatBackup' -Value $false
        Set-EldVar -Name 'GpsRestoredFromStaBackup' -Value $false
        Set-EldVar -Name 'BattleCursorVisible' -Value $false
        Set-EldVar -Name 'EeiBat' -Value ([Object]::new())
        Set-EldVar -Name 'EeiNightwing' -Value ([Object]::new())
        Set-EldVar -Name 'EeiWingblight' -Value ([Object]::new())
        Set-EldVar -Name 'EeiDarkfang' -Value ([Object]::new())
        Set-EldVar -Name 'EeiNocturna' -Value ([Object]::new())
        Set-EldVar -Name 'EeiBloodswoop' -Value ([Object]::new())
        Set-EldVar -Name 'EeiDuskbane' -Value ([Object]::new())
        Set-EldVar -Name 'TheSfxMPlayer' -Value ([System.Windows.Media.MediaPlayer]::new())
        Set-EldVar -Name 'TheBgmMPlayer' -Value ([System.Windows.Media.MediaPlayer]::new())
        Set-EldVar -Name 'AffinityMultNeg' -Value -0.75 -ReadOnly
        Set-EldVar -Name 'AffinityMultPos' -Value 1.6 -ReadOnly
        Set-EldVar -Name 'StatusEsSelectedSlot' -Value ([ActionSlot]::None)
        Set-EldVar -Name 'StatusIsSelected' -Value ([Object]::new())
        Set-EldVar -Name 'StatusScreenMode' -Value ([StatusScreenMode]::EquippedTechSelection)
        Set-EldVar -Name 'TheGlobalGameState' -Value ([GameStatePrimary]::GamePlayScreen)
        Set-EldVar -Name 'SampleMap' -Value ([Object]::new())
        Set-EldVar -Name 'SampleWarpMap01' -Value ([Object]::new())
        Set-EldVar -Name 'SampleWarpMap02' -Value ([Object]::new())
        Set-EldVar -Name 'CurrentMap' -Value ([Object]::new())
        Set-EldVar -Name 'PreviousMap' -Value ([Object]::new())
        Set-EldVar -Name 'TheSceneImages' -Value @{}
        Set-EldVar -Name 'MapWarpHandler' -Value {}
        Set-EldVar -Name 'BattleEncounterRegionTable' -Value @{}
        Set-EldVar -Name 'BATAdornmentCharTable' -Value @{}
        Set-EldVar -Name 'BATLut' -Value @{}
        Set-EldVar -Name 'Rui' -Value ($(Get-Host).UI.RawUI)
        Set-EldVar -Name 'TheSplashScreenAState' -Value {}
        Set-EldVar -Name 'TheSplashScreenBState' -Value {}
        Set-EldVar -Name 'TheTitleScreenState' -Value {}
        Set-EldVar -Name 'TheGamePlayScreenState' -Value {}
        Set-EldVar -Name 'TheInventoryScreenState' -Value {}
        Set-EldVar -Name 'TheBattleScreenState' -Value {}
        Set-EldVar -Name 'ThePlayerStatusScreenState' -Value {}
        Set-EldVar -Name 'TheCleanupState' -Value {}
        Set-EldVar -Name 'TheMoveCommand' -Value {}
        Set-EldVar -Name 'TheLookCommand' -Value {}
        Set-EldVar -Name 'TheInventoryCommand' -Value {}
        Set-EldVar -Name 'TheExamineCommand' -Value {}
        Set-EldVar -Name 'TheGetCommand' -Value {}
        Set-EldVar -Name 'TheUseCommand' -Value {}
        Set-EldVar -Name 'TheDropCommand' -Value {}
        Set-EldVar -Name 'TheStatusCommand' -Value {}
        Set-EldVar -Name 'TheEnterCommand' -Value {}
        Set-EldVar -Name 'TheCommandTable' -Value @{}
        Set-EldVar -Name 'BaCalc' -Value {}
        Set-EldVar -Name 'ThePlayer' -Value ([Object]::new())
        Set-EldVar -Name 'TheGlobalStateBlockTable' -Value @{}
        Set-EldVar -Name 'CCBlack24' -Value @(0, 0, 0) -ReadOnly
        Set-EldVar -Name 'CCWhite24' -Value @(255, 255, 255) -ReadOnly
        Set-EldVar -Name 'CCRed24' -Value @(255, 0, 0) -ReadOnly
        Set-EldVar -Name 'CCGreen24' -Value @(0, 255, 0) -ReadOnly
        Set-EldVar -Name 'CCBlue24' -Value @(0, 0, 255) -ReadOnly
        Set-EldVar -Name 'CCYellow24' -Value @(255, 255, 0) -ReadOnly
        Set-EldVar -Name 'CCDarkYellow24' -Value @(255, 204, 0) -ReadOnly
        Set-EldVar -Name 'CCDarkCyan24' -Value @(0, 139, 139) -ReadOnly
        Set-EldVar -Name 'CCDarkGrey24' -Value @(45, 45, 45) -ReadOnly
        Set-EldVar -Name 'CCAppleRedLight24' -Value @(255, 59, 48) -ReadOnly
        Set-EldVar -Name 'CCAppleRedDark24' -Value @(255, 69, 58) -ReadOnly
        Set-EldVar -Name 'CCAppleOrangeLight24' -Value @(255, 149, 0) -ReadOnly
        Set-EldVar -Name 'CCAppleOrangeDark24' -Value @(255, 159, 10) -ReadOnly
        Set-EldVar -Name 'CCAppleYellowLight24' -Value @(255, 204, 0) -ReadOnly
        Set-EldVar -Name 'CCAppleYellowDark24' -Value @(255, 214, 10) -ReadOnly
        Set-EldVar -Name 'CCAppleGreenLight24' -Value @(52, 199, 89) -ReadOnly
        Set-EldVar -Name 'CCAppleGreenDark24' -Value @(48, 209, 88) -ReadOnly
        Set-EldVar -Name 'CCAppleMintLight24' -Value @(0, 199, 190) -ReadOnly
        Set-EldVar -Name 'CCAppleMintDark24' -Value @(99, 230, 226) -ReadOnly
        Set-EldVar -Name 'CCAppleTealLight24' -Value @(48, 176, 199) -ReadOnly
        Set-EldVar -Name 'CCAppleTealDark24' -Value @(64, 200, 224) -ReadOnly
        Set-EldVar -Name 'CCAppleCyanLight24' -Value @(50, 173, 230) -ReadOnly
        Set-EldVar -Name 'CCAppleCyanDark24' -Value @(100, 210, 255) -ReadOnly
        Set-EldVar -Name 'CCAppleBlueLight24' -Value @(0, 122, 255) -ReadOnly
        Set-EldVar -Name 'CCAppleBlueDark24' -Value @(10, 132, 255) -ReadOnly
        Set-EldVar -Name 'CCAppleIndigoLight24' -Value @(88, 86, 214) -ReadOnly
        Set-EldVar -Name 'CCAppleIndigoDark24' -Value @(94, 92, 230) -ReadOnly
        Set-EldVar -Name 'CCApplePurpleLight24' -Value @(175, 82, 222) -ReadOnly
        Set-EldVar -Name 'CCApplePurpleDark24' -Value @(191, 90, 242) -ReadOnly
        Set-EldVar -Name 'CCApplePinkLight24' -Value @(255, 45, 85) -ReadOnly
        Set-EldVar -Name 'CCApplePinkDark24' -Value @(255, 55, 95) -ReadOnly
        Set-EldVar -Name 'CCAppleBrownLight24' -Value @(162, 132, 94) -ReadOnly
        Set-EldVar -Name 'CCAppleBrownDark24' -Value @(172, 142, 104) -ReadOnly
        Set-EldVar -Name 'CCAppleGrey1Light24' -Value @(142, 142, 147) -ReadOnly
        Set-EldVar -Name 'AnsiFgCol24Prefix' -Value "`e[38;2;" -ReadOnly
        Set-EldVar -Name 'AnsiBgCol24Prefix' -Value "`e[48;2;" -ReadOnly
        Set-EldVar -Name 'AnsiDecoBlink' -Value "`e[5m" -ReadOnly
        Set-EldVar -Name 'AnsiDecoItalic' -Value "`e[3m" -ReadOnly
        Set-EldVar -Name 'AnsiDecoUnderline' -Value "`e[4m" -ReadOnly
        Set-EldVar -Name 'AnsiDecoStrikethru' -Value "`e[9m" -ReadOnly
        Set-EldVar -Name 'AnsiModReset' -Value "`e[0m" -ReadOnly
        Set-EldVar -Name 'AnsiCursorHide' -Value "`e[?25l" -ReadOnly
        Set-EldVar -Name 'AnsiCursorShow' -Value "`e[?25h" -ReadOnly
    }
}
