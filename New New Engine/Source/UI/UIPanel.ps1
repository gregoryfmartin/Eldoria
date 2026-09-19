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
        $this.InitializeTabFocusHandling()
    }

    UIPanel(
        [Hashtable]$UiElementListing
    ) : base() {
        $this.ActiveIndex      = 0
        $this.UiElementListing = $UiElementListing
        $this.InitializeTabFocusHandling()
    }

    [Void]InitializeTabFocusHandling() {
        $this.Subscribe(@{
            'SMUiElementFocused_OnUpdate' = {
                Param([Context]$Context)
                [UIPanel]$Self = $Context.References[0]
                [Context]$OriginalContext = $Context.References[1]
                [Collections.Generic.List[ConsoleKeyInfo]]$KeysPressed = $OriginalContext.References[[SMState]::ContextKeysPressed]

                If ($null -ne $KeysPressed -and $KeysPressed.Count -gt 0) {
                    $TabKey = $null
                    Foreach ($KeyPress in $KeysPressed) {
                        If ($KeyPress.Key -eq [ConsoleKey]::Tab) {
                            $TabKey = $KeyPress
                            Break
                        }
                    }
                    If ($null -ne $TabKey) {
                        $Self.CycleFocus($OriginalContext)
                        $KeysPressed.Remove($TabKey) > $null
                    }
                }
            }
            'SMUiElementActive_OnUpdate' = {
                Param([Context]$Context)
                [UIPanel]$Self = $Context.References[0]
                [Context]$OriginalContext = $Context.References[1]
                [Collections.Generic.List[ConsoleKeyInfo]]$KeysPressed = $OriginalContext.References[[SMState]::ContextKeysPressed]

                If ($null -ne $KeysPressed -and $KeysPressed.Count -gt 0) {
                    $TabKey = $null
                    Foreach ($KeyPress in $KeysPressed) {
                        If ($KeyPress.Key -eq [ConsoleKey]::Tab) {
                            $TabKey = $KeyPress
                            Break
                        }
                    }
                    If ($null -ne $TabKey) {
                        $Self.CycleFocus($OriginalContext)
                        $KeysPressed.Remove($TabKey) > $null
                    }
                }
            }
        })
    }

    [Void]CycleFocus([Context]$OriginalContext) {
        If ($this.UiElementListing.Count -eq 0) { Return }

        [Int[]]$Keys = [Int[]]@($this.UiElementListing.Keys)
        [Array]::Sort($Keys)

        [Int]$CurrentKeyIndex = [Array]::IndexOf($Keys, $this.ActiveIndex)
        If ($CurrentKeyIndex -lt 0) {
            $CurrentKeyIndex = -1
        }

        [Int]$NextKeyIndex = ($CurrentKeyIndex + 1) % $Keys.Length
        $this.ActiveIndex = $Keys[$NextKeyIndex]

        Foreach ($UiElement in $this.UiElementListing.GetEnumerator()) {
            [Context]$ElementContext = [Context]::new(@($UiElement.Value, $OriginalContext))
            If ($UiElement.Key -eq $this.ActiveIndex) {
                $UiElement.Value.Focus($ElementContext)
            } Else {
                $UiElement.Value.Unfocus($ElementContext)
            }
        }
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
