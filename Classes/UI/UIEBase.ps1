using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# UIEBASE
#
# THE BASE COMPONENT FOR ALL USER INTERFACE OBJECTS.
#
###############################################################################

Class UIEBase : ATString {
    [Boolean]$Dirty

    [String]$Blank
    
    UIEBase() : base() {
        $this.Dirty = $false
        $this.Blank = ' '
    }
    
    [Void]SetUserData(
        [String]$UserData
    ) {
        If(($null -NE $UserData) -AND ($UserData.Length -GT 0)) {
            If($this.Blank.Length -LT $UserData.Length) {
                $this.SetBlankSize($UserData.Length)
            }
            $this.UserData = $UserData
        }
    }
    
    [Void]SetBlankSize(
        [Int]$Size
    ) {
        If($Size -LE 0) {
            $this.Blank = ' '
        } Else {
            $this.Blank = ' ' * $Size
        }
    }
    
    [String]ToAnsiControlSequenceString() {
        Return "$($this.Prefix.Coordinates.ToAnsiControlSequenceString())$($this.Blank)$(([ATString]$this).ToAnsiControlSequenceString())"
    }
    
    [Void]Draw() {
        If($this.Dirty -EQ $true) {
            Write-Host "$($this.ToAnsiControlSequenceString())"
            
            $this.Dirty = $false
        }
    }
}
