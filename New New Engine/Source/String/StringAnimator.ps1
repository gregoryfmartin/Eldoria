using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# STRING ANIMATOR
#
# A TAKE ON TI STRING ANIMATOR THAT DOESN'T DEAL WITH TEXT-IMAGE STRING
# ENCODINGS.
#
###############################################################################

Class StringAnimator {
    [String[]]$Frames
    [Double]$FrameDuration
    [Double]$Timer
    [Int]$CurrentFrameIndex

    StringAnimator() {
        $this.Frames            = @()
        $this.FrameDuration     = 0.0
        $this.Timer             = 0.0
        $this.CurrentFrameIndex = 0
    }

    StringAnimator(
        [String[]]$Frames,
        [Int]$Fps
    ) {
        $this.Frames            = $Frames
        $this.FrameDuration     = 1.0 / $Fps
        $this.Timer             = 0.0
        $this.CurrentFrameIndex = 0
    }

    [Void]Update(
        [Double]$Dt
    ) {
        $this.Timer += $Dt

        If($this.Timer -GE $this.FrameDuration) {
            $this.Timer = 0.0
            $this.CurrentFrameIndex = ($this.CurrentFrameIndex + 1) % $this.Frames.Length
        }

        # While($this.Timer -GE $this.FrameDuration) {
        #     $this.Timer             -= $this.FrameDuration
        #     $this.CurrentFrameIndex  = ($this.CurrentFrameIndex + 1) % $this.Frames.Length
        # }
    }

    [String]GetCurrentFrame() {
        Return "$($this.Frames[$this.CurrentFrameIndex])"
    }
}
