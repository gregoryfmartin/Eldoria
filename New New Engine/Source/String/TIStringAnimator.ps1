using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# TI STRING ANIMATOR
#
###############################################################################

Class TIStringAnimator {
    [TIString[]]$Frames
    [TIStringMode]$Mode
    [Double]$FrameDuration
    [Double]$Timer
    [Int]$CurrentFrameIndex
    
    TIStringAnimator() {
        $this.Frames            = @()
        $this.Mode              = [TIStringMode]::Sixel
        $this.FrameDuration     = 0.0
        $this.Timer             = 0.0
        $this.CurrentFrameIndex = 0

        If($(Get-Variable -Name IsMacOS)) {
            $this.Mode = [TIStringMode]::KGP
        }
    }
    
    TIStringAnimator(
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
