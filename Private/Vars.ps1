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
        New-EldVar -Name 'BABashType' -Data [BattleActionType]::Physical
        New-EldVar -Name 'BABashMpCost' -Data 0 -ReadOnly
        New-EldVar -Name 'BABashEffectValue' -Data 75 -ReadOnly
        New-EldVar -Name 'BABashChance' -Data 0.7 -ReadOnly

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
