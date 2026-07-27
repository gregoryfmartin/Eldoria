using namespace System
using namespace System.Diagnostics
using namespace System.Threading
using namespace System.Collections.Generic

Set-StrictMode -Version Latest





################################################################################
#
# GAME CORE
#
# THE CORE OF THE GAME. NOT UNLIKE THE CORE OF AN APPLE.
#
################################################################################

Class GameCore {
    [Boolean]$IsRunning
    [BufferSpecDefinition]$BufferSpec
    [ContextBroadcaster]$ContextBroadcaster
    [Janitor]$Janitor
    [Context]$GlobalGameContext

    [Int]$TargetFps
    [Double]$TargetFrameTime

    [Stopwatch]$Sw
    [Double]$LastTime

    GameCore() {
        $this.IsRunning = $true
        $this.TargetFps = 60
        $this.TargetFrameTime = 1.0 / $this.TargetFps
        $this.Sw = [Stopwatch]::new()
        $this.LastTime = 0
        $this.BufferSpec = [BufferSpecDefinition]::new()
        $this.Janitor = [Janitor]::new($Global:PSVersionTable)
        $this.ContextBroadcaster = [ContextBroadcaster]::new()
    }

    [Void]Logic() {}

    [Void]Setup() {
        Register-EngineEvent -SourceIdentifier ([CustomEvents]::BadPSEdition) -Action {
            [Context]$CurrentContext = $Event.MessageData -AS [Context]

            Write-Host ($CurrentContext.References | Out-String)
        }.GetNewClosure()

        Register-EngineEvent -SourceIdentifier ([CustomEvents]::BufferHeightTooSmall) -Action {
            [Context]$CurrentContext = $Event.MessageData -AS [Context]

            Write-Host ($CurrentContext.References | Out-String)
        }.GetNewClosure()

        Register-EngineEvent -SourceIdentifier ([CustomEvents]::BufferWidthTooSmall) -Action {
            [Context]$CurrentContext = $Event.MessageData -AS [Context]

            Write-Host ($CurrentContext.References | Out-String)
        }.GetNewClosure()

        $this.Sw.Start()
    }
}
