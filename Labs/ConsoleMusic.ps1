using namespace System

# After some testing, it would seem that frequencies below 250Hz are inaudible. This means that many songs will need to be shifted up at least two octaves
# since most fourth or lower octaves express notes in frequencies less than 250Hz.
#
# Something else that's becoming apparent through testing is that firing a large sequence of sixteenth notes (defined as 100 ms) at the speaker can cause some hiccups
# even if attempting to delay the command to the console by an additional ms. It's almost as if the notes get clobbered together at some point causing an audible mess.
# After some testing on this, it would seem that there can be race condition occurring where notes issued to the speaker with the Beep function aren't queued, and aren't
# aware if a note is currently playing. Currently the method I've employed for controlling this is to send a rest of equal duration along with the note to the speaker.
# The result is a highly monotone piece in terms of texture, but the integrity of the sample is maintained.

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

# An aggregate ADT that combines a frequency (note) with a duration. The frequency can be found by performing a lookup in the Note Table.
Class Note {
    [Int]$ActualNote
    [NoteDuration]$ActualDuration

    Note(
        [Int]$an,
        [NoteDuration]$nd
    ) {
        $this.ActualNote     = $an
        $this.ActualDuration = $nd
    }
}

# Define the Note Table. Rests are not included in the Note Table.
$numOctaves = 9
$numNotes   = 12
$noteTable  = New-Object 'Int[,]' $numNotes, $numOctaves

# Declare some songs. Songs are defined as arrangements of Notes polled from the Note Table.
[Collections.ArrayList]$dragonWarriorTheme = New-Object 'Collections.ArrayList'
[Collections.ArrayList]$battleTheme        = New-Object 'Collections.ArrayList'
[Collections.ArrayList]$duckTalesTheme     = New-Object 'Collections.ArrayList'
[Collections.ArrayList]$ghostbustersTheme  = New-Object 'Collections.ArrayList'

#region Note Table Definition
# Create the frequency table for each note in each octave
# This site has a table where the values are derived from: https://mixbutton.com/mixing-articles/music-note-to-frequency-chart/#:~:text=Music%20Note%20To%20Frequency%20Chart%20%20%20,%20155.56%20Hz%20%208%20more%20rows%20
$noteTable[[Notes]::C, [Octaves]::First]               = 0
$noteTable[[Notes]::C, [Octaves]::Second]              = 0
$noteTable[[Notes]::C, [Octaves]::Third]               = [Int]65.41D
$noteTable[[Notes]::C, [Octaves]::Fourth]              = [Int]130.81D
$noteTable[[Notes]::C, [Octaves]::Fifth]               = [Int]261.63D
$noteTable[[Notes]::C, [Octaves]::Sixth]               = [Int]523.25D
$noteTable[[Notes]::C, [Octaves]::Seventh]             = [Int]1046.5D
$noteTable[[Notes]::C, [Octaves]::Eighth]              = [Int]2093.0D
$noteTable[[Notes]::C, [Octaves]::Ninth]               = [Int]4186.01D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::First]   = 0
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Second]  = 0
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Third]   = [Int]69.3D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Fourth]  = [Int]138.59D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Fifth]   = [Int]277.18D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Sixth]   = [Int]554.37D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh] = [Int]1108.73D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Eighth]  = [Int]2217.46D
$noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Ninth]   = [Int]4434.92D
$noteTable[[Notes]::D, [Octaves]::First]               = 0
$noteTable[[Notes]::D, [Octaves]::Second]              = [Int]36.71D
$noteTable[[Notes]::D, [Octaves]::Third]               = [Int]73.42D
$noteTable[[Notes]::D, [Octaves]::Fourth]              = [Int]146.83D
$noteTable[[Notes]::D, [Octaves]::Fifth]               = [Int]293.66D
$noteTable[[Notes]::D, [Octaves]::Sixth]               = [Int]587.33D
$noteTable[[Notes]::D, [Octaves]::Seventh]             = [Int]1174.66D
$noteTable[[Notes]::D, [Octaves]::Eighth]              = [Int]2349.32D
$noteTable[[Notes]::D, [Octaves]::Ninth]               = [Int]4698.63D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::First]   = 0
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Second]  = [Int]38.89D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Third]   = [Int]77.78D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Fourth]  = [Int]155.56D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Fifth]   = [Int]311.13D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Sixth]   = [Int]622.25D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh] = [Int]1244.51D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Eighth]  = [Int]2489.02D
$noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Ninth]   = [Int]4978.03D
$noteTable[[Notes]::E, [Octaves]::First]               = 0
$noteTable[[Notes]::E, [Octaves]::Second]              = [Int]41.2D
$noteTable[[Notes]::E, [Octaves]::Third]               = [Int]82.41D
$noteTable[[Notes]::E, [Octaves]::Fourth]              = [Int]164.81D
$noteTable[[Notes]::E, [Octaves]::Fifth]               = [Int]329.63D
$noteTable[[Notes]::E, [Octaves]::Sixth]               = [Int]659.25D
$noteTable[[Notes]::E, [Octaves]::Seventh]             = [Int]1318.51D
$noteTable[[Notes]::E, [Octaves]::Eighth]              = [Int]2637.02D
$noteTable[[Notes]::E, [Octaves]::Ninth]               = [Int]5274.04D
$noteTable[[Notes]::F, [Octaves]::First]               = 0
$noteTable[[Notes]::F, [Octaves]::Second]              = [Int]43.65D
$noteTable[[Notes]::F, [Octaves]::Third]               = [Int]87.31D
$noteTable[[Notes]::F, [Octaves]::Fourth]              = [Int]174.61D
$noteTable[[Notes]::F, [Octaves]::Fifth]               = [Int]349.23D
$noteTable[[Notes]::F, [Octaves]::Sixth]               = [Int]689.46D
$noteTable[[Notes]::F, [Octaves]::Seventh]             = [Int]1396.91D
$noteTable[[Notes]::F, [Octaves]::Eighth]              = [Int]2793.83D
$noteTable[[Notes]::F, [Octaves]::Ninth]               = [Int]5587.65D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::First]   = 0
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Second]  = [Int]46.25D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Third]   = [Int]92.5D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Fourth]  = [Int]185D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Fifth]   = [Int]369.99D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth]   = [Int]739.99D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh] = [Int]1479.98D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Eighth]  = [Int]2959.96D
$noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Ninth]   = [Int]5919.91D
$noteTable[[Notes]::G, [Octaves]::First]               = 0
$noteTable[[Notes]::G, [Octaves]::Second]              = [Int]49D
$noteTable[[Notes]::G, [Octaves]::Third]               = [Int]98D
$noteTable[[Notes]::G, [Octaves]::Fourth]              = [Int]196D
$noteTable[[Notes]::G, [Octaves]::Fifth]               = [Int]392D
$noteTable[[Notes]::G, [Octaves]::Sixth]               = [Int]783.99D
$noteTable[[Notes]::G, [Octaves]::Seventh]             = [Int]1567.98D
$noteTable[[Notes]::G, [Octaves]::Eighth]              = [Int]3135.96D
$noteTable[[Notes]::G, [Octaves]::Ninth]               = [Int]6271.93D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::First]   = 0
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Second]  = [Int]51.91D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Third]   = [Int]103.83D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Fourth]  = [Int]207.65D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Fifth]   = [Int]415.3D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]   = [Int]830.61D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Seventh] = [Int]1661.22D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Eighth]  = [Int]3322.44D
$noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Ninth]   = [Int]6644.88D
$noteTable[[Notes]::A, [Octaves]::First]               = 0
$noteTable[[Notes]::A, [Octaves]::Second]              = [Int]55D
$noteTable[[Notes]::A, [Octaves]::Third]               = [Int]110D
$noteTable[[Notes]::A, [Octaves]::Fourth]              = [Int]220D
$noteTable[[Notes]::A, [Octaves]::Fifth]               = [Int]440D
$noteTable[[Notes]::A, [Octaves]::Sixth]               = [Int]880D
$noteTable[[Notes]::A, [Octaves]::Seventh]             = [Int]1760D
$noteTable[[Notes]::A, [Octaves]::Eighth]              = [Int]3520D
$noteTable[[Notes]::A, [Octaves]::Ninth]               = [Int]7040D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::First]   = 0
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Second]  = [Int]58.27D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Third]   = [Int]116.54D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Fourth]  = [Int]233.08D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Fifth]   = [Int]466.16D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]   = [Int]932.33D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh] = [Int]1864.66D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Eighth]  = [Int]3729.31D
$noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Ninth]   = [Int]7458.62D
$noteTable[[Notes]::B, [Octaves]::First]               = 0
$noteTable[[Notes]::B, [Octaves]::Second]              = [Int]61.74D
$noteTable[[Notes]::B, [Octaves]::Third]               = [Int]123.47D
$noteTable[[Notes]::B, [Octaves]::Fourth]              = [Int]246.94D
$noteTable[[Notes]::B, [Octaves]::Fifth]               = [Int]493.88D
$noteTable[[Notes]::B, [Octaves]::Sixth]               = [Int]987.77D
$noteTable[[Notes]::B, [Octaves]::Seventh]             = [Int]1975.53D
$noteTable[[Notes]::B, [Octaves]::Eighth]              = [Int]3951.07D
$noteTable[[Notes]::B, [Octaves]::Ninth]               = [Int]7902.13D
#endregion

#region Dragon Warrior Theme Jingle (Incomplete)
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::F, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::F, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::F, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$dragonWarriorTheme.Add([Note]::new(($noteTable[[Notes]::G, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
#endregion

#region Dragon Warrior 2 Battle Jingle Intro
$battleTheme.Add([Note]::new(($noteTable[[Notes]::C, [Octaves]::Eighth]), [NoteDuration]::Sixteenth)) | Out-Null
$battleTheme.Add([Note]::new(($noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$battleTheme.Add([Note]::new(($noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$battleTheme.Add([Note]::new(($noteTable[[Notes]::E, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$battleTheme.Add([Note]::new(($noteTable[[Notes]::C, [Octaves]::Seventh]), [NoteDuration]::Sixteenth)) | Out-Null
$battleTheme.Add([Note]::new(($noteTable[[Notes]::ASharpOrBFlat, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$battleTheme.Add([Note]::new(($noteTable[[Notes]::FSharpOrGFlat, [Octaves]::Sixth]), [NoteDuration]::Whole)) | Out-Null
#endregion

#region Duck Tales Theme (Portion)
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::E, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Half)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Half)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::E, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::D, [Octaves]::Seventh]), [NoteDuration]::Quarter)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$duckTalesTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
#endregion

#region Ghostbusters Theme Jingle
#region Ghostbuster Song Phrase 1
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
#endregion
#region Ghostbusters Song Phrase 2
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Fifth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::GSharpOrAFlat, [Octaves]::Sixth]), [NoteDuration]::Quarter)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Quarter)) | Out-Null
#endregion
#region Ghostbusters Song Verse 1
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Half)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Half)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::DSharpOrEFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new([Notes]::Rest, [NoteDuration]::Half)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::A, [Octaves]::Sixth]), [NoteDuration]::Sixteenth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::CSharpOrDFlat, [Octaves]::Seventh]), [NoteDuration]::Eighth)) | Out-Null
$ghostbustersTheme.Add([Note]::new(($noteTable[[Notes]::B, [Octaves]::Sixth]), [NoteDuration]::Eighth)) | Out-Null
#endregion
#endregion

# Test play some of the songs
# To change the song to test, change the variable in the conditional
foreach($n in $ghostbustersTheme) {
    [Console]::Beep($n.ActualNote, $n.ActualDuration)
}
