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
[System.ConsoleColor]$Script:PlayerStatNameDrawColor          = 'Blue'
[System.ConsoleColor]$Script:PlayerStatNumberDrawColorSafe    = 'Green'
[System.ConsoleColor]$Script:PlayerStatNumberDrawColorCaution = 'Yellow'
[System.ConsoleColor]$Script:PlayerStatNumberDrawColorDanger  = 'Red'
[System.ConsoleColor]$Script:PlayerStatGoldDrawColor          = 'DarkYellow'

#endregion

#region Scene Image Variables

[Int]$Script:SceneImageWidth       = 46
[Int]$Script:SceneImageHeight      = 18
[Int]$Script:SceneImageDrawOriginX = 32
[Int]$Script:SceneImageDrawOriginY = 1

#endregion

#region Status Window Variables

[System.ConsoleColor]$Script:UiStatusWindowBorderColor      = 'White'
[String]             $Script:UiStatusWindowBorderHoirzontal = '@--~---~---~---~---@'
[String]             $Script:UiStatusWindowBorderVertical   = '|'
[Int]                $Script:UiStatusWindowDrawX            = 0
[Int]                $Script:UiStatusWindowDrawY            = 0
[Int]                $Script:UiStatusWindowWidth            = 19
[Int]                $Script:UiStatusWindowHeight           = 14
[Int]                $Script:UiStatusWindowPlayerNameDrawX  = 2
[Int]                $Script:UiStatusWindowPlayerNameDrawY  = 2
[Int]                $Script:UiStatusWindowPlayerHpDrawX    = 2
[Int]                $Script:UiStatusWindowPlayerHpDrawY    = 4
[Int]                $Script:UiStatusWindowPlayerMpDrawX    = 2
[Int]                $Script:UiStatusWindowPlayerMpDrawY    = 6
[Int]                $Script:UiStatusWindowPlayerGoldDrawX  = 2
[Int]                $Script:UiStatusWindowPlayerGoldDrawY  = 9
[Int]                $Script:UiStatusWindowPlayerAilDrawX   = 2
[Int]                $Script:UiStatusWindowPlayerAilDrawY   = 11

#endregion

#region Scene Window Variables

[System.ConsoleColor]$Script:UiSceneWindowBorderColor      = 'White'
[String]             $Script:UiSceneWindowBorderHorizontal = '@-<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>--<>-@'
[String]             $Script:UiSceneWindowBorderVertical   = '|'
[Int]                $Script:UiSceneWindowDrawX            = 30
[Int]                $Script:UiSceneWindowDrawY            = 0
[Int]                $Script:UiSceneWindowWidth            = 50
[Int]                $Script:UiSceneWindowHeight           = 19
[Int]                $Script:UiSceneWindowSceneDrawX       = 32
[Int]                $Script:UiSceneWindowSceneDrawY       = 1

#endregion

#region Message Window Variables

[System.ConsoleColor]$Script:UiMessageWindowBorderColor      = 'White'
[String]             $Script:UiMessageWindowBorderHorizontal = '-'
[String]             $Script:UiMessageWindowBorderVertical   = '|'
[Int]                $Script:UiMessageWindowDrawX            = 0
[Int]                $Script:UiMessageWindowDrawY            = 20
[Int]                $Script:UiMessageWindowWidth            = 80
[Int]                $Script:UiMessageWindowHeight           = 4

#endregion

#region General Globals

$Script:Rui = $(Get-Host).UI.RawUI

[Int]   $Script:DefaultCursorX = 0
[Int]   $Script:DefaultCursorY = 0
[String]$Script:OsCheckLinux   = 'OsLinux'
[String]$Script:OsCheckMac     = 'OsMac'
[String]$Script:OsCheckWindows = 'OsWindows'
[String]$Script:OsCheckUnknown = 'OsUnknown'

#endregion

#region Scene Image Definitions

$Script:SceneImageSample = New-Object 'System.Management.Automation.Host.BufferCell[,]' $Script:SceneImageHeight, $Script:SceneImageWidth

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

# Define the Note Table. Rests are not included in the Note Table.
$Script:NumOctaves = 9
$Script:NumNotes   = 12
$Script:NoteTable  = New-Object 'Int[,]' $Script:NumNotes, $Script:NumOctaves

# Define the Note Table
# This site has a table where the values are derived from: https://mixbutton.com/mixing-articles/music-note-to-frequency-chart/#:~:text=Music%20Note%20To%20Frequency%20Chart%20%20%20,%20155.56%20Hz%20%208%20more%20rows%20
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

# Declare some songs. Songs are defined as arrangements of Notes polled from the Note Table.
[System.Tuple[]]$Script:DragonWarriorThemeSong = @()
[System.Tuple[]]$Script:BattleTheme            = @()
[System.Tuple[]]$Script:DuckTalesTheme         = @()
[System.Tuple[]]$Script:GhostbustersTheme      = @()

# Define the Songs

#region Dragon Warrior Theme Jingle (Incomplete)

$Script:DragonWarriorThemeSong[0]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[1]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[2]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[3]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[4]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[5]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[6]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::F, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[7]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[8]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[9]  = [System.Tuple]::Create(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[10] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[11] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[12] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[13] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[14] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[15] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[16] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::F, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[17] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[18] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[19] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[20] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[21] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[22] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[23] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[24] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[25] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[26] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[27] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::F, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[28] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DragonWarriorThemeSong[29] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)

#endregion

#region Battle Theme Jingle

$Script:BattleTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::C, [Octaves]::Eighth]), [NoteDuration]::Sixteenth)
$Script:BattleTheme[1] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)
$Script:BattleTheme[2] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)
$Script:BattleTheme[3] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::E, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)
$Script:BattleTheme[4] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)
$Script:BattleTheme[5] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)
$Script:BattleTheme[6] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth]), [NoteDuration]::Whole)

#endregion

#region Duck Tales Theme Jingle

$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::E, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Quarter)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Half)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Quarter)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Half)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::E, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)
$Script:DuckTalesTheme[0] = [System.Tuple]::Create(($Script:NoteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)

#endregion

#endregion

#endregion

#region Text Formatting Functions

Function Format-GfmPlayerHitPoints {
    [CmdletBinding()]
    Param ()
    
    Process {
        Return "H $($Script:PlayerCurrentHitPoints) `n`t/ $($Script:PlayerMaximumHitPoints)"
    }
}

Function Format-GfmPlayerMagicPoints {
    [CmdletBinding()]
    Param ()
    
    Process {
        Return "M $($Script:PlayerCurrentMagicPoints) `n`t/ $($Script:PlayerMaximumMagicPoints)"
    }
}

Function Format-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Return "$($Script:PlayerCurrentGold)G"
    }
}

#endregion

#region Scene Image Functions

Function New-GfmSceneImageSample {
    [CmdletBinding()]
    Param ()

    Process {
        For($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
            For($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                [Int]$randBgColor = Get-Random -Minimum 1 -Maximum 15
                $Script:SceneImageSample[$h, $w] = [System.Management.Automation.Host.BufferCell]::new(' ', 0, $randBgColor, 'Complete')
            }
        }
    }
}

Function Write-GfmSceneImage {
    [CmdletBinding()]
    Param (
        [Switch]$NonWindowsMethod,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Host.BufferCell[,]]$CellArray
    )

    Process {
        If ($NonWindowsMethod) {
            For($h = 0; $h -LT $Script:SceneImageHeight; $h++) {
                For($w = 0; $w -LT $Script:SceneImageWidth; $w++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:SceneImageDrawOriginX + $w, $Script:SceneImageDrawOriginY + $h)
                    Write-Host ' ' -BackgroundColor $CellArray[$h, $w].BackgroundColor -NoNewline
                }
            }
        } Else {
            # This is what I've been trying to accomplish on the Mac and Linux and it doesn't work on those two platforms.
            # This actually appears to be faster too
            $Script:Rui.SetBufferContents($([System.Management.Automation.Host.Coordinates]::new($Script:SceneImageDrawOriginX, $Script:SceneImageDrawOriginY)), $CellArray)
        }
    }
}

#endregion

#region Utility Functions

Function Test-GfmOs {
    [CmdletBinding()]
    Param ()

    Process {
        Get-PSDrive -Name Variable | Out-Null
        If($?) {
            Get-ChildItem Variable:/IsLinux | Out-Null
            If($?) {
                If($(Get-ChildItem Variable:/IsLinux).Value -EQ $true) {
                    Return $Script:OsCheckLinux
                }
            }

            Get-ChildItem Variable:/IsMacOS | Out-Null
            If($?) {
                If($(Get-ChildItem Variable:/IsMacOS).Value -EQ $true) {
                    Return $Script:OsCheckMac
                }
            }

            Get-ChildItem Variable:/IsWindows | Out-Null
            If($?) {
                If($(Get-ChildItem Variable:/IsWindows).Value -EQ $true) {
                    Return $Script:OsCheckWindows
                }
            }
        }

        Return $Script:OsCheckUnknown
    }
}

Function Write-GfmHostNnl {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$BackgroundColor = 'Black'
    )

    Process {
        Write-Host $Message -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
}

Function Set-GfmDefaultCursorPosition {
    [CmdletBinding()]
    Param ()

    Process {
        $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:DefaultCursorX, $Script:DefaultCursorY)
    }
}

Function Write-GfmPositionalString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Host.Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor
    )

    Process {
        $Script:Rui.CursorPosition = $Coordinates
        Write-GfmHostNnl -Message $Message -ForegroundColor $ForegroundColor
    }
}

Function Write-GfmTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Message,
        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]$ForegroundColor,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )

    Process {
        [Char[]]$msgCharArray = $Message.ToCharArray()
        [Int]   $typeCounter  = 0
        [Int]   $msgcaProbe   = 0

        While ($msgcaProbe -LE ($msgCharArray.Count - 1)) {
            $typeCounter++
            If($typeCounter -GE $TypeSpeed) {
                $typeCounter = 0
                Write-GfmHostNnl -Message $msgCharArray[$msgcaProbe] -ForegroundColor $ForegroundColor
                $msgcaProbe++
            }
        }
    }
}

Function Write-GfmPositionalTtyString {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Host.Coordinates]$Coordinates,
        [Parameter(Mandatory = $true)]
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

Function Write-GfmPlayerName {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerNameDrawX, $Script:UiStatusWindowPlayerNameDrawY)) `
            -Message $Script:PlayerName `
            -ForegroundColor $Script:PlayerStatNameDrawColor
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmPlayerHp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($Script:PlayerHitPointsState) {
            # The fix for properly strong-typing the scoping is found here: https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
            ([PlayerHpState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorSafe
            }

            ([PlayerHpState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorCaution
            }

            ([PlayerHpState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerHpDrawX, $Script:UiStatusWindowPlayerHpDrawY)) `
                    -Message $(Format-GfmPlayerHitPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmPlayerMp {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($Script:PlayerMagicPointsState) {
            # The fix for properly strong-typing the scoping is found here: https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.2#enum
            ([PlayerMpState]::Normal) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorSafe
            }

            ([PlayerMpState]::Caution) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorCaution
            }

            ([PlayerMpState]::Danger) {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }

            Default {
                Write-GfmPositionalString `
                    -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerMpDrawX, $Script:UiStatusWindowPlayerMpDrawY)) `
                    -Message $(Format-GfmPlayerMagicPoints) `
                    -ForegroundColor $Script:PlayerStatNumberDrawColorDanger
            }
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

Function Write-GfmPlayerGold {
    [CmdletBinding()]
    Param ()

    Process {
        Write-GfmPositionalString `
            -Coordinates $([System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowPlayerGoldDrawX, $Script:UiStatusWindowPlayerGoldDrawY)) `
            -Message $(Format-GfmPlayerGold) `
            -ForegroundColor $Script:PlayerStatGoldDrawColor
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

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

Function Update-GfmPlayerName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$NewName,
        [Switch]$WriteToConsole
    )

    Process {
        $Script:PlayerName = $NewName
        If($WriteToConsole) {
            Write-GfmPlayerName
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

Function Update-GfmPlayerHp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$HpDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentHitPoints + $HpDelta
        $t = [System.Math]::Clamp($t, 0, $Script:PlayerMaximumHitPoints)
        $Script:PlayerCurrentHitPoints = $t
        Test-GfmPlayerHpForState
        If($WriteToConsole) {
            Write-GfmPlayerHp
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

Function Update-GfmPlayerMp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$MpDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentMagicPoints + $MpDelta
        $t = [System.Math]::Clamp($t, 0, $Script:PlayerMaximumMagicPoints)
        $Script:PlayerCurrentMagicPoints = $t
        Test-GfmPlayerMpForState
        If($WriteToConsole) {
            Write-GfmPlayerMp
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

Function Update-GfmPlayerGold {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Int]$GDelta,
        [Switch]$WriteToConsole
    )

    Process {
        $t = $Script:PlayerCurrentGold + $GDelta
        $t = [System.Math]::Clamp($t, 0, [Int]::MaxValue)
        $Script:PlayerCurrentGold = $t
        If($WriteToConsole) {
            Write-GfmPlayerGold
        }
    }

    End {
        If($WriteToConsole) {
            Set-GfmDefaultCursorPosition
        }
    }
}

#endregion

#region Window Drawing Functions

Function Write-GfmStatusWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            {($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac)} {
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                For($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                # For the time being, I'm simply going to copypaste the code from the previous case
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $Script:UiStatusWindowDrawY + $Script:UiStatusWindowHeight)
                Write-GfmHostNnl -Message $Script:UiStatusWindowBorderHoirzontal -ForegroundColor $Script:UiStatusWindowBorderColor
                For($i = 1; $i -LT $Script:UiStatusWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiStatusWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiStatusWindowDrawX + $Script:UiStatusWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiStatusWindowBorderVertical -ForegroundColor $Script:UiStatusWindowBorderColor
                }
            }

            Default {}
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
            {($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac)} {
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY + $Script:UiSceneWindowWidth)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                For($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth), $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $Script:UiSceneWindowDrawY)
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, ($Script:UiSceneWindowDrawY + $Script:UiSceneWindowHeight))
                Write-GfmHostNnl -Message $Script:UiSceneWindowBorderHorizontal -ForegroundColor $Script:UiSceneWindowBorderColor
                For($i = 1; $i -LT $Script:UiSceneWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiSceneWindowDrawX, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiSceneWindowDrawX + $Script:UiSceneWindowWidth) - 1, $i)
                    Write-GfmHostNnl -Message $Script:UiSceneWindowBorderVertical -ForegroundColor $Script:UiSceneWindowBorderColor
                }
            }

            Default {}
        }
    }

    End {}
}

Function Write-GfmMessageWindow {
    [CmdletBinding()]
    Param ()

    Process {
        Switch ($(Test-GfmOs)) {
            {($_ -EQ $Script:OsCheckLinux) -OR ($_ -EQ $Script:OsCheckMac)} {
                For($i = 0; $i -LT $Script:UiMessageWindowWidth; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For($i = 0; $i -LE $Script:UiMessageWindowHeight; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth), ($Script:UiMessageWindowDrawY + $i))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            $Script:OsCheckWindows {
                For($i = 0; $i -LE $Script:UiMessageWindowWidth - 1; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, $Script:UiMessageWindowDrawY)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($i, ($Script:UiMessageWindowDrawY + $Script:UiMessageWindowHeight))
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderHorizontal -ForegroundColor $Script:UiMessageWindowBorderColor
                }
                For($i = 0; $i -LT $Script:UiMessageWindowHeight - 1; $i++) {
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Script:UiMessageWindowDrawX, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                    $Script:Rui.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($Script:UiMessageWindowDrawX + $Script:UiMessageWindowWidth) - 1, ($Script:UiMessageWindowDrawY + $i) + 1)
                    Write-GfmHostNnl -Message $Script:UiMessageWindowBorderVertical -ForegroundColor $Script:UiMessageWindowBorderColor
                }
            }

            Default {}
        }
    }

    End {
        Set-GfmDefaultCursorPosition
    }
}

#endregion

#region Testing Functions

Function Test-GfmPlayScreen {
    [CmdletBinding()]
    Param ()

    Process {
        New-GfmSceneImageSample
        Write-GfmSceneImage -CellArray $Script:SceneImageSample

        $Script:PlayerName               = 'Steve'
        $Script:PlayerCurrentHitPoints   = 100
        $Script:PlayerMaximumHitPoints   = 100
        $Script:PlayerCurrentMagicPoints = 25
        $Script:PlayerMaximumMagicPoints = 25
        $Script:PlayerCurrentGold        = 5000

        Write-GfmPlayerName
        Write-GfmPlayerHp
        Write-GfmPlayerMp
        Write-GfmPlayerGold
    }
}

#endregion
