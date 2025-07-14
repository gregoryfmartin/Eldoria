using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# UIE CONTAINER
#
###############################################################################

Class UIEContainer {
    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [Int]$Width
    [Int]$Height
    [Stack[UIEContainer]]$Children
    [UIELayout]$Layout

    UIEContainer() {
        $this.LeftTop     = [ATCoordinates]::new()
        $this.RightBottom = [ATCoordinates]::new()
        $this.Width       = 0
        $this.Height      = 0
        $this.Children    = [Stack[UIEContainer]]::new()
        $this.Layout      = [UIELayout]::Vertical
    }

    [Void]UpdateDimensions() {
        If($this.Children.Count -EQ 0) {
            $this.Width  = $this.LeftTop.Column + $this.RightBottom.Column
            $this.Height = $this.LeftTop.Row + $this.RightBottom.Row
        } Else {
            $this.Width  = 0
            $this.Height = 0
    
            Foreach($Child in $this.Children) {
                $this.Width  += $Child.Width
                $this.Height += $Child.Height
            }
        }
    }

    [Void]PushChild(
        [UIEContainer]$Child
    ) {
        If($null -EQ $Child) {
            # PROBABLY SHOULD DO SOMETHING A LITTLE DIFFERENT HERE, BUT WHATEVER
            Return
        }

        Switch($this.Layout) {
            ([UIELayout]::Horizontal) {
                If($this.Children.Count -GT 1) {
                    [UIEContainer]$Top = $this.Children.Peek()

                    $Child.LeftTop.Column = $Top.RightBottom.Column + 2
                    $Child.LeftTop.Row    = $Top.LeftTop.Row

                    $this.Children.Push($Child)
                    $this.UpdateDimensions()
                } Else {
                    $this.Children.Push($Child)
                    $this.UpdateDimensions()
                }
            }

            ([UIELayout]::Vertical) {
                If($this.Children.Count -GT 1) {
                    [UIEContainer]$Top = $this.Children.Peek()

                    # THIS PADDING CALCULATION MIGHT NEED ADJUSTED
                    $Child.LeftTop.Row = $Top.RightBottom.Row + 2

                    # ALIGN LEFT TO THE ABOVE CONTAINER
                    $Child.LeftTop.Column = $Top.LeftTop.Column

                    $this.Children.Push($Child)

                    $this.UpdateDimensions()
                } Else {
                    $this.Children.Push($Child)
                    $this.UpdateDimensions()
                }
            }

            Default {}
        }
    }
}

