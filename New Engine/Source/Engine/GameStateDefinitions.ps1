using namespace System
using namespace System.Threading

Set-StrictMode -Version Latest





################################################################################
#
# GAME STATE DEFINITIONS
#
################################################################################

[Hashtable]$Global:GameStateDefinitions = @{
    ([GameState]::Init) = {
        Param(
            [Context]$Context
        )

        # REFERENCE SPEC
        # 0 - GAME CORE
        ($Context.References[0] -AS [GameCore]).Setup()
        ($Context.References[0] -AS [GameCore]).Janitor.PerformSystemSetupChecks(
            ($Context.References[0] -AS [GameCore]).ContextBroadcaster
        )

        # TRANSITION STATE
        Set-NextGameState Running
    }

    ([GameState]::Running) = {
        Param(
            [Context]$Context
        )

        # REFERENCE SPEC
        # 0 - GAME CORE
        [Double]$CurrentTime = ($Context.References[0]).Sw.Elapsed.TotalSeconds
        [Double]$Dt = $CurrentTime - ($Context.References[0]).LastTime
        ($Context.References[0]).LastTime = $CurrentTime

        ($Context.References[0]).Janitor.PerformRegularChecks(
            ($Context.References[0]).ContextBroadcaster,
            ($Context.References[0]).BufferSpec
        )

        Write-Host "`e[?2026h" -NoNewline
        ($Context.References[0]).Logic()
        Write-Host "`e[?2026l" -NoNewline

        [Double]$FrameWorkTime = ($Context.References[0]).Sw.Elapsed.TotalSeconds - $CurrentTime
        [Double]$SleepTimeSeconds = ($Context.References[0]).TargetFrameTime - $FrameWorkTime

        If($SleepTimeSeconds -GT 0) {
            [Thread]::Sleep([Int]($SleepTimeSeconds * 1000))
        }

        Write-Host "$($Dt)"
    }

    ([GameState]::BadEnvironment) = {
        Param(
            [Context]$Context
        )

        # REFERENCE SPEC
        # 0 - GAME CORE
    }

    ([GameState]::Deinit) = {
        Param(
            [Context]$Context
        )

        # REFERENCE SPEC
        # 0 - GAME CORE
    }
}
