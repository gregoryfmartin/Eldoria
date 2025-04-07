. "$PSScriptRoot\Vars.ps1"

Set-StrictMode -Version Latest

<#
.SYNOPSIS
Returns an ANSI SGR-formatted string to change the foreground color of any following text to a 24-bit color.
#>
Function New-EldFg24String {
    [CmdletBinding()]
    Param(
        [Int[]]$ColorData = @(0, 0, 0)
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
            $null = Get-EldVar -Name 'AnsiFgCol24Prefix'
        } Catch {
            Write-Error "$($_.Exception.Message)"
        }
    }

    Process {
        Return "$((Get-EldVar -Name 'AnsiFgCol24Prefix').Value)$($ColorData[0]);$($ColorData[1]);$($ColorData[2])m"
    }
}
