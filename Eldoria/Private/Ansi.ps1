. "$PSScriptRoot\Vars.ps1"

Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns an ANSI SGR-formatted string to change the foreground color of any following text to a 24-bit color.

.PARAMETER ColorData
A 3-array of integers corresponding to 24-bit color data.

.PARAMETER Empty
A Switch that specifies if this function returns an empty string (has semantic value).

.OUTPUTS
An ANSI SGR-formatted string with FG 24-bit modifiers. Throws an Exception if ColorData contains less than 3 elements,
any of the values in ColorData fall outside the 8-bit range (0-255), or AnsiFgCol24Prefix can't be found.
Returns an empty string if the Empty switch is present.
#>
Function New-EldFg24String {
    [CmdletBinding()]
    Param(
        [Int[]]$ColorData = @(0, 0, 0),
        [Switch]$Empty
    )

    Begin {
        If($ColorData.Length -LT 3) {
            Throw [Exception]::new('ColorData length is less than expected.')
        }

        Foreach($Channel in $ColorData) {
            If($Channel -LT 0 -OR $Channel -GT 255) {
                Throw [Exception]::new('Color Channel value is out of expected range (0-255).')
            }
        }

        Try {
            $null = Get-EldVar -Name 'AnsiFgCol24Prefix' -ErrorAction SilentlyContinue
        } Catch {
            Throw $_
        }
    }

    Process {
        If($Empty) {
            Return ''
        }

        Return "$((Get-EldVar -Name 'AnsiFgCol24Prefix').Value)$($ColorData[0]);$($ColorData[1]);$($ColorData[2])m"
    }
}

<#
.SYNOPSIS
Returns an ANSI SGR-formatted string to change the background color of any following text to a 24-bit color.

.PARAMETER ColorData
A 3-array of integers corresponding to 24-bit color data.

.PARAMETER Empty
A Switch that specifies if this function returns an empty string (has semantic value).

.OUTPUTS
An ANSI SGR-formatted string with BG 24-bit modifiers. Throws an Exception if ColorData contains less than 3 elements,
any of the values in ColorData fall outside the 8-bit range (0-255), or AnsiBgCol24Prefix can't be found.
Returns an empty string if the Empty switch is present.
#>
Function New-EldBg24String {
    [CmdletBinding()]
    Param(
        [Int[]]$ColorData = @(0, 0, 0),
        [Switch]$Empty
    )

    Begin {
        If($ColorData.Length -LT 3) {
            Throw [Exception]::new('ColorData length is less than expected.')
        }

        Foreach($Channel in $ColorData) {
            If($Channel -LT 0 -OR $Channel -GT 255) {
                Throw [Exception]::new('Color Channel value is out of expected range (0-255).')
            }
        }

        Try {
            $null = Get-EldVar -Name 'AnsiBgCol24Prefix' -ErrorAction SilentlyContinue
        } Catch {
            Throw $_
        }
    }

    Process {
        If($Empty) {
            Return ''
        }

        Return "$((Get-EldVar -Name 'AnsiBgCol24Prefix').Value)$($ColorData[0]);$($ColorData[1]);$($ColorData[2])m"
    }
}

<#
.SYNOPSIS
Returns an ANSI CSI to reposition the cursor absolutely within the buffer. This function will restrict the cursor to 80, 80.

.PARAMETER Row
The row to place the cursor in.

.PARAMETER Column
The column to place the cursor in.

.PARAMETER Empty
A Switch that specifies if this function returns an empty string (has semantic value).

.OUTPUTS
An ANSI CSI-formatted string with absolutel cursor positioning modifiers. Returns an empty string if the Empty switch is present.
#>
Function New-EldCoordString {
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
