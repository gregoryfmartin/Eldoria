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
        New-EldVar -Name 'BACinderStormName' -Data 'Lava Surge' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'It''s like a surge of love, only the molten kind.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 15 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 100 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 1.0 -ReadOnly

        # Variables that pertain to the Battle Action Fire Cataclysm
        New-EldVar -Name 'BACinderStormName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalFire].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'It''s like a surge of love, only the molten kind.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalFire -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 50 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 250 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.5 -ReadOnly

        # Variables that pertain to the Battle Action Ice Punch
        New-EldVar -Name 'BACinderStormName' -Data 'Ice Punch' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Frigid AND stiff.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Frost Kick
        New-EldVar -Name 'BACinderStormName' -Data 'Frost Kick' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Ice on the knee. It''s a thing.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Icicle Strike
        New-EldVar -Name 'BACinderStormName' -Data 'Icicle Strike' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'When they''re this big, who needs a sword?' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Glacial Spike
        New-EldVar -Name 'BACinderStormName' -Data 'Glacial Spike' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Global warming helped me make this one.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Chill Slash
        New-EldVar -Name 'BACinderStormName' -Data 'Chill Slash' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Let''s all cool down, yeah?' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Ice Bolt
        New-EldVar -Name 'BACinderStormName' -Data 'Ice Bolt' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Not the kind of bolt you secure things with.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Arctic Blast
        New-EldVar -Name 'BACinderStormName' -Data 'Arctic Blast' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Oh you won''t be long for gettin'' frushbit, now!' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly
        
        # Variables that pertain to the Battle Action Frost Wave
        New-EldVar -Name 'BACinderStormName' -Data 'Frost Wave' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Ride the wave, dude.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Arctic Fury
        New-EldVar -Name 'BACinderStormName' -Data 'Arctic Fury' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'An ass whooping is a dish best served cold.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Frozen Spear
        New-EldVar -Name 'BACinderStormName' -Data 'Frozen Spear' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'I found this spear in a fridge.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Hailstorm
        New-EldVar -Name 'BACinderStormName' -Data 'Hailstorm' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'A common cause of insurance claims.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Icefall Slam
        New-EldVar -Name 'BACinderStormName' -Data 'Icefall Slam' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Not avoiding the avalance is a bad idea.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Ice Cataclysm
        New-EldVar -Name 'BACinderStormName' -Data "$((Get-EldVar -Name 'BATAdornmentCharTable').Value[[BattleActionType]::ElementalIce].Item1) Cataclysm" -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Frigid AND stiff' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalIce -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Aqua Jet
        New-EldVar -Name 'BACinderStormName' -Data 'Aqua Jet' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'A Boeing 737 made entirely of water.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tidal Surge
        New-EldVar -Name 'BACinderStormName' -Data 'Tidal Surge' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'They ebb, they flow, they attac.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Water Whip
        New-EldVar -Name 'BACinderStormName' -Data 'Water Whip' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Indiana Jones''s least favorite whip.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Mist Strike
        New-EldVar -Name 'BACinderStormName' -Data 'Mist Strike' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Was it a cat I saw? Was I tac a ti saw?' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Hydro Slash
        New-EldVar -Name 'BACinderStormName' -Data 'Hydro Slash' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'A moistened bint lobbed this scimitar at me' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Wave Punch
        New-EldVar -Name 'BACinderStormName' -Data 'Wave Punch' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'The latest Hawaiian Punch flavor. Swelling aftertaste.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Aquatic Bolt
        New-EldVar -Name 'BACinderStormName' -Data 'Aquatic Bolt' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Some watery things to pelt your neighbor with.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Aqua Sphere
        New-EldVar -Name 'BACinderStormName' -Data 'Aqua Sphere' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Listen to ''Barbie Girl'' all day long. Enjoy.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tidal Crush
        New-EldVar -Name 'BACinderStormName' -Data 'Tidal Crush' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Your high school crush came to kill you, in water form.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Tsunami
        New-EldVar -Name 'BACinderStormName' -Data 'Tsunami' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'WAVES!' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Seafoam Bolt
        New-EldVar -Name 'BACinderStormName' -Data 'Seafoam Bolt' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Sometimes I see these white bubbles on the shore.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Typhoon
        New-EldVar -Name 'BACinderStormName' -Data 'Typhoon' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Not to be confused with the infamous Tie Foon.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Raindance
        New-EldVar -Name 'BACinderStormName' -Data 'Raindance' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Like Riverdance, only shit.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

        # Variables that pertain to the Battle Action Watery Grave
        New-EldVar -Name 'BACinderStormName' -Data 'Watery Grave' -ReadOnly
        New-EldVar -Name 'BACinderStormDesc' -Data 'Davey Jones is holed up here.' -ReadOnly
        New-EldVar -Name 'BACinderStormType' -Data [BattleActionType]::ElementalWater -ReadOnly
        New-EldVar -Name 'BACinderStormMpCost' -Data 5 -ReadOnly
        New-EldVar -Name 'BACinderStormEffectChance' -Data 80 -ReadOnly
        New-EldVar -Name 'BACinderStormChance' -Data 0.9 -ReadOnly

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
