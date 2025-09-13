using namespace System

Set-StrictMode -Version Latest

<#
.SYNOPSIS
Starts the Eldoria game.

.DESCRIPTION
This function initializes and starts the Eldoria game by invoking the Run() method on the global $Script:TheGameCore object.

.EXAMPLE
Start-Eldoria

.NOTES
Ensure that $Script:TheGameCore is properly initialized before calling this function. This can be done by importing that class before this script.
#>
Function Start-Eldoria {
    $Script:TheBufferManager.ClearArea(
        [ATCoordinates]@{
            Row = 0
            Column = 0
        },
        [ATCoordinates]@{
            Row = 40
            Column = 80
        },
        0
    )

    $Script:TheGameCore.Run()
}
