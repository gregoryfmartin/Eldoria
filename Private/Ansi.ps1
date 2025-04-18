using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

. "$PSScriptRoot\Vars.ps1"

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
                Return "$((Get-EldVar -Name 'AnsiFg24Prefix').Value)$($ColorData.Value[0]);$($ColorData.Value[1]);$($ColorData.Value[2])m"
            }
            'Array' {
                Return "$((Get-EldVar -Name 'AnsiFg24Prefix').Value)$($ArrData[0]);$($ArrData[1]);$($ArrData[2])m"
            }
        }
    }
}

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
                Return "$((Get-EldVar -Name 'AnsiBg24Prefix').Value)$($ColorData.Value[0]);$($ColorData.Value[1]);$($ColorData.Value[2])m"
            }
            'Array' {
                Return "$((Get-EldVar -Name 'AnsiBg24Prefix').Value)$($ArrData[0]);$($ArrData[1]);$($ArrData[2])m"
            }
        }
    }
}

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

Function New-EldAtPrefix {
    [CmdletBinding()]
    Param(
        [Hashtable]$Fg24   = @{ArrData = @(0, 0, 0)},
        [Hashtable]$Bg24   = @{ArrData = @(0, 0, 0)},
        [Hashtable]$Deco   = @{},
        [Hashtable]$Coords = @{},
        [Switch]$Empty
    )

    Process {
        If($Empty) {
            Return ''
        }

        Return "$(New-EldAnsiFg24Prefix @Fg24)$(New-EldAnsiBg24Prefix @Bg24)$(New-EldAnsiDecoPrefix @Deco)$(New-EldAnsiCursorCoordPrefix @Coords)"
    }
}

Function New-EldAtString {
    [CmdletBinding()]
    Param(
        [Hashtable]$Prefix = @{},
        [String]$UserData,
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

Function New-EldAtSiString {
    [CmdletBinding()]
    Param(
        [Hashtable]$Bg24   = @{ArrData = @(0, 0, 0)},
        [Hashtable]$Coords = @{}
    )

    Process {
        Return "$(New-EldAtString @{
            Prefix = @{
                Fg24   = @{Empty = $true}
                Bg24   = $Bg24
                Deco   = @{Empty = $true}
                Coords = $Coords
            }
            UserData = ' '
            ModReset = $true
        })"
    }
}
