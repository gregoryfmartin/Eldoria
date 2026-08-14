using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest





################################################################################
#
# UI CHARACTER STATUS SUMMARY PANEL
#
# THIS IS GOING TO END UP BEING AN AMALGAMATION OF WHAT USED TO BE THE WINDOWBASE
# IMPLEMENTATIONS AND WHAT I COBBLED TOGETHER IN THE GS UI TEST SCREEN.
#
# THIS WINDOW IMPLEMENTATION ENDS UP BEING A LITTLE DIFFERENT BECAUSE THERE'S
# SUPPOSED TO BE MULTIPLE OF THESE. FOR TESTING PURPOSES, I'LL RETAIN THE
# STATIC MEMBERS.
#
################################################################################

Class UICharacterStatusSummaryPanel : UIPanel {
    Static [Int]$WindowLTRow    = 1 * 4
    Static [Int]$WindowLTColumn = 1 * 4
    Static [Int]$WindowRBRow    = 10 * 2
    Static [Int]$WindowRBColumn = 19 * 2

    UICharacterStatusSummaryPanel() : base() {
        $this.LeftTop = [ATCoordinates]::new(
            [UICharacterStatusSummaryPanel]::WindowLTRow,
            [UICharacterStatusSummaryPanel]::WindowLTColumn
        )
        $this.RightBottom = [ATCoordinates]::new(
            [UICharacterStatusSummaryPanel]::WindowRBRow,
            [UICharacterStatusSummaryPanel]::WindowRBColumn
        )

        $this.UpdateDimensions()
        $this.SetupTitle(
            'Char Name',
            [ColorLibrary]::TextColor
        )

        # NEW SHIT - ADD UI ELEMENTS
        $this.UiElementListing[0] = [UICheckbox]::new(
            'Sample Checkbox Label',
            [ATCoordinates]::new(
                ([UICharacterStatusSummaryPanel]::WindowLTRow + 1),
                ([UICharacterStatusSummaryPanel]::WindowLTColumn + 1)
            )
        )
        $this.UiElementListing[1] = [UIChevron]::new(
            [UIChevronOrientation]::Left,
            [ATCoordinates]::new(
                ([UICharacterStatusSummaryPanel]::WindowLTRow + 2),
                ([UICharacterStatusSummaryPanel]::WindowLTColumn + 1)
            )
        )
        $this.UiElementListing[2] = [UIChevron]::new(
            [UIChevronOrientation]::Right,
            [ATCoordinates]::new(
                ([UICharacterStatusSummaryPanel]::WindowLTRow + 2),
                ([UICharacterStatusSummaryPanel]::WindowLTColumn + 2)
            )
        )
        $this.UiElementListing[3] = [UICellSpinner]::new(
            5,
            [ColorLibrary]::ApplePinkLight
        )
        $this.UiElementListing[3].Prefix.Coordinates = [ATCoordinates]::new(
            ([UICharacterStatusSummaryPanel]::WindowLTRow + 3),
            ([UICharacterStatusSummaryPanel]::WindowLTColumn + 1)
        )
        $this.UiElementListing[4] = [UICellSpinner]::new(
            35,
            [ColorLibrary]::AppleMintLight
        )
        $this.UiElementListing[4].Prefix.Coordinates = [ATCoordinates]::new(
            ([UICharacterStatusSummaryPanel]::WindowLTRow + 4),
            ([UICharacterStatusSummaryPanel]::WindowLTColumn + 1)
        )
        $this.ToggleActive(); $this.ToggleActive()
    }

    [Void]Update(
        [Context]$Context
    ) {
        Confirm-Context $Context

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

        # If($Context.References[[SMState]::ContextKeysPressed].Count -GT 0) {
        #     If($Context.References[[SMState]::ContextKeysPressed][0].Key -EQ [ConsoleKey]::Spacebar) {
        #         $SelfState.SamplePanel.ToggleActive()
        #     } Elseif()
        # }

        ([UIPanel]$this).Update($Context)
    }
}
