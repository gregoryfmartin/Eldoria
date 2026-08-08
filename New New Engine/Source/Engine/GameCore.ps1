using namespace System
using namespace System.Diagnostics
using namespace System.Threading
using namespace System.Collections.Generic
using namespace System.Collections.Concurrent
using namespace System.Management.Automation
using namespace System.Management.Automation.Runspaces

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

    [SMStateMachine]$GameState
    [Runspace]$InputRunspace
    [PowerShell]$InputPowerShell

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

    [Void]InitializeStates() {}

    [Void]Setup() {
        # THESE ARE LIKELY GOING TO GO AWAY FOR THE TIME BEING
        # Register-EngineEvent -SourceIdentifier ([CustomEvents]::BadPSEdition) -Action {
        #     [Context]$CurrentContext = $Event.MessageData -AS [Context]

        #     Write-Host ($CurrentContext.References | Out-String)
        # }.GetNewClosure()

        # Register-EngineEvent -SourceIdentifier ([CustomEvents]::BufferHeightTooSmall) -Action {
        #     [Context]$CurrentContext = $Event.MessageData -AS [Context]

        #     Write-Host ($CurrentContext.References | Out-String)
        # }.GetNewClosure()

        # Register-EngineEvent -SourceIdentifier ([CustomEvents]::BufferWidthTooSmall) -Action {
        #     [Context]$CurrentContext = $Event.MessageData -AS [Context]

        #     Write-Host ($CurrentContext.References | Out-String)
        # }.GetNewClosure()

        $Global:InputQueue = [ConcurrentQueue[ConsoleKeyInfo]]::new()

        $this.InputRunspace = [RunspaceFactory]::CreateRunspace()
        $this.InputRunspace.Open()

        $this.InputRunspace.SessionStateProxy.SetVariable('InputQueue', $Global:InputQueue)

        $this.InputPowerShell = [PowerShell]::Create().AddScript({
            While($true) {
                If([Console]::KeyAvailable -EQ $true) {
                    $InputQueue.Enqueue([Console]::ReadKey($true))
                }

                Start-Sleep -Milliseconds 16
            }
        })
        $this.InputPowerShell.Runspace = $this.InputRunspace
        $null = $this.InputPowerShell.BeginInvoke()

        $this.InitializeStates()

        If($null -EQ $this.GameState) {
            Write-Warning "No Game State Machine was initialized!"
            $this.IsRunning = $false
        }

        $this.Sw.Start()

        Clear-Host
    }

    [Void]Logic(
        [Double]$DeltaTime
    ) {
        # Write-Host "$($DeltaTime)"

        [List[ConsoleKeyInfo]]$KeysPressedThisFrame = [List[ConsoleKeyInfo]]::new()
        [ConsoleKeyInfo]$KeyInfo                    = [ConsoleKeyInfo]::new([Char]' ', [ConsoleKey]::None, $false, $false, $false)

        While($Global:InputQueue.TryDequeue([Ref]$KeyInfo)) {
            $KeysPressedThisFrame.Add($KeyInfo)
        }

        If($null -NE $this.GameState) {
            $this.GameState.Update([Context]::new(@(
                $DeltaTime,
                $KeysPressedThisFrame,
                $this
            )))
        }
    }

    [Void]Run() {
        $this.Setup()

        While($this.IsRunning -EQ $true) {
            [Double]$CurrentTime = $this.Sw.Elapsed.TotalSeconds
            [Double]$Dt = $CurrentTime - $this.LastTime
            $this.LastTime = $CurrentTime

            $this.Logic($Dt)

            [Double]$FrameWorkTime = $this.Sw.Elapsed.TotalSeconds - $CurrentTime
            [Double]$SleepTimeSeconds = $this.TargetFrameTime - $FrameWorkTime

            If($SleepTimeSeconds -GT 0) {
                [Thread]::Sleep([Int]($SleepTimeSeconds * 1000))
            }
        }

        $this.Cleanup()
    }

    [Void]Cleanup() {
        If($null -NE $this.InputPowerShell) {
            $this.InputPowerShell.Stop()
            $this.InputPowerShell.Dispose()
        }
        
        If($null -NE $this.InputRunspace) {
            $this.InputRunspace.Close()
            $this.InputRunspace.Dispose()
        }

        If($null -NE $this.Sw) {
            $this.Sw.Stop()
        }
    }
}
