using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest





################################################################################
#
# GS UI TEST SCREEN
#
################################################################################

Class GSUiTestScreen : SMState {
    [UICharacterStatusSummaryPanel]$SamplePanel

    GSUiTestScreen() : base('GSUiTestScreen') {
        # $this.UiElementListing[1] = [UICheckbox]::new(
        #     'Sample Checkbox Label',
        #     [ATCoordinates]::new(1, 1)
        # )
        # $this.UiElementListing[2] = [UIChevron]::new(
        #     [UIChevronOrientation]::Left,
        #     [ATCoordinates]::new(2, 1)
        # )
        # $this.UiElementListing[3] = [UIChevron]::new(
        #     [UIChevronOrientation]::Right,
        #     [ATCoordinates]::new(2, 2)
        # )
        # $this.UiElementListing[4] = [UICellSpinner]::new(
        #     5,
        #     [ColorLibrary]::ApplePinkLight
        # )
        # $this.UiElementListing[4].Prefix.Coordinates = [ATCoordinates]::new(3, 1)
        # $this.UiElementListing[5] = [UICellSpinner]::new(
        #     35,
        #     [ColorLibrary]::AppleMintLight
        # )
        # $this.UiElementListing[5].Prefix.Coordinates = [ATCoordinates]::new(4, 1)

        $this.SamplePanel = [UICharacterStatusSummaryPanel]::new()

        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context
            Write-Host "$([ATControlSequences]::CursorHide)" -NoNewline
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

            [SMState]$SelfState                = $Context.References[[SMState]::ContextEldoriaCore].GameState.States[$Context.References[[SMState]::ContextEldoriaCore].GameState.CurrentState]
            [List[ConsoleKeyInfo]]$KeysPressed = $Context.References[[SMState]::ContextKeysPressed]

            If($KeysPressed.Count -GT 0) {
                If($KeysPressed[0].Key -EQ [ConsoleKey]::Spacebar) {
                    $SelfState.SamplePanel.ToggleActive()
                }
                If($KeysPressed[0].Key -EQ [ConsoleKey]::A) {
                    $SelfState.SamplePanel.SetBorderColor([ColorLibrary]::ApplePinkLight)
                }
                If($KeysPressed[0].Key -EQ [ConsoleKey]::B) {
                    $SelfState.SamplePanel.SetBorderColor([ColorLibrary]::AppleOrangeLight)
                }
            }

            $SelfState.SamplePanel.Update($Context)

            Write-Host "$([ATControlSequences]::DrawOptimizeOn)" -NoNewline
            $SelfState.SamplePanel.Draw()
            Write-Host "$([ATControlSequences]::DrawOptimizeOff)" -NoNewline
        }
    }
}
