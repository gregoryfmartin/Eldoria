using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

#region Global Variables

#region Game State Definitions

[Flags()] Enum GlobalGameState {
    SplashScreenAStarting
    SplashScreenARunning
    SplashScreenAEnding
    SplashScreenBStarting
    SplashScreenBRunning
    SplashScreenBEnding
    TitleScreenStarting
    TitleScreenRunning
    TitleScreenEnding
    PlayerSetupScreenStarting
    PlayerSetupScreenRunning
    PlayerSetupScreenEnding
    GamePlayScreenStarting
    GamePlayScreenRunning
    GamePlayScreenEnding
    InventoryScreenStarting
    InventoryScreenRunning
    InventoryScreenEnding
    Cleanup
}

[Flags()] Enum GamePlayState {
    Normal
    Battle
    Shop
    Inn
}

[Flags()] Enum GameStateFlags {
    Starting
    Running
    Ending
}

[Boolean]$Script:RefreshGPSSceneImage = $true
[Boolean]$Script:RefreshGPSPlayerName = $true
[Boolean]$Script:RefreshGPSPlayerHp = $true
[Boolean]$Script:RefreshGPSPlayerMp = $true
[Boolean]$Script:RefreshGPSPlayerGold = $true
[Boolean]$Script:RefreshGPSStatusWindow = $true
[Boolean]$Script:RefreshGPSSceneWindow = $true
[Boolean]$Script:RefreshGPSCommandWindow = $true
[Boolean]$Script:RefreshGPSMessageWindow = $true
[Boolean]$Script:GPSAllowUserInput = $true
[Boolean]$Script:PlayerDataInitialized = $false

#endregion

#region Player-Specific Variables

[Flags()] Enum PlayerHpState {
    Normal
    Caution
    Danger
}

[Flags()] Enum PlayerMpState {
    Normal
    Caution
    Danger
}

[String]             $Script:PlayerName                       = ''
[Int]                $Script:PlayerCurrentHitPoints           = 0
[Int]                $Script:PlayerMaximumHitPoints           = 0
[Int]                $Script:PlayerCurrentMagicPoints         = 0
[Int]                $Script:PlayerMaximumMagicPoints         = 0
[Int]                $Script:PlayerCurrentGold                = 0
[Single]             $Script:PlayerStatNumThresholdCaution    = 0.6D
[Single]             $Script:PlayerStatNumThresholdDanger     = 0.2D
[PlayerHpState]      $Script:PlayerHitPointsState             = [PlayerHpState]::Normal
[PlayerMpState]      $Script:PlayerMagicPointsState           = [PlayerMpState]::Normal
[ConsoleColor]       $Script:PlayerStatNameDrawColor          = 'Blue'
[ConsoleColor]       $Script:PlayerStatNumberDrawColorSafe    = 'Green'
[ConsoleColor]       $Script:PlayerStatNumberDrawColorCaution = 'Yellow'
[ConsoleColor]       $Script:PlayerStatNumberDrawColorDanger  = 'Red'
[ConsoleColor]       $Script:PlayerStatGoldDrawColor          = 'DarkYellow'
[ConsoleColor]       $Script:PlayerAsideColor                 = 'DarkCyan'
[Coordinates]        $Script:PlayerMapCoordinates             = [Coordinates]::new(0, 0)
[List[MapTileObject]]$Script:PlayerInventory                  = [List[MapTileObject]]::new()

#endregion

#region Scene Image Variables

[Int]$Script:SceneImageWidth       = 46
[Int]$Script:SceneImageHeight      = 18
[Int]$Script:SceneImageDrawOriginX = 32
[Int]$Script:SceneImageDrawOriginY = 1

#endregion

#region Status Window Variables

[ConsoleColor]$Script:UiStatusWindowBorderColor      = 'White'
[String]      $Script:UiStatusWindowBorderHoirzontal = '@--~---~---~---~---@'
[String]      $Script:UiStatusWindowBorderVertical   = '|'
[Int]         $Script:UiStatusWindowDrawX            = 0
[Int]         $Script:UiStatusWindowDrawY            = 0
[Int]         $Script:UiStatusWindowWidth            = 19
[Int]         $Script:UiStatusWindowHeight           = 11
[Int]         $Script:UiStatusWindowPlayerNameDrawX  = 2
[Int]         $Script:UiStatusWindowPlayerNameDrawY  = 2
[Int]         $Script:UiStatusWindowPlayerHpDrawX    = 2
[Int]         $Script:UiStatusWindowPlayerHpDrawY    = 4
[Int]         $Script:UiStatusWindowPlayerMpDrawX    = 2
[Int]         $Script:UiStatusWindowPlayerMpDrawY    = 6
[Int]         $Script:UiStatusWindowPlayerGoldDrawX  = 2
[Int]         $Script:UiStatusWindowPlayerGoldDrawY  = 9
[Int]         $Script:UiStatusWindowPlayerAilDrawX   = 2
[Int]         $Script:UiStatusWindowPlayerAilDrawY   = 11

#endregion

#region Command Window Variables

Class CmdWindowHistoryMessage {
    [String]$Message
    [ConsoleColor]$ForegroundColor

    CmdWindowHistoryMessage (
        [String]$msg,
        [ConsoleColor]$fgc
    ) {
        $this.Message         = $msg
        $this.ForegroundColor = $fgc
    }
}

[ConsoleColor]           $Script:UiCommandWindowBorderColor      = 'White'
[ConsoleColor]           $Script:UiCommandWindowCmdHistValid     = 'Green'
[ConsoleColor]           $Script:UiCommandWindowCmdHistErr       = 'Red'
[ConsoleColor]           $Script:UiCommandWindowCmdBlankColor    = 'Black'
[String]                 $Script:UiCommandWindowBorderHorizontal = '@--~---~---~---~---@'
[String]                 $Script:UiCommandWindowBorderVertical   = '|'
[String]                 $Script:UiCommandWindowCmdDiv           = '``````````````````'
[String]                 $Script:UiCommandWindowCmdActual        = ''
[String]                 $Script:UiCommandWindowCmdBlank         = '                  '
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistA            = [CmdWindowHistoryMessage]::new('', 'White')
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistB            = [CmdWindowHistoryMessage]::new('', 'White')
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistC            = [CmdWindowHistoryMessage]::new('', 'White')
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistD            = [CmdWindowHistoryMessage]::new('', 'White')
[Int]                    $Script:UiCommandWindowDrawX            = 0
[Int]                    $Script:UiCommandWindowDrawY            = 12
[Int]                    $Script:UiCommandWindowWidth            = 19
[Int]                    $Script:UiCommandWindowHeight           = 7
[Int]                    $Script:UiCommandWindowCmdDivDrawX      = $Script:UiCommandWindowDrawX + 1
[Int]                    $Script:UiCommandWindowCmdDivDrawY      = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 2
[Int]                    $Script:UiCommandWindowHistDrawX        = $Script:UiCommandWindowDrawX + 1
[Int]                    $Script:UiCommandWindowHistDDrawY       = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 3
[Int]                    $Script:UiCommandWindowHistCDrawY       = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 4
[Int]                    $Script:UiCommandWindowHistBDrawY       = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 5
[Int]                    $Script:UiCommandWindowHistADrawY       = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 6


#endregion

#region Scene Window Variables

[ConsoleColor]$Script:UiSceneWindowBorderColor      = 'White'
[String]      $Script:UiSceneWindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]      $Script:UiSceneWindowBorderVertical   = '|'
[Int]         $Script:UiSceneWindowDrawX            = 30
[Int]         $Script:UiSceneWindowDrawY            = 0
[Int]         $Script:UiSceneWindowWidth            = 50
[Int]         $Script:UiSceneWindowHeight           = 19
[Int]         $Script:UiSceneWindowSceneDrawX       = 32
[Int]         $Script:UiSceneWindowSceneDrawY       = 1

#endregion

#region Message Window Variables

Class MsgWindowHistoryMessage {
    [String]$Message
    [ConsoleColor]$ForegroundColor

    MsgWindowHistoryMessage (
        [String]$msg,
        [ConsoleColor]$fgc
    ) {
        $this.Message         = $msg
        $this.ForegroundColor = $fgc
    }
}

[ConsoleColor]           $Script:UiMessageWindowBorderColor        = 'White'
[String]                 $Script:UiMessageWindowBorderHorizontal   = '-'
[String]                 $Script:UiMessageWindowBorderVertical     = '|'
[Int]                    $Script:UiMessageWindowDrawX              = 0
[Int]                    $Script:UiMessageWindowDrawY              = 20
[Int]                    $Script:UiMessageWindowWidth              = 80
[Int]                    $Script:UiMessageWindowHeight             = 4
[MsgWindowHistoryMessage]$Script:UiMessageWindowMessageA           = [MsgWindowHistoryMessage]::new('', 'Black')
[MsgWindowHistoryMessage]$Script:UiMessageWindowMessageB           = [MsgWindowHistoryMessage]::new('', 'Black')
[MsgWindowHistoryMessage]$Script:UiMessageWindowMessageC           = [MsgWindowHistoryMessage]::new('', 'Black')
[Int]                    $Script:UiMessageWindowMessageBottomDrawY = 23
[Int]                    $Script:UiMessageWindowMessageMiddleDrawY = 22
[Int]                    $Script:UiMessageWindowMessageTopDrawY    = 21
[String]                 $Script:UiMessageWindowMessageBlank       = '                                                                             '


#endregion

#region Timing Variables

[Int]     $Script:TargetFrameRate  = 30
[Single]  $Script:MsPerFrame       = 1000 / $Script:TargetFrameRate
[Boolean] $Script:GameRunning      = $true
[Double]  $Script:LastFrameTime    = 0D
[Double]  $Script:CurrentFrameTime = 0D
[TimeSpan]$Script:FpsDelta         = [TimeSpan]::Zero

#endregion

#region General Globals

$Script:Rui = $(Get-Host).UI.RawUI

[Int]   $Script:DefaultCursorX = $Script:UiCommandWindowDrawX + 1
[Int]   $Script:DefaultCursorY = $Script:UiCommandWindowCmdDivDrawY + 1
[String]$Script:OsCheckLinux   = 'OsLinux'
[String]$Script:OsCheckMac     = 'OsMac'
[String]$Script:OsCheckWindows = 'OsWindows'
[String]$Script:OsCheckUnknown = 'OsUnknown'

#endregion

#region Game State Machine Variables

[GlobalGameState]$Script:GameState = [GlobalGameState]::GamePlayScreenRunning
[Boolean]        $Script:DrawDirty = $false
# [Boolean]        $Script:StateStarting = $false
# [Boolean]        $Script:StateRunning  = $false
# [Boolean]        $Script:StateEnding   = $false

#endregion

#region Scene Image Definitions

$Script:SceneImageSample = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldNRoad     = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldNERoad    = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldNWRoad    = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldNEWRoad   = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldSRoad     = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldSERoad    = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldSEWRoad   = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth

#endregion

#region Text Rendering Variables

[Flags()] Enum TtySpeed {
    SuperSlow = 1000000
    Slow      = 750000
    Normal    = 100000
    Moderate  = 75000
    Quick     = 65000
    Fast      = 50000
    SuperFast = 25000
    LineClear = 1
}

#endregion

#region Audio Variables

# This enumeration defines the notes. These are keys in a lookup table, nothing more. The exception here is the Rest, which is explicitly defined as being 37.
# 37 is the technical lower limit required for the frequency value in Beep; lower values will throw an exception. Notes with this frequency will not yield a sound.
# Earlier tests yielded that anything lower than 250hz won't play anything other than an audible electrical knocking on the speaker.
Enum Notes {
    C = 0
    CSharpOrDFlat
    D
    DSharpOrEFlat
    E
    F
    FSharpOrGFlat
    G
    GSharpOrAFlat
    A
    ASharpOrBFlat
    B
    Rest = 37
}

# This enumeration defines the unofficial names of the octaves. These are keys in a lookup table, nothing more. Note that most notes in the lowest octaves,
# First to some in the Fourth, won't play on the PC Speaker.
Enum Octaves {
    First = 0
    Second
    Third
    Fourth
    Fifth
    Sixth
    Seventh
    Eighth
    Ninth
}

# This enumeration defines common durations for notes, defined in milliseconds.
Enum NoteDuration {
    Whole     = 1600
    Half      = 800
    Quarter   = 400
    Eighth    = 200
    Sixteenth = 100
}

Class Note {
    [Int]$ActualNote
    [NoteDuration]$ActualDuration

    Note(
        [Int]$an,
        [NoteDuration]$ad
    ) {
        $this.ActualNote     = $an
        $this.ActualDuration = $ad
    }
}

# Define the Note Table. Rests are not included in the Note Table.
$Script:NumOctaves = 9
$Script:NumNotes   = 12
$Script:NoteTable  = New-Object 'Int[,]' $Script:NumNotes, $Script:NumOctaves

# Define the Note Table
# This site has a table where the values are derived from: https:   //mixbutton.com/mixing-articles/music-note-to-frequency-chart/#:~:text=Music%20Note%20To%20Frequency%20Chart%20%20%20,%20155.56%20Hz%20%208%20more%20rows%20
Write-Progress -Activity 'Creating Music Note Table' -Id 1 -PercentComplete -1
$Script:NoteTable[[Notes]::C, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::C, [Octaves]::Second]              = 0
$Script:NoteTable[[Notes]::C, [Octaves]::Third]               = [Int]65.41D
$Script:NoteTable[[Notes]::C, [Octaves]::Fourth]              = [Int]130.81D
$Script:NoteTable[[Notes]::C, [Octaves]::Fifth]               = [Int]261.63D
$Script:NoteTable[[Notes]::C, [Octaves]::Sixth]               = [Int]523.25D
$Script:NoteTable[[Notes]::C, [Octaves]::Seventh]             = [Int]1046.5D
$Script:NoteTable[[Notes]::C, [Octaves]::Eighth]              = [Int]2093.0D
$Script:NoteTable[[Notes]::C, [Octaves]::Ninth]               = [Int]4186.01D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::First]   = 0
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Second]  = 0
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Third]   = [Int]69.3D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Fourth]  = [Int]138.59D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Fifth]   = [Int]277.18D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Sixth]   = [Int]554.37D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh] = [Int]1108.73D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Eighth]  = [Int]2217.46D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Ninth]   = [Int]4434.92D
$Script:NoteTable[[Notes]::D, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::D, [Octaves]::Second]              = [Int]36.71D
$Script:NoteTable[[Notes]::D, [Octaves]::Third]               = [Int]73.42D
$Script:NoteTable[[Notes]::D, [Octaves]::Fourth]              = [Int]146.83D
$Script:NoteTable[[Notes]::D, [Octaves]::Fifth]               = [Int]293.66D
$Script:NoteTable[[Notes]::D, [Octaves]::Sixth]               = [Int]587.33D
$Script:NoteTable[[Notes]::D, [Octaves]::Seventh]             = [Int]1174.66D
$Script:NoteTable[[Notes]::D, [Octaves]::Eighth]              = [Int]2349.32D
$Script:NoteTable[[Notes]::D, [Octaves]::Ninth]               = [Int]4698.63D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::First]   = 0
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Second]  = [Int]38.89D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Third]   = [Int]77.78D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Fourth]  = [Int]155.56D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Fifth]   = [Int]311.13D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Sixth]   = [Int]622.25D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh] = [Int]1244.51D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Eighth]  = [Int]2489.02D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Ninth]   = [Int]4978.03D
$Script:NoteTable[[Notes]::E, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::E, [Octaves]::Second]              = [Int]41.2D
$Script:NoteTable[[Notes]::E, [Octaves]::Third]               = [Int]82.41D
$Script:NoteTable[[Notes]::E, [Octaves]::Fourth]              = [Int]164.81D
$Script:NoteTable[[Notes]::E, [Octaves]::Fifth]               = [Int]329.63D
$Script:NoteTable[[Notes]::E, [Octaves]::Sixth]               = [Int]659.25D
$Script:NoteTable[[Notes]::E, [Octaves]::Seventh]             = [Int]1318.51D
$Script:NoteTable[[Notes]::E, [Octaves]::Eighth]              = [Int]2637.02D
$Script:NoteTable[[Notes]::E, [Octaves]::Ninth]               = [Int]5274.04D
$Script:NoteTable[[Notes]::F, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::F, [Octaves]::Second]              = [Int]43.65D
$Script:NoteTable[[Notes]::F, [Octaves]::Third]               = [Int]87.31D
$Script:NoteTable[[Notes]::F, [Octaves]::Fourth]              = [Int]174.61D
$Script:NoteTable[[Notes]::F, [Octaves]::Fifth]               = [Int]349.23D
$Script:NoteTable[[Notes]::F, [Octaves]::Sixth]               = [Int]689.46D
$Script:NoteTable[[Notes]::F, [Octaves]::Seventh]             = [Int]1396.91D
$Script:NoteTable[[Notes]::F, [Octaves]::Eighth]              = [Int]2793.83D
$Script:NoteTable[[Notes]::F, [Octaves]::Ninth]               = [Int]5587.65D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::First]   = 0
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Second]  = [Int]46.25D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Third]   = [Int]92.5D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Fourth]  = [Int]185D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Fifth]   = [Int]369.99D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth]   = [Int]739.99D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh] = [Int]1479.98D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Eighth]  = [Int]2959.96D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Ninth]   = [Int]5919.91D
$Script:NoteTable[[Notes]::G, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::G, [Octaves]::Second]              = [Int]49D
$Script:NoteTable[[Notes]::G, [Octaves]::Third]               = [Int]98D
$Script:NoteTable[[Notes]::G, [Octaves]::Fourth]              = [Int]196D
$Script:NoteTable[[Notes]::G, [Octaves]::Fifth]               = [Int]392D
$Script:NoteTable[[Notes]::G, [Octaves]::Sixth]               = [Int]783.99D
$Script:NoteTable[[Notes]::G, [Octaves]::Seventh]             = [Int]1567.98D
$Script:NoteTable[[Notes]::G, [Octaves]::Eighth]              = [Int]3135.96D
$Script:NoteTable[[Notes]::G, [Octaves]::Ninth]               = [Int]6271.93D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::First]   = 0
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Second]  = [Int]51.91D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Third]   = [Int]103.83D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Fourth]  = [Int]207.65D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Fifth]   = [Int]415.3D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]   = [Int]830.61D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Seventh] = [Int]1661.22D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Eighth]  = [Int]3322.44D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Ninth]   = [Int]6644.88D
$Script:NoteTable[[Notes]::A, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::A, [Octaves]::Second]              = [Int]55D
$Script:NoteTable[[Notes]::A, [Octaves]::Third]               = [Int]110D
$Script:NoteTable[[Notes]::A, [Octaves]::Fourth]              = [Int]220D
$Script:NoteTable[[Notes]::A, [Octaves]::Fifth]               = [Int]440D
$Script:NoteTable[[Notes]::A, [Octaves]::Sixth]               = [Int]880D
$Script:NoteTable[[Notes]::A, [Octaves]::Seventh]             = [Int]1760D
$Script:NoteTable[[Notes]::A, [Octaves]::Eighth]              = [Int]3520D
$Script:NoteTable[[Notes]::A, [Octaves]::Ninth]               = [Int]7040D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::First]   = 0
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Second]  = [Int]58.27D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Third]   = [Int]116.54D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Fourth]  = [Int]233.08D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Fifth]   = [Int]466.16D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]   = [Int]932.33D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh] = [Int]1864.66D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Eighth]  = [Int]3729.31D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Ninth]   = [Int]7458.62D
$Script:NoteTable[[Notes]::B, [Octaves]::First]               = 0
$Script:NoteTable[[Notes]::B, [Octaves]::Second]              = [Int]61.74D
$Script:NoteTable[[Notes]::B, [Octaves]::Third]               = [Int]123.47D
$Script:NoteTable[[Notes]::B, [Octaves]::Fourth]              = [Int]246.94D
$Script:NoteTable[[Notes]::B, [Octaves]::Fifth]               = [Int]493.88D
$Script:NoteTable[[Notes]::B, [Octaves]::Sixth]               = [Int]987.77D
$Script:NoteTable[[Notes]::B, [Octaves]::Seventh]             = [Int]1975.53D
$Script:NoteTable[[Notes]::B, [Octaves]::Eighth]              = [Int]3951.07D
$Script:NoteTable[[Notes]::B, [Octaves]::Ninth]               = [Int]7902.13D
#Write-Progress -Activity 'Creating Music Note Table' -Completed
Write-Progress -Activity 'Creating Music Note Table' -Status 'Complete' -Id 1 -PercentComplete -1

# Declare some songs. Songs are defined as arrangements of Notes polled from the Note Table.
[ArrayList]$Script:DragonWarriorTheme = New-Object 'ArrayList'
[ArrayList]$Script:BattleTheme        = New-Object 'ArrayList'
[ArrayList]$Script:DuckTalesTheme     = New-Object 'ArrayList'
[ArrayList]$Script:GhostbustersTheme  = New-Object 'ArrayList'

# Define the Songs

#region Dragon Warrior Theme Jingle (Incomplete)

Write-Progress -Activity 'Creating Song Note Tables' -Status 'Creating Dragon Warrior Theme' -Id 2 -PercentComplete -1
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::F, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::F, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::F, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DragonWarriorTheme.Add([Note]::new(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null

#endregion

#region Battle Theme Jingle

Write-Progress -Activity 'Creating Song Note Tables' -Status 'Creating Battle Theme' -Id 2 -PercentComplete -1
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::C, [Octaves]::Eighth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::E, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth]), [NoteDuration]::Whole)) | Out-Null

#endregion

#region Duck Tales Theme Jingle

Write-Progress -Activity 'Creating Song Note Tables' -Status 'Creating Duck Tales Theme' -Id 2 -PercentComplete -1
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::E, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Half)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Half)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::E, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:DuckTalesTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null

#endregion

#region Ghostbusters Theme

Write-Progress -Activity 'Creating Song Note Tables' -Status 'Creating Ghostbusters Theme' -Id 2 -PercentComplete -1
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Half)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Half)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Half)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$Script:GhostbustersTheme.Add([Note]::new(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
#Write-Progress -Activity 'Creating Song Note Tables' -Id 2 -Completed
Write-Progress -Activity 'Creating Song Note Tables' -Status 'Complete' -Id 2 -PercentComplete -1

#endregion

#endregion

#region Screen Capture Test Variables

[BufferCell[,]]$Script:ScreenStateA = New-Object 'BufferCell[,]' 80, 80
[BufferCell[,]]$Script:ScreenStateB = New-Object 'BufferCell[,]' 80, 80

#endregion

#region Command Definition Variables

# ATTEMPT FIVE MILLION
# After ruminating over this for a few days, and despite this potentially being the most inelegant method to do this,
# I think this is going to be the best way to do this until someone else kicks me in the balls and says otherwise.
# Rather than trying to dynamically determine where the failure is at in the parser, the Command String permutations
# are going to be hardcoded in this dictionary, and each permutation is assoicated with a ScriptBlock that gets executed
# from the Command Parser when the Response is successful. Half-baked permutations (incomplete commands) are hardcoded
# here, partially as a way to torture myself, partially as a way to provide "sane" user feedback, and partially as a way
# to have an outlet for Easter Eggs.
$Script:CommandTable = @{
    'move' = {
        Param([String] $a0)

        Switch($a0) {
            { $_ -EQ 'north' -OR $_ -EQ 'n' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # We can modulo to see if there's going to be overflow from the arithmetic
                        $a = $Script:CurrentMap.Dimensions.Y - 1 # Subtract 1 since the array is zero-indexed
                        $b = $Script:PlayerMapCoordinates.Y + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, reset the coordinate to zero
                            $Script:PlayerMapCoordinates.Y = 0
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.Y += 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                       
                        # We can modulo to see if there's going to be overflow from the arithmetic
                        $a = $Script:CurrentMap.Dimensions.Y - 1 # Subtract 1 since the array is zero-indexed
                        $b = $Script:PlayerMapCoordinates.Y + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.Y += 1
                            Update-GfmSceneImageFromCoords
                            Update-GfmCmdHistory -CmdActualValid
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            { $_ -EQ 'south' -OR $_ -EQ 's' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitSouth] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with south bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.Y - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, reset the coordinate to the max -1
                            $Script:PlayerMapCoordinates.Y = $Script:CurrentMap.Dimensions.Y - 1
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.Y -= 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                        
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with south bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.Y - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.Y -= 1
                            Update-GfmCmdHistory -CmdActualValid
                            Update-GfmSceneImageFromCoords
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            { $_ -EQ 'east' -OR $_ -EQ 'e' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitEast] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # We can use modulo here too to see if the wrap can occur
                        $a = $Script:CurrentMap.Dimensions.X - 1
                        $b = $Script:PlayerMapCoordinates.X + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, reset the coordinate to zero
                            $Script:PlayerMapCoordinates.X = 0
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.X += 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                        
                        # We can modulo to see if there's going to be overflow from the arithmetic
                        $a = $Script:CurrentMap.Dimensions.X - 1 # Subtract 1 since the array is zero-indexed
                        $b = $Script:PlayerMapCoordinates.X + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.X += 1
                            Update-GfmSceneImageFromCoords
                            Update-GfmCmdHistory -CmdActualValid
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            { $_ -EQ 'west' -OR $_ -EQ 'w' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitWest] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with west bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.X - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, reset the coordinate to the max -1
                            $Script:PlayerMapCoordinates.X = $Script:CurrentMap.Dimensions.X - 1
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.X -= 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                        
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with west bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.X - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.X -= 1
                            Update-GfmCmdHistory -CmdActualValid
                            Update-GfmSceneImageFromCoords
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'm' = {
        Param([String] $a0)
        
        Switch($a0) {
            { $_ -EQ 'north' -OR $_ -EQ 'n' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # We can modulo to see if there's going to be overflow from the arithmetic
                        $a = $Script:CurrentMap.Dimensions.Y - 1 # Subtract 1 since the array is zero-indexed
                        $b = $Script:PlayerMapCoordinates.Y + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, reset the coordinate to zero
                            $Script:PlayerMapCoordinates.Y = 0
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.Y += 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                       
                        # We can modulo to see if there's going to be overflow from the arithmetic
                        $a = $Script:CurrentMap.Dimensions.Y - 1 # Subtract 1 since the array is zero-indexed
                        $b = $Script:PlayerMapCoordinates.Y + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.Y += 1
                            Update-GfmSceneImageFromCoords
                            Update-GfmCmdHistory -CmdActualValid
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            { $_ -EQ 'south' -OR $_ -EQ 's' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitSouth] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with south bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.Y - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, reset the coordinate to the max -1
                            $Script:PlayerMapCoordinates.Y = $Script:CurrentMap.Dimensions.Y - 1
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.Y -= 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                        
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with south bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.Y - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.Y -= 1
                            Update-GfmCmdHistory -CmdActualValid
                            Update-GfmSceneImageFromCoords
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            { $_ -EQ 'east' -OR $_ -EQ 'e' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitEast] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # We can use modulo here too to see if the wrap can occur
                        $a = $Script:CurrentMap.Dimensions.X - 1
                        $b = $Script:PlayerMapCoordinates.X + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, reset the coordinate to zero
                            $Script:PlayerMapCoordinates.X = 0
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.X += 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                        
                        # We can modulo to see if there's going to be overflow from the arithmetic
                        $a = $Script:CurrentMap.Dimensions.X - 1 # Subtract 1 since the array is zero-indexed
                        $b = $Script:PlayerMapCoordinates.X + 1
                        $c = $a % $b
                        
                        If($c -EQ $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, increment
                            $Script:PlayerMapCoordinates.X += 1
                            Update-GfmSceneImageFromCoords
                            Update-GfmCmdHistory -CmdActualValid
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            { $_ -EQ 'west' -OR $_ -EQ 'w' } {
                # PROTOTYPE
                # Check to see if the player is capable of exiting the current tile to the north
                If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitWest] -EQ $true) {
                    # Check to see if map wrapping is turned on
                    If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with west bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.X - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, reset the coordinate to the max -1
                            $Script:PlayerMapCoordinates.X = $Script:CurrentMap.Dimensions.X - 1
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.X -= 1
                        }
                        
                        Update-GfmSceneImageFromCoords
                        Update-GfmCmdHistory -CmdActualValid
                        Return
                    } Else {
                        # Wrapping is disabled
                        
                        # The north algorithm can use modulo since the number isn't zero. However, this isn't the case
                        # with west bound directions.
                        $a = 0
                        $b = $Script:PlayerMapCoordinates.X - 1
                        
                        If($b -LT $a) {
                            # Overflow is going to occur, invoke the invisible wall
                            Update-GfmCmdHistory -CmdActualValid
                            Write-GfmMapInvisibleWallException
                            Return
                        } Else {
                            # Overflow is not going to occur, decrement
                            $Script:PlayerMapCoordinates.X -= 1
                            Update-GfmCmdHistory -CmdActualValid
                            Update-GfmSceneImageFromCoords
                            Return
                        }
                    }
                } Else {
                    # The player requested to move in this direction, but it's not possible because the exit flag
                    # for this direction isn't set.
                    Update-GfmCmdHistory -CmdActualValid
                    Write-GfmMapYouShallNotPassException
                    Return
                }
            }
            
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'climb' = {
        Param([String]$a0, [String]$a1)
        
        Switch($a0) {
            { $_ -EQ 'up' -OR $_ -EQ 'u' } {
                Switch($a1) {
                    'tree' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'ladder' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'rope' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'wall' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'stairs' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'pole' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    Default {
                        Write-GfmBadCommandArg1Exception
                        Return
                    }
                }
            }
            
            { $_ -EQ 'down' -OR $_ -EQ 'd' } {
                Switch($a1) {
                    'tree' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'ladder' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'rope' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'wall' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'stairs' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'pole' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    Default {
                        Write-GfmBadCommandArg1Exception
                        Return
                    }
                }
            }
            
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'cl' = {
        Param([String]$a0, [String]$a1)
        
        Switch($a0) {
            { $_ -EQ 'up' -OR $_ -EQ 'u' } {
                Switch($a1) {
                    'tree' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'ladder' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'rope' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'wall' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'stairs' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'pole' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    Default {
                        Write-GfmBadCommandArg1Exception
                        Return
                    }
                }
            }
            
            { $_ -EQ 'down' -OR $_ -EQ 'd' } {
                Switch($a1) {
                    'tree' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'ladder' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'rope' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'wall' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'stairs' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    'pole' {
                        Invoke-GfmItemReactor -ItemName $_
                        Return
                    }
                    
                    Default {
                        Write-GfmBadCommandArg1Exception
                        Return
                    }
                }
            }
            
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'enter' = {
        Param([String]$a0)
        
        Switch($a0) {
            'door' {
                Invoke-GfmItemReactor -ItemName $_
                Return
            }
            
            'cave' {
                Invoke-GfmItemReactor -ItemName $_
                Return
            }
            
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'en' = {
        Param([String]$a0)
        
        Switch($a0) {
            'door' {
                Invoke-GfmItemReactor -ItemName $_
                Return
            }
            
            'cave' {
                Invoke-GfmItemReactor -ItemName $_
                Return
            }
            
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'exit' = {
        Update-GfmCmdHistory -CmdActualValid
        Return
    };
    
    'ex' = {
        Update-GfmCmdHistory -CmdActualValid
        Return
    };
    
    'look' = {
        Invoke-GfmLookAction
        Return
    };
    
    'l' = {
        Invoke-GfmLookAction
        Return
    };
    
    'examine' = {
        Param([String]$a0)
        
        Invoke-GfmExamineAction -ItemName $a0
    };
    
    'exa' = {
        Param([String]$a0)
        
        Invoke-GfmExamineAction -ItemName $a0
    };
    
    'get' = {
        Param([String]$a0)
        
        Invoke-GfmGetAction -ItemName $a0
    };
    
    'g' = {
        Param([String]$a0)
        
        Invoke-GfmGetAction -ItemName $a0
    };
    
    'take' = {
        Param([String]$a0)
        
        Invoke-GfmGetAction -ItemName $a0
    };
    
    't' = {
        Param([String]$a0)
        
        Invoke-GfmGetAction -ItemName $a0
    };
    
    'drop' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'd' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'inventory' = {
        Update-GfmCmdHistory -CmdActualValid
        Return
    };
    
    'i' = {
        Update-GfmCmdHistory -CmdActualValid
        Return
    };
    
    'use' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {}
        }
    };
    
    'u' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'equip' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'eq' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'open' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'op' = {
        Param([String]$a0)
        
        Switch($a0) {
            # TODO: Add valid Object Identifiers
            Default {
                Write-GfmBadCommandArg0Exception
                Return
            }
        }
    };
    
    'bg' = {
        Param([String]$a0)
        
        Switch($a0) {
            'a' {
                Write-GfmSceneImage -CellArray $Script:SiFieldNRoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            'b' {
                Write-GfmSceneImage -CellArray $Script:SiFieldNERoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            'c' {
                Write-GfmSceneImage -CellArray $Script:SiFieldNWRoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            'd' {
                Write-GfmSceneImage -CellArray $Script:SiFieldNEWRoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            'e' {
                Write-GfmSceneImage -CellArray $Script:SiFieldSRoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            'f' {
                Write-GfmSceneImage -CellArray $Script:SiFieldSERoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            'g' {
                Write-GfmSceneImage -CellArray $Script:SiFieldSEWRoad
                Update-GfmCmdHistory -CmdActualValid
                $Script:UiCommandWindowCmdActual = ''
                Set-GfmDefaultCursorPosition  
            }
            
            Default {}
        }
    };

    # THIS IS TOTAL TEST CODE AT THIS AREA!!!
    'scap' = {
        Update-GfmCmdHistory -CmdActualValid
        $Script:UiCommandWindowCmdActual = ''
        $Script:ScreenStateA             = $Script:Rui.GetBufferContents([Rectangle]::new(0, 0, 80, 80))
        Clear-Host
        Read-Host -Prompt 'Press any key to restore the previous state'
        $Script:Rui.SetBufferContents([Coordinates]::new(0, 0), $Script:ScreenStateA)
        Set-GfmDefaultCursorPosition
        Return
    };
}

#endregion

#region Map Variable Definitions

[ConsoleColor]$Script:MapTileItemsDiscoveredColor = 'Magenta'
[String]       $Script:MTODescTree                = 'It''s a tree. Looks like all the other ones.'
[String]       $Script:MTODescLadder              = 'Maybe I can climb this ladder?'
[String]       $Script:MTODescRope                = 'A tightly braided and durable rope.'
[String]       $Script:MTODescStairs              = 'Stairs. A faithful ally for elevating one''s position.'
[String]       $Script:MTODescPole                = 'Not the north or the south one. Just a pole. For climbing.'

Class MapTileObject {
    # TODO: Perhaps create a collection of Examine Strings and randomly select one when printing it to the console
    [String]$Name
    [String]$MapObjName
    [ScriptBlock]$Effect
    [Boolean]$CanAddToInventory
    [String]$ExamineString
    
    MapTileObject(
        [String]$n,
        [String]$mon,
        [Boolean]$cati,
        [String]$exastr,
        [ScriptBlock]$e = {}
    ) {
        $this.Name              = $n
        $this.MapObjName        = $mon
        $this.CanAddToInventory = $cati
        $this.ExamineString     = $exastr
        $this.Effect            = $e
    }
}

Class MTOTree : MapTileObject {
    MTOTree() : base('Tree', 'tree', $false, $Script:MTODescTree, {
        Write-GfmMessageWindowMessage -Message 'I climbed a tree!' -Teletype
    }) {}
}

Class MTOLadder : MapTileObject {
    MTOLadder() : base('Ladder', 'ladder', $false, $Script:MTODescLadder, {
        Write-GfmMessageWindowMessage -Message 'I climbed a ladder!' -Teletype
    }) {}
}

Class MTORope : MapTileObject {
    MTORope() : base('Rope', 'rope', $false, $Script:MTODescRope, {
        Write-GfmMessageWindowMessage -Message 'I climbed a rope!' -Teletype
    }) {}
}

Class MTOStairs : MapTileObject {
    MTOStairs() : base('Stairs', 'stairs', $false, $Script:MTODescStairs, {
        Write-GfmMessageWindowMessage -Message 'I climbed some stairs!' -Teletype
    }) {}
}

Class MTOPole : MapTileObject {
    MTOPole() : base('Pole', 'pole', $false, $Script:MTODescPole, {
        Write-GfmMessageWindowMessage -Message 'I climbed a pole!' -Teletype
    }) {}
}

Class MapTile {
    [BufferCell[,]]$BackgroundImage
    [List[MapTileObject]]$ObjectListing
    [Boolean[]]$Exits
    
    Static [Int]$TileExitNorth = 0
    Static [Int]$TileExitSouth = 1
    Static [Int]$TileExitEast  = 2
    Static [Int]$TileExitWest  = 3
    
    
    MapTile(
        [BufferCell[,]]$bi,
        [MapTileObject[]]$ol,
        [Boolean[]]$ex
    ) {
        $this.BackgroundImage = $bi
        $this.Exits           = $ex
        $this.ObjectListing   = [List[MapTileObject]]::new()
        
        Foreach($a in $ol) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }
}

Class Map {
    [String]$Name
    [Coordinates]$Dimensions
    [Boolean]$BoundaryWrap
    [MapTile[,]]$Tiles
    
    Map(
        [String]$n,
        [Coordinates]$d,
        [Boolean]$bw
    ) {
        $this.Name         = $n
        $this.Dimensions   = $d
        $this.BoundaryWrap = $bw
        $this.Tiles        = New-Object 'MapTile[,]' $this.Dimensions.Y, $this.Dimensions.X
    }
    
    [MapTile]GetTileAtPlayerCoordinates() {
        Return $this.Tiles[$Script:PlayerMapCoordinates.Y, $Script:PlayerMapCoordinates.X]
    }
}

#region Map Declarations

[Map]$Script:SampleMap   = [Map]::new('Sample Map', [Coordinates]::new(2, 2), $true)
[Map]$Script:CurrentMap  = $Script:SampleMap
[Map]$Script:PreviousMap = $null

#endregion

#endregion

#region Game State ScriptBlock Definitions

$Script:GameStateBlockTable = @{
    [GlobalGameState]::SplashScreenAStarting = {
        <#
        WORKFLOW
        
        1. Properly initialize the variables for the Splash Screen A State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::SplashScreenARunning = {
        <#
        WORKFLOW
        
        1. Clear the screen (only once)
        2. Teletype the text 'gregfmartin.org' on the first line in the center of the buffer
        3. Teletype the text 'studios' on the second line in the center of the buffer, below the first one
        4. Wait a second or three
        5. Teletype the text CLEAR LINE on the first line in the center of the buffer
        6. Teletype the text CLEAR LINE on the second line in the center of the buffer, below the first one
        7. Wait a second or three
        8. Transition to the next state
        #>
    }
    
    [GlobalGameState]::SplashScreenAEnding = {
        <#
        WORKFLOW
        
        1. Properly deinitialize the variables for the Splash Screen A State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::SplashScreenBStarting = {
        <#
        WORKFLOW
        
        1. Properly initialize the variables for the Splash Screen B State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::SplashScreenBRunning = {
        <#
        WORKFLOW
        
        1. Clear the screen (only once)
        2. Teletype the text 'In association with' on the first line in the center of the buffer
        3. Teletype the text 'OLIY COW' on the second line in the center of the buffer, below the first one
        4. Wait a second or three
        5. Teletype the text CLEAR LINE on the first line in the center of the buffer
        6. Teletype the text CLEAR LINE on the second line in the center of the buffer, below the first one
        7. Wait a second or three
        8. Transition to the next state
        #>
    }
    
    [GlobalGameState]::SplashScreenBEnding = {
        <#
        WORKFLOW
        
        1. Properly deinitialize the variables for the Splash Screen B State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::TitleScreenStarting = {
        <#
        WORKFLOW
        
        1. Properly initialize the variables for the Title Screen State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::TitleScreenRunning = {
        <#
        WORKFLOW
        
        1. Clear the screen (only once)
        2. Draw the title screen (TBD)
        3. Wait for input from the user before moving on; input from the user will trigger a state transfer
        #>
    }
    
    [GlobalGameState]::TitleScreenEnding = {
        <#
        WORKFLOW
        
        1. Properly deinitialize the variables for the Title Screen State
        2. Transition to the next state (previously defined by user interaction from the Title Screen Running state)
        #>
    }
    
    [GlobalGameState]::PlayerSetupScreenStarting = {
        <#
        WORKFLOW
        
        1. Properly initialize the variables for the Player Setup Screen State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::PlayerSetupScreenRunning = {
        <#
        WORKFLOW
        
        1. Clear the screen (only once)
        2. Draw the form (TBD)
        3. Accept input from the user to satisfy all of the prerequisite requirements
        4. Accept input from the user to confirm that their input information is correct
        5. Transition to the next state
        #>
    }
    
    [GlobalGameState]::PlayerSetupScreenEnding = {
        <#
        WORKFLOW
        
        1. Commit the values from the temporary stores to the actual stores relative to the user's input information
        2. Properly deinitialize the variables for the Player Setup Screen State
        3. Transition to the next state
        #>
    }
    
    [GlobalGameState]::GamePlayScreenStarting = {
        <#
        WORKFLOW
        
        1. Properly initialize variables for the Game Play Screen State
        2. Transition to the next state
        #>
    }
    
    [GlobalGameState]::GamePlayScreenRunning = {
        <#
        WORKFLOW
        
        1. Clear the screen (only once)
        2. Draw the entirety of the play area (only as needed, should only be once)
        3. Permit the Command Parser to accept input (when possible) (this may fix another issue I've had with it)
        #>

        Test-GfmPlayScreen
    }
    
    [GlobalGameState]::GamePlayScreenEnding = {}
    
    [GlobalGameState]::InventoryScreenStarting = {}
    
    [GlobalGameState]::InventoryScreenRunning = {}
    
    [GlobalGameState]::InventoryScreenEnding = {}
    
    [GlobalGameState]::Cleanup = {}
}

$Script:GamePlayStateBlockTable = @{
    [GamePlayState]::Normal = {}
    
    [GamePlayState]::Battle = {}
    
    [GamePlayState]::Shop = {}
    
    [GamePlayState]::Inn = {}
}

#endregion

#endregion

#region Text Formatting Functions

<#
.SYNOPSIS
Returns a string preformatted to display the player's hit point information.
#>
Function Format-GfmPlayerHitPoints {
    [CmdletBinding()]
    Param ()
    
    Process {
        Return "H $($Script:PlayerCurrentHitPoints) `n`t/ $($Script:PlayerMaximumHitPoints)"
    }
}

<#
.SYNOPSIS
Returns a string preformatted to display the player's magic point information.
#>
Function Format-GfmPlayerMagicPoints {
    [CmdletBinding()]
    Param ()
    
    Process {
        Return "M $($Script:PlayerCurrentMagicPoints) `n`t/ $($Script:PlayerMaximumMagicPoints)"
    }
}

<#
.SYNOPSIS
Returns a string preformatted to display the player's gold information.
#>
Function Format-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$($Script:PlayerCurrentGold)G"
    }
}

#endregion

#region Scene Image Functions

<#
.SYNOPSIS
Creates a new Sample Scene Image. This Scene Image is used for testing purposes only. All Scene Images would be created using this patten, however note that with this image in particular, it's randomly generated.
#>
Function New-GfmSceneImageSample {
    [CmdletBinding()]
    Param ()

    Process {
        For ($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
            For ($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                [Int]  $randBgColor              = Get-Random -Minimum 1 -Maximum 15
                $Script:SceneImageSample[$h, $w] = [BufferCell]::new(' ', 0, $randBgColor, 'Complete')
            }
        }
    }
}

Function New-GfmSiBc {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$Bgc
    )
    
    Process {
        Return [BufferCell]:: new(' ', 0, $Bgc, 'Complete')
    }
}

<#
.SYNOPSIS
Writes a Scene Image to the Scene Image "Window".

.DESCRIPTION
This function takes a two-dimensional array of BufferCell objects and writes them to the console buffer in the position where the Scene Image "Window" exists at.

Originally, this function was tested on MacOS and Linux, where most of the functions in the RawUI instance are crippled. So a manual method of writing the cells was devised.
After coming back to testing this function on Windows - where all of the functionality of the RawUI instance is available - a multi-platform algorithm was devised.
The function now takes a switch that controls which algorithm is used. It should be noted that of the two, the Windows-specific algorithm is substantially faster and works as expected.

.PARAMETER CellArray
The two-dimensional array of BufferCell objects that represent the Scene Image that are going to be written to the console buffer. The drawing origin coordinates are predefined.
#>
Function Write-GfmSceneImage {
    [CmdletBinding()]
    Param (
        #[Switch]$NonWindowsMethod,
        [Parameter(Mandatory = $true)]
        [BufferCell[,]]$CellArray
    )

    Process {
        Switch($(Test-GfmOs)) {
            { $_ -EQ $Script:OsCheckLinux -OR $_ -EQ $Script:OsCheckMac } {
                For ($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
                    For ($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                        $Script:Rui.CursorPosition = [Coordinates]::new($Script:SceneImageDrawOriginX + $w, $Script:SceneImageDrawOriginY + $h)
                        Write-Host ' ' -BackgroundColor $CellArray[$h, $w].BackgroundColor -NoNewline
                    }
                }
            }
            
            { $_ -EQ $Script:OsCheckWindows }  {
                $Script:Rui.SetBufferContents($([Coordinates]::new($Script:SceneImageDrawOriginX, $Script:SceneImageDrawOriginY)), $CellArray)
            }
            
            Default {}
        }
    }
}

#endregion

#region Utility Functions

<#
.SYNOPSIS
Checks to see what OS the module is running on and returns a module-specific string identifier to be used elsewhere.
#>
Function Test-GfmOs {
    [CmdletBinding()]
    Param ()

    Process {
        Get-PSDrive -Name Variable | Out-Null
        If ($?) {
            Get-ChildItem Variable:/IsLinux | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsLinux).Value -EQ $true) {
                    Return $Script:OsCheckLinux
                }
            }

            Get-ChildItem Variable:/IsMacOS | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsMacOS).Value -EQ $true) {
                    Return $Script:OsCheckMac
                }
            }

            Get-ChildItem Variable:/IsWindows | Out-Null
            If ($?) {
                If ($(Get-ChildItem Variable:/IsWindows).Value -EQ $true) {
                    Return $Script:OsCheckWindows
                }
            }
        }

        Return $Script:OsCheckUnknown
    }
}

<#
.SYNOPSIS
A wrapper for Write-Host that utilizes the NoNewline switch, which is a common requirement for a lot of console write calls in this module.
#>
Function Write-GfmHostNnl {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [ConsoleColor]$BackgroundColor = 'Black'
    )

    Process {
        Write-Host $Message -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
}

<#
.SYNOPSIS
Sets the console cursor position to the predefined "default" location. This is mostly to get it out of the way for visual aesthetic.
#>
Function Set-GfmDefaultCursorPosition {
    [CmdletBinding()]
    Param ()

    Process {
        $Script:Rui.CursorPosition = [Coordinates]::new($Script:DefaultCursorX, $Script:DefaultCursorY)
    }
}

<#
.SYNOPSIS
Writes a string to the console buffer at a caller-specified cell coordinate location. This function will leverate Write-GfmHostNnl to perform the write operation.

.PARAMETER Coordinates
The Coordinates (in console cells) where the string will start to be written to.

.PARAMETER Message
The string to write to the console.

.PARAMETER ForegroundColor
The color to give to the string when it's being written.
#>
Function Write-GfmPositionalString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-GfmHostNnl -Message $Message -ForegroundColor $ForegroundColor
    }
}

<#
.SYNOPSIS
Writes a string to the console in a teletype fashion. This function will leverage Write-GfmHostNnl.

.PARAMETER Message
The string that will be written to the console.

.PARAMETER ForegroundColor
The color to give to the string when it's being written.

.PARAMETER TypeSpeed
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]:: Normal.
#>
Function Write-GfmTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        [Char[]]$msgCharArray = $Message.ToCharArray()
        [Int]    $typeCounter = 0
        [Int]    $msgcaProbe  = 0

        While ($msgcaProbe -LE ($msgCharArray.Count - 1)) {
            $typeCounter++
            If ($typeCounter -GE $TypeSpeed) {
                $typeCounter = 0
                Write-GfmHostNnl -Message $msgCharArray[$msgcaProbe] -ForegroundColor $ForegroundColor
                $msgcaProbe++
            }
        }
    }
}

<#
.SYNOPSIS
Combines the positional string and teletype functions.

.PARAMETER Coordinates
The Coordinates (in console cells) where the string will start to be written to.

.PARAMETER Message
The string that will be written to the console.

.PARAMETER ForegroundColor
The color to give to the string when it's being written.

.PARAMETER TypeSpeed
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]:: Normal.
#>
Function Write-GfmPositionalTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-GfmTtyString -Message $Message -ForegroundColor $ForegroundColor -TypeSpeed $TypeSpeed
    }
}

<#
.SYNOPSIS
Writes the player's name to the console window at the predefined cell coordinates.
#>
Function Write-GfmPlayerName {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerNameDrawX, $Script:UiStatusWindowPlayerNameDrawY)) `
            -Message $Script:PlayerName `
            -ForegroundColor $Script:PlayerStatNameDrawColor
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

<#
.SYNOPSIS
Writes the player's hit points to the console window at the predefined cell coordinates. This function also performs logic against the current hit points to color the text based on state.
#>
Function Write-GfmPlayerHp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($Script:PlayerHitPointsState) {
            # The fix for properly strong-typing the scoping is found here: https: //learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
            ([PlayerHpState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorSafe
            }

            ([PlayerHpState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorCaution
            }

            ([PlayerHpState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

<#
.SYNOPSIS
Writes the player's magic points to the console window at the predefined cell coordinates. This function also performs logic against the current magic points to color the text based on state.
#>
Function Write-GfmPlayerMp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($Script:PlayerMagicPointsState) {
            # The fix for properly strong-typing the scoping is found here: https: //learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
            ([PlayerMpState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorSafe
            }

            ([PlayerMpState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorCaution
            }

            ([PlayerMpState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

<#
.SYNOPSIS
Writes the player's gold points to the console window at the predefined cell coordinates.
#>
Function Write-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $([Coordinates]::new($Script:UiStatusWindowPlayerGoldDrawX, $Script:UiStatusWindowPlayerGoldDrawY)) `
            -Message $(Format-GfmPlayerGold) `
            -ForegroundColor $Script:PlayerStatGoldDrawColor
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

<#
.SYNOPSIS
Tests the player's current hit points against a fraction of the maximum and determines their state accordingly.
#>
Function Test-GfmPlayerHpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If ($Script:PlayerCurrentHitPoints -GT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdCaution)) {
            $Script:PlayerHitPointsState = [PlayerHpState]::Normal
        } Elseif (($Script:PlayerCurrentHitPoints -GT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdDanger)) -AND ($Script:PlayerCurrentHitPoints -LT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdCaution))) {
            $Script:PlayerHitPointsState = [PlayerHpState]::Caution
        } Elseif ($Script:PlayerCurrentHitPoints -LT ($Script:PlayerMaximumHitPoints * $Script:PlayerStatNumThresholdDanger)) {
            $Script:PlayerHitPointsState = [PlayerHpState]::Danger
        }
    }
}

<#
.SYNOPSIS
Tests the player's current magic points against a fraction of the maximum and determines their state accordingly.
#>
Function Test-GfmPlayerMpForState {
    [CmdletBinding()]
    Param ()

    Process {
        If ($Script:PlayerCurrentMagicPoints -GT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdCaution)) {
            $Script:PlayerMagicPointsState = [PlayerMpState]::Normal
        } Elseif (($Script:PlayerCurrentMagicPoints -GT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdDanger)) -AND ($Script:PlayerCurrentMagicPoints -LT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdCaution))) {
            $Script:PlayerMagicPointsState = [PlayerMpState]::Caution
        } Elseif ($Script:PlayerCurrentMagicPoints -LT ($Script:PlayerMaximumMagicPoints * $Script:PlayerStatNumThresholdDanger)) {
            $Script:PlayerMagicPointsState = [PlayerMpState]::Danger
        }
    }
}

<#
.SYNOPSIS
Changes the player's name and writes it to the console window if applicable.

.PARAMETER NewName
The new name to assign to the player.

.PARAMETER WriteToConsole
Writes the name to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$NewName,
        [Switch]$WriteToConsole
    )

    Process {
        $Script:PlayerName = $NewName
        If ($WriteToConsole) {
            Write-GfmPlayerName
        }
    }

    End {
        If ($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

<#
.SYNOPSIS
Updates the player's current hit points and writes it to the console window if applicable.

.PARAMETER HpDelta
The additive to the current hit points value. To subtract from the current hit points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the HP String to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerHp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$HpDelta,
        [Switch]$WriteToConsole
    )

    Process {
                $t                     = $Script:PlayerCurrentHitPoints + $HpDelta
                $t                     = [Math]::Clamp($t, 0, $Script:PlayerMaximumHitPoints)
        $Script:PlayerCurrentHitPoints = $t
        Test-GfmPlayerHpForState
        If ($WriteToConsole) {
            Write-GfmPlayerHp
        }
    }

    End {
        If ($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

<#
.SYNOPSIS
Updates the player's current magic points and writes it to the console window if applicable.

.PARAMETER MpDelta
The additive to the current magic points value. To subtract from the current magic points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the MP String to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerMp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$MpDelta,
        [Switch]$WriteToConsole
    )

    Process {
                $t                       = $Script:PlayerCurrentMagicPoints + $MpDelta
                $t                       = [Math]::Clamp($t, 0, $Script:PlayerMaximumMagicPoints)
        $Script:PlayerCurrentMagicPoints = $t
        Test-GfmPlayerMpForState
        If ($WriteToConsole) {
            Write-GfmPlayerMp
        }
    }

    End {
        If ($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

<#
.SYNOPSIS
Updates the player's current gold points and writes it to the console window if applicable.

.PARAMETER GDelta
The additive to the current gold points value. To subtract from the current gold points, assign this a negative value.

.PARAMETER WriteToConsole
Writes the Gold String to the console at the predefined cell coordinates if necessary.
#>
Function Update-GfmPlayerGold {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$GDelta,
        [Switch]$WriteToConsole
    )

    Process {
                $t                = $Script:PlayerCurrentGold + $GDelta
                $t                = [Math]::Clamp($t, 0, [Int]::MaxValue)
        $Script:PlayerCurrentGold = $t
        If ($WriteToConsole) {
            Write-GfmPlayerGold
        }
    }

    End {
        If ($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

<#
.SYNOPSIS
Writes a message to the Message Window Area

.PARAMETER Message
The message to add to the Message Window "queue".

.PARAMETER Teletype
Specifies if we're going to use the teletype method for printing the message to the window.
#>
Function Write-GfmMessageWindowMessage {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $false)]
        [ConsoleColor]$ForegroundColor = 'White',
        [Switch]$Teletype
    )

    Process {
        # FIXED
        # The color provided in the parameters is propagated to all of the strings in this window when it's updated
        # which kind of defeats the purpose of having the color argument there at all. I'll need to rethink this.
        # There's a model for the intended behavior in the Update-GmfCmdHistory function. As of now, this will stay borken.

        # FIXED
        # I've discovered a new issue with this. If the length of one of the strings is too small in comparison to
        # any adjacent one in the queue, there are artifacts remaining. The messages should be fixed length,
        # but the clearing of the row should be complete from start to length of the current string.


        # The algorithm here is a little odd so I'm going to step through it as best I can
        # First, we need to shift the contents of the string containers to the next, with the contents of
        # the top being discarded/overwritten. Even if there's nothing currently in the string containers,
        # the shift needs to occur.

        $Script:UiMessageWindowMessageA.Message = $Script:UiMessageWindowMessageB.Message; $Script:UiMessageWindowMessageA.ForegroundColor = $Script:UiMessageWindowMessageB.ForegroundColor
        $Script:UiMessageWindowMessageB.Message = $Script:UiMessageWindowMessageC.Message; $Script:UiMessageWindowMessageB.ForegroundColor = $Script:UiMessageWindowMessageC.ForegroundColor
        $Script:UiMessageWindowMessageC.Message = $Message; $Script:UiMessageWindowMessageC.ForegroundColor                                = $ForegroundColor

        # Print the messages back to their appropraite positions in the buffer, optionally using the teletype method
        If ($Teletype) {
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalTtyString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
                -Message $($Script:UiMessageWindowMessageC.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageC.ForegroundColor)
            
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalTtyString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
                -Message $($Script:UiMessageWindowMessageB.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageB.ForegroundColor)

            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageTopDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalTtyString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageTopDrawY)) `
                -Message $($Script:UiMessageWindowMessageA.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageA.ForegroundColor)
        } Else {
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
                -Message $($Script:UiMessageWindowMessageC.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageC.ForegroundColor)

            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
                -Message $($Script:UiMessageWindowMessageB.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageB.ForegroundColor)

            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageTopDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageTopDrawY)) `
                -Message $($Script:UiMessageWindowMessageA.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageA.ForegroundColor)
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Read-GfmUserCommandInput {
    [CmdletBinding()]
    Param ()

    Process {
        <#
        We're going to try and take a different approach to reading this information in the parser cell row.
        First of all, a complete list of virtual key codes in hex can be found here: https: //learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
        The next thing we're going to want to do is see if we can loop using the return value of RawUI.ReadKey.
        If the return value of RawUI.ReadKey is 0x0D (DEC 13) (Enter Key), then we know that the user command has been completed.
        Each result of the call will have its Character property value concatenated to the cmdactual string. Because the console
        is accepting input in the current Cursor Position, this should render the character typed to the console window.
        While the typing is progressing, it should be possible to check the current Cursor Position against the maximum length
        of the command parser row and prohibit the user from typing any further. When Enter is pressed, we should have the
        cmdactual string populated with the characters that were typed into the command row and the parser can be invoked
        using this data.

        FIXED
        While this seems to work for typing shit in and getting it into cmdactual, the damn backspace functionality is borken.
        After checking the Cursor Position for max limit, a check should be made to see if the VirtualKeyCode is 0x08 (DEC 8) (Backspace).
        If this is the case, we check to see what the current Cursor Position is. If we can subtract 1 from its X property value, we
        first clear the Buffer Cell in the prior and then reposition the Cursor Position to X-1.

        FIXED
        There's an issue where if the Backspace key is pressed when the Command Buffer is empty, it throws an exception (referenced in this bug: https://github.com/gregoryfmartin/Playground/issues/20).
        #>

        $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        While ($keyCap.VirtualKeyCode -NE 13) {
            # Check to see what the current Cursor Position is to ensure that we're not violating length
            # when attempting to append the Character property value to the cmdactual string
            If ($Script:Rui.CursorPosition.X -GE 19) {
                # As of now, it's unclear what the hell to do in response to a length violation
                # other than to not do anything. I just don't have any idea if this is going to
                # do what I think it's going to do, so I'm just going with this for now.
                Invoke-GfmCmdParser
            }

            # Check to see if the key pressed is the Backspace Key
            If ($keyCap.VirtualKeyCode -EQ 8) {
                # Check to see if the current Cursor Position X-1 would violate the left limit (this would be the Default Cursor Position X)
                $fx = $Script:Rui.CursorPosition.X
                If ($fx -GE $Script:DefaultCursorX) {
                    # We can perform the backspace
                    Write-GfmHostNnl `
                        -Message ' ' `
                        -ForegroundColor 'Black' `
                        -BackgroundColor 'Black'

                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:Rui.CursorPosition.X - 1, $Script:DefaultCursorY)

                    # Remove the character from the cmdactual string
                    # Since I'm not going to go through the trouble of capturing what character was in the cell that just got
                    # clobbered, I'm going to just drop the last index from the cmdactual string.
                    # The conditional here is a sanity check. In this branch, there shouldn't be any reason why a LT 0 condition would occur, but it's present for parity.
                    If ($Script:UiCommandWindowCmdActual.Length -GT 0) {
                        $Script:UiCommandWindowCmdActual = $Script:UiCommandWindowCmdActual.Remove($Script:UiCommandWindowCmdActual.Length - 1, 1)
                    }
                } Else {
                    Write-GfmPositionalString `
                        -Coordinates $([Coordinates]::new($Script:Rui.CursorPosition.X + 1, $Script:DefaultCursorY)) `
                        -Message ' ' `
                        -ForegroundColor 'Black'
                    Set-GfmDefaultCursorPosition

                    # Remove the character from the cmdactual string
                    # Since I'm not going to go through the trouble of capturing what character was in the cell that just got
                    # clobbered, I'm going to just drop the last index from the cmdactual string.
                    If ($Script:UiCommandWindowCmdActual.Length -GT 0) {
                        $Script:UiCommandWindowCmdActual = $Script:UiCommandWindowCmdActual.Remove($Script:UiCommandWindowCmdActual.Length - 1, 1)
                    }
                }
            } Else {
                # Append the Character property value to the cmdactual string
                $Script:UiCommandWindowCmdActual += $keyCap.Character
            }

            # Call ReadKey again
            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }

        Invoke-GfmCmdParser
    }
}

Function Invoke-GfmCmdParser {
    [CmdletBinding()]
    Param ()

    Process {
        # The first thing to do is to clear the user input portion of the command window
        # The cursor will not be in the default position, so we need to reset it and then clear the row
        Set-GfmDefaultCursorPosition
        Write-GfmHostNnl `
            -Message $Script:UiCommandWindowCmdBlank `
            -ForegroundColor 'Black'     

        # Perform sanity checks on the cmdactual string
        If ([String]::IsNullOrEmpty($Script:UiCommandWindowCmdActual)) {
            # Don't do anything, but we need to reset the cursor position to the default position since the ReadLine function
            # will inject a CRLF character into the buffer at the cell the cursor is at.
            Set-GfmDefaultCursorPosition
            Return
        } Else {
            
            # Break the cmdactual apart
            $cmdactSplit = -Split $Script:UiCommandWindowCmdActual
            
            # Check the command table for the root
            $rootFound = $Script:CommandTable.GetEnumerator() | Where-Object { $_.Name -IEQ $cmdactSplit[0] }
            If($null -NE $rootFound) {
                # Found the root
                # Check the length of the split to determine how many arguments to pass to the invocation
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
                }
            } Else {
                # Failed to find the root
                Write-GfmBadCommandException
                Return
            }
        }
    }
}

Function Invoke-GfmItemReactor {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )
    
    Process {
        # First we need to check the contents of the object collection on the current tile
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        
        # Check to see if it's empty
        If($a.Count -EQ 0) {
            # There are no objects on the map tile
            Update-GfmCmdHistory -CmdActualValid
            Write-GfmMapNoItemsFoundException
            Return
        } Elseif ($a.Count -GT 0) {
            # There's something on this tile
            # Check to see if there's an object whose name matches the case
            Foreach($c in $a) {
                If($c.MapObjName -EQ $ItemName) {
                    # We've found a match
                    Update-GfmCmdHistory -CmdActualValid
                    Invoke-Command $c.Effect
                    Return
                }
            }
            
            # Couldn't find a match for this item on the map
            Update-GfmCmdHistory -CmdActualValid
            Write-GfmMapInvalidItemException -ItemName $ItemName
            Return
        } Else {
            # Something goofy happened that shouldn't have
            Write-GfmBadSomethingException
            Return
        }
    }
}

Function Invoke-GfmLookAction {
    [CmdletBinding()]
    Param ()
    
    Process {
        Update-GfmCmdHistory -CmdActualValid

        # Get the Object Listing from the Current Map Tile
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing
        $b = 78 # The maximum length of the String. This doesn't necessarily mean that this is where the String get's broken up at.
        $c = '' # The first String that would be printed to the Message Window
        $f = '' # The second String that would be printed to the Message Window (if needed)
        $z = 0 # Probe counter to determine if a comma should be removed from the last addition to $a
        $y = $false # Flag specifying if there's been overflow in $c or not ($c length exceeds $b)

        If($a.Count -LE 0) {
            Write-GfmMessageWindowMessage `
                -Message 'It doesn''t look like there''s anything of interest here.' `
                -ForegroundColor $Script:PlayerAsideColor `
                -Teletype
            Return
        }
        
        Foreach($d in $a) {
            If($z -EQ $a.Count - 1) {
                # If the iteration is on the last addition, just add it without the ending comma
                $c += $d.Name
            } Else {
                # If the iteration isn't on the last addition, add it with an ending comma
                $c += $d.Name + ', '
            }
            
            # Increment the probe counter
            $z += 1
        }
        $e = $c.Length # This is the length of the String that has all of the availabale items on the current tile
        
        # Space Saver Method 1 - Remove the last five entries and place them into a third line.
        If($e -GT $b) {
            $y = $true # $c overflow has occurred
            $c -MATCH '([\s,]+\w+){5}$' | Out-Null # Match the last five comma-whitespace-word sequences in $c
            If($_ -EQ $true) {
                # This should always be true in this case, but check anyway to be kind :)
                $c = $c -REPLACE '([\s,]+\w+){5}$', '' # Remove the match from the root
                $f = $matches[0].Remove(0, 2) # Get rid of garbage characters from the head of the secondary String
            }
        }
        
        # Method 1
        # Brute force write two strings
        Write-GfmMessageWindowMessage `
            -Message 'I can see the following things here:' `
            -ForegroundColor $Script:PlayerAsideColor `
            -Teletype
        Write-GfmMessageWindowMessage `
            -Message $c `
            -ForegroundColor $Script:MapTileItemsDiscoveredColor `
            -Teletype
        If($y -EQ $true) {
            Write-GfmMessageWindowMessage `
                -Message $f `
                -ForegroundColor $Script:MapTileItemsDiscoveredColor `
                -Teletype
        }
    }
}

Function Invoke-GfmExamineAction {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )
    
    Process {
        Foreach($a in $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing) {
            If($a.Name -EQ $ItemName) {
                Update-GfmCmdHistory -CmdActualValid
                Write-GfmMessageWindowMessage `
                    -Message $a.ExamineString `
                    -ForegroundColor $Script:PlayerAsideColor `
                    -Teletype
                Return
            }
        }
        
        Update-GfmCmdHistory
        Write-GfmMessageWindowMessage `
            -Message "There's no $ItemName to be found here..." `
            -ForegroundColor $Script:PlayerAsideColor `
            -Teletype
        Return
    }
}

Function Invoke-GfmGetAction {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )
    
    Process {
        # The argument passed here is the lowercase name of the item
        #  There are two sanity checks that need made from the start: are there any items on this tile,                                 and does the requested item exist?
        $a = $Script:CurrentMap.GetTileAtPlayerCoordinates().ObjectListing # Remember, this is now a List<MapTileObject> instance
        
        If($a.Count -LE 0) {
            # There aren't any items on this map tile
            Update-GfmCmdHistory
            Write-GfmMessageWindowMessage `
                -Message 'There doesn''t appear to be anything to collect here...' `
                -ForegroundColor 'Magenta' `
                -Teletype
            Return
        }
        Foreach($b in $a) {
            If($b.Name -EQ $ItemName) {
                # We've found a match; copy the item from the Map Tile OL into the Player's Inventory, then remove the instance
                # from the Map Tile OL. However, not every item found on a Map Tile can be taken into the Player's Inventory.
                # So now we need to check and see if the item can be added before attempting to do so.
                If($b.CanAddToInventory -EQ $true) {
                    # We can add the item to the Player's Inventory; attempt to do so.
                    $Script:PlayerInventory.Add($b) | Out-Null
                    $c = $a.Remove($b) | Out-Null
                    If($c -EQ $false) {
                        # Failed to remove the item from the Map Tile OL: This is a critical failure
                        Write-Error 'Failed to remove item from Map Tile OL!'
                        Exit
                    } Else {
                        # Addition and removal of the item was successful
                        Update-GfmCmdHistory -CmdActualValid
                        Write-GfmMessageWindowMessage `
                            -Message "I've taken the $($b.MapObjName) and put it in my pocket." `
                            -ForegroundColor $Script:PlayerAsideColor `
                            -Teletype
                        Return
                    }
                } Else {
                    # This item can't be added into the Player's Inventory because the flag that allows this op has been toggled off.
                    Update-GfmCmdHistory
                    Write-GfmMessageWindowMessage `
                        -Message "It's not possbile to take the $($b.MapObjName)." `
                        -ForegroundColor 'Magenta' `
                        -Teletype
                    Return
                }
            }
        }
        
        # Although there were items found in the Map Tile, the one the user requested wasn't found here.
        Update-GfmCmdHistory
        Write-GfmMessageWindowMessage `
            -Message "There's no $ItemName to be found here..." `
            -ForegroundColor 'Magenta' `
            -Teletype
        Return
    }
}

Function Write-GfmGoodCommandAlert {
    [CmdletBinding()]
    Param ()
    
    Process {
        Write-Error 'Write-GfmGoodCommandAlert Function is Deprecated'
    }
}

Function Write-GfmBadCommandException {
    [CmdletBinding()]
    Param ()
    
    Process {
        Update-GfmCmdHistory `
            -UpdateMessageWindow `
            -MsgTeletype `
            -MsgWindowMessage "INVALID COMMAND: $Script:UiCommandWindowCmdActual" `
            -MsgColor $Script:UiCommandWindowCmdHistErr
    }
}

Function Write-GfmBadCommandArg0Exception {
    [CmdletBinding()]
    Param ()
    
    Process {
        Update-GfmCmdHistory `
            -UpdateMessageWindow `
            -MsgTeletype `
            -MsgWindowMessage "INVALID ARGUMENT 0: $Script:UiCommandWindowCmdActual" `
            -MsgColor $Script:UiCommandWindowCmdHistErr
    }
}

Function Write-GfmBadCommandArg1Exception {
    [CmdletBinding()]
    Param ()
    
    Process {
        Update-GfmCmdHistory `
            -UpdateMessageWindow `
            -MsgTeletype `
            -MsgWindowMessage "INVALID ARGUMENT 1: $Script:UiCommandWindowCmdActual" `
            -MsgColor $Script:UiCommandWindowCmdHistErr
    }
}

Function Write-GfmBadSomethingException {
    [CmdletBinding()]
    Param ()
    
    Process {
        Update-GfmCmdHistory `
            -UpdateMessageWindow `
            -MsgTeletype `
            -MsgWindowMessage 'I''m God, and I don''t know what just happened...' `
            -MsgColor $Script:UiCommandWindowCmdHistErr
    }
}

Function Write-GfmMapInvisibleWallException {
    [CmdletBinding()]
    Param ()
    
    Process {
        Write-GfmMessageWindowMessage `
            -Message 'The invisible wall blocks your path...' `
            -ForegroundColor 'DarkMagenta' `
            -Teletype
    }
}

Function Write-GfmMapYouShallNotPassException {
    [CmdletBinding()]
    Param ()
    
    Process {
        Write-GfmMessageWindowMessage `
            -Message 'The path you asked for is impossible...' `
            -ForegroundColor 'Magenta' `
            -Teletype
    }
}

Function Write-GfmMapNoItemsFoundException {
    [CmdletBinding()]
    Param ()
    
    Process {
        Write-GfmMessageWindowMessage `
            -Message 'There''s nothing of interest here...' `
            -ForegroundColor $Script:PlayerAsideColor `
            -Teletype
    }
}

Function Write-GfmMapInvalidItemException {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$ItemName
    )
    
    Process {
        Write-GfmMessageWindowMessage `
            -Message "There's no $ItemName here" `
            -ForegroundColor 'Magenta' `
            -Teletype
    }
}

<#
.SYNOPSIS
Updates the Command Window History, optionally printing information to the Message Window.
#>
Function Update-GfmCmdHistory {
    [CmdletBinding()]
    Param (
        [Switch]$CmdActualValid,
        [Switch]$UpdateMessageWindow,
        [String]      $MsgWindowMessage = '',
        [ConsoleColor]$MsgColor         = 'White',
        [Switch]$MsgTeletype
    )

    Process {
        # This algorithm is similar to what's used in the Message Window.
        # Shift all of the strings up, and promote the new command into the bottom.
        # For some reason, object assignments here weren't doing what I wanted it to do in terms of rendering.
        # There was some goofy bullshit where D would render twice, meaning that it was copied into C despite the fact
        # that there shouldn't have been anything in it, and I don't quite understand how that happened. However, it was
        # visible in the buffer cells, so this manual moving seems to be the best way to mitigate this. I'll want to look
        # into this a bit more once the code is more stable.
        $Script:UiCommandWindowHistA.Message = $Script:UiCommandWindowHistB.Message; $Script:UiCommandWindowHistA.ForegroundColor = $Script:UiCommandWindowHistB.ForegroundColor
        $Script:UiCommandWindowHistB.Message = $Script:UiCommandWindowHistC.Message; $Script:UiCommandWindowHistB.ForegroundColor = $Script:UiCommandWindowHistC.ForegroundColor
        $Script:UiCommandWindowHistC.Message = $Script:UiCommandWindowHistD.Message; $Script:UiCommandWindowHistC.ForegroundColor = $Script:UiCommandWindowHistD.ForegroundColor
        $Script:UiCommandWindowHistD.Message = $Script:UiCommandWindowCmdActual
        If ($CmdActualValid) {
            $Script:UiCommandWindowHistD.ForegroundColor = $Script:UiCommandWindowCmdHistValid
        } Else {
            $Script:UiCommandWindowHistD.ForegroundColor = $Script:UiCommandWindowCmdHistErr
        }

        # Clear the positions and write the histories
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistDDrawY)) `
            -Message $($Script:UiCommandWindowCmdBlank) `
            -ForegroundColor $($Script:UiCommandWindowCmdBlankColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistDDrawY)) `
            -Message $($Script:UiCommandWindowHistD.Message) `
            -ForegroundColor $($Script:UiCommandWindowHistD.ForegroundColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistCDrawY)) `
            -Message $($Script:UiCommandWindowCmdBlank) `
            -ForegroundColor $($Script:UiCommandWindowCmdBlankColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistCDrawY)) `
            -Message $($Script:UiCommandWindowHistC.Message) `
            -ForegroundColor $($Script:UiCommandWindowHistC.ForegroundColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistBDrawY)) `
            -Message $($Script:UiCommandWindowCmdBlank) `
            -ForegroundColor $($Script:UiCommandWindowCmdBlankColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistBDrawY)) `
            -Message $($Script:UiCommandWindowHistB.Message) `
            -ForegroundColor $($Script:UiCommandWindowHistB.ForegroundColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistADrawY)) `
            -Message $($Script:UiCommandWindowCmdBlank) `
            -ForegroundColor $($Script:UiCommandWindowCmdBlankColor) `
            -TypeSpeed LineClear
        Write-GfmPositionalTtyString `
            -Coordinates $([Coordinates]::new($Script:UiCommandWindowHistDrawX, $Script:UiCommandWindowHistADrawY)) `
            -Message $($Script:UiCommandWindowHistA.Message) `
            -ForegroundColor $($Script:UiCommandWindowHistA.ForegroundColor) `
            -TypeSpeed LineClear
        
        If($UpdateMessageWindow) {
            If($MsgTeletype) {
                Write-GfmMessageWindowMessage `
                    -Message $MsgWindowMessage `
                    -ForegroundColor $MsgColor `
                    -Teletype
            } Else {
                Write-GfmMessageWindowMessage `
                    -Message $MsgWindowMessage `
                    -ForegroundColor $MsgColor
            }
        }
            
        $Script:UiCommandWindowCmdActual = ''
        Set-GfmDefaultCursorPosition
    }
}

Function Update-GfmSceneImageFromCoords {
    [CmdletBinding()]
    Param ()
    
    Process {
        Write-GfmSceneImage -CellArray $Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage
    }
}

#endregion

#region Window Drawing Functions

<#
.SYNOPSIS
Writes Status "Window" to the console buffer at the predefined cell coordinates.

.DESCRIPTION
This function uses two different algorithms for writing the "window" to the console buffer. One algorithm is utilized when running on MacOS or Linux. The other is used when running on Windows.
#>
Function Write-GfmStatusWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal `
                                 -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal `
                                 -ForegroundColor $Script:UiStatusWindowBorderColor
                For ($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical `
                                     -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical `
                                     -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                # For the time being, I'm simply going to copypaste the code from the previous case
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal `
                                 -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal `
                                 -ForegroundColor $Script:UiStatusWindowBorderColor
                For ($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical `
                                     -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical `
                                     -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            Default {
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmSceneWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, ($Script:UiSceneWindowDrawY + $Script:UiSceneWindowHeight))
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiSceneWindowBorderColor
                For ($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical `
                                     -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth) - 1, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical `
                                     -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, ($Script:UiSceneWindowDrawY + $Script:UiSceneWindowHeight))
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiSceneWindowBorderColor
                For ($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical `
                                     -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth) - 1, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical `
                                     -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            Default {
            }
        }
    }

    End {
    }
}

Function Write-GfmMessageWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                For ($i = 0; $i -LE $Script:UiMessageWindowWidth - 1; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For ($i = 0; $i -LT $Script:UiMessageWindowHeight - 1; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth) - 1, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                For ($i = 0; $i -LE $Script:UiMessageWindowWidth - 1; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For ($i = 0; $i -LT $Script:UiMessageWindowHeight - 1; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth) - 1, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical `
                                     -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            Default {
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmCommandWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            { ($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac) } {
                # Draw the horizontal borders
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, $Script:UiCommandWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiCommandWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiCommandWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight))
                Write-GfmHostNnl -Message $Script:UiCommandWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiCommandWindowBorderColor

                # Draw the command input div
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowCmdDivDrawX, $Script:UiCommandWindowCmdDivDrawY)
                Write-GfmHostNnl -Message $Script:UiCommandWindowCmdDiv `
                                 -ForegroundColor $Script:UiCommandWindowBorderColor

                # Draw the vertical borders
                For ($i = 1; $i -LT $Script:UiCommandWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, ($Script:UiCommandWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiCommandWindowBorderVertical `
                                     -ForegroundColor $Script:UiCommandWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiCommandWindowDrawX + $Script:UiCommandWindowWidth), ($Script:UiCommandWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiCommandWindowBorderVertical `
                                     -ForegroundColor $Script:UiCommandWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                # Draw the horizontal borders
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, $Script:UiCommandWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiCommandWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiCommandWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight))
                Write-GfmHostNnl -Message $Script:UiCommandWindowBorderHorizontal `
                                 -ForegroundColor $Script:UiCommandWindowBorderColor

                # Draw the command input div
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowCmdDivDrawX, $Script:UiCommandWindowCmdDivDrawY)
                Write-GfmHostNnl -Message $Script:UiCommandWindowCmdDiv `
                                 -ForegroundColor $Script:UiCommandWindowBorderColor

                # Draw the vertical borders
                For ($i = 1; $i -LT $Script:UiCommandWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, ($Script:UiCommandWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiCommandWindowBorderVertical `
                                     -ForegroundColor $Script:UiCommandWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiCommandWindowDrawX + $Script:UiCommandWindowWidth), ($Script:UiCommandWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiCommandWindowBorderVertical `
                                     -ForegroundColor $Script:UiCommandWindowBorderColor
                }
            }

            Default {
            }
        }
    }
}

#endregion

#region State Machine Functions

Function Switch-GfmGameStateFlags {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [GameStateFlags]$DesiredState
    )
    
    Process {
        Switch($DesiredState) {
            [GameStateFlags]::Starting {
                $Script:StateStarting = $true
                $Script:StateRunning  = $false
                $Script:StateEnding   = $false
                Return
            }
            
            [GameStateFlags]::Running {
                $Script:StateStarting = $false
                $Script:StateRunning  = $true
                $Script:StateEnding   = $false
                Return
            }
            
            [GameStateFlags]::Ending {
                $Script:StateStarting = $false
                $Script:StateRunning  = $false
                $Script:StateEnding   = $true
                Return
            }
            
            Default {
                # This is an error state - die
                # I need to make this a bit more verbose in the long run
                Exit
            }
        }
    }
}

Function Invoke-GfmGameStateMachine {
    [CmdletBinding()]
    Param ()
    
    Begin {
        If($Script:StateStarting -EQ $true) {
            Switch($Script:GameState) {
                Default {}
            }
        }
    }
    
    Process {
        If($Script:StateRunning -EQ $true) {
            Switch($Script:GameState) {
                Default {}
            }
        }
    }
    
    End {
        If($Script:StateEnding -EQ $true) {
            Switch($Script:GameState) {
                Default {}
            }
        }
    }
}

Function Invoke-GfmGamePlayScreenStarting {
    [CmdletBinding()]
    Param ()
    
    Process {
        Clear-Host
        Write-GfmStatusWindow
        Write-GfmSceneWindow
        Write-GfmMessageWindow
        Write-GfmCommandWindow
        Write-GfmSceneImage -CellArray $Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage
        Write-GfmPlayerName
        Write-GfmPlayerHp
        Write-GfmPlayerMp
        Write-GfmPlayerGold
    }
    
    End {
        Switch-GfmGameStateFlags -DesiredState [GameStateFlags]::Running
    }
}

Function Invoke-GfmGamePlayScreenEnding {
    [CmdletBinding()]
    Param ()
    
    Process {
        
    }
}

#endregion

#region Lifecycle Functions

Function Start-GfmGame {
    [CmdletBinding()]
    Param ()
    
    Process {      
        While ($Script:GameRunning -EQ $true) {            
            $Script:CurrentFrameTime = [DateTime]::Now.Ticks
            
            If (($Script:CurrentFrameTime - $Script:LastFrameTime) -GE $Script:MsPerFrame) {
                $Script:FpsDelta = [TimeSpan]::new($Script:CurrentFrameTime - $Script:LastFrameTime)
                Invoke-GfmGameLogic
                #Invoke-GfmGameDraw
            }
        }
    }
}

Function Invoke-GfmGameLogic {
    [CmdletBinding()]
    Param ()
    
    Process {
        # Query the current state of the game
        Invoke-Command $Script:GameStateBlockTable[$Script:GameState]
    }
}

Function Invoke-GfmGameDraw {
    [CmdletBinding()]
    Param ()
    
    Process {
        # Query the current state/substate of the game
        Switch ($Script:GameState) {
            # TODO: Add the possible top-level states here
            
            Default {}
        }
    }
}

#endregion

#region Testing Functions

Function Test-GfmPlayScreen {
    [CmdletBinding()]
    Param ()

    Process {
    	If($Script:RefreshGPSStatusWindow) {
    		Write-GfmStatusWindow
    		$Script:RefreshGPSStatusWindow = $false
    	}
    	If($Script:RefreshGPSSceneWindow) {
    		Write-GfmSceneWindow
    		$Script:RefreshGPSSceneWindow = $false
    	}
    	If($Script:RefreshGPSCommandWindow) {
    		Write-GfmCommandWindow
    		$Script:RefreshGPSCommandWindow = $false
    	}
    	If($Script:RefreshGPSMessageWindow) {
    		Write-GfmMessageWindow
    		$Script:RefreshGPSMessageWindow = $false
    	}

		If($Script:RefreshGPSSceneImage) {
        	Write-GfmSceneImage -CellArray $Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage
        	$Script:REfreshGPSSceneImage = $false
        }

		If(-NOT($Script:PlayerDataInitialized)) {
	        $Script:PlayerName = 'Steve'
	        $Script:PlayerCurrentHitPoints = 100
	        $Script:PlayerMaximumHitPoints = 100
	        $Script:PlayerCurrentMagicPoints = 25
	        $Script:PlayerMaximumMagicPoints = 25
	        $Script:PlayerCurrentGold = 5000
	        $Script:PlayerDataInitialized = $true
        }

        If($Script:RefreshGPSPlayerName) {
        	Write-GfmPlayerName
        	$Script:RefreshGPSPlayerName = $false
        }
        If($Script:RefreshGPSPlayerHp) {
        	Write-GfmPlayerHp
        	$Script:RefreshGPSPlayerHp = $false
        }
        If($Script:RefreshGPSPlayerMp) {
        	Write-GfmPlayerMp
        	$Script:RefreshGPSPlayerMp = $false
        }
        If($Script:RefreshGPSPlayerGold) {
        	Write-GfmPlayerGold
        	$Script:RefreshGPSPlayerGold = $false
        }

        While($Script:GPSAllowUserInput) {
        	Read-GfmUserCommandInput
        }
    }
}

#endregion

#region Scene Image Definitions

#region SiFieldNRoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldNRoad' -CurrentOperation 'Creating SiFieldNRoad' -Id 3 -PercentComplete -1
$Script:SiFieldNRoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[16, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[17, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

#endregion

#region SiFieldNERoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldNERoad' -CurrentOperation 'Creating SiFieldNERoad' -Id 3 -PercentComplete -1
$Script:SiFieldNERoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[16, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 44] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[17, 45] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')

#endregion

#region SiFieldNWRoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldNWRoad' -CurrentOperation 'Creating SiFieldNWRoad' -Id 3 -PercentComplete -1
$Script:SiFieldNWRoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNWRoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 1]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 2]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 3]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 4]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 5]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 6]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 7]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 8]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 9]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 10] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[16, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 0]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 1]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 2]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 3]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 4]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 5]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 6]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 7]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 8]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 9]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 10] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNWRoad[17, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNWRoad[17, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

#endregion

#region SiFieldNEWRoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldNEWRoad' -CurrentOperation 'Creating SiFieldNEWRoad' -Id 3 -PercentComplete -1
$Script:SiFieldNEWRoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNEWRoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[16, 1]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 2]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 3]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 4]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 5]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 6]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 7]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 8]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 9]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 10] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 44] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNEWRoad[17, 0]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 1]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 2]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 3]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 4]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 5]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 6]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 7]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 8]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 9]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 10] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 44] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNEWRoad[17, 45] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')

#endregion

#region SiFieldSRoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldSRoad' -CurrentOperation 'Creating SiFieldSRoad' -Id 3 -PercentComplete -1
$Script:SiFieldSRoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSRoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 14]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 14]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[16, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSRoad[17, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSRoad[17, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

#endregion

#region SiFieldSERoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldSERoad' -CurrentOperation 'Creating SiFieldSERoad' -Id 3 -PercentComplete -1
$Script:SiFieldSERoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSERoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 14]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 14]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[16, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSERoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 44] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSERoad[17, 45] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')

#endregion

#region SiFieldSEWRoad

Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Status 'Creating SiFieldSEWRoad' -CurrentOperation 'Creating SiFieldSEWRoad' -Id 3 -PercentComplete -1
$Script:SiFieldSEWRoad[0, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[0, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[1, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[2, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[3, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 0]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 1]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 2]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 3]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 4]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 5]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 6]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 7]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 8]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 9]   = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 10]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 11]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 12]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 13]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 14]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 15]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 16]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 17]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 18]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 19]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 20]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 21]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 22]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 23]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 24]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 25]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 26]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 27]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 28]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 29]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 30]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 31]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 32]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 33]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 34]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 35]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 36]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 37]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 38]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 39]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 40]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 41]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 42]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 43]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 44]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[4, 45]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldSEWRoad[5, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 14]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[5, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 13]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 14]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 15]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[6, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 12]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[7, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[7, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[7, 16]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[7, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[8, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[8, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[8, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[8, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[8, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[8, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 0]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 1]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 2]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 3]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 4]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 5]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 6]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 7]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 8]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 9]   = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 10]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 11]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 12]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[9, 13]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[9, 14]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[9, 15]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[9, 16]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[9, 17]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 18]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 19]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 20]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 21]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 22]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 23]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 24]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 25]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 26]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 27]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 28]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 29]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 30]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 31]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 32]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 33]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 34]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 35]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 36]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 37]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 38]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 39]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 40]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 41]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 42]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 43]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 44]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[9, 45]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[10, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[10, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[11, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[11, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[12, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[12, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[13, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[13, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[14, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[14, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 2]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 3]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 4]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 5]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 6]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 7]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 8]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 9]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[15, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[15, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[16, 0]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[16, 1]  = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[16, 2]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 3]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 4]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 5]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 6]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 7]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 8]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 9]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 10] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[16, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[16, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldSEWRoad[17, 0]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 1]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 2]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 3]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 4]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 5]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 6]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 7]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 8]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 9]  = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 10] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 11] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 17] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 18] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 19] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 20] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 21] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 22] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 23] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 24] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 25] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 26] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 27] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 28] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 29] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 30] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 31] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 32] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 33] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 34] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 35] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 36] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 37] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 38] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 39] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 40] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 41] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 42] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 43] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 44] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldSEWRoad[17, 45] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')

#endregion

#endregion

#region Map Definitions

#region Sample Map Definition

$Script:SampleMap.Tiles[0, 0] = [MapTile]::new($Script:SiFieldNERoad, 
    @(
        [MapTileObject]::new('Apple', 'apple', $true, 'A big, fat, juicy apple. Worm not included.', {Write-GfmMessageWindowMessage -Message 'I found an apple!' -Teletype}),
        [MTOTree]::new(),
        [MTOLadder]::new(),
        [MTORope]::new(),
        [MTOStairs]::new(),
        [MTOPole]::new()
    ),
    @($true, $false, $true, $false)
)
$Script:SampleMap.Tiles[0, 1] = [MapTile]::new($Script:SiFieldNWRoad, @(), @($true, $false, $false, $true))
$Script:SampleMap.Tiles[1, 0] = [MapTile]::new($Script:SiFieldSEWRoad, @(), @($false, $true, $true, $false))
$Script:SampleMap.Tiles[1, 1] = [MapTile]::new($Script:SiFieldNRoad, @(), @($false, $true, $false, $true))

#endregion

#endregion

#region Closing Progress Bars

Write-Progress -Activity 'Creating Music Note Table' -Id 1 -Completed
Write-Progress -Activity 'Creating Song Note Tables' -Id 2 -Completed
Write-Progress -Activity 'Creating Scene Image Buffer Cells' -Id 3 -Completed

#endregion
