using namespace System

# After some testing, it would seem that frequencies below 250Hz are inaudible. This means that many songs will need to be shifted up at least two octaves
# since most fourth or lower octaves express notes in frequencies less than 250Hz.
#
# Something else that's becoming apparent through testing is that firing a large sequence of sixteenth notes (defined as 100 ms) at the speaker can cause some hiccups
# even if attempting to delay the command to the console by an additional ms. It's almost as if the notes get clobbered together at some point causing an audible mess.

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
}

$numOctaves = 9
$numNotes = 12
$noteTable = New-Object 'Int[,]' $numNotes, $numOctaves

# Create the frequency table for each note in each octave
# This site has a table where the values are derived from: https://mixbutton.com/mixing-articles/music-note-to-frequency-chart/#:~:text=Music%20Note%20To%20Frequency%20Chart%20%20%20,%20155.56%20Hz%20%208%20more%20rows%20
$noteTable[[Notes]::C, 0]             = 0
$noteTable[[Notes]::C, 1]             = 0
$noteTable[[Notes]::C, 2]             = [Int]65.41D
$noteTable[[Notes]::C, 3]             = [Int]130.81D
$noteTable[[Notes]::C, 4]             = [Int]261.63D
$noteTable[[Notes]::C, 5]             = [Int]523.25D
$noteTable[[Notes]::C, 6]             = [Int]1046.5D
$noteTable[[Notes]::C, 7]             = [Int]2093.0D
$noteTable[[Notes]::C, 8]             = [Int]4186.01D
$noteTable[[Notes]::CSharpOrDFlat, 0] = 0
$noteTable[[Notes]::CSharpOrDFlat, 1] = 0
$noteTable[[Notes]::CSharpOrDFlat, 2] = [Int]69.3D
$noteTable[[Notes]::CSharpOrDFlat, 3] = [Int]138.59D
$noteTable[[Notes]::CSharpOrDFlat, 4] = [Int]277.18D
$noteTable[[Notes]::CSharpOrDFlat, 5] = [Int]554.37D
$noteTable[[Notes]::CSharpOrDFlat, 6] = [Int]1108.73D
$noteTable[[Notes]::CSharpOrDFlat, 7] = [Int]2217.46D
$noteTable[[Notes]::CSharpOrDFlat, 8] = [Int]4434.92D
$noteTable[[Notes]::D, 0]             = 0
$noteTable[[Notes]::D, 1]             = [Int]36.71D
$noteTable[[Notes]::D, 2]             = [Int]73.42D
$noteTable[[Notes]::D, 3]             = [Int]146.83D
$noteTable[[Notes]::D, 4]             = [Int]293.66D
$noteTable[[Notes]::D, 5]             = [Int]587.33D
$noteTable[[Notes]::D, 6]             = [Int]1174.66D
$noteTable[[Notes]::D, 7]             = [Int]2349.32D
$noteTable[[Notes]::D, 8]             = [Int]4698.63D
$noteTable[[Notes]::DSharpOrEFlat, 0] = 0
$noteTable[[Notes]::DSharpOrEFlat, 1] = [Int]38.89D
$noteTable[[Notes]::DSharpOrEFlat, 2] = [Int]77.78D
$noteTable[[Notes]::DSharpOrEFlat, 3] = [Int]155.56D
$noteTable[[Notes]::DSharpOrEFlat, 4] = [Int]311.13D
$noteTable[[Notes]::DSharpOrEFlat, 5] = [Int]622.25D
$noteTable[[Notes]::DSharpOrEFlat, 6] = [Int]1244.51D
$noteTable[[Notes]::DSharpOrEFlat, 7] = [Int]2489.02D
$noteTable[[Notes]::DSharpOrEFlat, 8] = [Int]4978.03D
$noteTable[[Notes]::E, 0]             = 0
$noteTable[[Notes]::E, 1]             = [Int]41.2D
$noteTable[[Notes]::E, 2]             = [Int]82.41D
$noteTable[[Notes]::E, 3]             = [Int]164.81D
$noteTable[[Notes]::E, 4]             = [Int]329.63D
$noteTable[[Notes]::E, 5]             = [Int]659.25D
$noteTable[[Notes]::E, 6]             = [Int]1318.51D
$noteTable[[Notes]::E, 7]             = [Int]2637.02D
$noteTable[[Notes]::E, 8]             = [Int]5274.04D
$noteTable[[Notes]::F, 0]             = 0
$noteTable[[Notes]::F, 1]             = [Int]43.65D
$noteTable[[Notes]::F, 2]             = [Int]87.31D
$noteTable[[Notes]::F, 3]             = [Int]174.61D
$noteTable[[Notes]::F, 4]             = [Int]349.23D
$noteTable[[Notes]::F, 5]             = [Int]689.46D
$noteTable[[Notes]::F, 6]             = [Int]1396.91D
$noteTable[[Notes]::F, 7]             = [Int]2793.83D
$noteTable[[Notes]::F, 8]             = [Int]5587.65D
$noteTable[[Notes]::FSharpOrGFlat, 0] = 0
$noteTable[[Notes]::FSharpOrGFlat, 1] = [Int]46.25D
$noteTable[[Notes]::FSharpOrGFlat, 2] = [Int]92.5D
$noteTable[[Notes]::FSharpOrGFlat, 3] = [Int]185D
$noteTable[[Notes]::FSharpOrGFlat, 4] = [Int]369.99D
$noteTable[[Notes]::FSharpOrGFlat, 5] = [Int]739.99D
$noteTable[[Notes]::FSharpOrGFlat, 6] = [Int]1479.98D
$noteTable[[Notes]::FSharpOrGFlat, 7] = [Int]2959.96D
$noteTable[[Notes]::FSharpOrGFlat, 8] = [Int]5919.91D
$noteTable[[Notes]::G, 0]             = 0
$noteTable[[Notes]::G, 1]             = [Int]49D
$noteTable[[Notes]::G, 2]             = [Int]98D
$noteTable[[Notes]::G, 3]             = [Int]196D
$noteTable[[Notes]::G, 4]             = [Int]392D
$noteTable[[Notes]::G, 5]             = [Int]783.99D
$noteTable[[Notes]::G, 6]             = [Int]1567.98D
$noteTable[[Notes]::G, 7]             = [Int]3135.96D
$noteTable[[Notes]::G, 8]             = [Int]6271.93D
$noteTable[[Notes]::GSharpOrAFlat, 0] = 0
$noteTable[[Notes]::GSharpOrAFlat, 1] = [Int]51.91D
$noteTable[[Notes]::GSharpOrAFlat, 2] = [Int]103.83D
$noteTable[[Notes]::GSharpOrAFlat, 3] = [Int]207.65D
$noteTable[[Notes]::GSharpOrAFlat, 4] = [Int]415.3D
$noteTable[[Notes]::GSharpOrAFlat, 5] = [Int]830.61D
$noteTable[[Notes]::GSharpOrAFlat, 6] = [Int]1661.22D
$noteTable[[Notes]::GSharpOrAFlat, 7] = [Int]3322.44D
$noteTable[[Notes]::GSharpOrAFlat, 8] = [Int]6644.88D
$noteTable[[Notes]::A, 0]             = 0
$noteTable[[Notes]::A, 1]             = [Int]55D
$noteTable[[Notes]::A, 2]             = [Int]110D
$noteTable[[Notes]::A, 3]             = [Int]220D
$noteTable[[Notes]::A, 4]             = [Int]440D
$noteTable[[Notes]::A, 5]             = [Int]880D
$noteTable[[Notes]::A, 6]             = [Int]1760D
$noteTable[[Notes]::A, 7]             = [Int]3520D
$noteTable[[Notes]::A, 8]             = [Int]7040D
$noteTable[[Notes]::ASharpOrBFlat, 0] = 0
$noteTable[[Notes]::ASharpOrBFlat, 1] = [Int]58.27D
$noteTable[[Notes]::ASharpOrBFlat, 2] = [Int]116.54D
$noteTable[[Notes]::ASharpOrBFlat, 3] = [Int]233.08D
$noteTable[[Notes]::ASharpOrBFlat, 4] = [Int]466.16D
$noteTable[[Notes]::ASharpOrBFlat, 5] = [Int]932.33D
$noteTable[[Notes]::ASharpOrBFlat, 6] = [Int]1864.66D
$noteTable[[Notes]::ASharpOrBFlat, 7] = [Int]3729.31D
$noteTable[[Notes]::ASharpOrBFlat, 8] = [Int]7458.62D
$noteTable[[Notes]::B, 0]             = 0
$noteTable[[Notes]::B, 1]             = [Int]61.74D
$noteTable[[Notes]::B, 2]             = [Int]123.47D
$noteTable[[Notes]::B, 3]             = [Int]246.94D
$noteTable[[Notes]::B, 4]             = [Int]493.88D
$noteTable[[Notes]::B, 5]             = [Int]987.77D
$noteTable[[Notes]::B, 6]             = [Int]1975.53D
$noteTable[[Notes]::B, 7]             = [Int]3951.07D
$noteTable[[Notes]::B, 8]             = [Int]7902.13D

# For ($nn = 0; $nn -LT $numNotes; $nn++) {
#     For ($no = 0; $no -LT $numOctaves; $no++) {
#         # For some reason, I can't use the array notation within the Beep function call
#         # So the note variable here has to be leveraged
#         $note = $noteTable[$nn, $no]
#         If ($note -GE 37 -AND $note -LE 32767) {
#             [System.Console]::Beep($note, 500)
#         }
#     }
# }

# $note = $noteTable[[Notes]::ASharpOrBFlat, 4] # note = 233
#[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 3]), 200)
# [Console]::Beep(260, 200)

[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::F, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::F, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::FSharpOrGFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::FSharpOrGFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::GSharpOrAFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::GSharpOrAFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::DSharpOrEFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::DSharpOrEFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::F, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::F, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::FSharpOrGFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::FSharpOrGFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::GSharpOrAFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::GSharpOrAFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::DSharpOrEFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::DSharpOrEFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::F, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::F, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::FSharpOrGFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::FSharpOrGFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::GSharpOrAFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::GSharpOrAFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::DSharpOrEFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::DSharpOrEFlat, 5]), 200); Start-Sleep -Milliseconds 1
[Console]::Beep($($noteTable[[Notes]::ASharpOrBFlat, 4]), 200); Start-Sleep -Milliseconds 1

