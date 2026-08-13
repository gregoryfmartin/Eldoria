using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# UI CELL SPINNER
#
# A SPINNER THAT OCCUPIES A SINGLE BUFFER CELL.
#
###############################################################################

Class UICellSpinner : UIBase {
    [StringAnimator]$Animator
    [Double]$AnimationSpeedScalar

    UICellSpinner() : base() {
        $this.Animator = [StringAnimator]::new(
            @(
                '|',
                '\',
                '-',
                '/'
            ),
            2 # START WITH SOMETHING SMALL SO I CAN TEST IT
        )
        $this.AnimationSpeedScalar = 1.0 # I'M NOT EVEN SURE I'M GOING TO USE THIS, BUT I'M HANGING ONTO IT FOR THE TIME BEING
    }

    UICellSpinner(
        [Int]$Fps,
        [TrueColor]$ForegroundColor
    ) : base() {
        $this.Animator = [StringAnimator]::new(
            @(
                '|',
                '\',
                '-',
                '/'
            ),
            $Fps
        )
        $this.AnimationSpeedScalar   = 1.0
        $this.Prefix.ForegroundColor = [ATForegroundColor24]::new($ForegroundColor)
    }

    [Void]Update(
        [Double]$Dt
    ) {
        $this.Animator.Update($Dt)
        $this.SetUserData("$($this.Animator.GetCurrentFrame())")

        # THIS MIGHT NEED INVESTIGATED A BIT MORE
        $this.Dirty = $true
    }
}
