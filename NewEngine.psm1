using namespace System
using namespace System.Collections
using namespace System.Management.Automation.Host

#region Script Notes
#endregion

#region Global Variables

#region Game State Definitions

[Flags()] Enum GlobalGameState {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    Cleanup
}

[Flags()] Enum GamePlayState {
    Normal
    Battle
    Shop
    Inn
}

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

[String]       $Script:PlayerName = ''
[Int]          $Script:PlayerCurrentHitPoints = 0
[Int]          $Script:PlayerMaximumHitPoints = 0
[Int]          $Script:PlayerCurrentMagicPoints = 0
[Int]          $Script:PlayerMaximumMagicPoints = 0
[Int]          $Script:PlayerCurrentGold = 0
[Single]       $Script:PlayerStatNumThresholdCaution = 0.6D
[Single]       $Script:PlayerStatNumThresholdDanger = 0.2D
[PlayerHpState]$Script:PlayerHitPointsState = [PlayerHpState]::Normal
[PlayerMpState]$Script:PlayerMagicPointsState = [PlayerMpState]::Normal
[ConsoleColor] $Script:PlayerStatNameDrawColor = 'Blue'
[ConsoleColor] $Script:PlayerStatNumberDrawColorSafe = 'Green'
[ConsoleColor] $Script:PlayerStatNumberDrawColorCaution = 'Yellow'
[ConsoleColor] $Script:PlayerStatNumberDrawColorDanger = 'Red'
[ConsoleColor] $Script:PlayerStatGoldDrawColor = 'DarkYellow'

#endregion

#region Scene Image Variables

[Int]$Script:SceneImageWidth = 46
[Int]$Script:SceneImageHeight = 18
[Int]$Script:SceneImageDrawOriginX = 32
[Int]$Script:SceneImageDrawOriginY = 1

#endregion

#region Status Window Variables

[ConsoleColor]$Script:UiStatusWindowBorderColor = 'White'
[String]      $Script:UiStatusWindowBorderHoirzontal = '@--~---~---~---~---@'
[String]      $Script:UiStatusWindowBorderVertical = '|'
[Int]         $Script:UiStatusWindowDrawX = 0
[Int]         $Script:UiStatusWindowDrawY = 0
[Int]         $Script:UiStatusWindowWidth = 19
[Int]         $Script:UiStatusWindowHeight = 11
[Int]         $Script:UiStatusWindowPlayerNameDrawX = 2
[Int]         $Script:UiStatusWindowPlayerNameDrawY = 2
[Int]         $Script:UiStatusWindowPlayerHpDrawX = 2
[Int]         $Script:UiStatusWindowPlayerHpDrawY = 4
[Int]         $Script:UiStatusWindowPlayerMpDrawX = 2
[Int]         $Script:UiStatusWindowPlayerMpDrawY = 6
[Int]         $Script:UiStatusWindowPlayerGoldDrawX = 2
[Int]         $Script:UiStatusWindowPlayerGoldDrawY = 9
[Int]         $Script:UiStatusWindowPlayerAilDrawX = 2
[Int]         $Script:UiStatusWindowPlayerAilDrawY = 11

#endregion

#region Command Window Variables

Class CmdWindowHistoryMessage {
    [String]$Message
    [ConsoleColor]$ForegroundColor

    CmdWindowHistoryMessage (
        [String]$msg,
        [ConsoleColor]$fgc
    ) {
        $this.Message = $msg
        $this.ForegroundColor = $fgc
    }
}

[ConsoleColor]    $Script:UiCommandWindowBorderColor = 'White'
[ConsoleColor]    $Script:UiCommandWindowCmdHistValid = 'Green'
[ConsoleColor]    $Script:UiCommandWindowCmdHistErr = 'Red'
[ConsoleColor]    $Script:UiCommandWindowCmdBlankColor = 'Black'
[String]                 $Script:UiCommandWindowBorderHorizontal = '@--~---~---~---~---@'
[String]                 $Script:UiCommandWindowBorderVertical = '|'
[String]                 $Script:UiCommandWindowCmdDiv = '``````````````````'
[String]                 $Script:UiCommandWindowCmdActual = ''
[String]                 $Script:UiCommandWindowCmdBlank = '                  '
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistA = [CmdWindowHistoryMessage]::new('', 'White')
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistB = [CmdWindowHistoryMessage]::new('', 'White')
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistC = [CmdWindowHistoryMessage]::new('', 'White')
[CmdWindowHistoryMessage]$Script:UiCommandWindowHistD = [CmdWindowHistoryMessage]::new('', 'White')
[Int]                    $Script:UiCommandWindowDrawX = 0
[Int]                    $Script:UiCommandWindowDrawY = 12
[Int]                    $Script:UiCommandWindowWidth = 19
[Int]                    $Script:UiCommandWindowHeight = 7
[Int]                    $Script:UiCommandWindowCmdDivDrawX = $Script:UiCommandWindowDrawX + 1
[Int]                    $Script:UiCommandWindowCmdDivDrawY = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 2
[Int]                    $Script:UiCommandWindowHistDrawX = $Script:UiCommandWindowDrawX + 1
[Int]                    $Script:UiCommandWindowHistDDrawY = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 3
[Int]                    $Script:UiCommandWindowHistCDrawY = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 4
[Int]                    $Script:UiCommandWindowHistBDrawY = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 5
[Int]                    $Script:UiCommandWindowHistADrawY = ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight) - 6

#endregion

#region Scene Window Variables

[ConsoleColor]$Script:UiSceneWindowBorderColor = 'White'
[String]             $Script:UiSceneWindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]             $Script:UiSceneWindowBorderVertical = '|'
[Int]                $Script:UiSceneWindowDrawX = 30
[Int]                $Script:UiSceneWindowDrawY = 0
[Int]                $Script:UiSceneWindowWidth = 50
[Int]                $Script:UiSceneWindowHeight = 19
[Int]                $Script:UiSceneWindowSceneDrawX = 32
[Int]                $Script:UiSceneWindowSceneDrawY = 1

#endregion

#region Message Window Variables

Class MsgWindowHistoryMessage {
    [String]$Message
    [ConsoleColor]$ForegroundColor

    MsgWindowHistoryMessage (
        [String]$msg,
        [ConsoleColor]$fgc
    ) {
        $this.Message = $msg
        $this.ForegroundColor = $fgc
    }
}

[ConsoleColor]    $Script:UiMessageWindowBorderColor = 'White'
[String]                 $Script:UiMessageWindowBorderHorizontal = '-'
[String]                 $Script:UiMessageWindowBorderVertical = '|'
[Int]                    $Script:UiMessageWindowDrawX = 0
[Int]                    $Script:UiMessageWindowDrawY = 20
[Int]                    $Script:UiMessageWindowWidth = 80
[Int]                    $Script:UiMessageWindowHeight = 4
[MsgWindowHistoryMessage]$Script:UiMessageWindowMessageA = [MsgWindowHistoryMessage]::new('', 'Black')
[MsgWindowHistoryMessage]$Script:UiMessageWindowMessageB = [MsgWindowHistoryMessage]::new('', 'Black')
[MsgWindowHistoryMessage]$Script:UiMessageWindowMessageC = [MsgWindowHistoryMessage]::new('', 'Black')
# [String]                 $Script:UiMessageWindowMessageBottom = ''
# [String]                 $Script:UiMessageWindowMessageMiddle = ''
# [String]                 $Script:UiMessageWindowMessageTop = ''
[Int]                    $Script:UiMessageWindowMessageBottomDrawY = 23
[Int]                    $Script:UiMessageWindowMessageMiddleDrawY = 22
[Int]                    $Script:UiMessageWindowMessageTopDrawY = 21
[String]                 $Script:UiMessageWindowMessageBlank = '                                                                             '

#endregion

#region General Globals

$Script:Rui = $(Get-Host).UI.RawUI

[Int]   $Script:DefaultCursorX = $Script:UiCommandWindowDrawX + 1
[Int]   $Script:DefaultCursorY = $Script:UiCommandWindowCmdDivDrawY + 1
[String]$Script:OsCheckLinux = 'OsLinux'
[String]$Script:OsCheckMac = 'OsMac'
[String]$Script:OsCheckWindows = 'OsWindows'
[String]$Script:OsCheckUnknown = 'OsUnknown'

#endregion

#region Scene Image Definitions

$Script:SceneImageSample = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldNRoad     = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth
$Script:SiFieldNERoad    = New-Object 'BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth

#endregion

#region Text Rendering Variables

[Flags()] Enum TtySpeed {
    SuperSlow = 1000000
    Slow = 750000
    Normal = 100000
    Moderate = 75000
    Quick = 65000
    Fast = 50000
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
    Whole = 1600
    Half = 800
    Quarter = 400
    Eighth = 200
    Sixteenth = 100
}

Class Note {
    [Int]$ActualNote
    [NoteDuration]$ActualDuration

    Note(
        [Int]$an,
        [NoteDuration]$ad
    ) {
        $this.ActualNote = $an
        $this.ActualDuration = $ad
    }
}

# Define the Note Table. Rests are not included in the Note Table.
$Script:NumOctaves = 9
$Script:NumNotes = 12
$Script:NoteTable = New-Object 'Int[,]' $Script:NumNotes, $Script:NumOctaves

# Define the Note Table
# This site has a table where the values are derived from: https://mixbutton.com/mixing-articles/music-note-to-frequency-chart/#:~:text=Music%20Note%20To%20Frequency%20Chart%20%20%20,%20155.56%20Hz%20%208%20more%20rows%20
$Script:NoteTable[[Notes]::C, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::C, [Octaves]::Second] = 0
$Script:NoteTable[[Notes]::C, [Octaves]::Third] = [Int]65.41D
$Script:NoteTable[[Notes]::C, [Octaves]::Fourth] = [Int]130.81D
$Script:NoteTable[[Notes]::C, [Octaves]::Fifth] = [Int]261.63D
$Script:NoteTable[[Notes]::C, [Octaves]::Sixth] = [Int]523.25D
$Script:NoteTable[[Notes]::C, [Octaves]::Seventh] = [Int]1046.5D
$Script:NoteTable[[Notes]::C, [Octaves]::Eighth] = [Int]2093.0D
$Script:NoteTable[[Notes]::C, [Octaves]::Ninth] = [Int]4186.01D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Second] = 0
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Third] = [Int]69.3D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Fourth] = [Int]138.59D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Fifth] = [Int]277.18D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Sixth] = [Int]554.37D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh] = [Int]1108.73D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Eighth] = [Int]2217.46D
$Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Ninth] = [Int]4434.92D
$Script:NoteTable[[Notes]::D, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::D, [Octaves]::Second] = [Int]36.71D
$Script:NoteTable[[Notes]::D, [Octaves]::Third] = [Int]73.42D
$Script:NoteTable[[Notes]::D, [Octaves]::Fourth] = [Int]146.83D
$Script:NoteTable[[Notes]::D, [Octaves]::Fifth] = [Int]293.66D
$Script:NoteTable[[Notes]::D, [Octaves]::Sixth] = [Int]587.33D
$Script:NoteTable[[Notes]::D, [Octaves]::Seventh] = [Int]1174.66D
$Script:NoteTable[[Notes]::D, [Octaves]::Eighth] = [Int]2349.32D
$Script:NoteTable[[Notes]::D, [Octaves]::Ninth] = [Int]4698.63D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Second] = [Int]38.89D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Third] = [Int]77.78D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Fourth] = [Int]155.56D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Fifth] = [Int]311.13D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Sixth] = [Int]622.25D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh] = [Int]1244.51D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Eighth] = [Int]2489.02D
$Script:NoteTable[[Notes]::DSharpOrEFlat, [Octaves]::Ninth] = [Int]4978.03D
$Script:NoteTable[[Notes]::E, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::E, [Octaves]::Second] = [Int]41.2D
$Script:NoteTable[[Notes]::E, [Octaves]::Third] = [Int]82.41D
$Script:NoteTable[[Notes]::E, [Octaves]::Fourth] = [Int]164.81D
$Script:NoteTable[[Notes]::E, [Octaves]::Fifth] = [Int]329.63D
$Script:NoteTable[[Notes]::E, [Octaves]::Sixth] = [Int]659.25D
$Script:NoteTable[[Notes]::E, [Octaves]::Seventh] = [Int]1318.51D
$Script:NoteTable[[Notes]::E, [Octaves]::Eighth] = [Int]2637.02D
$Script:NoteTable[[Notes]::E, [Octaves]::Ninth] = [Int]5274.04D
$Script:NoteTable[[Notes]::F, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::F, [Octaves]::Second] = [Int]43.65D
$Script:NoteTable[[Notes]::F, [Octaves]::Third] = [Int]87.31D
$Script:NoteTable[[Notes]::F, [Octaves]::Fourth] = [Int]174.61D
$Script:NoteTable[[Notes]::F, [Octaves]::Fifth] = [Int]349.23D
$Script:NoteTable[[Notes]::F, [Octaves]::Sixth] = [Int]689.46D
$Script:NoteTable[[Notes]::F, [Octaves]::Seventh] = [Int]1396.91D
$Script:NoteTable[[Notes]::F, [Octaves]::Eighth] = [Int]2793.83D
$Script:NoteTable[[Notes]::F, [Octaves]::Ninth] = [Int]5587.65D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Second] = [Int]46.25D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Third] = [Int]92.5D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Fourth] = [Int]185D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Fifth] = [Int]369.99D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth] = [Int]739.99D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh] = [Int]1479.98D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Eighth] = [Int]2959.96D
$Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Ninth] = [Int]5919.91D
$Script:NoteTable[[Notes]::G, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::G, [Octaves]::Second] = [Int]49D
$Script:NoteTable[[Notes]::G, [Octaves]::Third] = [Int]98D
$Script:NoteTable[[Notes]::G, [Octaves]::Fourth] = [Int]196D
$Script:NoteTable[[Notes]::G, [Octaves]::Fifth] = [Int]392D
$Script:NoteTable[[Notes]::G, [Octaves]::Sixth] = [Int]783.99D
$Script:NoteTable[[Notes]::G, [Octaves]::Seventh] = [Int]1567.98D
$Script:NoteTable[[Notes]::G, [Octaves]::Eighth] = [Int]3135.96D
$Script:NoteTable[[Notes]::G, [Octaves]::Ninth] = [Int]6271.93D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Second] = [Int]51.91D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Third] = [Int]103.83D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Fourth] = [Int]207.65D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Fifth] = [Int]415.3D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth] = [Int]830.61D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Seventh] = [Int]1661.22D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Eighth] = [Int]3322.44D
$Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Ninth] = [Int]6644.88D
$Script:NoteTable[[Notes]::A, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::A, [Octaves]::Second] = [Int]55D
$Script:NoteTable[[Notes]::A, [Octaves]::Third] = [Int]110D
$Script:NoteTable[[Notes]::A, [Octaves]::Fourth] = [Int]220D
$Script:NoteTable[[Notes]::A, [Octaves]::Fifth] = [Int]440D
$Script:NoteTable[[Notes]::A, [Octaves]::Sixth] = [Int]880D
$Script:NoteTable[[Notes]::A, [Octaves]::Seventh] = [Int]1760D
$Script:NoteTable[[Notes]::A, [Octaves]::Eighth] = [Int]3520D
$Script:NoteTable[[Notes]::A, [Octaves]::Ninth] = [Int]7040D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Second] = [Int]58.27D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Third] = [Int]116.54D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Fourth] = [Int]233.08D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Fifth] = [Int]466.16D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth] = [Int]932.33D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh] = [Int]1864.66D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Eighth] = [Int]3729.31D
$Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Ninth] = [Int]7458.62D
$Script:NoteTable[[Notes]::B, [Octaves]::First] = 0
$Script:NoteTable[[Notes]::B, [Octaves]::Second] = [Int]61.74D
$Script:NoteTable[[Notes]::B, [Octaves]::Third] = [Int]123.47D
$Script:NoteTable[[Notes]::B, [Octaves]::Fourth] = [Int]246.94D
$Script:NoteTable[[Notes]::B, [Octaves]::Fifth] = [Int]493.88D
$Script:NoteTable[[Notes]::B, [Octaves]::Sixth] = [Int]987.77D
$Script:NoteTable[[Notes]::B, [Octaves]::Seventh] = [Int]1975.53D
$Script:NoteTable[[Notes]::B, [Octaves]::Eighth] = [Int]3951.07D
$Script:NoteTable[[Notes]::B, [Octaves]::Ninth] = [Int]7902.13D

# Declare some songs. Songs are defined as arrangements of Notes polled from the Note Table.
[Collections.ArrayList]$Script:DragonWarriorTheme = New-Object 'ArrayList'
[Collections.ArrayList]$Script:BattleTheme = New-Object 'ArrayList'
[Collections.ArrayList]$Script:DuckTalesTheme = New-Object 'ArrayList'
[Collections.ArrayList]$Script:GhostbustersTheme = New-Object 'ArrayList'

# Define the Songs

#region Dragon Warrior Theme Jingle (Incomplete)

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

$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::C, [Octaves]::Eighth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::E, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$Script:BattleTheme.Add([Note]::new(($Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth]), [NoteDuration]::Whole)) | Out-Null

#endregion

#region Duck Tales Theme Jingle

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

#endregion

#endregion

#region Command Definition Variables

[String[]]$Script:CommandTableFirstTier = @(
    'move',
    'take'
)
[String[]]$Script:CommandTableSecondTier = @()

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
                [Int]$randBgColor = Get-Random -Minimum 1 -Maximum 15
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
        Return [BufferCell]::new(' ', 0, $Bgc, 'Complete')
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

.PARAMETER NonWindowsMethod
A switch that determines if the function is going to use a cross-platform supported algorithm for drawing Scene Images or not.

.PARAMETER CellArray
The two-dimensional array of BufferCell objects that represent the Scene Image that are going to be written to the console buffer. The drawing origin coordinates are predefined.
#>
Function Write-GfmSceneImage {
    [CmdletBinding()]
    Param (
        [Switch]$NonWindowsMethod,
        [Parameter(Mandatory = $true)]
        [BufferCell[, ]]$CellArray
    )

    Process {
        If ($NonWindowsMethod) {
            For ($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
                For ($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:SceneImageDrawOriginX + $w, $Script:SceneImageDrawOriginY + $h)
                    Write-Host ' ' -BackgroundColor $CellArray[$h, $w].BackgroundColor -NoNewline
                }
            }
        } Else {
            # This is what I've been trying to accomplish on the Mac and Linux and it doesn't work on those two platforms.
            # This actually appears to be faster too
            $Script:Rui.SetBufferContents($([Coordinates]::new($Script:SceneImageDrawOriginX, $Script:SceneImageDrawOriginY)), $CellArray)
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
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]::Normal.
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
        [Int]   $typeCounter = 0
        [Int]   $msgcaProbe = 0

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
The speed at which to type the characters of the Message to the console at. By default, this is [TtySpeed]::Normal.
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
            # The fix for properly strong-typing the scoping is found here:https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
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
            # The fix for properly strong-typing the scoping is found here:https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
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
        $t = $Script:PlayerCurrentHitPoints + $HpDelta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMaximumHitPoints)
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
        $t = $Script:PlayerCurrentMagicPoints + $MpDelta
        $t = [Math]::Clamp($t, 0, $Script:PlayerMaximumMagicPoints)
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
        $t = $Script:PlayerCurrentGold + $GDelta
        $t = [Math]::Clamp($t, 0, [Int]::MaxValue)
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
        $Script:UiMessageWindowMessageC.Message = $Message; $Script:UiMessageWindowMessageC.ForegroundColor = $ForegroundColor

        # First, move from middle to top
        # $Script:UiMessageWindowMessageTop = $Script:UiMessageWindowMessageMiddle

        # Next, move from bottom to middle
        # $Script:UiMessageWindowMessageMiddle = $Script:UiMessageWindowMessageBottom

        # Assign the bottom message the user-specified message
        # $Script:UiMessageWindowMessageBottom = $Message

        # Print the messages back to their appropraite positions in the buffer, optionally using the teletype method
        If ($Teletype) {
            # Write-GfmPositionalTtyString `
            #     -Coordinates $([System.Management.Automation.Host.Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
            #     -Message $($Script:UiMessageWindowMessageBlank) `
            #     -ForegroundColor $ForegroundColor `
            #     -TypeSpeed LineClear
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalTtyString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageBottomDrawY)) `
                -Message $($Script:UiMessageWindowMessageC.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageC.ForegroundColor)
            
            # Write-GfmPositionalTtyString `
            #     -Coordinates $([System.Management.Automation.Host.Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
            #     -Message $($Script:UiMessageWindowMessageBlank) `
            #     -ForegroundColor $ForegroundColor `
            #     -TypeSpeed LineClear
            Write-GfmPositionalString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
                -Message $($Script:UiMessageWindowMessageBlank) `
                -ForegroundColor $ForegroundColor
            Write-GfmPositionalTtyString `
                -Coordinates $([Coordinates]::new(2, $Script:UiMessageWindowMessageMiddleDrawY)) `
                -Message $($Script:UiMessageWindowMessageB.Message) `
                -ForegroundColor $($Script:UiMessageWindowMessageB.ForegroundColor)

            # Write-GfmPositionalTtyString `
            #     -Coordinates $([System.Management.Automation.Host.Coordinates]::new(2, $Script:UiMessageWindowMessageTopDrawY)) `
            #     -Message $($Script:UiMessageWindowMessageBlank) `
            #     -ForegroundColor $ForegroundColor `
            #     -TypeSpeed LineClear
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
        First of all, a complete list of virtual key codes in hex can be found here: https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
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
                    $Script:UiCommandWindowCmdActual = $Script:UiCommandWindowCmdActual.Remove($Script:UiCommandWindowCmdActual.Length - 1, 1)
                } Else {
                    Write-GfmPositionalString `
                        -Coordinates $([Coordinates]::new($Script:Rui.CursorPosition.X + 1, $Script:DefaultCursorY)) `
                        -Message ' ' `
                        -ForegroundColor 'Black'
                    Set-GfmDefaultCursorPosition

                    # Remove the character from the cmdactual string
                    # Since I'm not going to go through the trouble of capturing what character was in the cell that just got
                    # clobbered, I'm going to just drop the last index from the cmdactual string.
                    $Script:UiCommandWindowCmdActual = $Script:UiCommandWindowCmdActual.Remove($Script:UiCommandWindowCmdActual.Length - 1, 1)
                }
            } Else {
                # Append the Character property value to the cmdactual string
                $Script:UiCommandWindowCmdActual += $keyCap.Character
            }

            # Call ReadKey again
            $keyCap = $Script:Rui.ReadKey('IncludeKeyDown')
        }


        # # TODO: I need to restrict ReadLine from printing characters beyond the width of the command window
        # $Script:UiCommandWindowCmdActual = $(Get-Host).UI.ReadLine()

        # # Poll the cursor position
        # # This doesn't work
        # $cpos = $Script:Rui.CursorPosition
        # If ($cpos.X -GE 19) {
        #     $Script:Rui.CursorPosition.X = 19
        # }

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

        # TODO: When a valid command is entered, nothing is done

        [Boolean]$foundCmdFirstTierMatch = $false

        # Perform sanity checks on the cmdactual string
        If ([String]::IsNullOrEmpty($Script:UiCommandWindowCmdActual)) {
            # Don't do anything, but we need to reset the cursor position to the default position since the ReadLine function
            # will inject a CRLF character into the buffer at the cell the cursor is at.
            Set-GfmDefaultCursorPosition
            Return
        } Else {
            # The command string isn't empty, so go ahead and start the parsing algorithm
            # The first step is to see what the command string starts with. This will be accomplished with the String::StartsWith
            # function. We'll simply loop through the valid command first tier entries to see if it matches anything. If there are
            # no matches, the command history gets the addition in red, and a message is printed to the Message Window.
            Foreach ($cmdFirstTier in $Script:CommandTableFirstTier) {
                If ($Script:UiCommandWindowCmdActual -LIKE "$cmdFirstTier*") {
                    $foundCmdFirstTierMatch = $true
                }
            }
            If (-NOT($foundCmdFirstTierMatch)) {
                # We couldn't find a match in the first tier, so the command string is likely entirely invalid.
                Update-GfmCmdHistory

                Write-GfmMessageWindowMessage `
                    -Message "INVALID COMMAND ENTERED: $Script:UiCommandWindowCmdActual" `
                    -ForegroundColor $Script:UiCommandWindowCmdHistErr `
                    -Teletype

                # Clear the cmdactual string
                $Script:UiCommandWindowCmdActual = ''

                # Reset the command window
                Set-GfmDefaultCursorPosition
                Return
            } Else {
                # The first phrase of the command found a match
                # Although it's possible at this point that the command phrase is incomplete,
                # for the purposes of testing, we're going to assume that it is and start building 
                # the functional mechanics of it in terms of rendering.
                Update-GfmCmdHistory -CmdActualValid

                Write-GfmMessageWindowMessage `
                    -Message "VALID COMMAND ENTERED: $Script:UiCommandWindowCmdActual" `
                    -ForegroundColor $Script:UiCommandWindowCmdHistValid `
                    -Teletype

                # Clear the cmdactual string
                $Script:UiCommandWindowCmdActual = ''

                # Reset the command window
                Set-GfmDefaultCursorPosition
                Return
            }
        }
    }
}

Function Update-GfmCmdHistory {
    [CmdletBinding()]
    Param (
        [Switch]$CmdActualValid
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
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                For ($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                # For the time being, I'm simply going to copypaste the code from the previous case
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                For ($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
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
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY + $Script:UiSceneWindowWidth)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                For ($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, ($Script:UiSceneWindowDrawY + $Script:UiSceneWindowHeight))
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                For ($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth) - 1, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
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
                For ($i = 0; $i -LT $Script:UiMessageWindowWidth; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For ($i = 0; $i -LE $Script:UiMessageWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth), ($Script:UiMessageWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                For ($i = 0; $i -LE $Script:UiMessageWindowWidth - 1; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For ($i = 0; $i -LT $Script:UiMessageWindowHeight - 1; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth) - 1, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
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
            }

            $Script:OsCheckWindows {
                # Draw the horizontal borders
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, $Script:UiCommandWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiCommandWindowBorderHorizontal -ForegroundColor $Script:UiCommandWindowBorderColor

                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, ($Script:UiCommandWindowDrawY + $Script:UiCommandWindowHeight))
                Write-GfmHostNnl -Message $Script:UiCommandWindowBorderHorizontal -ForegroundColor $Script:UiCommandWindowBorderColor

                # Draw the command input div
                $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowCmdDivDrawX, $Script:UiCommandWindowCmdDivDrawY)
                Write-GfmHostNnl -Message $Script:UiCommandWindowCmdDiv -ForegroundColor $Script:UiCommandWindowBorderColor

                # Draw the vertical borders
                For ($i = 1; $i -LT $Script:UiCommandWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [Coordinates]::new($Script:UiCommandWindowDrawX, ($Script:UiCommandWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiCommandWindowBorderVertical -ForegroundColor $Script:UiCommandWindowBorderColor
                    $Script:Rui.CursorPosition = [Coordinates]::new(($Script:UiCommandWindowDrawX + $Script:UiCommandWindowWidth), ($Script:UiCommandWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiCommandWindowBorderVertical -ForegroundColor $Script:UiCommandWindowBorderColor
                }
            }

            Default {
            }
        }
    }
}

#endregion

#region Testing Functions

Function Test-GfmPlayScreen {
    [CmdletBinding()]
    Param ()

    Process {
        #New-GfmSceneImageSample
        Write-GfmSceneImage -CellArray $Script:SiFieldNERoad

        $Script:PlayerName = 'Steve'
        $Script:PlayerCurrentHitPoints = 100
        $Script:PlayerMaximumHitPoints = 100
        $Script:PlayerCurrentMagicPoints = 25
        $Script:PlayerMaximumMagicPoints = 25
        $Script:PlayerCurrentGold = 5000

        Write-GfmPlayerName
        Write-GfmPlayerHp
        Write-GfmPlayerMp
        Write-GfmPlayerGold
    }
}

#endregion

#region Scene Image Definitions

#region SiFieldNRoad

$Script:SiFieldNRoad[0, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[0, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNRoad[1, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[1, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNRoad[2, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[2, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNRoad[3, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[3, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNRoad[4, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNRoad[4, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNRoad[5, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 12] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 13] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[5, 15] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 16] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[5, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNRoad[6, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 12] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 13] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[6, 15] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 16] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[6, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNRoad[7, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 12] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[7, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[7, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[7, 16] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[7, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNRoad[8, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[8, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[8, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNRoad[9, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNRoad[9, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[9, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNRoad[10, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[10, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[11, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[11, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[12, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[12, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[13, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[13, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[14, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[14, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[15, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[15, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[16, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[16, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNRoad[17, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNRoad[17, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[0, 0]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 1]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 2]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 3]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 4]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 5]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 6]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 7]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 8]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 9]  = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[0, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNERoad[1, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[1, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNERoad[2, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[2, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNERoad[3, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[3, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNERoad[4, 0] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 1] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 2] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 3] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 4] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 5] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 6] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 7] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 8] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 9] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 10] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 11] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 12] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 13] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 14] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 15] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 16] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 17] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 18] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 19] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 20] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 21] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 22] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 23] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 24] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 25] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 26] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 27] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 28] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 29] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 30] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 31] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 32] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 33] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 34] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 35] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 36] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 37] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 38] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 39] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 40] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 41] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 42] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 43] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 44] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')
$Script:SiFieldNERoad[4, 45] = [BufferCell]::new(' ', 0, 'Blue', 'Complete')

$Script:SiFieldNERoad[5, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 12] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 13] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[5, 15] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 16] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[5, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNERoad[6, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 12] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 13] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[6, 15] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 16] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[6, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNERoad[7, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 12] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[7, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[7, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[7, 16] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[7, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNERoad[8, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[8, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[8, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNERoad[9, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 10] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 11] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 12] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 13] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 14] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 15] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 16] = [BufferCell]::new(' ', 0, 'DarkYellow', 'Complete')
$Script:SiFieldNERoad[9, 17] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 18] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 19] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 20] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 21] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 22] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 23] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 24] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 25] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 26] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 27] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 28] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 29] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 30] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 31] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 32] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 33] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 34] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 35] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 36] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 37] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 38] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 39] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 40] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 41] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 42] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 43] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 44] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[9, 45] = [BufferCell]::new(' ', 0, 'Green', 'Complete')

$Script:SiFieldNERoad[10, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[10, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[11, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[11, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[12, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[12, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[13, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[13, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[14, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[14, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[15, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[15, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

$Script:SiFieldNERoad[16, 0] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 1] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 2] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 3] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 4] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 5] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 6] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 7] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 8] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
$Script:SiFieldNERoad[16, 9] = [BufferCell]::new(' ', 0, 'Green', 'Complete')
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

#endregion
