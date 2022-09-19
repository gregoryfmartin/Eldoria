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
$noteTable[[Notes]::C, 0] =  0
$noteTable[[Notes]::C, 1] =  0
$noteTable[[Notes]::C, 2] =  [Int]65.41D
$noteTable[[Notes]::C, 3] =  [Int]130.81D
$noteTable[[Notes]::C, 4] =  [Int]261.63D


