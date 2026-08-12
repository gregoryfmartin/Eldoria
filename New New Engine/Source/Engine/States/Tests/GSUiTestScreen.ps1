using namespace System

Set-StrictMode -Version Latest





################################################################################
#
# GS UI TEST SCREEN
#
################################################################################

Class GSUiTestScreen : UIState {
    GSUiTestScreen() : base('GSUiTestScreen') {
        $this.UiElementListing[1] = [UICheckbox]::new(
            'Sample Checkbox Label',
            [ATCoordinates]::new(1, 1)
        )
        $this.UiElementListing[2] = [UIChevron]::new(
            [UIChevronOrientation]::Left,
            [ATCoordinates]::new(2, 1)
        )
        $this.UiElementListing[3] = [UIChevron]::new(
            [UIChevronOrientation]::Right,
            [ATCoordinates]::new(2, 2)
        )

        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context
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

            [SMState]$SelfState = $Context.References[[SMState]::ContextEldoriaCore].GameState.States[$Context.References[[SMState]::ContextEldoriaCore].GameState.CurrentState]

            Foreach($UiElement in $SelfState.UiElementListing.GetEnumerator()) {
                $UiElement.Value.Draw()
            }

            Write-Host "$([ATControlSequences]::DrawOptimizeOff)" -NoNewline
        }
    }
}
