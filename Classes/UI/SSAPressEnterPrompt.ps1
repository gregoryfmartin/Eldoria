using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SSA PRESS ENTER PROMPT
#
###############################################################################

Class SSAPressEnterPrompt {
    Static [Int]$DrawTop    = 15
    Static [Int]$DrawLeft   = 35
    Static [Int]$DataLength = 11

    Static [String]$LineBlankData = ' ' * [SSAPressEnterPrompt]::DataLength

    [Boolean]$Dirty
    [Boolean]$DrawMode
    [ATStringComposite]$Text

    SSAPressEnterPrompt() {
        $this.Dirty    = $true
        $this.DrawMode = $false
        $this.Text     = [ATStringComposite]::new(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAPressEnterPrompt]::DrawTop
                        Column = [SSAPressEnterPrompt]::DrawLeft
                    }
                }
                UserData   = "$([SSAPressEnterPrompt]::LineBlankData)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Coordinates     = [ATCoordinates]@{
                        Row    = [SSAPressEnterPrompt]::DrawTop
                        Column = [SSAPressEnterPrompt]::DrawLeft
                    }
                }
                UserData   = 'PRESS ENTER'
                UseATReset = $true
            }
        ))
    }

    [Void]Draw() {
        If($this.Dirty -EQ $true) {
            If($this.DrawMode -EQ $false) {
                Write-Host "$($this.Text.CompositeActual[0].ToAnsiControlSequenceString())"
                $this.Dirty = $false
            } Else {
                Write-Host "$($this.Text.CompositeActual[1].ToAnsiControlSequenceString())"
                $this.Dirty = $false
            }
        }
    }
}
