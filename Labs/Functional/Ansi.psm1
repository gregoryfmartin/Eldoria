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

<#
.SYNOPSIS
Returns a preformatted CSI Sequence that will move the cursor up by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorUpString {
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
Returns a preformatted CSI Sequence that will move the cursor down by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorDownString {
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
Returns a preformatted CSI Sequence that will move the cursor forward by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorForwardString {
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
Returns a preformatted CSI Sequence that will move the cursor backward by a user-specified number of cells.

.PARAMETER Increment
The number of cells that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorBackwardString {
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
Returns a preformatted CSI Sequence that will move the cursor to the start of the line a fixed number of lines below the current position.

.PARAMETER Increment
The number of lines that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorNextLineString {
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
Returns a preformatted CSI Sequence that will move the cursor to the start of the line a fixed number of lines above the current position.

.PARAMETER Increment
The number of lines that the cursor should be moved by. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorPrevLineString {
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
Returns a preformatted CSI Sequence that will move the cursor to a user-specified column in the current line.

.PARAMETER Increment
The column that the cursor should be moved to. This value should be a positive integer.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorHorizAbsString {
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
Returns a preformatted CSI Sequence that will move the cursor to a user-specified position in the buffer.

.PARAMETER Row
The Row to move the cursor to.

.PARAMETER Column
The Column to move the cursor to.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiCursorPosString {
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
Returns a preformatted CSI Sequence that will clear part of the screen, as instructed by the user-specified mode.

.PARAMETER Mode
The clear mode. See the VtCsiEidMode enumeration for more information.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiEidString {
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
Returns a preformatted CSI Sequence that will clear part of a line, as instructed by the user-specified mode.

.PARAMETER Mode
The clear mode. See the VtCsiEilMode enumeration for more information.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiEilString {
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
Returns a preformatted CSI Sequence that will scroll the screen buffer up by the number of user-specified lines.

.PARAMETER NumLines
The number of lines to scroll the screen buffer up by.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiScrollUpString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange('Positive')]
        [Int]$NumLines
    )

    Process {
        Return "$($Script:VtCsiRoot)$(NumLines)S"
    }
}

<#
.SYNOPSIS
Returns a preformatted CSI Sequence that will scroll the screen buffer down by the number of user-specified lines.

.PARAMETER NumLines
The number of lines to scroll the screen buffer down by.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-CsiScrollDownString {
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
Returns a SGR Sequence that adds various kinds of text decorators.

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
Function Script:New-SgrTextDecorationString {
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
The foreground color of the text. This can be generated from New-Sgr24FgColorString.

.PARAMETER BackgroundColor
The background color of the text. This can be generated from New-Sgr24BgColorString.

.PARAMETER Decorations
The decorations that are desired to be applied to the text. This can be generated from New-SgrTextDecorationString.

.PARAMETER Coordinates
The coordinates where the text is desired to be placed at. This can be generated from New-CsiCursorPosString.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-AtStringPrefix {
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
Returns a preformatted String that combines a CSI/SGR Prefix with custom user data and, conditionally, a CSI/SGR terminator.

.PARAMETER Prefix
A VT CSI/SGR Prefix. This can be generated from New-EldVtStringPrefix.

.PARAMETER UserData
A String that contains the text that the user wants to display in the terminal.

.PARAMETER TerminateWithReset
A Switch that specifies if a SGR Reset terminates this string or not. Usually, this will be yes, but it's conditional all the same.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-AtString {
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

.PARAMETER AtStrings
An Array of Strings that will be combined together. The first element should contain the desired coordinates, while the remainder should not contain coordinate modifiers.

.OUTPUTS
A String. See the Synopsis for information on the return.
#>
Function New-AtStringComposite {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]]$AtStrings
    )

    Process {
        [String]$a = ''

        Foreach($b in $ATStrings) {
            $a += $b
        }

        Return $a
    }
}
