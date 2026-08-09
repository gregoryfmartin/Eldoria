using namespace System

Set-StrictMode -Version Latest





################################################################################
#
# GS UI TEST SCREEN
#
################################################################################

Class GSUiTestScreen : SMState {
    [UICheckbox]$SampleCheckbox

    GSUiTestScreen() : base('GSUiTestScreen') {
        $this.SampleCheckbox = [UICheckbox]::new(
            'Sample Checkbox Label',
            [ATCoordinates]::new(1, 1)
        )
        $this.SampleCheckbox.ToggleCheckbox()

        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context
            # Write-Host 'Entering GSUiTestScreen'
            Clear-Host
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context
            Clear-Host
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context

            # CONTEXT LAYOUT HERE IS
            # 0 - DELTA TIME
            # 1 - KEYS PRESSED
            # 2 - ELDORIA CORE

            Write-Host "$([ATControlSequences]::DrawOptimizeOn)" -NoNewline

            [SMState]$SelfState = $Context.References[2].GameState.States[$Context.References[2].GameState.CurrentState]

            $SelfState.SampleCheckbox.Draw()

            Write-Host "$([ATControlSequences]::DrawOptimizeOff)" -NoNewline
        }
    }
}
