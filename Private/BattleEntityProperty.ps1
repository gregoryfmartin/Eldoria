using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

. "$PSScriptRoot\Vars.ps1"

Function Update-EldBep {
    [CmdletBinding()]
    Param(
        [Switch]$Player,
        [Switch]$Enemy,
        [StatId]$Stat
    )

    Begin {
        
    }
}