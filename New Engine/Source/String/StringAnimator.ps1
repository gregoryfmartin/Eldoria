using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# STRING ANIMATOR
#
# ANIMATES STRINGS, SPECIFICALLY TI STRINGS. MANAGES ITS OWN DURATION, BUT
# RELIES ON DELTA TIME FROM UPSTREAM. DEFAULTS TO SIXEL, BUT WILL CHANGE TO
# KGP IF ON MACOS. THIS ISN'T A ROBUST CHECK, BUT WHO CARES AT THIS POINT.
#
###############################################################################

Class StringAnimator {
    [TIString[]]$Frames
    [TIStringMode]$Mode
    [Double]$FrameDuration
    [Double]$Timer
    [Int]$CurrentFrameIndex
    
    StringAnimator() {
        $this.Frames            = @()
        $this.Mode              = [TIStringMode]::Sixel
        $this.FrameDuration     = 0.0
        $this.Timer             = 0.0
        $this.CurrentFrameIndex = 0

        If($(Get-Variable -Name IsMacOS)) {
            $this.Mode = [TIStringMode]::KGP
        }
    }
    
    StringAnimator(
        [TIString[]]$Frames,
        [Int]$Fps
    ) {
        $this.Frames            = $Frames
        $this.Mode              = [TIStringMode]::Sixel
        $this.FrameDuration     = 1.0 / $Fps
        $this.Timer             = 0.0
        $this.CurrentFrameIndex = 0

        If($(Get-Variable -Name IsMacOS)) {
            $this.Mode = [TIStringMode]::KGP
        }
    }
    
    [Void]Update(
        [Double]$Dt
    ) {
        $this.Timer += $Dt
        
        While($this.Timer -GE $this.FrameDuration) {
            $this.Timer             -= $this.FrameDuration
            $this.CurrentFrameIndex  = ($this.CurrentFrameIndex + 1) % $this.Frames.Length
        }
    }
    
    [String]GetCurrentFrame() {
        Return "$($this.Frames[$this.CurrentFrameIndex].GetModeVariant($this.Mode))"
    }
}
