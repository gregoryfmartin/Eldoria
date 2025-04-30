using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

. "$PSScriptRoot\Vars.ps1"

<#
.SYNOPSIS
Creates a new ANSI SGR Foreground 24-bit color prefix.

.PARAMETER PSVData
A PSVariable to extract color data from. This can be obtained from Get-EldVar after all ELD
variables have been initialized.

.PARAMETER ArrData
An Array of integers to extract color data from. The array should be three integers in length,
mapping to 8-bit RGB values.

.PARAMETER Empty
A Switch specifying if the function should return an empty string. Because this function uses
Parameter Sets, if Empty is used, one of the other paramters is required. The best pattern of use
here is to provide ArrData and an empty array.

.OUTPUTS
System.String
    A properly formatted ANSI SGR Foreground 24-bit color string with the provided color data, or empty.
#>
Function New-EldAnsiFg24Prefix {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName = 'PSVar')]
        [PSVariable]$PSVData,

        [Parameter(ParameterSetName = 'Array')]
        [Int[]]$ArrData,

        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        Switch($PSCmdlet.ParameterSetName) {
            'PSVar' {
                Return "$((Get-EldVar -Name 'AnsiFg24Prefix').Value)$($PSVData.Value[0]);$($PSVData.Value[1]);$($PSVData.Value[2])m"
            }
            'Array' {
                Return "$((Get-EldVar -Name 'AnsiFg24Prefix').Value)$($ArrData[0]);$($ArrData[1]);$($ArrData[2])m"
            }
        }
    }
}

<#
.SYNOPSIS
Creates a new ANSI SGR Background 24-bit color prefix.

.PARAMETER PSVData
A PSVariable to extract color data from. This can be obtained from Get-EldVar after all ELD
variables have been initialized.

.PARAMETER ArrData
An Array of integers to extract color data from. The array should be three integers in length,
mapping to 8-bit RGB values.

.PARAMETER Empty
A Switch specifying if the function should return an empty string. Because this function uses
Parameter Sets, if Empty is used, one of the other paramters is required. The best pattern of use
here is to provide ArrData and an empty array.

.OUTPUTS
System.String
    A properly formatted ANSI SGR Background 24-bit color string with the provided color data, or empty.
#>
Function New-EldAnsiBg24Prefix {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName = 'PSVar')]
        [PSVariable]$PSVData,

        [Parameter(ParameterSetName = 'Array')]
        [Int[]]$ArrData,

        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        Switch($PSCmdlet.ParameterSetName) {
            'PSVar' {
                Return "$((Get-EldVar -Name 'AnsiBg24Prefix').Value)$($PSVData.Value[0]);$($PSVData.Value[1]);$($PSVData.Value[2])m"
            }
            'Array' {
                Return "$((Get-EldVar -Name 'AnsiBg24Prefix').Value)$($ArrData[0]);$($ArrData[1]);$($ArrData[2])m"
            }
        }
    }
}

<#
.SYNOPSIS
Creates a new ANSI CSI Cursor Positioning string.

.PARAMETER Row
The row to position the cursor at.

.PARAMETER Column
The column to position the cursor at.

.PARAMETER Empty
A Switch specifying if the function should return an empty string.

.OUTPUTS
System.String
    A properly formatted CSI Cursor Positioning string, or empty.

System.Management.Automation.ValidationManagementException
    If the values for either Row or Column are out of range, this exception is thrown.
#>
Function New-EldAnsiCursorCoordPrefix {
    [CmdletBinding()]
    Param(
        [ValidateRange(1, 80)]
        [Int]$Row = 1,

        [ValidateRange(1, 80)]
        [Int]$Column = 1,

        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        Return "`e[$($Row);$($Column)H"
    }
}

<#
.SYNOPSIS
Creates a new ANSI SGR Decorator string.

.PARAMETER Blink
A Switch specifying if the Blink decorator should be included in this string.

.PARAMETER Italic
A Switch specifying if the Italic decorator should be included in this string.

.PARAMETER Underline
A Switch specifying if the Underline decorator should be included in this string.

.PARAMETER Strikethru
A Switch specifying if the Strikethru decorator should be included in this string.

.PARAMETER Empty
A Switch specifying if the function should return an empty string.

.OUTPUTS
System.String
    A properly formatted SGR Decorator string, or empty.
#>
Function New-EldAnsiDecoPrefix {
    [CmdletBinding()]
    Param(
        [Switch]$Blink,
        [Switch]$Italic,
        [Switch]$Underline,
        [Switch]$Strikethru,
        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        [String]$A = ''

        If($Blink) {
            $A += "$((Get-EldVar -Name 'AnsiDecoBlink').Value)"
        }
        If($Italic) {
            $A += "$((Get-EldVar -Name 'AnsiDecoItalic').Value)"
        }
        If($Underline) {
            $A += "$((Get-EldVar -Name 'AnsiDecoUnderline').Value)"
        }
        If($Strikethru) {
            $A += "$((Get-EldVar -Name 'AnsiDecoStrikethru').Value)"
        }

        Return $A
    }
}

<#
.SYNOPSIS
Creates an ANSI-Terminated Prefix that is composed of all the previous modifiers.

.PARAMETER Fg24
A Splat to give to the New-EldAnsiFg24Prefix function.

.PARAMETER Bg24
A Splat to give to the New-EldAnsiBg24Prefix function.

.PARAMETER Deco
A Splat to give to the New-EldAnsiDecoPrefix function.

.PARAMETER Coords
A Splat to give to the New-EldAnsiCursorCoordPrefix function.

.PARAMETER Empty
A Switch specifying if the function should return an empty string.

.OUTPUTS
System.String
    A conditionally filled out ANSI-Terminated prefix, or empty.
#>
Function New-EldAtPrefix {
    [CmdletBinding()]
    Param(
        [Hashtable]$Fg24   = @{ ArrData = @(); Empty = $true },

        [Hashtable]$Bg24   = @{ ArrData = @(); Empty = $true },

        [Hashtable]$Deco   = @{ Empty = $true },

        [Hashtable]$Coords = @{ Empty = $true },

        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        Return "$(New-EldAnsiFg24Prefix @Fg24)$(New-EldAnsiBg24Prefix @Bg24)$(New-EldAnsiDecoPrefix @Deco)$(New-EldAnsiCursorCoordPrefix @Coords)"
    }
}

<#
.SYNOPSIS
Creates an ANSI-Terminated string that composes an ANSI-Terminated Prefix with user data.

.PARAMETER Prefix
A Hashtable that contains all the information to create an ANSI-Terminated Prefix (this is given to the New-EldAtPrefix function as a Splat).

.PARAMETER UserData
A String to decorate with the ANSI-Terminated Prefix.

.PARAMETER ModReset
A Switch specifying if the SGR Reset modifier should be appended.

.PARAMETER Empty
A Switch specifying if the function should return an empty string.
#>
Function New-EldAtString {
    [CmdletBinding()]
    Param(
        [Hashtable]$Prefix = @{},

        [String]$UserData = '',

        [Switch]$ModReset,

        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        Return "$(New-EldAtPrefix @Prefix)$($UserData)$($ModReset ? (Get-EldVar -Name 'AnsiModReset').Value : '')"
    }
}

<#
.SYNOPSIS
Creates a composition of one or more ANSI-Terminated Strings.

.PARAMETER AtStrings
An Array of Hashtables, intended as Splats, that can be given to the New-EldAtString function.

.OUTPUTS
System.String
    A String with all the given AT String data concatenated.
#>
Function New-EldAtStrComposite {
    [CmdletBinding()]
    Param(
        [Hashtable[]]$AtStrings
    )

    Process {
        [String]$A = ''

        Foreach($AtString in $AtStrings) {
            $A += "$(New-EldAtString @AtString)"
        }

        Return $A
    }
}

<#
.SYNOPSIS
Creates an AI Scene Image String.

.DESCRIPTION
An AT Scene Image String (ATSI) is a specialization of an AT String that's intended to be used only for creating
"images" in a bizarre sense of the word. ATSI's are only intended to be mutable in the background color and the 
coordinates. They always have a single whitepsace for their UserData value and are always appended with a SGR
Reset Modifier. A very long concatenation of these will create "images" that can be displayed in the Scene Image
Window.

.PARAMETER Bg24
Color data to use for the background color. See the New-EldAnsiBg24Prefix function for more details.

.PARAMETER Coords
Data to use for the cursor coordinates. See the New-EldAnsiCursorCoordPrefix function for more details.

.OUTPUTS
System.String
    A string that contains proper ATSI data.
#>
Function New-EldAtSiString {
    [CmdletBinding()]
    Param(
        [Hashtable]$Bg24   = @{ ArrData = @(); Empty = $true },

        [Hashtable]$Coords = @{}
    )

    Process {
        [Hashtable]$Vals = @{
            Prefix = @{
                Fg24   = @{ ArrData = @(); Empty = $true }
                Bg24   = $Bg24
                Deco   = @{ Empty = $true }
                Coords = $Coords
            }
            UserData = ' '
            ModReset = $true
        }
        
        Return "$(New-EldAtString @Vals)"
    }
}
