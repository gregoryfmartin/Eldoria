using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host
using namespace System.Management.Automation.Runspaces
using namespace System.Media

Set-StrictMode -Version Latest

###############################################################################
#
# GLOBAL VARIABLES
#
###############################################################################

[Int]                             $Script:SceneImagesToLoad              = $(Get-ChildItem "$PSScriptRoot\..\Resources\ImageData").Count
[Int]                             $Script:SceneImagesLoaded              = 0
[Int]                             $Script:MaxWidth                       = 80
[Int]                             $Script:SSAPECounter                   = 0
[Int]                             $Script:SSAPETimeout                   = 1000
[Int]                             $Script:ItemClearAreaTop               = 1
[Int]                             $Script:ItemClearAreaLeft              = 12
[Int]                             $Script:ItemClearAreaRight             = 70
[Int]                             $Script:ItemClearAreaBottom            = 25
[String]                          $Script:SfxUiChevronMove               = "$PSScriptRoot\..\Resources\SFX\UI Chevron Move.wav"
[String]                          $Script:SfxUiSelectionValid            = "$PSScriptRoot\..\Resources\SFX\UI Selection Valid.wav"
[String]                          $Script:SfxBaPhysicalStrikeA           = "$PSScriptRoot\..\Resources\SFX\BA Physical Strike 0001.wav"
[String]                          $Script:SfxBaMissFail                  = "$PSScriptRoot\..\Resources\SFX\BA Miss Fail.wav"
[String]                          $Script:SfxBaActionDisabled            = "$PSScriptRoot\..\Resources\SFX\BA Action Disabled.wav"
[String]                          $Script:SfxBaFireStrikeA               = "$PSScriptRoot\..\Resources\SFX\BA Fire Strike 0001.wav"
[String]                          $Script:SfxBattleIntro                 = "$PSScriptRoot\..\Resources\SFX\Battle Intro.wav"
[String]                          $Script:SfxBattlePlayerWin             = "$PSScriptRoot\..\Resources\SFX\Battle Player Win.wav"
[String]                          $Script:SfxBattlePlayerLose            = "$PSScriptRoot\..\Resources\SFX\Battle Player Lose.wav"
[String]                          $Script:BgmBattleThemeA                = "$PSScriptRoot\..\Resources\BGM\Battle Theme A.wav"
[String]                          $Script:SfxBattleNem                   = "$PSScriptRoot\..\Resources\SFX\UI Selection NEM.wav"
[String]                          $Script:BgmTitleThemeA                 = "$PSScriptRoot\..\Resources\BGM\Title Theme A.wav"
[String]                          $Script:BgmTitleThemeB                 = "$PSScriptRoot\..\Resources\BGM\Title Theme B.wav"
[String]                          $Script:BgmPlayerSetupThemeA           = "$PSScriptRoot\..\Resources\BGM\Player Setup Theme A.wav"
[String]                          $Script:TheGameSubtitle                = 'A NOT GARY GAME'
[Hashtable]                       $Script:SpectreBBPRounded              = @{}
[Hashtable]                       $Script:SpectreBBPSquare               = @{}
[Hashtable]                       $Script:CurrentWindowDesign            = @{}
[String[]]                        $Script:BadCommandRetorts              = @()
[StatusWindow]                    $Script:TheStatusWindow                = [StatusWindow]::new()
[CommandWindow]                   $Script:TheCommandWindow               = [CommandWindow]::new()
[SceneWindow]                     $Script:TheSceneWindow                 = [SceneWindow]::new()
[MessageWindow]                   $Script:TheMessageWindow               = [MessageWindow]::new()
[InventoryWindow]                 $Script:TheInventoryWindow             = $null
[ATCoordinatesDefault]            $Script:DefaultCursorCoordinates       = [ATCoordinatesDefault]::new()
[BattleEntityStatusWindow]        $Script:ThePlayerBattleStatWindow      = $null
[BattleEntityStatusWindow]        $Script:TheEnemyBattleStatWindow       = $null
[BattlePlayerActionWindow]        $Script:ThePlayerBattleActionWindow    = $null
[BattleStatusMessageWindow]       $Script:TheBattleStatusMessageWindow   = $null
[BattleEnemyImageWindow]          $Script:TheBattleEnemyImageWindow      = $null
[BattlePhaseIndicator]            $Script:TheBattlePhaseIndicator        = $null
[StatusHudWindow]                 $Script:TheStatusHudWindow             = $null
[StatusTechniqueSelectionWindow]  $Script:TheStatusTechSelectionWindow   = $null
[StatusTechniqueInventoryWindow]  $Script:TheStatusTechInventoryWindow   = $null
[BufferManager]                   $Script:TheBufferManager               = [BufferManager]::new()
[GameCore]                        $Script:TheGameCore                    = [GameCore]::new()
[EnemyBattleEntity]               $Script:TheCurrentEnemy                = $null
[BattleManager]                   $Script:TheBattleManager               = $null
[SoundPlayer]                     $Script:TheSfxMachine                  = [SoundPlayer]::new()
[SoundPlayer]                     $Script:TheBgmMachine                  = [SoundPlayer]::new()
[Boolean]                         $Script:IsBattleBgmPlaying             = $false
[Boolean]                         $Script:HasBattleIntroPlayed           = $false
[Boolean]                         $Script:HasBattleWonChimePlayed        = $false
[Boolean]                         $Script:HasBattleLostChimePlayed       = $false
[Boolean]                         $Script:GpsRestoredFromInvBackup       = $true
[Boolean]                         $Script:GpsRestoredFromBatBackup       = $false
[Boolean]                         $Script:GpsRestoredFromStaBackup       = $false
[Boolean]                         $Script:BattleCursorVisible            = $false
[Boolean]                         $Script:HasTitleBgmStarted             = $false
[Boolean]                         $Script:HasSubtitleBeenWritten         = $false
[Boolean]                         $Script:HasSubtitleBeenColored         = $false
[Boolean]                         $Script:HasSSAPressEnterShown          = $false
[Boolean]                         $Script:HasSSAPressEnterToggled        = $false
[Boolean]                         $Script:HasSSASetupRunspace            = $false
[Boolean]                         $Script:PlayerSetupThemePlaying        = $false
[Boolean]                         $Script:GpsBufferCleared               = $false
[EEIBat]                          $Script:EeiBat                         = [EEIBat]::new()
[EEINightwing]                    $Script:EeiNightwing                   = [EEINightwing]::new()
[EEIWingblight]                   $Script:EeiWingblight                  = [EEIWingblight]::new()
[EEIDarkfang]                     $Script:EeiDarkfang                    = [EEIDarkfang]::new()
[EEINocturna]                     $Script:EeiNocturna                    = [EEINocturna]::new()
[EEIBloodswoop]                   $Script:EeiBloodswoop                  = [EEIBloodswoop]::new()
[EEIDuskbane]                     $Script:EeiDuskbane                    = [EEIDuskbane]::new()
[System.Windows.Media.MediaPlayer]$Script:TheSfxMPlayer                  = [System.Windows.Media.MediaPlayer]::new()
[System.Windows.Media.MediaPlayer]$Script:TheBgmMPlayer                  = [System.Windows.Media.MediaPlayer]::new()
[Double]                          $Script:AffinityMultNeg                = -0.75
[Double]                          $Script:AffinityMultPos                = 1.6
[ActionSlot]                      $Script:StatusEsSelectedSlot           = [ActionSlot]::None
[BattleAction]                    $Script:StatusIsSelected               = $null
[StatusScreenMode]                $Script:StatusScreenMode               = [StatusScreenMode]::EquippedTechSelection
[GameStatePrimary]                $Script:TheGlobalGameState             = [GameStatePrimary]::PlayerSetupScreen
[GameStatePrimary]                $Script:ThePreviousGlobalGameState     = $Script:TheGlobalGameState
[Map]                             $Script:SampleMap                      = $null
[Map]                             $Script:SampleWarpMap01                = $null
[Map]                             $Script:SampleWarpMap02                = $null
[Map]                             $Script:CurrentMap                     = $null
[Map]                             $Script:PreviousMap                    = $null
[SSAFiglet]                       $Script:TheTitleFiglet                 = [SSAFiglet]::new()
[SSASubtitle]                     $Script:TheSubtitleFiglet              = [SSASubtitle]::new()
[SSAPressEnterPrompt]             $Script:TheSSAPressEnterPrompt         = [SSAPressEnterPrompt]::new()
[TtySpeed]                        $Script:TeletypeSpeed                  = [TtySpeed]::Slow
[Runspace]                        $Script:TheOffThread                   = [RunspaceFactory]::CreateRunspace()
[PowerShell]                      $Script:TheOffShell                    = [PowerShell]::Create()
[IAsyncResult]                    $Script:SSAInputAsr                    = $null
[PlayerSetupScreenStates]         $Script:ThePssSubstate                 = [PlayerSetupScreenStates]::new()
[PSNameEntryWindow]               $Script:ThePSNameEntryWindow           = $null
[PSGenderSelectionWindow]         $Script:ThePSGenderSelectionWindow     = $null
[PSBonusPointAllocWindow]         $Script:ThePSBonusPointAllocWindow     = $null
[PSAffinitySelectWindow]          $Script:ThePSAffinitySelectWindow      = $null
[PSProfileSelectWindow]           $Script:ThePSProfileSelectWindow       = $null
[PSConfirmDialog]                 $Script:ThePSConfirmDialog             = $null
[StatusScreenState]               $Script:TheStatusScreenState           = [StatusScreenState]::Setup
[PlayerStatusMainMenu]            $Script:ThePlayerStatusMainMenu        = $null
[PlayerStatusSummaryWindow]       $Script:ThePlayerStatusSummaryWindow   = $null
[StatusItemInventoryWindow]       $Script:TheStatusItemInventoryWindow   = $null
[StatusItemHeaderWindow]          $Script:TheStatusItemHeaderWindow      = $null
[StatusItemDropConfirmDialog]     $Script:TheStatusItemConfirmDropDialog = $null
[VerticalInventoryWindow]         $Script:TheVerticalInventoryWindow     = $null
[MapTileObject]                   $Script:TheItemToDrop                  = $null


[String[]]$Script:FemaleImageData = @(
    $Script:ElfFemaleImageDataA,
    $Script:ElfFemaleImageDataB,
    $Script:ElfFemaleImageDataC,
    $Script:ElfFemaleImageDataD,
    $Script:ElfFemaleImageDataE,
    $Script:HumanFemaleImageDataA,
    $Script:HumanFemaleImageDataB,
    $Script:HumanFemaleImageDataC,
    $Script:HumanFemaleImageDataD,
    $Script:HumanFemaleImageDataE
)

[String[]]$Script:MaleImageData = @(
    $Script:ElfMaleImageDataA,
    $Script:ElfMaleImageDataB,
    $Script:ElfMaleImageDataC,
    $Script:HumanMaleImageDataA,
    $Script:HumanMaleImageDataB,
    $Script:HumanMaleImageDataC
)

[Hashtable]$Script:TheSceneImages = @{
    'FieldPlainsNoRoad'                          = [SIFieldPlainsNoRoad]::new()
    'FieldPlainsRoadNorth'                       = [SIFieldPlainsRoadNorth]::new()
    'FieldPlainsRoadSouth'                       = [SIFieldPlainsRoadSouth]::new()
    'FieldPlainsRoadEast'                        = [SIFieldPlainsRoadEast]::new()
    'FieldPlainsRoadWest'                        = [SIFieldPlainsRoadWest]::new()
    'FieldPlainsRoadNorthEast'                   = [SIFieldPlainsRoadNorthEast]::new()
    'FieldPlainsRoadNorthWest'                   = [SIFieldPlainsRoadNorthWest]::new()
    'FieldPlainsRoadNorthSouth'                  = [SIFieldPlainsRoadNorthSouth]::new()
    'FieldPlainsRoadEastWest'                    = [SIFieldPlainsRoadEastWest]::new()
    'FieldPlainsRoadNorthSouthEast'              = [SIFieldPlainsRoadNorthSouthEast]::new()
    'FieldPlainsRoadNorthSouthEastWest'          = [SIFieldPlainsRoadNorthSouthEastWest]::new()
    'FieldPlainsRoadNorthSouthWest'              = [SIFieldPlainsRoadNorthSouthWest]::new()
    'RiverRoadSample'                            = [SIRiverRoadSample]::new()
    'RiverRoadEWNSSample'                        = [SIRiverRoadEWNSSample]::new()
    'RiverRoadEWSSSample'                        = [SIRiverRoadEWSSSample]::new()
    'Random'                                     = [SIRandomNoise]::new()
    'SIRiverOnEastAtNorth'                       = [SIRiverOnEastAtNorth]::new()
    'SIRiverOnEastAtSouth'                       = [SIRiverOnEastAtSouth]::new()
    'SIRiverOnEastWestAtNorth'                   = [SIRiverOnEastWestAtNorth]::new()
    'SIRiverOnEastWestAtNorthSouth'              = [SIRiverOnEastWestAtNorthSouth]::new()
    'SIRiverOnEastWestNorthSouthAtEast'          = [SIRiverOnEastWestNorthSouthAtEast]::new()
    'SIRiverOnEastWestNorthSouthAtEastWest'      = [SIRiverOnEastWestNorthSouthAtEastWest]::new()
    'SIRiverOnEastWestNorthSouthAtEastWestSouth' = [SIRiverOnEastWestNorthSouthAtEastWestSouth]::new()
    'SIRiverOnEastWestNorthSouthAtWest'          = [SIRiverOnEastWestNorthSouthAtWest]::new()
    'SIRiverOnNorthEastAtNorth'                  = [SIRiverOnNorthEastAtNorth]::new()
    'SIRiverOnNorthSouthAtEast'                  = [SIRiverOnNorthSouthAtEast]::new()
    'SIRiverOnNorthSouthAtWest'                  = [SIRiverOnNorthSouthAtWest]::new()
    'SIRiverOnNorthSouthEastAtEast'              = [SIRiverOnNorthSouthEastAtEast]::new()
    'SIRiverOnNorthSouthEastAtNorth'             = [SIRiverOnNorthSouthEastAtNorth]::new()
    'SIRiverOnSouthAtEast'                       = [SIRiverOnSouthAtEast]::new()
    'SIRiverOnSouthEastAtSouthEast'              = [SIRiverOnSouthEastAtSouthEast]::new()
    'SIRiverOnWestAtNorth'                       = [SIRiverOnWestAtNorth]::new()
    'SIRiverOnWestAtSouth'                       = [SIRiverOnWestAtSouth]::new()
    'SIRiverOnWestEastAtSouth'                   = [SIRiverOnWestEastAtSouth]::new()
    'SIRiverOnWestNorthAtNorth'                  = [SIRiverOnWestNorthAtNorth]::new()
    'SIRiverOnWestNorthSouthAtNorth'             = [SIRiverOnWestNorthSouthAtNorth]::new()
}

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

[Map]$Script:SampleMap       = [Map]::new("$PSScriptRoot\..\Resources\MapData\SampleMap.json")
[Map]$Script:SampleWarpMap01 = [Map]::new("$PSScriptRoot\..\Resources\MapData\MapWarpTest01.json")
[Map]$Script:SampleWarpMap02 = [Map]::new("$PSScriptRoot\..\Resources\MapData\MapWarpTest02.json")
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

$Script:SpectreBBPRounded = @{
    [WindowBorderPart]::LeftTop     = '╭'
    [WindowBorderPart]::Top         = '─'
    [WindowBorderPart]::RightTop    = '╮'
    [WindowBorderPart]::Left        = '│'
    [WindowBorderPart]::Right       = '│'
    [WindowBorderPart]::LeftBottom  = '╰'
    [WindowBorderPart]::Bottom      = '─'
    [WindowBorderPart]::RightBottom = '╯'
}

$Script:SpectreBBPSquare = @{
    [WindowBorderPart]::LeftTop     = '┌'
    [WindowBorderPart]::Top         = '─'
    [WindowBorderPart]::RightTop    = '┐'
    [WindowBorderPart]::Left        = '│'
    [WindowBorderPart]::Right       = '│'
    [WindowBorderPart]::LeftBottom  = '└'
    [WindowBorderPart]::Bottom      = '─'
    [WindowBorderPart]::RightBottom = '┘'
}

$Script:CurrentWindowDesign = $SpectreBBPRounded

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

[ScriptBlock]$Script:TheSplashScreenAState = {}

[ScriptBlock]$Script:TheSplashScreenBState = {}

[ScriptBlock]$Script:TheTitleScreenState = {
    Write-Host "$([ATControlSequences]::CursorHide)"

    If($Script:HasSSASetupRunspace -EQ $false) {
        $Script:TheOffThread = [RunspaceFactory]::CreateRunspace()
        $Script:TheOffShell  = [PowerShell]::Create()

        $Script:TheOffThread.Open()
        $Script:TheOffShell.Runspace = $Script:TheOffThread
        $Script:TheOffShell.AddScript({
            [Console]::ReadKey($true)
        })

        $Script:SSAInputAsr = $Script:TheOffShell.BeginInvoke()

        $Script:HasSSASetupRunspace = $true
    }

    # TEMPORARILY DISABLE THE TITLE TRACK FROM PLAYING!!!
    <#
    If($Script:HasTitleBgmStarted -EQ $false) {
        Start-Sleep -Seconds 1
        Try {
            $Script:TheBgmMPlayer.Open($Script:BgmTitleThemeB)
            $Script:TheBgmMPlayer.Play()
        } Catch {}
        $Script:HasTitleBgmStarted = $true
    }
    #>

    $Script:TheTitleFiglet.Draw()

    If($Script:HasSubtitleBeenWritten -EQ $false) {
        [Char[]]$CharArr   = $Script:TheGameSubtitle.ToCharArray()
        [Int]$PrintCounter = 0
        [Int]$Probe        = 0
        [Int]$PrintCol     = 33

        While($Probe -LE ($CharArr.Count - 1)) {
            $PrintCounter++
            If($PrintCounter -GE $Script:TeletypeSpeed) {
                $PrintCounter = 0
                Write-Host "$([ATControlSequences]::GenerateCoordinateString(9, $PrintCol))$($CharArr[$Probe])" -NoNewline
                $Probe++
                $PrintCol++
            }
        }

        $Script:HasSubtitleBeenWritten = $true
    }

    If($Script:HasSubtitleBeenColored -EQ $false) {
        $Script:TheSubtitleFiglet.Draw()
        $Script:HasSubtitleBeenColored = $true
    }

    If((Get-Random -Minimum 1 -Maximum 50000) -LT 250) {
        $Script:HasSubtitleBeenColored  = $false
        $Script:TheSubtitleFiglet.Dirty = $true
    }

    If($Script:HasSSAPressEnterShown -EQ $false) {
        $Script:TheSSAPressEnterPrompt.Draw()
        $Script:HasSSAPressEnterShown = $true
    }

    If($Script:HasSSAPressEnterShown -EQ $true) {
        $Script:SSAPECounter++
        If($Script:SSAPECounter -GE $Script:SSAPETimeout) {
            $Script:SSAPECounter                    = 0
            $Script:TheSSAPressEnterPrompt.DrawMode = -NOT $Script:TheSSAPressEnterPrompt.DrawMode
            $Script:TheSSAPressEnterPrompt.Dirty    = $true
            $Script:TheSSAPressEnterPrompt.Draw()
        }
    }

    If($Script:SSAInputAsr.IsCompleted -EQ $true) {
        $SSAKeyPressInfo = $Script:TheOffShell.EndInvoke($Script:SSAInputAsr) | Select-Object -First 1
        
        If($SSAKeyPressInfo.Key -NE [ConsoleKey]::Enter) {
            $Script:HasSSASetupRunspace = $false
        } Else {
            Try {
                $Script:TheBgmMPlayer.Stop()
            } Catch {}
            $Script:HasTitleBgmStarted = $false

            $Script:TheOffThread.Dispose()
            $Script:TheOffShell.Dispose()

            $Script:TheBufferManager.CopyActiveToBufferAWithWipe()

            Start-Sleep -Seconds 1

            $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
            $Script:TheGlobalGameState         = [GameStatePrimary]::PlayerSetupScreen
        }
    }

    Write-Host "$([ATControlSequences]::GenerateCoordinateString(1, 1))"
}

[ScriptBlock]$Script:ThePlayerSetupState = {
    Switch($Script:ThePssSubstate) {
        ([PlayerSetupScreenStates]::PlayerSetupSetup) {
            # CLEANUP THE PREVIOUS STATE
            If($null -NE $Script:TheTitleFiglet) {
                $Script:TheTitleFiglet = $null
            }
            If($null -NE $Script:TheSubtitleFiglet) {
                $Script:TheSubtitleFiglet = $null
            }
            If($null -NE $Script:TheSSAPressEnterPrompt) {
                $Script:TheSSAPressEnterPrompt = $null
            }
            
            # TRANSITION TO THE NEXT STATE AUTOMATICALLY
            $Script:ThePssSubstate = [PlayerSetupScreenStates]::PlayerSetupNameEntry
            
            Break
        }
        
        ([PlayerSetupScreenStates]::PlayerSetupNameEntry) {
            If($Script:ThePSGenderSelectionWindow -NE $null) {
                If($Script:ThePSGenderSelectionWindow.IsActive -EQ $true) {
                    $Script:ThePSGenderSelectionWindow.IsActive = $false
                    $Script:ThePSGenderSelectionWindow.HasBorderBeenRedrawn = $false
                    $Script:ThePSGenderSelectionWindow.Draw()
                    
                    $Script:ThePSNameEntryWindow.IsActive = $true
                    $Script:ThePSNameEntryWindow.HasBorderBeenRedrawn = $false
                }
            }
            
            If($null -EQ $Script:ThePSNameEntryWindow) {
                $Script:ThePSNameEntryWindow           = [PSNameEntryWindow]::new()
                $Script:ThePSNameEntryWindow.IsActive = $true
            }
            
            $Script:ThePSNameEntryWindow.Draw()
            $Script:ThePSNameEntryWindow.HandleInput()
            
            Break
        }
        
        ([PlayerSetupScreenStates]::PlayerSetupGenderSelection) {
            If($Script:ThePSNameEntryWindow.IsActive -EQ $true) {
                $Script:ThePSNameEntryWindow.IsActive = $false
                $Script:ThePSNameEntryWindow.HasBorderBeenRedrawn = $false
                $Script:ThePSNameEntryWindow.Draw()
            }
            
            If($Script:ThePSBonusPointAllocWindow -NE $null) {
                If($Script:ThePSBonusPointAllocWindow.IsActive -EQ $true) {
                    $Script:ThePSBonusPointAllocWindow.IsActive = $false
                    $Script:ThePSBonusPointAllocWindow.HasBorderBeenRedrawn = $false
                    $Script:ThePSBonusPointAllocWindow.Draw()
                    
                    $Script:ThePSGenderSelectionWindow.IsActive = $true
                    $Script:ThePSGenderSelectionWindow.HasBorderBeenRedrawn = $false
                }
            }
            
            If($null -EQ $Script:ThePSGenderSelectionWindow) {
                $Script:ThePSGenderSelectionWindow          = [PSGenderSelectionWindow]::new()
                $Script:ThePSGenderSelectionWindow.IsActive = $true
            }
            
            $Script:ThePSGenderSelectionWindow.Draw()
            $Script:ThePSGenderSelectionWindow.HandleInput()
            
            Break
        }
        
        ([PlayerSetupScreenStates]::PlayerSetupPointAllocate) {
            If($Script:ThePSGenderSelectionWindow.IsActive -EQ $true) {
                $Script:ThePSGenderSelectionWindow.IsActive             = $false
                $Script:ThePSGenderSelectionWindow.HasBorderBeenRedrawn = $false
                $Script:ThePSGenderSelectionWindow.Draw()
            }
            
            If($Script:ThePSAffinitySelectWindow -NE $null) {
                If($Script:ThePSAffinitySelectWindow.IsActive -EQ $true) {
                    $Script:ThePSAffinitySelectWindow.IsActive = $false
                    $Script:ThePSAffinitySelectWindow.HasBorderBeenRedrawn = $false
                    $Script:ThePSAffinitySelectWindow.Draw()
                    
                    $Script:ThePSBonusPointAllocWindow.IsActive = $true
                    $Script:ThePSBonusPointAllocWindow.HasBorderBeenRedrawn = $false
                }
            }

            If($null -EQ $Script:ThePSBonusPointAllocWindow) {
                $Script:ThePSBonusPointAllocWindow          = [PSBonusPointAllocWindow]::new()
                $Script:ThePSBonusPointAllocWindow.IsActive = $true
            }
            
            $Script:ThePSBonusPointAllocWindow.Draw()
            $Script:ThePSBonusPointAllocWindow.HandleInput()
        }
        
        ([PlayerSetupScreenStates]::PlayerSetupAffinitySelect) {
            If($Script:ThePSBonusPointAllocWindow.IsActive -EQ $true) {
                $Script:ThePSBonusPointAllocWindow.IsActive = $false
                $Script:ThePSBonusPointAllocWindow.HasBorderBeenRedrawn = $false
                $Script:ThePSBonusPointAllocWindow.Draw()
            }
            
            If($Script:ThePSProfileSelectWindow -NE $null) {
                If($Script:ThePSProfileSelectWindow.IsActive -EQ $true) {
                    $Script:ThePSProfileSelectWindow.IsActive = $false
                    $Script:ThePSProfileSelectWindow.HasBorderBeenRedrawn = $false
                    $Script:ThePSProfileSelectWindow.Draw()
                    
                    $Script:ThePSAffinitySelectWindow.IsActive = $true
                    $Script:ThePSAffinitySelectWindow.HasBorderBeenRedrawn = $false
                }
            }
        
            If($null -EQ $Script:ThePSAffinitySelectWindow) {
                $Script:ThePSAffinitySelectWindow = [PSAffinitySelectWindow]::new()
                $Script:ThePSAffinitySelectWindow.IsActive = $true
            }
            
            $Script:ThePSAffinitySelectWindow.Draw()
            $Script:ThePSAffinitySelectWindow.HandleInput()
        }
        
        ([PlayerSetupScreenStates]::PlayerSetupProfileSelect) {
            If($Script:ThePSAffinitySelectWindow.IsActive -EQ $true) {
                $Script:ThePSAffinitySelectWindow.IsActive = $false
                $Script:ThePSAffinitySelectWindow.HasBorderBeenRedrawn = $false
                $Script:ThePSAffinitySelectWindow.Draw()
            }
            
            If($null -EQ $Script:ThePSProfileSelectWindow) {
                $Script:ThePSProfileSelectWindow = [PSProfileSelectWindow]::new()
                $Script:ThePSProfileSelectWindow.IsActive = $true
            }
            
            $Script:ThePSProfileSelectWindow.Draw()
            $Script:ThePSProfileSelectWindow.HandleInput()
        }
        
        ([PlayerSetupScreenStates]::PlayerSetupConfirmation) {
            If($null -EQ $Script:ThePSConfirmDialog) {
                $Script:ThePSConfirmDialog = [PSConfirmDialog]::new()
            }
            
            $Script:ThePSConfirmDialog.Draw()
            $Script:ThePSConfirmDialog.HandleInput()
        }
    }
}

[ScriptBlock]$Script:TheGamePlayScreenState = {
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
    If($null -NE $Script:ThePlayerStatusMainMenu) {
        $Script:ThePlayerStatusMainMenu = $null
    }
    If($null -NE $Script:ThePlayerStatusSummaryWindow) {
        $Script:ThePlayerStatusSummaryWindow = $null
    }
    If($null -NE $Script:TheStatusItemInventoryWindow) {
        $Script:TheStatusItemInventoryWindow = $null
    }
    If($null -NE $Script:TheStatusItemHeaderWindow) {
        $Script:TheStatusItemHeaderWindow = $null
    }
    If($null -NE $Script:TheStatusItemConfirmDropDialog) {
        $Script:TheStatusItemConfirmDropDialog = $null
    }
    If($null -NE $Script:TheItemToDrop) {
        $Script:TheItemToDrop = $null
    }

    If($Script:GpsBufferCleared -EQ $false) {
        $Script:TheBufferManager.ClearArea(
            [ATCoordinates]@{
                Row = 0
                Column = 0
            },
            [ATCoordinates]@{
                Row = 40
                Column = 80
            },
            0
        )
        $Script:GpsBufferCleared = $true
    }

    $Script:ThePlayer.Update()
    $Script:TheStatusWindow.SetAllDirty(); $Script:TheStatusWindow.Draw()
    $Script:TheCommandWindow.SetAllDirty(); $Script:TheCommandWindow.Draw()
    $Script:TheSceneWindow.SetAllDirty(); $Script:TheSceneWindow.Draw()
    $Script:TheMessageWindow.SetAllDirty(); $Script:TheMessageWindow.Draw()
    $Script:TheCommandWindow.HandleInput()
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
    Switch($Script:TheStatusScreenState) {
        ([StatusScreenState]::Setup) {
            Write-Host "$([ATControlSequences]::CursorHide)"

            $Script:TheStatusScreenState = [StatusScreenState]::MainMenu

            Break
        }

        ([StatusScreenState]::MainMenu) {
            If($null -EQ $Script:ThePlayerStatusMainMenu) {
                $Script:ThePlayerStatusMainMenu = [PlayerStatusMainMenu]::new()
                Write-Host "$([ATControlSequences]::CursorHide)"
            }
            
            If($null -NE $Script:TheStatusItemInventoryWindow) {
                $Script:TheBufferManager.ClearArea($Script:ItemClearAreaTop - 1,
                    $Script:ItemClearAreaLeft,
                    $Script:ItemClearAreaRight,
                    $Script:ItemClearAreaBottom)
                $Script:TheStatusItemInventoryWindow = $null
                $Script:TheStatusItemHeaderWindow = $null
                $Script:ThePlayerStatusMainMenu.Menu.SetActiveColored()
                Write-Host "$([ATControlSequences]::CursorHide)"
            }
            
            $Script:ThePlayerStatusMainMenu.Draw()
            $Script:ThePlayerStatusMainMenu.HandleInput()

            Break
        }
        
        ([StatusScreenState]::Status) {
            If($null -EQ $Script:ThePlayerStatusSummaryWindow) {
                $Script:TheBufferManager.ClearArea($Script:ItemClearAreaTop,
                    $Script:ItemClearAreaLeft,
                    $Script:ItemClearAreaRight,
                    $Script:ItemClearAreaBottom)
                $Script:ThePlayerStatusSummaryWindow = [PlayerStatusSummaryWindow]::new()
            }

            If($null -NE $Script:TheStatusItemInventoryWindow) {
                $Script:TheStatusItemInventoryWindow = $null
            }
            If($null -NE $Script:TheStatusItemHeaderWindow) {
                $Script:TheStatusItemHeaderWindow = $null
            }
            
            $Script:ThePlayerStatusSummaryWindow.Draw()
            
            $Script:TheStatusScreenState = [StatusScreenState]::MainMenu
            
            Break
        }

        ([StatusScreenState]::Items) {
            If($null -NE $Script:ThePlayerStatusSummaryWindow) {
                $Script:ThePlayerStatusSummaryWindow = $null
            }

            If($null -EQ $Script:TheStatusItemInventoryWindow) {
                $Script:TheBufferManager.ClearArea($Script:ItemClearAreaTop,
                    $Script:ItemClearAreaLeft,
                    $Script:ItemClearAreaRight,
                    $Script:ItemClearAreaBottom)
                $Script:TheStatusItemInventoryWindow = [StatusItemInventoryWindow]::new()
            }
            If($null -EQ $Script:TheStatusItemHeaderWindow) {
                $Script:TheStatusItemHeaderWindow = [StatusItemHeaderWindow]::new()
            }

            $Script:TheStatusItemInventoryWindow.Draw()
            $Script:TheStatusItemHeaderWindow.Draw()

            $Script:TheStatusItemInventoryWindow.HandleInput()

            Break
        }

        ([StatusScreenState]::ItemDropConfirm) {
            If($null -EQ $Script:TheStatusItemConfirmDropDialog) {
                $Script:TheStatusItemConfirmDropDialog = [StatusItemDropConfirmDialog]::new()
            } Else {
                $Script:TheStatusItemConfirmDropDialog.SetAllDirty()
            }

            $Script:TheStatusItemConfirmDropDialog.Draw()
            $Script:TheStatusItemConfirmDropDialog.HandleInput()

            Break
        }

        Default {
            $Script:TheStatusScreenState = [StatusScreenState]::MainMenu

            Break
        }
    }
}

[ScriptBlock]$Script:TheCleanupState = {}

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

                    # THIS CODE IS PROBLEMATIC IF THE FILTER HAS NO ITEMS IN IT
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
            # THE ITEM ISN'T IN THE PLAYER'S INVENTORY, THUS RENDERING THIS AN INOPERABLE COMMAND (DESPITE NOT BEING SYNTACTICALLY INVALID).
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
                # AT THIS POINT, THIS BRANCH IS CONSIDERED A FATAL ERROR
                # THERE REALLY SHOULD BE A BETTER WAY OF HANDLING THIS, HOWEVER
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
    
    $Script:TheBufferManager.ClearArea(
        [ATCoordinates]@{
            Row = 0
            Column = 0
        },
        [ATCoordinates]@{
            Row = 40
            Column = 80
        },
        0
    )
    
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
    'move'    = $Script:TheMoveCommand
    'm'       = $Script:TheMoveCommand
    'look'    = $Script:TheLookCommand
    'l'       = $Script:TheLookCommand
    'examine' = $Script:TheExamineCommand
    'exa'     = $Script:TheExamineCommand
    'get'     = $Script:TheGetCommand
    'g'       = $Script:TheGetCommand
    'take'    = $Script:TheGetCommand
    't'       = $Script:TheGetCommand
    'use'     = $Script:TheUseCommand
    'u'       = $Script:TheUseCommand
    'drop'    = $Script:TheDropCommand
    'd'       = $Script:TheDropCommand
    'status'  = $Script:TheStatusCommand
    'sta'     = $Script:TheStatusCommand
    'enter'   = $Script:TheEnterCommand
    'en'      = $Script:TheEnterCommand
    'exit'    = $Script:TheEnterCommand
    'ex'      = $Script:TheEnterCommand
}

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
            Return [BattleActionResult]@{
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

$Script:TheGlobalStateBlockTable = @{
    [GameStatePrimary]::SplashScreenA      = $Script:TheSplashScreenAState
    [GameStatePrimary]::SplashScreenB      = $Script:TheSplashScreenBState
    [GameStatePrimary]::TitleScreen        = $Script:TheTitleScreenState
    [GameStatePrimary]::PlayerSetupScreen  = $Script:ThePlayerSetupState
    [GameStatePrimary]::GamePlayScreen     = $Script:TheGamePlayScreenState
    [GameStatePrimary]::BattleScreen       = $Script:TheBattleScreenState
    [GameStatePrimary]::PlayerStatusScreen = $Script:ThePlayerStatusScreenState
    [GameStatePrimary]::Cleanup            = $Script:TheCleanupState
}
