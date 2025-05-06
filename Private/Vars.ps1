using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Add-Type -AssemblyName PresentationCore

Set-StrictMode -Version Latest

. "$PSScriptRoot\Enums.ps1"

<#
.SYNOPSIS
Creates a new ELD variable in the global scope.

.DESCRIPTION
Wraps Set-Variable to create a new ELD variable in the global scope. The variable name will have the ELD prefix prepended to it before creation.
The caller can optionally make the variable readonly. All variables created will be in the Variable PSDrive.

.PARAMETER Name
The name of the variable. The ELD prefix will automatically be prepended to it, so don't add this to the name itself.

.PARAMETER Data
The value to assign to the variable. This can be omitted and will default to null.

.PARAMETER ReadOnly
A Switch that specifies if this variable is readonly. By default, variables are mutable.

.OUTPUTS
None
#>
Function New-EldVar {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Object]$Data = $null,
        [Switch]$ReadOnly
    )

    Process {
        If($ReadOnly) {
            Set-Variable -Name "ELD:$Name" -Value $Data -Scope Global -Option ReadOnly -Force
        } Else {
            Set-Variable -Name "ELD:$Name" -Value $Data -Scope Global -Force
        }
    }
}

<#
.SYNOPSIS
Checks to see if a specific ELD variable exists or not. The value of the variable is inconsequential.

.PARAMETER Name
The name of an ELD variable to check.

.OUTPUTS
System.Exception
    If the specified ELD variable doesn't exist, this function throws a standard Exception.
#>
Function Assert-EldVarExists {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    Process {
        If(-NOT $(Get-Variable -Name "ELD:$Name" -Scope Global -ErrorAction SilentlyContinue)) {
            Throw [Exception]::new("Failed to locate the variable ELD:$Name")
        }
    }
}

<#
.SYNOPSIS
Checks to see if a specified group of ELD variables exists or not. The values of these variables are inconsequential.

.PARAMETER Names
An array of names of ELD variables to check.

.OUTPUTS
System.Exception
    If any of the specifed ELD variables doesn't exist, this function bubbles the standard Exception thrown from Assert-EldVarExists.
#>
Function Assert-EldVarsExists {
    [CmdletBinding()]
    Param(
        [String[]]$Names
    )

    Process {
        Foreach($Name in $Names) {
            Try {
                Assert-EldVarExists -Name $Name
            } Catch {
                Throw $_
            }
        }
    }
}

<#
.SYNOPSIS
Gets an ELD variable from the Variable PSDrive, if it exists.

.DESCRIPTION
If the requested ELD variable exists in the Variable PSDrive, this function will give that variable back to the caller.
Assert-EldVarExists will throw a standard Exception if the requested variable doesn't exist, so this will cause the program
to halt (which is what we would want really as it would indicate a failure to initialize the program state).

If CastTo has been provided, this function will return the value of the variable cast to the type specified by it.

.PARAMETER Name
The name of the ELD variable to get.

.PARAMETER CastTo
The type to cast the value of the ELD variable to before returning it to the caller.

.OUTPUTS
System.Management.Automation.PSVariable
    The ELD variable, if found in the Variable PSDrive.

T
    If the caller has specified a value for CastTo, the value of the ELD variable will
    be cast to it before being returned.
#>
Function Get-EldVar {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    Begin {
        Try {
            Assert-EldVarExists -Name $Name
        } Catch {
            Throw $_
        }
    }

    Process {
        Return Get-Variable -Name "ELD:$Name" -Scope Global
    }
}

<#
.SYNOPSIS
Checks to see if a specific ELD variable is readonly.


.DESCRIPTION
This function seems a little counterintuitive, but the whole point is to prevent a write attempt to a variable that's marked as readonly
and deflect the standard PowerShell response to it.

.PARAMETER Name
The name of the ELD variable to check.

.OUTPUTS
System.Exception
    If the ELD variable is readonly, this function will throw a standard Exception.
#>
Function Assert-EldVarReadOnly {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    Begin {
        Try {
            Assert-EldVarExists -Name $Name
        } Catch {
            Throw $_
        }
    }

    Process {
        If($(Get-EldVar -Name $Name).Options -EQ [ScopedItemOptions]::ReadOnly) {
            Throw [Exception]::new("ELD:$Name is readonly")
        }
    }
}

<#
.SYNOPSIS
Changes the current value of an existing ELD variable.

.DESCRIPTION
This function will check to see if the target ELD variable is readonly before attempting anything. As such, it's possible 
for this function to throw a standard Exception.

.PARAMETER Name
The name of the ELD variable to change.

.PARAMETER Data
The new value to assign to the ELD variable.

.OUTPUTS
System.Exception
    If Assert-EldVarReadOnly throws a standard Exception, this function will bubble it.
#>
Function Set-EldVar {
    [CmdletBinding()]
    Param(
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Object]$Data
    )

    Begin {
        Try {
            Assert-EldVarReadOnly -Name $Name
        } Catch {
            Throw $_
        }
    }

    Process {
        New-EldVar -Name $Name -Data $Data
    }
}

<#
.SYNOPSIS
Creates and sets all ELD variables. This is a crucial function and should be called as early as possible.
#>
Function Initialize-EldVars {
    Process {
        Write-Progress -Activity 'Setting Up Globals' -Id 1 -PercentComplete -1

        New-EldVar -Name 'SceneImagesToLoad' -Data 0
        New-EldVar -Name 'SceneImagesLoaded' -Data 0
        New-EldVar -Name 'SfxUiChevronMove' -Data "$PSScriptRoot\Assets\SFX\UI Chevron Move.wav" -ReadOnly
        New-EldVar -Name 'SfxUiSelectionValid' -Data "$PSScriptRoot\Assets\SFX\UI Selection Valid.wav" -ReadOnly
        New-EldVar -Name 'SfxBaPhysicalStrikeA' -Data "$PSScriptRoot\Assets\SFX\BA Physical Strike 0001.wav" -ReadOnly
        New-EldVar -Name 'SfxBaMissFail' -Data "$PSScriptRoot\Assets\SFX\BA Miss Fail.wav" -ReadOnly
        New-EldVar -Name 'SfxBaActionDisabled' -Data "$PSScriptRoot\Assets\SFX\BA Action Disabled.wav" -ReadOnly
        New-EldVar -Name 'SfxBaFireStrikeA' -Data "$PSScriptRoot\Assets\SFX\BA Fire Strike 0001.wav" -ReadOnly
        New-EldVar -Name 'SfxBattleIntro' -Data "$PSScriptRoot\Assets\SFX\Battle Intro.wav" -ReadOnly
        New-EldVar -Name 'SfxBattlePlayerWin' -Data "$PSScriptRoot\Assets\SFX\Battle Player Win.wav" -ReadOnly
        New-EldVar -Name 'SfxBattlePlayerLose' -Data "$PSScriptRoot\Assets\SFX\Battle Player Lose.wav" -ReadOnly
        New-EldVar -Name 'BgmBattleThemeA' -Data "$PSScriptRoot\Assets\BGM\Battle Theme A.wav" -ReadOnly
        New-EldVar -Name 'SfxBattleNem' -Data "$PSScriptRoot\Assets\SFX\UI Selection NEM.wav" -ReadOnly
        New-EldVar -Name 'BadCommandRetorts' -Data @(
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
        New-EldVar -Name 'TheStatusWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheCommandWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheSceneWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheMessageWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheInventoryWindow' -Data ([Object]::new())
        New-EldVar -Name 'DefaultCursorCoordinates' -Data ([Object]::new())
        New-EldVar -Name 'ThePlayerBattleStatWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheEnemyBattleStatWindow' -Data ([Object]::new())
        New-EldVar -Name 'ThePlayerBattleActionWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheBattleStatusMessageWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheBattleEnemyImageWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheBattlePhaseIndicator' -Data ([Object]::new())
        New-EldVar -Name 'TheStatusHudWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheStatusTechSelectionWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheStatusTechInventoryWindow' -Data ([Object]::new())
        New-EldVar -Name 'TheBufferManager' -Data ([Object]::new())
        New-EldVar -Name 'TheGameCore' -Data ([Object]::new())
        New-EldVar -Name 'TheCurrentEnemy' -Data ([Object]::new())
        New-EldVar -Name 'TheBattleManager' -Data ([Object]::new())
        New-EldVar -Name 'IsBattleBgmPlaying' -Data $false
        New-EldVar -Name 'HasBattleIntroPlayed' -Data $false
        New-EldVar -Name 'HasBattleWonChimePlayed' -Data $false
        New-EldVar -Name 'HasBattleLostChimePlayed' -Data $false
        New-EldVar -Name 'GpsRestoredFromInvBackup' -Data $true
        New-EldVar -Name 'GpsRestoredFromBatBackup' -Data $false
        New-EldVar -Name 'GpsRestoredFromStaBackup' -Data $false
        New-EldVar -Name 'BattleCursorVisible' -Data $false
        New-EldVar -Name 'EeiBat' -Data ([Object]::new())
        New-EldVar -Name 'EeiNightwing' -Data ([Object]::new())
        New-EldVar -Name 'EeiWingblight' -Data ([Object]::new())
        New-EldVar -Name 'EeiDarkfang' -Data ([Object]::new())
        New-EldVar -Name 'EeiNocturna' -Data ([Object]::new())
        New-EldVar -Name 'EeiBloodswoop' -Data ([Object]::new())
        New-EldVar -Name 'EeiDuskbane' -Data ([Object]::new())
        New-EldVar -Name 'TheSfxMPlayer' -Data ([System.Windows.Media.MediaPlayer]::new())
        New-EldVar -Name 'TheBgmMPlayer' -Data ([System.Windows.Media.MediaPlayer]::new())
        New-EldVar -Name 'AffinityMultNeg' -Data -0.75 -ReadOnly
        New-EldVar -Name 'AffinityMultPos' -Data 1.6 -ReadOnly
        New-EldVar -Name 'StatusEsSelectedSlot' -Data [ActionSlot]::None
        New-EldVar -Name 'StatusIsSelected' -Data ([Object]::new())
        New-EldVar -Name 'StatusScreenMode' -Data [StatusScreenMode]::EquippedTechSelection
        New-EldVar -Name 'TheGlobalGameState' -Data [GameStatePrimary]::GamePlayScreen
        New-EldVar -Name 'ThePreviousGlobalGameState' -Data $(Get-EldVar -Name 'TheGlobalGameState').Value
        New-EldVar -Name 'SampleMap' -Data ([Object]::new())
        New-EldVar -Name 'SampleWarpMap01' -Data ([Object]::new())
        New-EldVar -Name 'SampleWarpMap02' -Data ([Object]::new())
        New-EldVar -Name 'CurrentMap' -Data ([Object]::new())
        New-EldVar -Name 'PreviousMap' -Data ([Object]::new())
        New-EldVar -Name 'TheSceneImages' -Data @{}
        New-EldVar -Name 'MapWarpHandler' -Data {}
        New-EldVar -Name 'BattleEncounterRegionTable' -Data @{
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
        New-EldVar -Name 'BATLut' -Data @(
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
        New-EldVar -Name 'Rui' -Data ($(Get-Host).UI.RawUI)
        New-EldVar -Name 'TheSplashScreenAState' -Data {}
        New-EldVar -Name 'TheSplashScreenBState' -Data {}
        New-EldVar -Name 'TheTitleScreenState' -Data {}
        New-EldVar -Name 'ThePlayerSetupState' -Data {}
        New-EldVar -Name 'TheGamePlayScreenState' -Data {}
        New-EldVar -Name 'TheInventoryScreenState' -Data {}
        New-EldVar -Name 'TheBattleScreenState' -Data {}
        New-EldVar -Name 'ThePlayerStatusScreenState' -Data {}
        New-EldVar -Name 'TheCleanupState' -Data {}
        New-EldVar -Name 'TheMoveCommand' -Data {}
        New-EldVar -Name 'TheLookCommand' -Data {}
        New-EldVar -Name 'TheInventoryCommand' -Data {}
        New-EldVar -Name 'TheExamineCommand' -Data {}
        New-EldVar -Name 'TheGetCommand' -Data {}
        New-EldVar -Name 'TheUseCommand' -Data {}
        New-EldVar -Name 'TheDropCommand' -Data {}
        New-EldVar -Name 'TheStatusCommand' -Data {}
        New-EldVar -Name 'TheEnterCommand' -Data {}
        New-EldVar -Name 'TheCommandTable' -Data @{
            'move'      = (Get-EldVar -Name 'TheMoveCommand').Value
            'm'         = (Get-EldVar -Name 'TheMoveCommand').Value
            'look'      = (Get-EldVar -Name 'TheLookCommand').Value
            'l'         = (Get-EldVar -Name 'TheLookCommand').Value
            'inventory' = (Get-EldVar -Name 'TheInventoryCommand').Value
            'i'         = (Get-EldVar -Name 'TheInventoryCommand').Value
            'examine'   = (Get-EldVar -Name 'TheExamineCommand').Value
            'exa'       = (Get-EldVar -Name 'TheExamineCommand').Value
            'get'       = (Get-EldVar -Name 'TheGetCommand').Value
            'g'         = (Get-EldVar -Name 'TheGetCommand').Value
            'take'      = (Get-EldVar -Name 'TheGetCommand').Value
            't'         = (Get-EldVar -Name 'TheGetCommand').Value
            'use'       = (Get-EldVar -Name 'TheUseCommand').Value
            'u'         = (Get-EldVar -Name 'TheUseCommand').Value
            'drop'      = (Get-EldVar -Name 'TheDropCommand').Value
            'd'         = (Get-EldVar -Name 'TheDropCommand').Value
            'status'    = (Get-EldVar -Name 'TheStatusCommand').Value
            'sta'       = (Get-EldVar -Name 'TheStatusCommand').Value
            'enter'     = (Get-EldVar -Name 'TheEnterCommand').Value
            'en'        = (Get-EldVar -Name 'TheEnterCommand').Value
            'exit'      = (Get-EldVar -Name 'TheEnterCommand').Value
            'ex'        = (Get-EldVar -Name 'TheEnterCommand').Value
        }
        New-EldVar -Name 'BaCalc' -Data {}
        New-EldVar -Name 'ThePlayer' -Data ([Object]::new())
        New-EldVar -Name 'TheGlobalStateBlockTable' -Data @{
            [GameStatePrimary]::SplashScreenA      = (Get-EldVar -Name 'TheSplashScreenAState').Value
            [GameStatePrimary]::SplashScreenB      = (Get-EldVar -Name 'TheSplashScreenBState').Value
            [GameStatePrimary]::TitleScreen        = (Get-EldVar -Name 'TheTitleScreenState').Value
            [GameStatePrimary]::PlayerSetupScreen  = (Get-EldVar -Name 'ThePlayerSetupState').Value
            [GameStatePrimary]::GamePlayScreen     = (Get-EldVar -Name 'TheGamePlayScreenState').Value
            [GameStatePrimary]::InventoryScreen    = (Get-EldVar -Name 'TheInventoryScreenState').Value
            [GameStatePrimary]::BattleScreen       = (Get-EldVar -Name 'TheBattleScreenState').Value
            [GameStatePrimary]::PlayerStatusScreen = (Get-EldVar -Name 'ThePlayerStatusScreenState').Value
            [GameStatePrimary]::Cleanup            = (Get-EldVar -Name 'TheCleanupState').Value
        }
        New-EldVar -Name 'CCBlack24' -Data @(0, 0, 0) -ReadOnly
        New-EldVar -Name 'CCWhite24' -Data @(255, 255, 255) -ReadOnly
        New-EldVar -Name 'CCRed24' -Data @(255, 0, 0) -ReadOnly
        New-EldVar -Name 'CCGreen24' -Data @(0, 255, 0) -ReadOnly
        New-EldVar -Name 'CCBlue24' -Data @(0, 0, 255) -ReadOnly
        New-EldVar -Name 'CCYellow24' -Data @(255, 255, 0) -ReadOnly
        New-EldVar -Name 'CCDarkYellow24' -Data @(255, 204, 0) -ReadOnly
        New-EldVar -Name 'CCDarkCyan24' -Data @(0, 139, 139) -ReadOnly
        New-EldVar -Name 'CCDarkGrey24' -Data @(45, 45, 45) -ReadOnly
        New-EldVar -Name 'CCRandom24' -Data @($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0))
        New-EldVar -Name 'CCAppleRedLight24' -Data @(255, 59, 48) -ReadOnly
        New-EldVar -Name 'CCAppleRedDark24' -Data @(255, 69, 58) -ReadOnly
        New-EldVar -Name 'CCAppleOrangeLight24' -Data @(255, 149, 0) -ReadOnly
        New-EldVar -Name 'CCAppleOrangeDark24' -Data @(255, 159, 10) -ReadOnly
        New-EldVar -Name 'CCAppleYellowLight24' -Data @(255, 204, 0) -ReadOnly
        New-EldVar -Name 'CCAppleYellowDark24' -Data @(255, 214, 10) -ReadOnly
        New-EldVar -Name 'CCAppleGreenLight24' -Data @(52, 199, 89) -ReadOnly
        New-EldVar -Name 'CCAppleGreenDark24' -Data @(48, 209, 88) -ReadOnly
        New-EldVar -Name 'CCAppleMintLight24' -Data @(0, 199, 190) -ReadOnly
        New-EldVar -Name 'CCAppleMintDark24' -Data @(99, 230, 226) -ReadOnly
        New-EldVar -Name 'CCAppleTealLight24' -Data @(48, 176, 199) -ReadOnly
        New-EldVar -Name 'CCAppleTealDark24' -Data @(64, 200, 224) -ReadOnly
        New-EldVar -Name 'CCAppleCyanLight24' -Data @(50, 173, 230) -ReadOnly
        New-EldVar -Name 'CCAppleCyanDark24' -Data @(100, 210, 255) -ReadOnly
        New-EldVar -Name 'CCAppleBlueLight24' -Data @(0, 122, 255) -ReadOnly
        New-EldVar -Name 'CCAppleBlueDark24' -Data @(10, 132, 255) -ReadOnly
        New-EldVar -Name 'CCAppleIndigoLight24' -Data @(88, 86, 214) -ReadOnly
        New-EldVar -Name 'CCAppleIndigoDark24' -Data @(94, 92, 230) -ReadOnly
        New-EldVar -Name 'CCApplePurpleLight24' -Data @(175, 82, 222) -ReadOnly
        New-EldVar -Name 'CCApplePurpleDark24' -Data @(191, 90, 242) -ReadOnly
        New-EldVar -Name 'CCApplePinkLight24' -Data @(255, 45, 85) -ReadOnly
        New-EldVar -Name 'CCApplePinkDark24' -Data @(255, 55, 95) -ReadOnly
        New-EldVar -Name 'CCAppleBrownLight24' -Data @(162, 132, 94) -ReadOnly
        New-EldVar -Name 'CCAppleBrownDark24' -Data @(172, 142, 104) -ReadOnly
        New-EldVar -Name 'CCAppleGrey1Light24' -Data @(142, 142, 147) -ReadOnly
        New-EldVar -Name 'CCAppleGrey1Dark24' -Data @(142, 142, 147) -ReadOnly
        New-EldVar -Name 'CCAppleGrey2Light24' -Data @(174, 174, 178) -ReadOnly
        New-EldVar -Name 'CCAppleGrey2Dark24' -Data @(99, 99, 102) -ReadOnly
        New-EldVar -Name 'CCAppleGrey3Light24' -Data @(199, 199, 204) -ReadOnly
        New-EldVar -Name 'CCAppleGrey3Dark24' -Data @(72, 72, 74) -ReadOnly
        New-EldVar -Name 'CCAppleGrey4Light24' -Data @(209, 209, 214) -ReadOnly
        New-EldVar -Name 'CCAppleGrey4Dark24' -Data @(58, 58, 60) -ReadOnly
        New-EldVar -Name 'CCAppleGrey5Light24' -Data @(229, 229, 234) -ReadOnly
        New-EldVar -Name 'CCAppleGrey5Dark24' -Data @(44, 44, 46) -ReadOnly
        New-EldVar -Name 'CCAppleGrey6Light24' -Data @(242, 242, 247) -ReadOnly
        New-EldVar -Name 'CCAppleGrey6Dark24' -Data @(28, 28, 30) -ReadOnly
        New-EldVar -Name 'CCPantoneSkyBlue24' -Data @(54, 73, 83) -ReadOnly
        New-EldVar -Name 'CCPantoneLightGrassGreen24' -Data @(49, 70, 53) -ReadOnly
        New-EldVar -Name 'CCPantonePottingSoil24' -Data @(33, 22, 18) -ReadOnly
        New-EldVar -Name 'CCAppleNRedLight24' -Data @(255, 59, 48) -ReadOnly
        New-EldVar -Name 'CCAppleNRedDark24' -Data @(255, 69, 58) -ReadOnly
        New-EldVar -Name 'CCAppleNRedALight24' -Data @(215, 0, 21) -ReadOnly
        New-EldVar -Name 'CCAppleNRedADark24' -Data @(255, 105, 97) -ReadOnly
        New-EldVar -Name 'CCAppleNOrangeLight24' -Data @(255, 149, 0) -ReadOnly
        New-EldVar -Name 'CCAppleNOrangeDark24' -Data @(255, 159, 10) -ReadOnly
        New-EldVar -Name 'CCAppleNOrangeALight24' -Data @(201, 52, 0) -ReadOnly
        New-EldVar -Name 'CCAppleNOrangeADark24' -Data @(255, 179, 64) -ReadOnly
        New-EldVar -Name 'CCAppleNYellowLight24' -Data @(255, 204, 0) -ReadOnly
        New-EldVar -Name 'CCAppleNYellowDark24' -Data @(255, 214, 10) -ReadOnly
        New-EldVar -Name 'CCAppleNYellowALight24' -Data @(178, 80, 0) -ReadOnly
        New-EldVar -Name 'CCAppleNGreenDark24' -Data @(48, 209, 88) -ReadOnly
        New-EldVar -Name 'CCAppleNGreenALight24' -Data @(36, 138, 61) -ReadOnly
        New-EldVar -Name 'CCAppleNGreenADark24' -Data @(48, 219, 91) -ReadOnly
        New-EldVar -Name 'CCAppleNMintLight24' -Data @(0, 199, 190) -ReadOnly
        New-EldVar -Name 'CCAppleNMintDark24' -Data @(99, 230, 226) -ReadOnly
        New-EldVar -Name 'CCAppleNMintALight24' -Data @(12, 129, 123) -ReadOnly
        New-EldVar -Name 'CCAppleNMintADark24' -Data @(102, 212, 207) -ReadOnly
        New-EldVar -Name 'CCAppleNTealLight24' -Data @(48, 176, 199) -ReadOnly
        New-EldVar -Name 'CCAppleNTealDark24' -Data @(64, 200, 224) -ReadOnly
        New-EldVar -Name 'CCAppleNTealALight24' -Data @(0, 130, 153) -ReadOnly
        New-EldVar -Name 'CCAppleNTealADark24' -Data @(93, 230, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNCyanLight24' -Data @(50, 173, 230) -ReadOnly
        New-EldVar -Name 'CCAppleNCyanDark24' -Data @(100, 210, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNCyanALight24' -Data @(0, 113, 164) -ReadOnly
        New-EldVar -Name 'CCAppleNCyanADark24' -Data @(112, 215, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNBlueLight24' -Data @(0, 122, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNBlueDark24' -Data @(10, 132, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNBlueALight24' -Data @(0, 64, 221) -ReadOnly
        New-EldVar -Name 'CCAppleNBlueADark24' -Data @(64, 156, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNIndigoLight24' -Data @(88, 86, 214) -ReadOnly
        New-EldVar -Name 'CCAppleNIndigoDark24' -Data @(94, 92, 230) -ReadOnly
        New-EldVar -Name 'CCAppleNIndigoALight24' -Data @(54, 52, 163) -ReadOnly
        New-EldVar -Name 'CCAppleNIndigoADark24' -Data @(125, 122, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNPurpleLight24' -Data @(175, 82, 222) -ReadOnly
        New-EldVar -Name 'CCAppleNPurpleDark24' -Data @(191, 90, 242) -ReadOnly
        New-EldVar -Name 'CCAppleNPurpleALight24' -Data @(137, 68, 171) -ReadOnly
        New-EldVar -Name 'CCAppleNPurpleADark24' -Data @(218, 143, 255) -ReadOnly
        New-EldVar -Name 'CCAppleNPinkLight24' -Data @(255, 45, 85) -ReadOnly
        New-EldVar -Name 'CCAppleNPinkDark24' -Data @(255, 55, 95) -ReadOnly
        New-EldVar -Name 'CCAppleNPinkALight24' -Data @(211, 15, 69) -ReadOnly
        New-EldVar -Name 'CCAppleNPinkADark24' -Data @(255, 100, 130) -ReadOnly
        New-EldVar -Name 'CCAppleNBrownLight24' -Data @(162, 132, 94) -ReadOnly
        New-EldVar -Name 'CCAppleNBrownDark24' -Data @(172, 142, 104) -ReadOnly
        New-EldVar -Name 'CCAppleNBrownALight24' -Data @(127, 101, 69) -ReadOnly
        New-EldVar -Name 'CCAppleNBrownADark24' -Data @(181, 148, 105) -ReadOnly
        New-EldVar -Name 'CCAppleNGreyLight24' -Data @(142, 142, 147) -ReadOnly
        New-EldVar -Name 'CCAppleNGreyDark24' -Data @(142, 142, 147) -ReadOnly
        New-EldVar -Name 'CCAppleNGreyALight24' -Data @(108, 108, 112) -ReadOnly
        New-EldVar -Name 'CCAppleNGreyADark24' -Data @(174, 174, 178) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey2Light24' -Data @(174, 174, 178) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey2Dark24' -Data @(99, 99, 102) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey2ALight24' -Data @(142, 142, 147) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey2ADark24' -Data @(124, 124, 128) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey3Light24' -Data @(199, 199, 204) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey3Dark24' -Data @(72, 72, 74) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey4ALight24' -Data @(188, 188, 192) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey4ADark24' -Data @(68, 68, 70) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey5Light24' -Data @(229, 229, 234) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey5Dark24' -Data @(44, 44, 46) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey5ALight24' -Data @(216, 216, 220) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey5ADark24' -Data @(54, 54, 56) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey6Light24' -Data @(242, 242, 247) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey6Dark24' -Data @(28, 28, 30) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey6ALight24' -Data @(235, 235, 240) -ReadOnly
        New-EldVar -Name 'CCAppleNGrey6ADark24' -Data @(36, 36, 38) -ReadOnly
        New-EldVar -Name 'CCAppleVRedLight24' -Data @(255, 49, 38) -ReadOnly
        New-EldVar -Name 'CCAppleVRedDark24' -Data @(255, 79, 68) -ReadOnly
        New-EldVar -Name 'CCAppleVRedALight24' -Data @(194, 6, 24) -ReadOnly
        New-EldVar -Name 'CCAppleVRedADark24' -Data @(255, 65, 54) -ReadOnly
        New-EldVar -Name 'CCAppleVOrangeLight24' -Data @(245, 139, 0) -ReadOnly
        New-EldVar -Name 'CCAppleVOrangeDark24' -Data @(255, 169, 20) -ReadOnly
        New-EldVar -Name 'CCAppleVOrangeALight24' -Data @(173, 58, 0) -ReadOnly
        New-EldVar -Name 'CCAppleVOrangeADark24' -Data @(255, 179, 64) -ReadOnly
        New-EldVar -Name 'CCAppleVYellowLight24' -Data @(245, 194, 0) -ReadOnly
        New-EldVar -Name 'CCAppleVYellowDark24' -Data @(255, 224, 20) -ReadOnly
        New-EldVar -Name 'CCAppleVYellowALight24' -Data @(146, 81, 0) -ReadOnly
        New-EldVar -Name 'CCAppleVYellowADark24' -Data @(255, 212, 38) -ReadOnly
        New-EldVar -Name 'CCAppleVGreenLight24' -Data @(30, 195, 55) -ReadOnly
        New-EldVar -Name 'CCAppleVGreenDark24' -Data @(60, 225, 85) -ReadOnly
        New-EldVar -Name 'CCAppleVGreenALight24' -Data @(0, 112, 24) -ReadOnly
        New-EldVar -Name 'CCAppleVGreenADark24' -Data @(49, 222, 75) -ReadOnly
        New-EldVar -Name 'CCAppleVMintLight24' -Data @(0, 189, 180) -ReadOnly
        New-EldVar -Name 'CCAppleVMintDark24' -Data @(108, 224, 219) -ReadOnly
        New-EldVar -Name 'CCAppleVMintALight24' -Data @(11, 117, 112) -ReadOnly
        New-EldVar -Name 'CCAppleVMintADark24' -Data @(49, 222, 75) -ReadOnly
        New-EldVar -Name 'CCAppleVTealLight24' -Data @(46, 167, 189) -ReadOnly
        New-EldVar -Name 'CCAppleVTealDark24' -Data @(68, 212, 237) -ReadOnly
        New-EldVar -Name 'CCAppleVTealALight24' -Data @(0, 119, 140) -ReadOnly
        New-EldVar -Name 'CCAppleVTealADark24' -Data @(93, 230, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVCyanLight24' -Data @(65, 175, 220) -ReadOnly
        New-EldVar -Name 'CCAppleVCyanDark24' -Data @(90, 205, 250) -ReadOnly
        New-EldVar -Name 'CCAppleVCyanALight24' -Data @(0, 103, 150) -ReadOnly
        New-EldVar -Name 'CCAppleVCyanADark24' -Data @(112, 215, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVBlueLight24' -Data @(0, 122, 245) -ReadOnly
        New-EldVar -Name 'CCAppleVBlueDark24' -Data @(20, 142, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVBlueALight24' -Data @(0, 64, 221) -ReadOnly
        New-EldVar -Name 'CCAppleVBlueADark24' -Data @(64, 156, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVIndigoLight24' -Data @(84, 82, 204) -ReadOnly
        New-EldVar -Name 'CCAppleVIndigoDark24' -Data @(99, 97, 242) -ReadOnly
        New-EldVar -Name 'CCAppleVIndigoALight24' -Data @(54, 52, 163) -ReadOnly
        New-EldVar -Name 'CCAppleVIndigoADark24' -Data @(125, 122, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVPurpleLight24' -Data @(159, 75, 201) -ReadOnly
        New-EldVar -Name 'CCAppleVPurpleDark24' -Data @(204, 101, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVPurpleALight24' -Data @(173, 68, 171) -ReadOnly
        New-EldVar -Name 'CCAppleVPurpleADark24' -Data @(218, 143, 255) -ReadOnly
        New-EldVar -Name 'CCAppleVPinkLight24' -Data @(245, 35, 75) -ReadOnly
        New-EldVar -Name 'CCAppleVPinkDark24' -Data @(255, 65, 105) -ReadOnly
        New-EldVar -Name 'CCAppleVPinkALight24' -Data @(193, 16, 50) -ReadOnly
        New-EldVar -Name 'CCAppleVPinkADark24' -Data @(255, 58, 95) -ReadOnly
        New-EldVar -Name 'CCAppleVBrownLight24' -Data @(152, 122, 84) -ReadOnly
        New-EldVar -Name 'CCAppleVBrownDark24' -Data @(182, 152, 114) -ReadOnly
        New-EldVar -Name 'CCAppleVBrownALight24' -Data @(119, 93, 59) -ReadOnly
        New-EldVar -Name 'CCAppleVGreyLight24' -Data @(132, 132, 137) -ReadOnly
        New-EldVar -Name 'CCAppleVGreyDark24' -Data @(162, 162, 167) -ReadOnly
        New-EldVar -Name 'CCAppleVGreyALight24' -Data @(97, 97, 101) -ReadOnly
        New-EldVar -Name 'CCTextDefault24' -Data $((Get-EldVar -Name 'CCAppleGrey5Light24').Value) -ReadOnly
        New-EldVar -Name 'CCListItemCurrentHighlight24' -Data $((Get-EldVar -Name 'CCAppleNPinkLight24').Value) -ReadOnly
        New-EldVar -Name 'AnsiFg24Prefix' -Data "`e[38;2;" -ReadOnly
        New-EldVar -Name 'AnsiBg24Prefix' -Data "`e[48;2;" -ReadOnly
        New-EldVar -Name 'AnsiDecoBlink' -Data "`e[5m" -ReadOnly
        New-EldVar -Name 'AnsiDecoItalic' -Data "`e[3m" -ReadOnly
        New-EldVar -Name 'AnsiDecoUnderline' -Data "`e[4m" -ReadOnly
        New-EldVar -Name 'AnsiDecoStrikethru' -Data "`e[9m" -ReadOnly
        New-EldVar -Name 'AnsiModReset' -Data "`e[0m" -ReadOnly
        New-EldVar -Name 'AnsiCursorHide' -Data "`e[?25l" -ReadOnly
        New-EldVar -Name 'AnsiCursorShow' -Data "`e[?25h" -ReadOnly
        New-EldVar -Name 'BATAdornmentCharTable' -Data @{
            [BattleActionType]::Physical         = [Tuple[[String], [Int[]]]]::new("`u{2022}", (Get-EldVar -Name 'CCTextDefault24').Value)
            [BattleActionType]::ElementalFire    = [Tuple[[String], [Int[]]]]::new("`u{03B6}", (Get-EldVar -Name 'CCAppleRedLight24').Value)
            [BattleActionType]::ElementalWater   = [Tuple[[String], [Int[]]]]::new("`u{03C8}", (Get-EldVar -Name 'CCAppleBlueLight24').Value)
            [BattleActionType]::ElementalEarth   = [Tuple[[String], [Int[]]]]::new("`u{03B5}", (Get-EldVar -Name 'CCAppleBrownLight24').Value)
            [BattleActionType]::ElementalWind    = [Tuple[[String], [Int[]]]]::new("`u{03C6}", (Get-EldVar -Name 'CCAppleGreenLight24').Value)
            [BattleActionType]::ElementalLight   = [Tuple[[String], [Int[]]]]::new("`u{03BC}", (Get-EldVar -Name 'CCAppleYellowLight24').Value)
            [BattleActionType]::ElementalDark    = [Tuple[[String], [Int[]]]]::new("`u{03B4}", (Get-EldVar -Name 'CCApplePurpleLight24').Value)
            [BattleActionType]::ElementalIce     = [Tuple[[String], [Int[]]]]::new("`u{03B9}", (Get-EldVar -Name 'CCAppleCyanDark24').Value)
            [BattleActionType]::MagicPoison      = [Tuple[[String], [Int[]]]]::new("`u{03BE}", (Get-EldVar -Name 'CCAppleIndigoLight24').Value)
            [BattleActionType]::MagicConfuse     = [Tuple[[String], [Int[]]]]::new("`u{0398}", (Get-EldVar -Name 'CCAppleCyanDark24').Value)
            [BattleActionType]::MagicSleep       = [Tuple[[String], [Int[]]]]::new("`u{03B7}", (Get-EldVar -Name 'CCAppleGrey4Light24').Value)
            [BattleActionType]::MagicAging       = [Tuple[[String], [Int[]]]]::new("`u{03C3}", (Get-EldVar -Name 'CCAppleGrey6Light24').Value)
            [BattleActionType]::MagicHealing     = [Tuple[[String], [Int[]]]]::new("`u{20AA}", (Get-EldVar -Name 'CCAppleMintLight24').Value)
            [BattleActionType]::MagicStatAugment = [Tuple[[String], [Int[]]]]::new("`u{20B9}", (Get-EldVar -Name 'CCAppleOrangeLight24').Value)
        }
        New-EldVar -Name 'BepStatNumThresholdCaution' -Data 0.6D -ReadOnly
        New-EldVar -Name 'BepStatNumThresholdDanger' -Data 0.3D -ReadOnly
        New-EldVar -Name 'BepStatNumDrawColorSafe' -Data $((Get-EldVar -Name 'CCAppleGreenLight24').Value) -ReadOnly
        New-EldVar -Name 'BepStatNumDrawColorCaution' -Data $((Get-EldVar -Name 'CCAppleYellowLight24').Value) -ReadOnly
        New-EldVar -Name 'BepStatNumDrawColorDanger' -Data $((Get-EldVar -Name 'CCAppleRedLight24').Value) -ReadOnly
        New-EldVar -Name 'BepStatAugDrawColorPositive' -Data $((Get-EldVar -Name 'CCAppleCyanLight24').Value) -ReadOnly
        New-EldVar -Name 'BepStatAugDrawColorNegative' -Data $((Get-EldVar -Name 'CCApplePurpleDark24').Value) -ReadOnly

        # Variables that pertain to the Player
        New-EldVar -Name 'PlayerEntityName' -Data 'Steve'
        New-EldVar -Name 'PlayerEntityCanAct' -Data $true
        New-EldVar -Name 'PlayerEntityNameDrawColor' -Data $((Get-EldVar -Name 'CCTextDefault24').Value)
        New-EldVar -Name 'PlayerEntityAffinity' -Data [BattleActionType]::None
        New-EldVar -Name 'PlayerEntityAsideDrawColor' -Data $((Get-EldVar -Name 'CCAppleIndigoLight24').Value) -ReadOnly
        New-EldVar -Name 'PlayerEntityGoldDrawColor' -Data $((Get-EldVar -Name 'CCAppleYellowLight24').Value) -ReadOnly
        New-EldVar -Name 'PlayerEntityCurrentGold' -Data 0
        New-EldVar -Name 'PlayerEntityMapCoordinates' -Data @(1, 1)
        New-EldVar -Name 'PlayerEntityTargetOfFilter' -Data @()
        New-EldVar -Name 'PlayerEntityItemInventory' -Data @()
        New-EldVar -Name 'PlayerEntityActionInventory' -Data @()
        New-EldVar -Name 'PlayerBepHitPointsBase' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsBase' -Data 0
        New-EldVar -Name 'PlayerBepAttackBase' -Data 0
        New-EldVar -Name 'PlayerBepDefenseBase' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackBase' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseBase' -Data 0
        New-EldVar -Name 'PlayerBepSpeedBase' -Data 0
        New-EldVar -Name 'PlayerBepLuckBase' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyBase' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsBasePre' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsBasePre' -Data 0
        New-EldVar -Name 'PlayerBepAttackBasePre' -Data 0
        New-EldVar -Name 'PlayerBepDefenseBasePre' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackBasePre' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseBasePre' -Data 0
        New-EldVar -Name 'PlayerBepSpeedBasePre' -Data 0
        New-EldVar -Name 'PlayerBepLuckBasePre' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyBasePre' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepAttackBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepDefenseBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepSpeedBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepLuckBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyBaseAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsMax' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsMax' -Data 0
        New-EldVar -Name 'PlayerBepAttackMax' -Data 0
        New-EldVar -Name 'PlayerBepDefenseMax' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackMax' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseMax' -Data 0
        New-EldVar -Name 'PlayerBepSpeedMax' -Data 0
        New-EldVar -Name 'PlayerBepLuckMax' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyMax' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepAttackMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepDefenseMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepSpeedMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepLuckMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyMaxPre' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepAttackMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepDefenseMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepSpeedMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepLuckMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyMaxAugmentValue' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepMagicPointsAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepAttackAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepDefenseAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepMagicAttackAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepMagicDefenseAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepSpeedAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepLuckAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepAccuracyAugmentTurnDuration' -Data 0
        New-EldVar -Name 'PlayerBepHitPointsBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepMagicPointsBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepAttackBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepDefenseBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepMagicAttackBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepMagicDefenseBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepSpeedBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepLuckBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepAccuracyBaseAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepHitPointsMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepMagicPointsMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepAttackMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepDefenseMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepMagicAttackMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepMagicDefenseMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepSpeedMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepLuckMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepAccuracyMaxAugmentActive' -Data $false
        New-EldVar -Name 'PlayerBepHitPointsState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepMagicPointsState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepAttackState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepDefenseState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepMagicAttackState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepMagicDefenseState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepSpeedState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepLuckState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepAccuracyState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'PlayerBepHitPointsValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepMagicPointsValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepAttackValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepDefenseValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepMagicAttackValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepMagicDefenseValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepSpeedValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepLuckValidateFunction' -Data {}
        New-EldVar -Name 'PlayerBepAccuracyValidateFunction' -Data {}
        New-EldVar -Name 'PlayerEntityActionListing' -Data @{
            [ActionSlot]::A = ''
            [ActionSlot]::B = ''
            [ActionSlot]::C = ''
            [ActionSlot]::D = ''
        }
        New-EldVar -Name 'PlayerEntityActionMarbleBag' -Data @()

        # Variables that pertain to the CURRENT enemy
        New-EldVar -Name 'EnemyEntityName' -Data ''
        New-EldVar -Name 'EnemyEntityCanAct' -Data $true
        New-EldVar -Name 'EnemyEntityNameDrawColor' -Data $((Get-EldVar -Name 'CCTextDefault24').Value)
        New-EldVar -Name 'EnemyEntityAffinity' -Data [BattleActionType]::None
        New-EldVar -Name 'EnemyBepHitPointsBase' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsBase' -Data 0
        New-EldVar -Name 'EnemyBepAttackBase' -Data 0
        New-EldVar -Name 'EnemyBepDefenseBase' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackBase' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseBase' -Data 0
        New-EldVar -Name 'EnemyBepSpeedBase' -Data 0
        New-EldVar -Name 'EnemyBepLuckBase' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyBase' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsBasePre' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsBasePre' -Data 0
        New-EldVar -Name 'EnemyBepAttackBasePre' -Data 0
        New-EldVar -Name 'EnemyBepDefenseBasePre' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackBasePre' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseBasePre' -Data 0
        New-EldVar -Name 'EnemyBepSpeedBasePre' -Data 0
        New-EldVar -Name 'EnemyBepLuckBasePre' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyBasePre' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepAttackBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepDefenseBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepSpeedBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepLuckBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyBaseAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsMax' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsMax' -Data 0
        New-EldVar -Name 'EnemyBepAttackMax' -Data 0
        New-EldVar -Name 'EnemyBepDefenseMax' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackMax' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseMax' -Data 0
        New-EldVar -Name 'EnemyBepSpeedMax' -Data 0
        New-EldVar -Name 'EnemyBepLuckMax' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyMax' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepAttackMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepDefenseMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepSpeedMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepLuckMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyMaxPre' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepAttackMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepDefenseMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepSpeedMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepLuckMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyMaxAugmentValue' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepMagicPointsAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepAttackAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepDefenseAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepMagicAttackAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepMagicDefenseAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepSpeedAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepLuckAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepAccuracyAugmentTurnDuration' -Data 0
        New-EldVar -Name 'EnemyBepHitPointsBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepMagicPointsBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepAttackBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepDefenseBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepMagicAttackBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepMagicDefenseBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepSpeedBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepLuckBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepAccuracyBaseAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepHitPointsMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepMagicPointsMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepAttackMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepDefenseMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepMagicAttackMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepMagicDefenseMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepSpeedMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepLuckMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepAccuracyMaxAugmentActive' -Data $false
        New-EldVar -Name 'EnemyBepHitPointsState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepMagicPointsState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepAttackState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepDefenseState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepMagicAttackState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepMagicDefenseState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepSpeedState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepLuckState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepAccuracyState' -Data [StatNumberState]::Normal
        New-EldVar -Name 'EnemyBepHitPointsValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepMagicPointsValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepAttackValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepDefenseValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepMagicAttackValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepMagicDefenseValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepSpeedValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepLuckValidateFunction' -Data {}
        New-EldVar -Name 'EnemyBepAccuracyValidateFunction' -Data {}
        New-EldVar -Name 'EnemyEntityActionListing' -Data @{
            [ActionSlot]::A = ''
            [ActionSlot]::B = ''
            [ActionSlot]::C = ''
            [ActionSlot]::D = ''
        }
        New-EldVar -Name 'EnemyEntityActionMarbleBag' -Data @()
        New-EldVar -Name 'EnemyEntityImage' -Data ''
        New-EldVar -Name 'EnemyEntitySpoilsGold' -Data 0
        New-EldVar -Name 'EnemyEntitySpoilsEffect' -Data {}
        New-EldVar -Name 'EnemyEntitySpoilsItems' -Data @()

        # Variables that pertain to the Battle Action Punch
        New-EldVar -Name 'BAPunchName' -Data 'Punch' -ReadOnly
        New-EldVar -Name 'BAPunchDesc' -Data 'A punch. Just like data taught you.' -ReadOnly
        New-EldVar -Name 'BAPunchType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAPunchMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAPunchEffectValue' -Data 50 -ReadOnly
        New-EldVar -Name 'BAPunchChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Kick
        New-EldVar -Name 'BAKickName' -Data 'Kick' -ReadOnly
        New-EldVar -Name 'BAKickDesc' -Data 'A kick. Don''t stub your toe.'
        New-EldVar -Name 'BAKickType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAKickMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAKickEffectValue' -Data 50 -ReadOnly
        New-EldVar -Name 'BAKickChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Karate Chop
        New-EldVar -Name 'BAKarateChopName' -Data 'Karate Chop' -ReadOnly
        New-EldVar -Name 'BAKarateChopDesc' -Data 'Test your might!' -ReadOnly
        New-EldVar -Name 'BAKarateChopType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAKarateChopMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAKarateChopEffectValue' -Data 60 -ReadOnly
        New-EldVar -Name 'BAKarateChopChance' -Data 0.8 -ReadOnly

        # Variables that pertain to the Battle Action Karate Kick
        New-EldVar -Name 'BAKarateKickName' -Data 'Karate Kick' -ReadOnly
        New-EldVar -Name 'BAKarateKickDesc' -Data 'I hope your shins are fit' -ReadOnly
        New-EldVar -Name 'BAKarateKickType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAKarateKickMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAKarateKickEffectValue' -Data 65 -ReadOnly
        New-EldVar -Name 'BAKarateKickChance' -Data 0.75 -ReadOnly

        # Variables that pertain to the Battle Action Bash
        New-EldVar -Name 'BABashName' -Data 'Bash' -ReadOnly
        New-EldVar -Name 'BABashDesc' -Data 'HULK SMASH!' -ReadOnly
        New-EldVar -Name 'BABashType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BABashMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BABashEffectValue' -Data 75 -ReadOnly
        New-EldVar -Name 'BABashChance' -Data 0.7 -ReadOnly

        # Variables that pertain to the Battle Action Bite
        New-EldVar -Name 'BABiteName' -Data 'Bite' -ReadOnly
        New-EldVar -Name 'BABiteDesc' -Data 'When fists fail, teeth do just fine.' -ReadOnly
        New-EldVar -Name 'BABiteType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BABiteMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BABiteEffectValue' -Data 40 -ReadOnly
        New-EldVar -Name 'BABiteChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Scratch
        New-EldVar -Name 'BAScratchName' -Data 'Scratch' -ReadOnly
        New-EldVar -Name 'BAScratchDesc' -Data 'Nails are sometimes useful.' -ReadOnly
        New-EldVar -Name 'BAScratchType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAScratchMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAScratchEffectValue' -Data 45 -ReadOnly
        New-EldVar -Name 'BAScratchChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Double Scratch
        New-EldVar -Name 'BADoubleScratchName' -Data 'Double Scratch' -ReadOnly
        New-EldVar -Name 'BADoubleScratchDesc' -Data 'The manicure on these is lethal.' -ReadOnly
        New-EldVar -Name 'BADoubleScratchType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BADoubleScratchMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BADoubleScratchEffectValue' -Data 85 -ReadOnly
        New-EldVar -Name 'BADoubleScratchChance' -Data 0.75 -ReadOnly

        # Variables that pertain to the Battle Action Headbutt
        New-EldVar -Name 'BAHeadbuttName' -Data 'Headbutt' -ReadOnly
        New-EldVar -Name 'BAHeadbuttDesc' -Data 'Put that noggin to work!' -ReadOnly
        New-EldVar -Name 'BAHeadbuttType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAHeadbuttMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAHeadbuttEffectValue' -Data 160 -ReadOnly
        New-EldVar -Name 'BAHeadbuttChance' -Data 0.4 -ReadOnly

        # Variables that pertain to the Battle Action Drop Kick
        New-EldVar -Name 'BADropKickName' -Data 'Drop Kick' -ReadOnly
        New-EldVar -Name 'BADropKickDesc' -Data 'Don''t use this on Murphy.' -ReadOnly
        New-EldVar -Name 'BADropKickType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BADropKickMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BADropKickEffectValue' -Data 120 -ReadOnly
        New-EldVar -Name 'BADropKickChance' -Data 0.3 -ReadOnly

        # Variables that pertain to the Battle Action Throw
        New-EldVar -Name 'BAThrowName' -Data 'Throw' -ReadOnly
        New-EldVar -Name 'BAThrowDesc' -Data 'One man''s trash is a useful weapon.' -ReadOnly
        New-EldVar -Name 'BAThrowType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAThrowMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAThrowEffectValue' -Data 0 -ReadOnly
        New-EldVar -Name 'BAThrowChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Peck
        New-EldVar -Name 'BAPeckName' -Data 'Peck' -ReadOnly
        New-EldVar -Name 'BAPeckDesc' -Data 'One from Grandma usually means cookies later.' -ReadOnly
        New-EldVar -Name 'BAPeckType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAPeckMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAPeckEffectValue' -Data 20 -ReadOnly
        New-EldVar -Name 'BAPeckChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Talon Stab
        New-EldVar -Name 'BATalonStabName' -Data 'Talon Stab' -ReadOnly
        New-EldVar -Name 'BATalonStabDesc' -Data 'You don''t want a hug from these.' -ReadOnly
        New-EldVar -Name 'BATalonStabType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BATalonStabMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BATalonStabEffectValue' -Data 70 -ReadOnly
        New-EldVar -Name 'BATalonStabChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Sword Slash
        New-EldVar -Name 'BASwordSlashName' -Data 'Sword Slash' -ReadOnly
        New-EldVar -Name 'BASwordSlashDesc' -Data 'A basic sword attack.' -ReadOnly
        New-EldVar -Name 'BASwordSlashType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BASwordSlashMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BASwordSlashEffectValue' -Data 60 -ReadOnly
        New-EldVar -Name 'BASwordSlashChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Sword Stab
        New-EldVar -Name 'BASwordStabName' -Data 'Sword Stab' -ReadOnly
        New-EldVar -Name 'BASwordStabDesc' -Data 'This was practiced with toothpicks.' -ReadOnly
        New-EldVar -Name 'BASwordStabType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BASwordStabMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BASwordStabEffectValue' -Data 80 -ReadOnly
        New-EldVar -Name 'BASwordStabChance' -Data 0.7 -ReadOnly

        # Variables that pertain to the Battle Action Axe Slash
        New-EldVar -Name 'BAAxeSlashName' -Data 'Axe Slash' -ReadOnly
        New-EldVar -Name 'BAAxeSlashDesc' -Data 'Chopping trees pays off.' -ReadOnly
        New-EldVar -Name 'BAAxeSlashType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAAxeSlashMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAAxeSlashEffectValue' -Data 70 -ReadOnly
        New-EldVar -Name 'BAAxeSlashChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Axe Cleave
        New-EldVar -Name 'BAAxeCleaveName' -Data 'Axe Cleave' -ReadOnly
        New-EldVar -Name 'BAAxeCleaveDesc' -Data 'Before his fury, the trees stood no chance.' -ReadOnly
        New-EldVar -Name 'BAAxeCleaveType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAAxeCleaveMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAAxeCleaveEffectValue' -Data 90 -ReadOnly
        New-EldVar -Name 'BAAxeCleaveChance' -Data 0.8 -ReadOnly

        # Variables that pertain to the Battle Action Axe Throw
        New-EldVar -Name 'BAAxeThrowName' -Data 'Axe Throw' -ReadOnly
        New-EldVar -Name 'BAAxeThrowDesc' -Data 'Dont''t let one hit you on the way out.' -ReadOnly
        New-EldVar -Name 'BAAxeThrowType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAAxeThrowMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAAxeThrowEffectValue' -Data 180 -ReadOnly
        New-EldVar -Name 'BAAxeThrowChance' -Data 0.3 -ReadOnly

        # Variables that pertain to the Battle Action Knife Stab
        New-EldVar -Name 'BAKnifeStabName' -Data 'Knife Stab' -ReadOnly
        New-EldVar -Name 'BAKnifeStabDesc' -Data 'Just a little prick, right?' -ReadOnly
        New-EldVar -Name 'BAKnifeStabType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAKnifeStabMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAKnifeStabEffectValue' -Data 40 -ReadOnly
        New-EldVar -Name 'BAKnifeStabChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Knife Throw
        New-EldVar -Name 'BAKnifeThrowName' -Data 'Knife Throw' -ReadOnly
        New-EldVar -Name 'BAKnifeThrowDesc' -Data 'Like throwing dats, but cooler.' -ReadOnly
        New-EldVar -Name 'BAKnifeThrowType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAKnifeThrowMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAKnifeThrowEffectValue' -Data 80 -ReadOnly
        New-EldVar -Name 'BAKnifeThrowChance' -Data 0.3 -ReadOnly

        # Variables that pertain to the Battle Action Club Swing
        New-EldVar -Name 'BAClubSwingName' -Data 'Club Swing' -ReadOnly
        New-EldVar -Name 'BAClubSwingDesc' -Data 'Me Ooga. Me swing-um big-um sick.' -ReadOnly
        New-EldVar -Name 'BAClubSwingType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAClubSwingMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAClubSwingEffectValue' -Data 70 -ReadOnly
        New-EldVar -Name 'BAClubSwingChance' -Data 0.7 -ReadOnly

        # Variables that pertain to the Battle Action Homerun Hit
        New-EldVar -Name 'BAHomerunHitName' -Data 'Homerun Hit' -ReadOnly
        New-EldVar -Name 'BAHomerunHitDesc' -Data 'Swing, batter... SWING!' -ReadOnly
        New-EldVar -Name 'BAHomerunHitType' -Data [BattleActionType]::Physical -ReadOnly
        New-EldVar -Name 'BAHomerunHitMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAHomerunHitEffectValue' -Data 75 -ReadOnly
        New-EldVar -Name 'BAHomerunHitChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Flame Punch
        New-EldVar -Name 'BAFlamePunchName' -Data 'Flame Punch' -ReadOnly
        New-EldVar -Name 'BAFlamePunchDesc' -Data 'Flaming fists of fury.' -ReadOnly
        New-EldVar -Name 'BAFlamePunchType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAFlamePunchMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAFlamePunchEffectChance' -Data 75 -ReadOnly
        New-EldVar -Name 'BAFlamePunchChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Flame Kick
        New-EldVar -Name 'BAFlameKickName' -Data 'Flame Kick' -ReadOnly
        New-EldVar -Name 'BAFlameKickDesc' -Data 'I got canned heat on my heels.' -ReadOnly
        New-EldVar -Name 'BAFlameKickType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAFlameKickMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAFlameKickEffectChance' -Data 85 -ReadOnly
        New-EldVar -Name 'BAFlameKickChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Fireball
        New-EldVar -Name 'BAFireballName' -Data 'Fireball' -ReadOnly
        New-EldVar -Name 'BAFireballDesc' -Data 'That''s a spicy meatball!' -ReadOnly
        New-EldVar -Name 'BAFireballType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAFireballMpCost' -Data 7 -ReadOnly
        New-EldVar -Name 'BAFireballEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAFireballChance' -Data 0.75 -ReadOnly

        # Variables that pertain to the Battle Action Mortar Toss
        New-EldVar -Name 'BAMortarTossName' -Data 'Mortar Toss' -ReadOnly
        New-EldVar -Name 'BAMortarTossDesc' -Data 'An esploozshun of firez.' -ReadOnly
        New-EldVar -Name 'BAMortarTossType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAMortarTossMpCost' -Data 9 -ReadOnly
        New-EldVar -Name 'BAMortarTossEffectChance' -Data 100 -ReadOnly
        New-EldVar -Name 'BAMortarTossChance' -Data 0.7 -ReadOnly

        # Variables that pertain to the Battle Action IKill
        New-EldVar -Name 'BAIKillName' -Data 'IKill' -ReadOnly
        New-EldVar -Name 'BAIKillDesc' -Data 'Insta death.' -ReadOnly
        New-EldVar -Name 'BAIKillType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAIKillMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BAIKillEffectChance' -Data 50000 -ReadOnly
        New-EldVar -Name 'BAIKillChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Blaze Burst
        New-EldVar -Name 'BABlazeBurstName' -Data 'Blaze Burst' -ReadOnly
        New-EldVar -Name 'BABlazeBurstDesc' -Data 'Like an arc flash, only worse.' -ReadOnly
        New-EldVar -Name 'BABlazeBurstType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BABlazeBurstMpCost' -Data 10 -ReadOnly
        New-EldVar -Name 'BABlazeBurstEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BABlazeBurstChance' -Data 0.8 -ReadOnly

        # Variables that pertain to the Battle Action Flamethrower
        New-EldVar -Name 'BAFlamethrowerName' -Data 'Flamethrower' -ReadOnly
        New-EldVar -Name 'BAFlamethrowerDesc' -Data 'Our inspiration was Elon.' -ReadOnly
        New-EldVar -Name 'BAFlamethrowerType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAFlamethrowerMpCost' -Data 10 -ReadOnly
        New-EldVar -Name 'BAFlamethrowerEffectChance' -Data 90 -ReadOnly
        New-EldVar -Name 'BAFlamethrowerChance' -Data 0.7 -ReadOnly

        # Variables that pertain to the Battle Action Ember Slash
        New-EldVar -Name 'BAEmberSlashName' -Data 'Ember Slash' -ReadOnly
        New-EldVar -Name 'BAEmberSlashDesc' -Data 'At least the wound is cauterized.' -ReadOnly
        New-EldVar -Name 'BAEmberSlashType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAEmberSlashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAEmberSlashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAEmberSlashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Pyroblast
        New-EldVar -Name 'BAPyroblastName' -Data 'Pyroblast' -ReadOnly
        New-EldVar -Name 'BAPyroblastDesc' -Data 'Fireworks never looked so good.' -ReadOnly
        New-EldVar -Name 'BAPyroblastType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAPyroblastMpCost' -Data 15 -ReadOnly
        New-EldVar -Name 'BAPyroblastEffectChance' -Data 110 -ReadOnly
        New-EldVar -Name 'BAPyroblastChance' -Data 0.6 -ReadOnly

        # Variables that pertain to the Battle Action Ashen Nova
        New-EldVar -Name 'BAAshenNovaName' -Data 'Ashen Nova' -ReadOnly
        New-EldVar -Name 'BAAshenNovaDesc' -Data 'Reminds me of Pompeii. Only worse.' -ReadOnly
        New-EldVar -Name 'BAAshenNovaType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAAshenNovaMpCost' -Data 50 -ReadOnly
        New-EldVar -Name 'BAAshenNovaEffectChance' -Data 250 -ReadOnly
        New-EldVar -Name 'BAAshenNovaChance' -Data 0.5 -ReadOnly

        # Variables that pertain to the Battle Action Incenerate
        New-EldVar -Name 'BAIncenerateName' -Data 'Incenerate' -ReadOnly
        New-EldVar -Name 'BAIncenerateDesc' -Data 'Kill it with fire, they said.' -ReadOnly
        New-EldVar -Name 'BAIncenerateType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAIncenerateMpCost' -Data 20 -ReadOnly
        New-EldVar -Name 'BAIncenerateEffectChance' -Data 120 -ReadOnly
        New-EldVar -Name 'BAIncenerateChance' -Data 0.7 -ReadOnly

        # Variables that pertain to the Battle Action Cinder Storm
        New-EldVar -Name 'BACinderStormName' -Data 'Cinder Storm' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Hot coal hail. Yum.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 60 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Lava Surge
        New-EldVar -Name 'BALavaSurgeName' -Data 'Lava Surge' -ReadOnly
        New-EldVar -Name 'BALavaSurgeDesc' -Data 'It''s like a surge of love, only the molten kind.' -ReadOnly
        New-EldVar -Name 'BALavaSurgeType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BALavaSurgeMpCost' -Data 15 -ReadOnly
        New-EldVar -Name 'BALavaSurgeEffectChance' -Data 100 -ReadOnly
        New-EldVar -Name 'BALavaSurgeChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Fire Cataclysm
        New-EldVar -Name 'BAFireCataclysmName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalFire].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BAFireCataclysmDesc' -Data 'It''s like a surge of love, only the molten kind.' -ReadOnly
        New-EldVar -Name 'BAFireCataclysmType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BAFireCataclysmMpCost' -Data 50 -ReadOnly
        New-EldVar -Name 'BAFireCataclysmEffectChance' -Data 250 -ReadOnly
        New-EldVar -Name 'BAFireCataclysmChance' -Data 0.5 -ReadOnly

        # Variables that pertain to the Battle Action Ice Punch
        New-EldVar -Name 'BAIcePunchName' -Data 'Ice Punch' -ReadOnly
        New-EldVar -Name 'BAIcePunchDesc' -Data 'Frigid AND stiff.' -ReadOnly
        New-EldVar -Name 'BAIcePunchType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAIcePunchMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAIcePunchEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAIcePunchChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Frost Kick
        New-EldVar -Name 'BAFrostKickName' -Data 'Frost Kick' -ReadOnly
        New-EldVar -Name 'BAFrostKickDesc' -Data 'Ice on the knee. It''s a thing.' -ReadOnly
        New-EldVar -Name 'BAFrostKickType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAFrostKickMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAFrostKickEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAFrostKickChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Icicle Strike
        New-EldVar -Name 'BAIcicleStrikeName' -Data 'Icicle Strike' -ReadOnly
        New-EldVar -Name 'BAIcicleStrikeDesc' -Data 'When they''re this big, who needs a sword?' -ReadOnly
        New-EldVar -Name 'BAIcicleStrikeType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAIcicleStrikeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAIcicleStrikeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAIcicleStrikeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Glacial Spike
        New-EldVar -Name 'BAGlacialSpikeName' -Data 'Glacial Spike' -ReadOnly
        New-EldVar -Name 'BAGlacialSpikeDesc' -Data 'Global warming helped me make this one.' -ReadOnly
        New-EldVar -Name 'BAGlacialSpikeType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAGlacialSpikeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAGlacialSpikeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAGlacialSpikeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Chill Slash
        New-EldVar -Name 'BAChillSlashName' -Data 'Chill Slash' -ReadOnly
        New-EldVar -Name 'BAChillSlashDesc' -Data 'Let''s all cool down, yeah?' -ReadOnly
        New-EldVar -Name 'BAChillSlashType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAChillSlashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAChillSlashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAChillSlashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Ice Bolt
        New-EldVar -Name 'BAIceBoltName' -Data 'Ice Bolt' -ReadOnly
        New-EldVar -Name 'BAIceBoltDesc' -Data 'Not the kind of bolt you secure things with.' -ReadOnly
        New-EldVar -Name 'BAIceBoltType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAIceBoltMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAIceBoltEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAIceBoltChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Arctic Blast
        New-EldVar -Name 'BAArcticBlastName' -Data 'Arctic Blast' -ReadOnly
        New-EldVar -Name 'BAArcticBlastDesc' -Data 'Oh you won''t be long for gettin'' frushbit, now!' -ReadOnly
        New-EldVar -Name 'BAArcticBlastType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAArcticBlastMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAArcticBlastEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAArcticBlastChance' -Data 0.9 -ReadOnly
        
        # Variables that pertain to the Battle Action Frost Wave
        New-EldVar -Name 'BAFrostWaveName' -Data 'Frost Wave' -ReadOnly
        New-EldVar -Name 'BAFrostWaveDesc' -Data 'Ride the wave, dude.' -ReadOnly
        New-EldVar -Name 'BAFrostWaveType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAFrostWaveMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAFrostWaveEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAFrostWaveChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Arctic Fury
        New-EldVar -Name 'BAArcticFuryName' -Data 'Arctic Fury' -ReadOnly
        New-EldVar -Name 'BAArcticFuryDesc' -Data 'An ass whooping is a dish best served cold.' -ReadOnly
        New-EldVar -Name 'BAArcticFuryType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAArcticFuryMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAArcticFuryEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAArcticFuryChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Frozen Spear
        New-EldVar -Name 'BAFrozenSpearName' -Data 'Frozen Spear' -ReadOnly
        New-EldVar -Name 'BAFrozenSpearDesc' -Data 'I found this spear in a fridge.' -ReadOnly
        New-EldVar -Name 'BAFrozenSpearType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAFrozenSpearMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAFrozenSpearEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAFrozenSpearChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Hailstorm
        New-EldVar -Name 'BAHailstormName' -Data 'Hailstorm' -ReadOnly
        New-EldVar -Name 'BAHailstormDesc' -Data 'A common cause of insurance claims.' -ReadOnly
        New-EldVar -Name 'BAHailstormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAHailstormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAHailstormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAHailstormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Icefall Slam
        New-EldVar -Name 'BAIcefallSlamName' -Data 'Icefall Slam' -ReadOnly
        New-EldVar -Name 'BAIcefallSlamDesc' -Data 'Not avoiding the avalance is a bad idea.' -ReadOnly
        New-EldVar -Name 'BAIcefallSlamType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAIcefallSlamMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAIcefallSlamEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAIcefallSlamChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Ice Cataclysm
        New-EldVar -Name 'BAIceCataclysmName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalIce].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BAIceCataclysmDesc' -Data 'Frigid AND stiff' -ReadOnly
        New-EldVar -Name 'BAIceCataclysmType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BAIceCataclysmMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAIceCataclysmEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAIceCataclysmChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Aqua Jet
        New-EldVar -Name 'BAAquaJetName' -Data 'Aqua Jet' -ReadOnly
        New-EldVar -Name 'BAAquaJetDesc' -Data 'A Boeing 737 made entirely of water.' -ReadOnly
        New-EldVar -Name 'BAAquaJetType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAAquaJetMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAAquaJetEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAAquaJetChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tidal Surge
        New-EldVar -Name 'BATidalSurgeName' -Data 'Tidal Surge' -ReadOnly
        New-EldVar -Name 'BATidalSurgeDesc' -Data 'They ebb, they flow, they attac.' -ReadOnly
        New-EldVar -Name 'BATidalSurgeType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BATidalSurgeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATidalSurgeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATidalSurgeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Water Whip
        New-EldVar -Name 'BAWaterWhipName' -Data 'Water Whip' -ReadOnly
        New-EldVar -Name 'BAWaterWhipDesc' -Data 'Indiana Jones''s least favorite whip.' -ReadOnly
        New-EldVar -Name 'BAWaterWhipType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAWaterWhipMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAWaterWhipEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAWaterWhipChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Mist Strike
        New-EldVar -Name 'BAMistStrikeName' -Data 'Mist Strike' -ReadOnly
        New-EldVar -Name 'BAMistStrikeDesc' -Data 'Was it a cat I saw? Was I tac a ti saw?' -ReadOnly
        New-EldVar -Name 'BAMistStrikeType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAMistStrikeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAMistStrikeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAMistStrikeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Hydro Slash
        New-EldVar -Name 'BAHydroSlashName' -Data 'Hydro Slash' -ReadOnly
        New-EldVar -Name 'BAHydroSlashDesc' -Data 'A moistened bint lobbed this scimitar at me' -ReadOnly
        New-EldVar -Name 'BAHydroSlashType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAHydroSlashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAHydroSlashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAHydroSlashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Wave Punch
        New-EldVar -Name 'BAWavePunchName' -Data 'Wave Punch' -ReadOnly
        New-EldVar -Name 'BAWavePunchDesc' -Data 'The latest Hawaiian Punch flavor. Swelling aftertaste.' -ReadOnly
        New-EldVar -Name 'BAWavePunchType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAWavePunchMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAWavePunchEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAWavePunchChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Aquatic Bolt
        New-EldVar -Name 'BAAquaticBoltName' -Data 'Aquatic Bolt' -ReadOnly
        New-EldVar -Name 'BAAquaticBoltDesc' -Data 'Some watery things to pelt your neighbor with.' -ReadOnly
        New-EldVar -Name 'BAAquaticBoltType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAAquaticBoltMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAAquaticBoltEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAAquaticBoltChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Aqua Sphere
        New-EldVar -Name 'BAAquaSphereName' -Data 'Aqua Sphere' -ReadOnly
        New-EldVar -Name 'BAAquaSphereDesc' -Data 'Listen to ''Barbie Girl'' all day long. Enjoy.' -ReadOnly
        New-EldVar -Name 'BAAquaSphereType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAAquaSphereMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAAquaSphereEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAAquaSphereChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tidal Crush
        New-EldVar -Name 'BATidalCrushName' -Data 'Tidal Crush' -ReadOnly
        New-EldVar -Name 'BATidalCrushDesc' -Data 'Your high school crush came to kill you, in water form.' -ReadOnly
        New-EldVar -Name 'BATidalCrushType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BATidalCrushMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATidalCrushEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATidalCrushChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tsunami
        New-EldVar -Name 'BATsunamiName' -Data 'Tsunami' -ReadOnly
        New-EldVar -Name 'BATsunamiDesc' -Data 'WAVES!' -ReadOnly
        New-EldVar -Name 'BATsunamiType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BATsunamiMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATsunamiEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATsunamiChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Seafoam Bolt
        New-EldVar -Name 'BASeafoamBoltName' -Data 'Seafoam Bolt' -ReadOnly
        New-EldVar -Name 'BASeafoamBoltDesc' -Data 'Sometimes I see these white bubbles on the shore.' -ReadOnly
        New-EldVar -Name 'BASeafoamBoltType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BASeafoamBoltMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BASeafoamBoltEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BASeafoamBoltChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Typhoon
        New-EldVar -Name 'BATyphoonName' -Data 'Typhoon' -ReadOnly
        New-EldVar -Name 'BATyphoonDesc' -Data 'Not to be confused with the infamous Tie Foon.' -ReadOnly
        New-EldVar -Name 'BATyphoonType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BATyphoonMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATyphoonEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATyphoonChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Raindance
        New-EldVar -Name 'BARaindanceName' -Data 'Raindance' -ReadOnly
        New-EldVar -Name 'BARaindanceDesc' -Data 'Like Riverdance, only shit.' -ReadOnly
        New-EldVar -Name 'BARaindanceType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BARaindanceMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BARaindanceEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BARaindanceChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Watery Grave
        New-EldVar -Name 'BAWateryGraveName' -Data 'Watery Grave' -ReadOnly
        New-EldVar -Name 'BAWateryGraveDesc' -Data 'Davey Jones is holed up here.' -ReadOnly
        New-EldVar -Name 'BAWateryGraveType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAWateryGraveMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAWateryGraveEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAWateryGraveChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tempest
        New-EldVar -Name 'BATempestName' -Data 'Tempest' -ReadOnly
        New-EldVar -Name 'BATempestDesc' -Data 'If it were a tempest of love, would you feel any different?' -ReadOnly
        New-EldVar -Name 'BATempestType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BATempestMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATempestEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATempestChance' -Data 0.9 -ReadOnly

        
        # Variables that pertain to the Battle Action Water Cataclysm
        New-EldVar -Name 'BAWaterCataclysmName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalWater].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BAWaterCataclysmDesc' -Data 'Watery death rains down upon you.' -ReadOnly
        New-EldVar -Name 'BAWaterCataclysmType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BAWaterCataclysmMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAWaterCataclysmEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAWaterCataclysmChance' -Data 0.9 -ReadOnly
        
        # Variables that pertain to the Battle Action Terra Strike
        New-EldVar -Name 'BATerraStrikeName' -Data 'Terra Strike' -ReadOnly
        New-EldVar -Name 'BATerraStrikeDesc' -Data 'Sticks and stones can break your bones.' -ReadOnly
        New-EldVar -Name 'BATerraStrikeType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BATerraStrikeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATerraStrikeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATerraStrikeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Quake Fist
        New-EldVar -Name 'BAQuakeFistName' -Data 'Quake Fist' -ReadOnly
        New-EldVar -Name 'BAQuakeFistDesc' -Data 'Two nerds get in a fight at QuakeCon.' -ReadOnly
        New-EldVar -Name 'BAQuakeFistType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BAQuakeFistMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAQuakeFistEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAQuakeFistChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Boulder Bash
        New-EldVar -Name 'BABoulderBashName' -Data 'Boulder Bash' -ReadOnly
        New-EldVar -Name 'BABoulderBashDesc' -Data 'We played Resident Evil 5 to the end.' -ReadOnly
        New-EldVar -Name 'BABoulderBashType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BABoulderBashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BABoulderBashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BABoulderBashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Quake Fist
        New-EldVar -Name 'BAQuakeFistName' -Data 'Quake Fist' -ReadOnly
        New-EldVar -Name 'BAQuakeFistDesc' -Data 'Two nerds get in a fight at QuakeCon.' -ReadOnly
        New-EldVar -Name 'BAQuakeFistType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BAQuakeFistMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAQuakeFistEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAQuakeFistChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tremor
        New-EldVar -Name 'BATremorName' -Data 'Tremor' -ReadOnly
        New-EldVar -Name 'BATremorDesc' -Data 'Does more damage than those Kevin Bacon movies.' -ReadOnly
        New-EldVar -Name 'BATremorType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BATremorMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BATremorEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BATremorChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Granite Dust
        New-EldVar -Name 'BAGraniteDustName' -Data 'Granite Dust' -ReadOnly
        New-EldVar -Name 'BAGraniteDustDesc' -Data 'There''s blood on the ground before you know it.' -ReadOnly
        New-EldVar -Name 'BAGraniteDustType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BAGraniteDustMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAGraniteDustEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAGraniteDustChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Rockslide
        New-EldVar -Name 'BARockslideName' -Data 'Rockslide' -ReadOnly
        New-EldVar -Name 'BARockslideDesc' -Data 'Fallin'' rocks, fallin'' rocks, fallin'' rocks.' -ReadOnly
        New-EldVar -Name 'BARockslideType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BARockslideMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BARockslideEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BARockslideChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Sinkhole
        New-EldVar -Name 'BASinkholeName' -Data 'Sinkhole' -ReadOnly
        New-EldVar -Name 'BASinkholeDesc' -Data 'Tumbling down the rabbit hole.' -ReadOnly
        New-EldVar -Name 'BASinkholeType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BASinkholeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BASinkholeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BASinkholeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Geo Fence
        New-EldVar -Name 'BAGeoFenceName' -Data 'Geo Fence' -ReadOnly
        New-EldVar -Name 'BAGeoFenceDesc' -Data 'Get off my lawn!' -ReadOnly
        New-EldVar -Name 'BAGeoFenceType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BAGeoFenceMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAGeoFenceEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAGeoFenceChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Earth Cataclysm
        New-EldVar -Name 'BAEarthCataclysmName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalEarth].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BAEarthCataclysmDesc' -Data 'A rocky death rains down upon you.' -ReadOnly
        New-EldVar -Name 'BAEarthCataclysmType' -Data [BattleActionType]::ElementalEarth -ReadOnly
        New-EldVar -Name 'BAEarthCataclysmMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAEarthCataclysmEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAEarthCataclysmChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Gale Strike
        New-EldVar -Name 'BAGaleStrikeName' -Data 'Gale Strike' -ReadOnly
        New-EldVar -Name 'BAGaleStrikeDesc' -Data 'The wind can hurt you.' -ReadOnly
        New-EldVar -Name 'BAGaleStrikeType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BAGaleStrikeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAGaleStrikeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAGaleStrikeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Zephyr Slash
        New-EldVar -Name 'BAZephyrSlashName' -Data 'Zephyr Slash' -ReadOnly
        New-EldVar -Name 'BAZephyrSlashDesc' -Data 'What the hell is a zephyr anyway?' -ReadOnly
        New-EldVar -Name 'BAZephyrSlashType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BAZephyrSlashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAZephyrSlashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAZephyrSlashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Breeze Blade
        New-EldVar -Name 'BABreezeBladeName' -Data 'Breeze Blade' -ReadOnly
        New-EldVar -Name 'BABreezeBladeDesc' -Data 'Easy, breezy, bleedy, dying guy.' -ReadOnly
        New-EldVar -Name 'BABreezeBladeType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BABreezeBladeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BABreezeBladeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BABreezeBladeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Thunder Clap
        New-EldVar -Name 'BAThunderClapName' -Data 'Thunder Clap' -ReadOnly
        New-EldVar -Name 'BAThunderClapDesc' -Data 'Cometimes an euphemism, this time a threat.' -ReadOnly
        New-EldVar -Name 'BAThunderClapType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BAThunderClapMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAThunderClapEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAThunderClapChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Skyward Cut
        New-EldVar -Name 'BASkywardCutName' -Data 'Skyward Cut' -ReadOnly
        New-EldVar -Name 'BASkywardCutDesc' -Data 'Remember to always cut away from yourself.' -ReadOnly
        New-EldVar -Name 'BASkywardCutType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BASkywardCutMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BASkywardCutEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BASkywardCutChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Grand Flash
        New-EldVar -Name 'BAGrandFlashName' -Data 'Grand Flash' -ReadOnly
        New-EldVar -Name 'BAGrandFlashDesc' -Data 'Right when the lightning strikes.' -ReadOnly
        New-EldVar -Name 'BAGrandFlashType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BAGrandFlashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAGrandFlashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAGrandFlashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Cyclone
        New-EldVar -Name 'BACycloneName' -Data 'Cyclone' -ReadOnly
        New-EldVar -Name 'BACycloneDesc' -Data 'Something about moving all night long.' -ReadOnly
        New-EldVar -Name 'BACycloneType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BACycloneMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACycloneEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACycloneChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Lightning Bolt
        New-EldVar -Name 'BALightningBoltName' -Data 'Lightning Bolt' -ReadOnly
        New-EldVar -Name 'BALightningBoltDesc' -Data 'These look cool from a distance.' -ReadOnly
        New-EldVar -Name 'BALightningBoltType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BALightningBoltMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BALightningBoltEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BALightningBoltChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Galeflash
        New-EldVar -Name 'BAGaleflashName' -Data 'Galeflash' -ReadOnly
        New-EldVar -Name 'BAGaleflashDesc' -Data 'The lightning rode on the wind.' -ReadOnly
        New-EldVar -Name 'BAGaleflashType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BAGaleflashMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAGaleflashEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAGaleflashChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Breezy Wind
        New-EldVar -Name 'BABreezyWindName' -Data 'Breezy Wind' -ReadOnly
        New-EldVar -Name 'BABreezyWindDesc' -Data 'So brisk it''ll carry her bonnet off.' -ReadOnly
        New-EldVar -Name 'BABreezyWindType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BABreezyWindMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BABreezyWindEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BABreezyWindChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Leaf Shield
        New-EldVar -Name 'BALeafShieldName' -Data 'Leaf Shield' -ReadOnly
        New-EldVar -Name 'BALeafShieldDesc' -Data 'Are you sure this''ll work?' -ReadOnly
        New-EldVar -Name 'BALeafShieldType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BALeafShieldMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BALeafShieldEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BALeafShieldChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Wind Cataclysm
        New-EldVar -Name 'BAWindCataclysmName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalWind].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BAWindCataclysmDesc' -Data 'Windy death rains down upon you.' -ReadOnly
        New-EldVar -Name 'BAWindCataclysmType' -Data [BattleActionType]::ElementalWind -ReadOnly
        New-EldVar -Name 'BAWindCataclysmMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAWindCataclysmEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAWindCataclysmChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Radiance
        New-EldVar -Name 'BARadianceName' -Data 'Radiance' -ReadOnly
        New-EldVar -Name 'BARadianceDesc' -Data 'All teh brights.' -ReadOnly
        New-EldVar -Name 'BARadianceType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BARadianceMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BARadianceEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BARadianceChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Holy Nova
        New-EldVar -Name 'BAHolyNovaName' -Data 'Holy Nova' -ReadOnly
        New-EldVar -Name 'BAHolyNovaDesc' -Data 'More Bible than you can handle.' -ReadOnly
        New-EldVar -Name 'BAHolyNovaType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BAHolyNovaMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAHolyNovaEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAHolyNovaChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Divine Beam
        New-EldVar -Name 'BADivineBeamName' -Data 'Divine Beam' -ReadOnly
        New-EldVar -Name 'BADivineBeamDesc' -Data 'Got Jesus?' -ReadOnly
        New-EldVar -Name 'BADivineBeamType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BADivineBeamMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BADivineBeamEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BADivineBeamChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Prism Shock
        New-EldVar -Name 'BAPrismShockName' -Data 'Prism Shock' -ReadOnly
        New-EldVar -Name 'BAPrismShockDesc' -Data 'The pretty rainbow of death.' -ReadOnly
        New-EldVar -Name 'BAPrismShockType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BAPrismShockMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAPrismShockEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAPrismShockChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Halo Strike
        New-EldVar -Name 'BAHaloStrikeName' -Data 'Halo Strike' -ReadOnly
        New-EldVar -Name 'BAHaloStrikeDesc' -Data 'These surprisingly hurt.' -ReadOnly
        New-EldVar -Name 'BAHaloStrikeType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BAHaloStrikeMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAHaloStrikeEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAHaloStrikeChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Lightbringer
        New-EldVar -Name 'BALightbringerName' -Data 'Lightbringer' -ReadOnly
        New-EldVar -Name 'BALightbringerDesc' -Data 'Bring the party!' -ReadOnly
        New-EldVar -Name 'BALightbringerType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BALightbringerMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BALightbringerEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BALightbringerChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Sacred Pulse
        New-EldVar -Name 'BASacredPulseName' -Data 'Saced Pulse' -ReadOnly
        New-EldVar -Name 'BASacredPulseDesc' -Data 'The defunct newsletter of the Catholic Church.' -ReadOnly
        New-EldVar -Name 'BASacredPulseType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BASacredPulseMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BASacredPulseEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BASacredPulseChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Daybreaker
        New-EldVar -Name 'BADaybreakerName' -Data 'Daybreaker' -ReadOnly
        New-EldVar -Name 'BADaybreakerDesc' -Data 'Some status in Skyrim gave me this.' -ReadOnly
        New-EldVar -Name 'BADaybreakerType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BADaybreakerMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BADaybreakerEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BADaybreakerChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Angelic Hymn
        New-EldVar -Name 'BAAngelicHymnName' -Data 'Angelic Hymn' -ReadOnly
        New-EldVar -Name 'BAAngelicHymnDesc' -Data 'This is how I sound when I sing Britney Spears.' -ReadOnly
        New-EldVar -Name 'BAAngelicHymnType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BAAngelicHymnMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BAAngelicHymnEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BAAngelicHymnChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Brilliance
        New-EldVar -Name 'BABrillianceName' -Data 'Brilliance' -ReadOnly
        New-EldVar -Name 'BABrillianceDesc' -Data 'How I feel when I look at myself in the mirror.' -ReadOnly
        New-EldVar -Name 'BABrillianceType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BABrillianceMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BABrillianceEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BABrillianceChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Sunfire
        New-EldVar -Name 'BASunfireName' -Data 'Sunfire' -ReadOnly
        New-EldVar -Name 'BASunfireDesc' -Data 'Scorched Earth, mofo.' -ReadOnly
        New-EldVar -Name 'BASunfireType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BASunfireMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BASunfireEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BASunfireChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Light Cataclysm
        New-EldVar -Name 'BALightCataclysmName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalLight].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BALightCataclysmDesc' -Data 'Holy death rains down upon you.' -ReadOnly
        New-EldVar -Name 'BALightCataclysmType' -Data [BattleActionType]::ElementalLight -ReadOnly
        New-EldVar -Name 'BALightCataclysmMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BALightCataclysmEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BALightCataclysmChance' -Data 0.9 -ReadOnly        

        Write-Progress -Activity 'Setting Up Globals' -Id 1 -PercentComplete -1 -Completed
    }
}

<#
.SYNOPSIS
Removes all ELD variables from the Variable PSDrive. This function is intended to be called at the cleanup state.
#>
Function Remove-EldVars {
    Process {
        Get-ChildItem Variable: | Where-Object { $_.Name -LIKE 'ELD:*' } | Remove-Variable -Scope Global -Force -ErrorAction SilentlyContinue
    }
}
