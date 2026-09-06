using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI PANEL
#
# A SPECIALIZATION OF UI CONTAINER INTENDED TO HOUSE UI ELEMENTS. THE PRIMARY
# TOOLING HERE IS MANAGEMENT OF TAB FOCUS FLOW. UI PANELS DON'T ATTEMPT TO
# LAYOUT THEIR ELEMENTS, BECAUSE I'M NOT ABOUT TO GET INVOLVED IN THAT HORSESHIT.
# YOU KNOW WHERE THE CONTAINER IS AND ITS DIMENSIONS, LET'S BE REAL AND PLACE
# SHIT WHERE IT'S SUPPOSED TO GO.
#
###############################################################################

Class UIPanel : UIContainer {
    [Int]$ActiveIndex
    [Hashtable]$UiElementListing

    UIPanel() : base() {
        $this.ActiveIndex      = 0
        $this.UiElementListing = @{}
    }

    UIPanel(
        [Hashtable]$UiElementListing
    ) : base() {
        $this.ActiveIndex      = 0
        $this.UiElementListing = $UiElementListing
    }

    [Void]Update(
        [Context]$Context
    ) {
        ([UIContainer]$this).Update($Context)

        If($this.Active -EQ $true) {
            Foreach($UiElement in $this.UiElementListing.GetEnumerator()) {
                $UiElement.Value.Update([Context]::new(@(
                    $UiElement.Value,
                    $Context
                )))
            }
        }
    }

    [Void]Draw() {
        ([UIContainer]$this).Draw()
        
        If($this.Active -EQ $true) {
            Foreach($UiElement in $this.UiElementListing.GetEnumerator()) {
                $UiElement.Value.Draw()
            }
        }
    }

    [Void]Activate(
        [Context]$Context
    ) {
        ([UIContainer]$this).Activate($Context)

        Foreach($UiElement in $this.UiElementListing.GetEnumerator()) {
            $UiElement.Value.Activate([Context]::new(@(
                $UiElement.Value,
                $Context
            )))
        }
    }

    [Void]Deactivate(
        [Context]$Context
    ) {
        ([UIContainer]$this).Deactivate($Context)

        Foreach($UiElement in $this.UiElementListing.GetEnumerator()) {
            $UiElement.Value.Deactivate([Context]::new(@(
                $UiElement.Value,
                $Context
            )))
        }
    }
}
