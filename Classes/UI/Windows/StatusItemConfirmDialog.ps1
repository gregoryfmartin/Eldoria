using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# STATUS ITEM CONFIRM DIALOG
#
# THIS DIALOG ALLOWS USERS TO EITHER USE OR DROP AN ITEM.
#
###############################################################################

Class StatusItemConfirmDialog : WindowBase {
    Static [Int]$WindowLTRow    = 1
    Static [Int]$WindowLTColumn = 1
    Static [Int]$WindowRBRow    = 4
    Static [Int]$WindowRBColumn = 10
    
    Static [String]$WindowTitle = 'Action'
    
    Static [Hashtable[]]$MenuData = @(
        @{ Label = 'Use';  Action = {} }
        @{ Label = 'Drop'; Action = {
            # THE ITEM TO DROP VARIABLE SHOULD ALREADY BE SET, SO WE CAN JUST TRANSITION STATE
            $Script:TheStatusScreenState = [StatusScreenState]::ItemDropConfirm
        } }
    )
    
    [UIEMenu]$Menu
    
    StatusItemConfirmDialog() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [StatusItemConfirmDialog]::WindowLTRow
            Column = [StatusItemConfirmDialog]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [StatusItemConfirmDialog]::WindowRBRow
            Column = [StatusItemConfirmDialog]::WindowRBColumn
        }
        
        $this.UpdateDimensions()
        $this.SetupTitle([StatusItemConfirmDialog]::WindowTitle, [CCTextDefault24]::new())
        
        $this.Menu = [UIEMenu]::new(
            [StatusItemConfirmDialog]::MenuData,
            $this.LeftTop
        )
    }
    
    [Void]UpdateOrigin(
        [ATCoordinates]$LeftTop
    ) {
        # THIS METHOD IS INTENDED TO BE CALLED WHEN THE INSTANCE IS UPDATED
        $this.LeftTop = [ATCoordinates]@{
            Row    = $LeftTop.Row
            Column = $LeftTop.Column
        }
        
        # THIS SHOULD BE SAFE TO DO... HOPEFULLY??
        $this.RightBottom = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + $this.Height
            Column = $this.LeftTop.Column + $this.Width
        }
        
        # MAYBE THIS NEEDS DONE?
        $this.UpdateDimensions()
        
        $this.Menu = [UIEMenu]::new(
            [StatusItemConfirmDialog]::MenuData,
            $this.LeftTop
        )
    }
    
    [Void]Draw() {
        ([WindowBase]$this).Draw()
        
        $this.Menu.Draw()
    }
    
    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        
        Switch($KeyCap.VirtualKeyCode) {
            38 { # UP ARROW
                $this.Menu.MoveActiveIndexUp()
                $this.Menu.PlayMoveSound()
                
                Break
            }
            
            40 { # DOWN ARROW
                $this.Menu.MoveActiveIndexDown()
                $this.Menu.PlayMoveSound()
                
                Break
            }
            
            27 { # ESCAPE
                # TODO: CHANGE STATE
                $Script:TheStatusScreenState = [StatusScreenState]::Items
                
                Break
            }
            
            13 { # ENTER
                # TODO: TAKE APPROPRIATE ACTION
                
                Break
            }
        }
    }
}
