#region ENUMERATION DEFINITIONS

Enum GameState {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    NavigationScreen
    InventoryScreen
    BattleScreen
    LoseScreen
    Cleanup
    None
}

Enum BattleManagerState {
    HealthCheck
    TurnIncrement
    PhaseOrdering
    PhaseAExecution
    PhaseBExecution
    Calculation
    BattleWon
    BattleLost
}

Enum BattleActionResultType {
    Success
    SuccessWithCritical
    SuccessWithAffinityBonus
    SuccessWithCritAndAffinityBonus
    FailedAttackMissed
    FailedAttackFailed
    FailedElementalMatch
    FailedNoUsesRemaining
    FailedNotEnoughMp
}

Enum StatNumberState {
    Normal
    Caution
    Danger
}

Enum ItemRemovalStatus {
    Success
    FailGeneral
    FailKeyItem
}

Enum BattleActionType {
    Physical
    ElementalFire
    ElementalWater
    ElementalEarth
    ElementalWind
    ElementalLight
    ElementalDark
    ElementalIce
    MagicPoison
    MagicConfuse
    MagicSleep
    MagicAging
    MagicHealing
    MagicStatAugment
    None
}

Enum StatId {
    HitPoints
    MagicPoints
    Attack
    Defense
    MagicAttack
    MagicDefense
    Speed
    Luck
    Accuracy
}

Enum ActionSlot {
    A
    B
    C
    D
}

Enum VtCsiEidMode {
    EndOfScreen
    BeginningOfScreen
    ClearWithScrollback
    ClearWithoutScrollback
}

Enum VtCsiEilMode {
    EndOfLine
    BeginningOfLine
    WholeLine
}

#endregion




#region UNICODE CHARACTER DEFINITIONS

[String]$Script:SmileyNormal             = "`u{1F600}"
[String]$Script:SimleyRofl               = "`u{1F606}"
[String]$Script:SmileySweat              = "`u{1F605}"
[String]$Script:SmileyMelting            = "`u{1FAE0}"
[String]$Script:AffectionNormal          = "`u{1F970}"
[String]$Script:AffectionHeartEyes       = "`u{1F60D}"
[String]$Script:AffectionBlowingKiss     = "`u{1F618}"
[String]$Script:TongueNormal             = "`u{1F61B}"
[String]$Script:TongueZany               = "`u{1F92A}"
[String]$Script:HandOverMouthSmile       = "`u{1F92D}"
[String]$Script:HandOverMouth            = "`u{1FAE2}"
[String]$Script:HandPeeking              = "`u{1FAE3}"
[String]$Script:HandShush                = "`u{1F92B}"
[String]$Script:HandThinking             = "`u{1F914}"
[String]$Script:HandSalute               = "`u{1FAE1}"
[String]$Script:SkepticRaisedEyebrow     = "`u{1F928}"
[String]$Script:SkepticNeutral           = "`u{1F610}"
[String]$Script:SkepticDottedFace        = "`u{1FAE5}"
[String]$Script:SkepticSmirk             = "`u{1F60F}"
[String]$Script:SkepticUnamused          = "`u{1F612}"
[String]$Script:SkepticRollingEyes       = "`u{1F644}"
[String]$Script:SkepticExhale            = "`u{1F62E}"
[String]$Script:SleepyRelieved           = "`u{1F60C}"
[String]$Script:SleepyPensive            = "`u{1F614}"
[String]$Script:SleepySleepy             = "`u{1F62A}"
[String]$Script:SleepyDrooling           = "`u{1F924}"
[String]$Script:SleepyAsleep             = "`u{1F634}"
[String]$Script:UnwellMedicalMask        = "`u{1F637}"
[String]$Script:UnwellThermometer        = "`u{1F912}"
[String]$Script:UnwellHeadBandage        = "`u{1F915}"
[String]$Script:UnwellNausea             = "`u{1F922}"
[String]$Script:UnwellVomiting           = "`u{1F92E}"
[String]$Script:UnwellSneezing           = "`u{1F927}"
[String]$Script:UnwellFever              = "`u{1F975}"
[String]$Script:UnwellChill              = "`u{1F976}"
[String]$Script:UnwellWoozy              = "`u{1F974}"
[String]$Script:UnwellDead               = "`u{1F635}"
[String]$Script:UnwellHeadExplode        = "`u{1F92F}"
[String]$Script:HatCowboy                = "`u{1F920}"
[String]$Script:HatParty                 = "`u{1F973}"
[String]$Script:HatDisgusied             = "`u{1F978}"
[String]$Script:GlassesSunglasses        = "`u{1F60E}"
[String]$Script:GlassesNerd              = "`u{1F913}"
[String]$Script:GlassesMonocle           = "`u{1F9D0}"
[String]$Script:ConcernedConfused        = "`u{1F615}"
[String]$Script:ConcernedDiagMouth       = "`u{1FAE4}"
[String]$Script:ConcernedWorried         = "`u{1F61F}"
[String]$Script:ConcernedSlightFrown     = "`u{1F641}"
[String]$Script:ConcernedOpenMouth       = "`u{1F62E}"
[String]$Script:ConcernedHushed          = "`u{1F62F}"
[String]$Script:ConcernedAstonished      = "`u{1F632}"
[String]$Script:ConcernedFlushed         = "`u{1F633}"
[String]$Script:ConcernedPleading        = "`u{1F97A}"
[String]$Script:ConcernedHoldingTears    = "`u{1F979}"
[String]$Script:ConcernedFearful         = "`u{1F628}"
[String]$Script:ConcernedAnxious         = "`u{1F630}"
[String]$Script:ConcernedCrying          = "`u{1F622}"
[String]$Script:ConcernedWailing         = "`u{1F63D}"
[String]$Script:ConcernedScreaming       = "`u{1F631}"
[String]$Script:NegativeNoseSteam        = "`u{1F624}"
[String]$Script:NegativeEnraged          = "`u{1F621}"
[String]$Script:NegativeAngry            = "`u{1F620}"
[String]$Script:NegativeExplitive        = "`u{1F92C}"
[String]$Script:NegativeSkull            = "`u{1F480}"
[String]$Script:CostumePoop              = "`u{1F4A9}"
[String]$Script:CostumeClown             = "`u{1F921}"
[String]$Script:CostumeOgre              = "`u{1F479}"
[String]$Script:CostumeGoblin            = "`u{1F47A}"
[String]$Script:CostumeGhost             = "`u{1F47B}"
[String]$Script:CostumeAlien             = "`u{1F47D}"
[String]$Script:CostumeInvaders          = "`u{1F47E}"
[String]$Script:CostumeRobot             = "`u{1F916}"
[String]$Script:CatGrinning              = "`u{1F63A}"
[String]$Script:CatHeartEyes             = "`u{1F63B}"
[String]$Script:CatWrySmile              = "`u{1F63C}"
[String]$Script:CatCrying                = "`u{1F63F}"
[String]$Script:CatAngry                 = "`u{1F63E}"
[String]$Script:MiscLoveLetter           = "`u{1F48C}"
[String]$Script:MiscBrokenHeart          = "`u{1F494}"
[String]$Script:MiscOrangeHeart          = "`u{1F9E1}"
[String]$Script:MiscYellowHeart          = "`u{1F49B}"
[String]$Script:MiscGreenHeart           = "`u{1F49A}"
[String]$Script:MiscBlueHeart            = "`u{1F499}"
[String]$Script:MiscLightBlueHeart       = "`u{1FA75}"
[String]$Script:MiscPurpleHeart          = "`u{1F49C}"
[String]$Script:MiscBrownHeart           = "`u{1F90E}"
[String]$Script:MiscBlackHeart           = "`u{1F5A4}"
[String]$Script:MiscGreyHeart            = "`u{1FA76}"
[String]$Script:MiscWhiteHeart           = "`u{1F90D}"
[String]$Script:MiscKissMark             = "`u{1F48B}"
[String]$Script:MiscHundredPoints        = "`u{1F4AF}"
[String]$Script:MiscAngerSymbol          = "`u{1F4A2}"
[String]$Script:MiscCollisionSymbol      = "`u{1F4A5}"
[String]$Script:MiscSweatDroplets        = "`u{1F4A6}"
[String]$Script:MiscDashingAway          = "`u{1F4A8}"
[String]$Script:MiscHole                 = "`u{1F573}"
[String]$Script:MiscSpeechBubble         = "`u{1F4AC}"
[String]$Script:MiscTripleZ              = "`u{1F4A4}"
[String]$Script:PersonBaby               = "`u{1F476}"
[String]$Script:PersonChild              = "`u{1F9D2}"
[String]$Script:PersonBoy                = "`u{1F466}"
[String]$Script:PersonGirl               = "`u{1F467}"
[String]$Script:PersonPerson             = "`u{1F9D1}"
[String]$Script:PersonBlondeHair         = "`u{1F471}"
[String]$Script:PersonMan                = "`u{1F468}"
[String]$Script:PersonManBeard           = "`u{1F9D4}"
[String]$Script:PersonWoman              = "`u{1F469}"
[String]$Script:PersonOldMan             = "`u{1F474}"
[String]$Script:PersonOldWoman           = "`u{1F475}"
[String]$Script:PersonGestureFrowning    = "`u{1F64D}"
[String]$Script:PersonGesturePouting     = "`u{1F64E}"
[String]$Script:PersonGestureNo          = "`u{1F645}"
[String]$Script:PersonGestureOkay        = "`u{1F646}"
[String]$Script:PersonGestureRaiseHand   = "`u{1F64B}"
[String]$Script:PersonGestureBowing      = "`u{1F647}"
[String]$Script:PersonGestureFacepalming = "`u{1F926}"
[String]$Script:PersonGestureShrugging   = "`u{1F937}"

#endregion




#region VT CSI/SGR DEFINITIONS

[String]$Script:VtCsiRoot                = "`e["
[String]$Script:VtCsiHideCursor          = "$($Script:VtCsiRoot)?25h"
[String]$Script:VtCsiShowCursor          = "$($Script:VtCsiRoot)?25l"
[String]$Script:VtCsiEnableAltBuffer     = "$($Script:VtCsiRoot)?1049h"
[String]$Script:VtCsiDisableAltBuffer    = "$($Script:VtCsiRoot)?1049l"
[String]$Script:VtSgrReset               = "$($Script:VtCsiRoot)m"
[String]$Script:VtSgrBoldText            = "$($Script:VtCsiRoot)1m"
[String]$Script:VtSgrFaintText           = "$($Script:VtCsiRoot)2m"
[String]$Script:VtSgrItalicText          = "$($Script:VtCsiRoot)3m"
[String]$Script:VtSgrUnderlineText       = "$($Script:VtCsiRoot)4m"
[String]$Script:VtSgrBlinkText           = "$($Script:VtCsiRoot)5m"
[String]$Script:VtSgrVideoInvert         = "$($Script:VtCsiRoot)7m"
[String]$Script:VtSgrConceal             = "$($Script:VtCsiRoot)8m"
[String]$Script:VtSgrStrikethruText      = "$($Script:VtCsiRoot)9m"
[String]$Script:VtSgrDoubleUnderlineText = "$($Script:VtCsiRoot)21m"
[String]$Script:VtSgrOverlineText        = "$($Script:VtCsiRoot)53m"
[String]$Script:VtSgr24FgRoot            = "$($Script:VtCsiRoot)38;2;"
[String]$Script:VtSgr24BgRoot            = "$($Script:VtCsiRoot)48;2;"
#[String]$Script:VtSgrAltText11        = "$($Script:VtCsiRoot)11m" # Alt Fonts aren't honored by Windows Terminal
#[String]$Script:VtSgrBlinkTextFast    = "$($Script:VtCsiRoot)6m" # This sequence isn't honored by Windows Terminal

#endregion




#region GLOBAL VARIABLE DEFINITIONS

$Script:LegalCommands = @(
    'move',
    'm',
    'look',
    'l',
    'inventory',
    'i',
    'examine',
    'exa',
    'get',
    'g',
    'take',
    't',
    'use',
    'u',
    'drop',
    'd'
)

[GameState]$Script:CurrentGameState  = [GameState]::SplashScreenA
[GameState]$Script:PreviousGameState = [GameState]::None

[Array]$Script:BattleEntityTable = @()

#endregion




#region VT CSI SGR FUNCTIONS

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor up by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorUpString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)A"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor down by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorDownString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)B"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor forward by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorForwardString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)C"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor backward by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorBackwardString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)D"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor to the start of the line a fixed number of lines below the current position.

.PARAMETER Increment
The number of lines that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorNextLineString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)E"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor to the start of the line a fixed number of lines above the current position.

.PARAMETER Increment
The number of lines that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorPrevLineString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)F"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor to a user-specified column in the current line.

.PARAMETER Increment
The column that the cursor should be moved to. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorHorizAbsString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Increment
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Increment)G"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will move the cursor to a user-specified position in the buffer.

.PARAMETER Row
The Row to move the cursor to.

.PARAMETER Column
The Column to move the cursor to.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiCursorPosString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Row,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Column
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Row);$($Column)H"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will clear part of the screen, as instructed by the user-specified mode.

.PARAMETER Mode
The clear mode. See the VtCsiEidMode enumeration for more information.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiEidString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [VtCsiEidMode]$Mode
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Mode)J"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will clear part of a line, as instructed by the user-specified mode.

.PARAMETER Mode
The clear mode. See the VtCsiEilMode enumeration for more information.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiEilString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [VtCsiEilMode]$Mode
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Mode)K"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will scroll the screen buffer up by the number of user-specified lines.

.PARAMETER NumLines
The number of lines to scroll the screen buffer up by.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiScrollUpString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$NumLines
    )

    Process {
        Return "$($Script:VtCsiRoot)$($NumLines)S"
    }
}

<#
.SYNOPSIS
Returns a preformatted VT CSI Sequence that will scroll the screen buffer down by the number of user-specified lines.

.PARAMETER NumLines
The number of lines to scroll the screen buffer down by.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtCsiScrollDownString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$NumLines
    )

    Process {
        Return "$($Script:VtCsiRoot)$($NumLines)T"
    }
}

<#
.SYNOPSIS
Returns a preformatted VI SGR Sequence that will color the preceding text in 24-bit format.

.PARAMETER Red
The intensity of the red channel, between 0 and 255.

.PARAMETER Green
The intensity of the green channel, between 0 and 255.

.PARAMETER Blue
The intensity of the blue channel, between 0 and 255.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtSgr24FgColorString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Red,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Green,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Blue
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Script:VtSgr24FgRoot)$($Red);$($Green);$($Blue)m"
    }
}

<#
.SYNOPSIS
Returns a preformatted VI SGR Sequence that will color the preceding text background in 24-bit format.

.PARAMETER Red
The intensity of the red channel, between 0 and 255.

.PARAMETER Green
The intensity of the green channel, between 0 and 255.

.PARAMETER Blue
The intensity of the blue channel, between 0 and 255.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtSgr24BgColorString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Red,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Green,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 255)]
        [Int]$Blue
    )

    Process {
        Return "$($Script:VtCsiRoot)$($Script:VtSgr24BgRoot)$($Red);$($Green);$($Blue)m"
    }
}

<#
.SYNOPSIS
Returns a VT SGR Sequence that adds various kinds of text decorators.

.PARAMETER UseBold
Specifies if the user has requested bold typeface. This is incompatible with UseFaint. If both this and UseFaint are specified, Bold takes precedence.

.PARAMETER UseFaint
Specifies if the user requested a faint typeface. This is incompatible with UseBold. If both this and UseBold are specified, Bold takes precendece.

.PARAMETER UseItalic
Specifies if the user requested an italic typeface. This can be combined with other typeface modifiers.

.PARAMETER UseUnderline
Specifies if the user requested an underline decoration. This is incompatible with UseDoubleUnderline. If both this and UseDoubleUnderline are specified, Underline takes precedence.

.PARAMETER UseBlink
Specifies if the user requested a blink decoration. This can be combined with other typeface modifiers.

.PARAMETER UseInversion
Specifies if the user requested a video inversion decoration. This can be combined with other typeface modifiers.

.PARAMETER UseConceal
Specifies if the user requested a conceal decoration. This can be combined with other typeface modifiers.

.PARAMETER UseStrikethru
Specifies if the user requested a strikethru decoration. This can be combined with other typeface modifiers.

.PARAMETER UseDoubleUnderline
Specifies if the user requested a double underline decoration. This is incompatible with UseUnderline. If both this and UseUnderline are specified, Underline takes precedence.

.PARAMETER UseOverline
Specifis if the user requested an overline decoration. This can be combined with other typeface modifiers.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function Script:New-EldVtSgrTextDecorationString {
    [CmdletBinding()]
    Param(
        [Switch]$UseBold,
        [Switch]$UseFaint,
        [Switch]$UseItalic,
        [Switch]$UseUnderline,
        [Switch]$UseBlink,
        [Switch]$UseInversion,
        [Switch]$UseConceal,
        [Switch]$UseStrikethru,
        [Switch]$UseDoubleUnderline,
        [Switch]$UseOverline
    )

    Process {
        [String]$a = ''

        If($UseBold -EQ $true -AND $UseFaint -EQ $true) {
            $UseFaint = $false # Faint and Bold can't be applied at the same time; use Bold if so.
        }
        If($UseUnderline -EQ $true -AND $UseDoubleUnderline -EQ $true) {
            $UseDoubleUnderline = $false # Underline and Double Underline can't be applied at the same time; use Underline if so.
        }
        If($UseBold -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrBoldText)"
            } Else {
                $a += "$($Script:VtSgrBoldText)"
            }
        }
        If($UseFaint -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrFaintText)"
            } Else {
                $a += "$($Script:VtSgrFaintText)"
            }
        }
        If($UseItalic -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrItalicText)"
            } Else {
                $a += "$($Script:VtSgrItalicText)"
            }
        }
        If($UseUnderline -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrUnderlineText)"
            } Else {
                $a += "$($Script:VtSgrUnderlineText)"
            }
        }
        If($UseBlink -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrBlinkText)"
            } Else {
                $a += "$($Script:VtSgrBlinkText)"
            }
        }
        If($UseInversion -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrVideoInvert)"
            } Else {
                $a += "$($Script:VtSgrVideoInvert)"
            }
        }
        If($UseConceal -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrConceal)"
            } Else {
                $a += "$($Script:VtSgrConceal)"
            }
        }
        If($UseStrikethru -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrStrikethruText)"
            } Else {
                $a += "$($Script:VtSgrStrikethruText)"
            }
        }
        If($UseDoubleUnderline -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrDoubleUnderlineText)"
            } Else {
                $a += "$($Script:VtSgrDoubleUnderlineText)"
            }
        }
        If($UseOverline -EQ $true) {
            If([String]::IsNullOrEmpty($a)) {
                $a += "$($Script:VtCsiRoot)$($Script:VtSgrOverlineText)"
            } Else {
                $a += "$($Script:VtSgrOverlineText)"
            }
        }

        Return $a
    }
}

<#
.SYNOPSIS
Returns a VT Sequence that serves as a prefix for groups of modifications.

.PARAMETER ForegroundColor
The foreground color of the text. This can be generated from New-EldVtSgr24FgColorString.

.PARAMETER BackgroundColor
The background color of the text. This can be generated from New-EldVtSgr24BgColorString.

.PARAMETER Decorations
The decorations that are desired to be applied to the text. This can be generated from New-EldVtSgrTextDecorationString.

.PARAMETER Coordinates
The coordinates where the text is desired to be placed at. This can be generated from New-EldVtCsiCursorPosString.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-EldVtStringPrefix {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$ForegroundColor,
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$BackgroundColor,
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$Decorations,
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$Coordinates
    )

    Process {
        Return "$($Coordinates)$($Decorations)$($ForegroundColor)$($BackgroundColor)"
    }
}

<#
.SYNOPSIS
Returns a preformatted String that combines a VT CSI/SGR Prefix with custom user data and, conditionally, a CSI/SGR terminator.

.PARAMETER Prefix
A VT CSI/SGR Prefix. This can be generated from New-EldVtStringPrefix.

.PARAMETER UserData
A String that contains the text that the user wants to display in the terminal.

.PARAMETER TerminateWithReset
A Switch that specifies if a SGR Reset terminates this string or not. Usually, this will be yes, but it's conditional all the same.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-EldVtString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$Prefix,
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$UserData,
        [Switch]$TerminateWithReset
    )

    Process {
        [String]$a = "$($Prefix)$($UserData)"
        
        If($UserData -EQ $true) {
            $a += "$($VtSgrReset)"
        }

        Return $a
    }
}

<#
.SYNOPSIS
Returns a String that serves as a composite of VtStrings.

.PARAMETER VtStrings
An Array of Strings that will be combined together. The first element should contain the desired coordinates, while the remainder should not contain coordinate modifiers.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-EldVtStringComposite {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]]$VtStrings
    )

    Process {
        [String]$a = ''

        Foreach($b in $VTStrings) {
            $a += $b
        }

        Return $a
    }
}

<#
.SYNOPSIS
Returns a preformatted String that can be used for a Scene Image.

.PARAMETER BackgroundColor
The background color for the cell. This can be generated from New-EldVtSgr24BgColorString.

.PARAMETER Coordinates
The coordinates for the cell. This can be generated from New-EldVtCsiCursorPosString.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-EldVtSceneImageString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$BackgroundColor,
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [String]$Coordinates
    )

    Process {
        [String]$a = $(New-EldVtStringPrefix -ForegroundColor '' -BackgroundColor $BackgroundColor -Decorations '' -Coordinates $Coordinates)

        Return $(New-EldVtString -Prefix $a -UserData ' ' -TerminateWithReset)
    }
}

#endregion




#region GLOBAL VARIABLES GROUP 2

[Hashtable]$Script:CCBlack24 = @{
    Red   = 0
    Green = 0
    Blue  = 0
}
[Hashtable]$Script:CCWhite24 = @{
    Red   = 255
    Green = 255
    Blue  = 255
}
[Hashtable]$Script:CCRed24 = @{
    Red   = 255
    Green = 0
    Blue  = 0
}
[Hashtable]$Script:CCGreen24 = @{
    Red   = 0
    Green = 255
    Blue  = 0
}
[Hashtable]$Script:CCBlue24 = @{
    Red   = 0
    Green = 0
    Blue  = 255
}
[Hashtable]$Script:CCYellow24 = @{
    Red   = 255
    Green = 255
    Blue  = 0
}
[Hashtable]$Script:CCDarkYellow24 = @{
    Red   = 255
    Green = 204
    Blue  = 0
}
[Hashtable]$Script:CCDarkCyan24 = @{
    Red   = 0
    Green = 139
    Blue  = 139
}
[Hashtable]$Script:CCDarkGrey24 = @{
    Red   = 45
    Green = 45
    Blue  = 45
}
[Hashtable]$Script:CCRandom24 = @{
    Red   = $(Get-Random -Minimum 0 -Maximum 255)
    Green = $(Get-Random -Minimum 0 -Maximum 255)
    Blue  = $(Get-Random -Minimum 0 -Maximum 255)
}
[Hashtable]$Script:CCBlack24 = @{
    Red   = 0
    Green = 0
    Blue  = 0
}
[Hashtable]$Script:CCAppleNRedLight24 = @{
    Red   = 255
    Green = 59
    Blue  = 48
}
[Hashtable]$Script:CCAppleNRedDark2424 = @{
    Red   = 255
    Green = 69
    Blue  = 58
}
[Hashtable]$Script:CCAppleNRedALight24 = @{
    Red   = 215
    Green = 0
    Blue  = 21
}
[Hashtable]$Script:CCAppleNRedADark24 = @{
    Red   = 255
    Green = 105
    Blue  = 97
}
[Hashtable]$Script:CCAppleNOrangeLight24 = @{
    Red   = 255
    Green = 149
    Blue  = 0
}
[Hashtable]$Script:CCAppleNOrangeDark24 = @{
    Red   = 255
    Green = 159
    Blue  = 10
}
[Hashtable]$Script:CCAppleNOrangeALight24 = @{
    Red   = 201
    Green = 52
    Blue  = 0
}
[Hashtable]$Script:CCAppleNOrangeADark24 = @{
    Red   = 255
    Green = 179
    Blue  = 64
}
[Hashtable]$Script:CCAppleNYellowLight24 = @{
    Red   = 255
    Green = 214
    Blue  = 10
}
[Hashtable]$Script:CCAppleNYellowDark2424 = @{
    Red   = 255
    Green = 214
    Blue  = 10
}
[Hashtable]$Script:CCAppleNYellowALight24 = @{
    Red   = 178
    Green = 80
    Blue  = 0
}
[Hashtable]$Script:CCAppleNYellowADark24 = @{
    Red   = 255
    Green = 212
    Blue  = 38
}
[Hashtable]$Script:CCAppleNGreenLight24 = @{
    Red   = 52
    Green = 199
    Blue  = 89
}
[Hashtable]$Script:CCAppleNGreenDark24 = @{
    Red   = 48
    Green = 209
    Blue  = 88
}
[Hashtable]$Script:CCAppleNGreenALight24 = @{
    Red   = 36
    Green = 138
    Blue  = 61
}
[Hashtable]$Script:CCAppleNGreenADark24 = @{
    Red   = 48
    Green = 219
    Blue  = 91
}
[Hashtable]$Script:CCAppleNMintLight24 = @{
    Red   = 0
    Green = 199
    Blue  = 190
}
[Hashtable]$Script:CCAppleNMintDark24 = @{
    Red   = 99
    Green = 230
    Blue  = 226
}
[Hashtable]$Script:CCAppleNMintALight24 = @{
    Red   = 12
    Green = 129
    Blue  = 123
}
[Hashtable]$Script:CCAppleNMintADark24 = @{
    Red   = 102
    Green = 212
    Blue  = 207
}
[Hashtable]$Script:CCAppleNTealLight24 = @{
    Red   = 48
    Green = 176
    Blue  = 199
}
[Hashtable]$Script:CCAppleNTealDark24 = @{
    Red   = 64
    Green = 200
    Blue  = 224
}
[Hashtable]$Script:CCAppleNTealALight24 = @{
    Red   = 0
    Green = 130
    Blue  = 153
}
[Hashtable]$Script:CCAppleNTealADark24 = @{
    Red   = 93
    Green = 230
    Blue  = 255
}
[Hashtable]$Script:CCAppleNCyanLight24 = @{
    Red   = 50
    Green = 173
    Blue  = 230
}
[Hashtable]$Script:CCAppleNCyanDark24 = @{
    Red   = 100
    Green = 210
    Blue  = 255
}
[Hashtable]$Script:CCAppleNCyanALight24 = @{
    Red   = 0
    Green = 113
    Blue  = 164
}
[Hashtable]$Script:CCAppleNCyanADark24 = @{
    Red   = 112
    Green = 215
    Blue  = 255
}
[Hashtable]$Script:CCAppleNBlueLight24 = @{
    Red   = 0
    Green = 122
    Blue  = 255
}
[Hashtable]$Script:CCAppleNBlueDark24 = @{
    Red   = 10
    Green = 132
    Blue  = 255
}
[Hashtable]$Script:CCAppleNBlueALight24 = @{
    Red   = 0
    Green = 64
    Blue  = 221
}
[Hashtable]$Script:CCAppleNBlueADark24 = @{
    Red   = 64
    Green = 156
    Blue  = 255
}
[Hashtable]$Script:CCAppleNIndigoLight24 = @{
    Red   = 88
    Green = 86
    Blue  = 214
}
[Hashtable]$Script:CCAppleNIndigoDark24 = @{
    Red   = 94
    Green = 92
    Blue  = 230
}
[Hashtable]$Script:CCAppleNIndigoALight24 = @{
    Red   = 54
    Green = 52
    Blue  = 163
}
[Hashtable]$Script:CCAppleNIndigoADark24 = @{
    Red   = 125
    Green = 122
    Blue  = 255
}
[Hashtable]$Script:CCAppleNPurpleLight24 = @{
    Red   = 175
    Green = 82
    Blue  = 222
}
[Hashtable]$Script:CCAppleNPurpleDark24 = @{
    Red   = 191
    Green = 90
    Blue  = 242
}
[Hashtable]$Script:CCAppleNPurpleALight24 = @{
    Red   = 137
    Green = 68
    Blue  = 171
}
[Hashtable]$Script:CCAppleNPurpleADark24 = @{
    Red   = 218
    Green = 143
    Blue  = 255
}
[Hashtable]$Script:CCAppleNPinkLight24 = @{
    Red   = 255
    Green = 45
    Blue  = 85
}
[Hashtable]$Script:CCAppleNPinkDark24 = @{
    Red   = 255
    Green = 55
    Blue  = 95
}
[Hashtable]$Script:CCAppleNPinkALight24 = @{
    Red   = 211
    Green = 15
    Blue  = 69
}
[Hashtable]$Script:CCAppleNPinkADark24 = @{
    Red   = 255
    Green = 100
    Blue  = 130
}
[Hashtable]$Script:CCAppleNBrownLight24 = @{
    Red   = 162
    Green = 132
    Blue  = 94
}
[Hashtable]$Script:CCAppleNBrownDark24 = @{
    Red   = 172
    Green = 142
    Blue  = 104
}
[Hashtable]$Script:CCAppleNBrownALight24 = @{
    Red   = 127
    Green = 101
    Blue  = 69
}
[Hashtable]$Script:CCAppleNBrownADark24 = @{
    Red   = 181
    Green = 148
    Blue  = 105
}
[Hashtable]$Script:CCAppleNGreyLight24 = @{
    Red   = 142
    Green = 142
    Blue  = 147
}
[Hashtable]$Script:CCAppleNGreyDark24 = @{
    Red   = 142
    Green = 142
    Blue  = 147
}
[Hashtable]$Script:CCAppleNGreyALight24 = @{
    Red   = 108
    Green = 108
    Blue  = 112
}
[Hashtable]$Script:CCAppleNGreyADark24 = @{
    Red   = 174
    Green = 174
    Blue  = 178
}
[Hashtable]$Script:CCAppleNGrey2Light24 = @{
    Red   = 174
    Green = 174
    Blue  = 178
}
[Hashtable]$Script:CCAppleNGrey2Dark24 = @{
    Red   = 99
    Green = 99
    Blue  = 102
}
[Hashtable]$Script:CCAppleNGrey2ALight24 = @{
    Red   = 142
    Green = 142
    Blue  = 147
}
[Hashtable]$Script:CCAppleNGrey2ADark24 = @{
    Red   = 124
    Green = 124
    Blue  = 128
}
[Hashtable]$Script:CCAppleNGrey3Light24 = @{
    Red   = 199
    Green = 199
    Blue  = 204
}
[Hashtable]$Script:CCAppleNGrey3Dark24 = @{
    Red   = 72
    Green = 72
    Blue  = 74
}
[Hashtable]$Script:CCAppleNGrey4ALight24 = @{
    Red   = 188
    Green = 188
    Blue  = 192
}
[Hashtable]$Script:CCAppleNGrey4ADark24 = @{
    Red   = 68
    Green = 68
    Blue  = 70
}
[Hashtable]$Script:CCAppleNGrey5Light24 = @{
    Red   = 229
    Green = 229
    Blue  = 234
}
[Hashtable]$Script:CCAppleNGrey5Dark24 = @{
    Red   = 44
    Green = 44
    Blue  = 46
}
[Hashtable]$Script:CCAppleNGrey5ALight24 = @{
    Red   = 216
    Green = 216
    Blue  = 220
}
[Hashtable]$Script:CCAppleNGrey5ADark24 = @{
    Red   = 54
    Green = 54
    Blue  = 56
}
[Hashtable]$Script:CCAppleNGrey6Light24 = @{
    Red   = 242
    Green = 242
    Blue  = 247
}
[Hashtable]$Script:CCAppleNGrey6Dark24 = @{
    Red   = 28
    Green = 28
    Blue  = 30
}
[Hashtable]$Script:CCAppleNGrey6ALight24 = @{
    Red   = 235
    Green = 235
    Blue  = 240
}
[Hashtable]$Script:CCAppleNGrey6ADark24 = @{
    Red   = 36
    Green = 36
    Blue  = 38
}
[Hashtable]$Script:CCAppleVRedLight24 = @{
    Red   = 255
    Green = 49
    Blue  = 38
}
[Hashtable]$Script:CCAppleVRedDark24 = @{
    Red   = 255
    Green = 79
    Blue  = 68
}
[Hashtable]$Script:CCAppleVRedALight24 = @{
    Red   = 194
    Green = 6
    Blue  = 24
}
[Hashtable]$Script:CCAppleVRedADark24 = @{
    Red   = 255
    Green = 65
    Blue  = 54
}
[Hashtable]$Script:CCAppleVOrangeLight24 = @{
    Red   = 245
    Green = 139
    Blue  = 0
}
[Hashtable]$Script:CCAppleVOrangeDark24 = @{
    Red   = 255
    Green = 169
    Blue  = 20
}
[Hashtable]$Script:CCAppleVOrangeALight24 = @{
    Red   = 173
    Green = 58
    Blue  = 0
}
[Hashtable]$Script:CCAppleVOrangeADark24 = @{
    Red   = 255
    Green = 179
    Blue  = 64
}
[Hashtable]$Script:CCAppleVYellowLight24 = @{
    Red   = 245
    Green = 194
    Blue  = 0
}
[Hashtable]$Script:CCAppleVYellowDark24 = @{
    Red   = 255
    Green = 224
    Blue  = 20
}
[Hashtable]$Script:CCAppleVYellowALight24 = @{
    Red   = 146
    Green = 81
    Blue  = 0
}
[Hashtable]$Script:CCAppleVYellowADark24 = @{
    Red   = 255
    Green = 212
    Blue  = 38
}
[Hashtable]$Script:CCAppleVGreenLight24 = @{
    Red   = 30
    Green = 195
    Blue  = 55
}
[Hashtable]$Script:CCAppleVGreenDark24 = @{
    Red   = 60
    Green = 225
    Blue  = 85
}
[Hashtable]$Script:CCAppleVGreenALight24 = @{
    Red   = 0
    Green = 112
    Blue  = 24
}
[Hashtable]$Script:CCAppleVGreenADark24 = @{
    Red   = 49
    Green = 222
    Blue  = 75
}
[Hashtable]$Script:CCAppleVMintLight24 = @{
    Red   = 0
    Green = 189
    Blue  = 180
}
[Hashtable]$Script:CCAppleVMintDark24 = @{
    Red   = 108
    Green = 224
    Blue  = 219
}
[Hashtable]$Script:CCAppleVMintALight24 = @{
    Red   = 11
    Green = 117
    Blue  = 112
}
[Hashtable]$Script:CCAppleVMintADark24 = @{
    Red   = 49
    Green = 222
    Blue  = 75
}
[Hashtable]$Script:CCAppleVTealLight24 = @{
    Red   = 46
    Green = 167
    Blue  = 189
}
[Hashtable]$Script:CCAppleVTealDark24 = @{
    Red   = 68
    Green = 212
    Blue  = 237
}
[Hashtable]$Script:CCAppleVTealALight24 = @{
    Red   = 0
    Green = 119
    Blue  = 140
}
[Hashtable]$Script:CCAppleVTealADark24 = @{
    Red   = 93
    Green = 230
    Blue  = 255
}
[Hashtable]$Script:CCAppleVCyanLight24 = @{
    Red   = 65
    Green = 175
    Blue  = 220
}
[Hashtable]$Script:CCAppleVCyanDark24 = @{
    Red   = 90
    Green = 205
    Blue  = 250
}
[Hashtable]$Script:CCAppleVCyanALight24 = @{
    Red   = 0
    Green = 103
    Blue  = 150
}
[Hashtable]$Script:CCAppleVCyanADark24 = @{
    Red   = 112
    Green = 215
    Blue  = 255
}
[Hashtable]$Script:CCAppleVBlueLight24 = @{
    Red   = 0
    Green = 122
    Blue  = 245
}
[Hashtable]$Script:CCAppleVBlueDark24 = @{
    Red   = 20
    Green = 142
    Blue  = 255
}
[Hashtable]$Script:CCAppleVBlueALight24 = @{
    Red   = 0
    Green = 64
    Blue  = 221
}
[Hashtable]$Script:CCAppleVBlueADark24 = @{
    Red   = 64
    Green = 156
    Blue  = 255
}
[Hashtable]$Script:CCAppleVIndigoLight24 = @{
    Red   = 84
    Green = 82
    Blue  = 204
}
[Hashtable]$Script:CCAppleVIndigoDark24 = @{
    Red   = 99
    Green = 97
    Blue  = 242
}
[Hashtable]$Script:CCAppleVIndigoALight24 = @{
    Red   = 54
    Green = 52
    Blue  = 163
}
[Hashtable]$Script:CCAppleVIndigoADark24 = @{
    Red   = 125
    Green = 122
    Blue  = 255
}
[Hashtable]$Script:CCAppleVPurpleLight24 = @{
    Red   = 159
    Green = 75
    Blue  = 201
}
[Hashtable]$Script:CCAppleVPurpleDark24 = @{
    Red   = 204
    Green = 101
    Blue  = 255
}
[Hashtable]$Script:CCAppleVPurpleALight24 = @{
    Red   = 173
    Green = 68
    Blue  = 171
}
[Hashtable]$Script:CCAppleVPurpleADark24 = @{
    Red   = 218
    Green = 143
    Blue  = 255
}
[Hashtable]$Script:CCAppleVPinkLight24 = @{
    Red   = 245
    Green = 35
    Blue  = 75
}
[Hashtable]$Script:CCAppleVPinkDark24 = @{
    Red   = 255
    Green = 65
    Blue  = 105
}
[Hashtable]$Script:CCAppleVPinkALight24 = @{
    Red   = 193
    Green = 16
    Blue  = 50
}
[Hashtable]$Script:CCAppleVPinkADark24 = @{
    Red   = 255
    Green = 58
    Blue  = 95
}
[Hashtable]$Script:CCAppleVBrownLight24 = @{
    Red   = 152
    Green = 122
    Blue  = 84
}
[Hashtable]$Script:CCAppleVBrownDark24 = @{
    Red   = 182
    Green = 152
    Blue  = 114
}
[Hashtable]$Script:CCAppleVBrownALight24 = @{
    Red   = 119
    Green = 93
    Blue  = 59
}
[Hashtable]$Script:CCAppleVGreyLight24 = @{
    Red   = 132
    Green = 132
    Blue  = 137
}
[Hashtable]$Script:CCAppleVGreyDark24 = @{
    Red   = 162
    Green = 162
    Blue  = 167
}
[Hashtable]$Script:CCAppleVGreyALight24 = @{
    Red   = 97
    Green = 97
    Blue  = 101
}
[Hashtable]$Script:CCAppleVGreyADark24 = @{
    Red   = 152
    Green = 152
    Blue  = 157
}
[Hashtable]$Script:CCTextDefault24 = $Script:CCAppleNGrey5Light24
[Hashtable]$Script:CPDefault = @{
    Row    = 1
    Column = 1
}

#endregion




#region CONSTRUCT DEFINITIONS
Function New-EldBattleEntityProperty {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Base,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$BasePre,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$BaseAugmentValue,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$Max,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$MaxPre,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$MaxAugmentValue,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [StatNumberState]$State,
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [ScriptBlock]$ValidateFunction,
        [Switch]$BaseAugmentActive,
        [Switch]$MaxAugmentActive
    )

    Process {
        ### String Format Information
        ###
        ### GUID-of-Parent-Entity;GUID-of-This;Base;BasePre;BaseAugmentValue;Max;MaxPre;MaxAugmentValue;State;
    }
}
