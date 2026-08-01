using namespace System

Set-StrictMode -Version Latest





<#
.SYNOPSIS
Asserts the state of a Context.
#>
Function Confirm-Context {
    Param(
        [Context]$Context
    )

    If($null -EQ $Context) {
        [ContextBroadcaster]::StaticBroadcast(
            "$([CustomEvents]::BadContext)",
            $null,
            $null
        )
    }
}
