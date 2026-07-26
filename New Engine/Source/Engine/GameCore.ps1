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

    [Void]Run() {
        $this.Setup()

        $this.Sw.Start()

        $this.Janitor.PerformSystemSetupChecks($this.ContextBroadcaster)

        While($this.IsRunning -EQ $true) {
            [Double]$CurrentTime = $this.Sw.Elapsed.TotalSeconds
            [Double]$Dt = $CurrentTime - $this.LastTime
            $this.LastTime = $CurrentTime

            $this.Janitor.PerformRegularChecks(
                $this.ContextBroadcaster,
                $this.BufferSpec
            )

            Write-Host "`e[?2026h" -NoNewline
            $this.Logic()
            Write-Host "`e[?2026l" -NoNewline

            [Double]$FrameWorkTime = $this.Sw.Elapsed.TotalSeconds - $CurrentTime
            [Double]$SleepTimeSeconds = $this.TargetFrameTime - $FrameWorkTime

            If($SleepTimeSeconds -GT 0) {
                [Thread]::Sleep([Int]($SleepTimeSeconds * 1000))
            }

            Write-Host "$($Dt)"
        }
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
    }
}
