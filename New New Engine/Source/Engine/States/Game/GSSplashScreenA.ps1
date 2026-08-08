using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# GS SPLASH SCREEN A
#
###############################################################################

Class GSSplashScreenA : SMState {
    [UIContainer]$SampleContainer

    GSSplashScreenA() : base('GSSplashScreenA') {
        $this.SampleContainer             = [UIContainer]::new()
        $this.SampleContainer.LeftTop     = [ATCoordinates]::new(1, 1)
        $this.SampleContainer.RightBottom = [ATCoordinates]::new(5, 10)
        $this.SampleContainer.SetupTitle('Title', [ColorLibrary]::Red)
        $this.SampleContainer.UpdateDimensions()

        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context

            Write-Host 'Entered Splash Screen A State'
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context

            Write-Host 'Leaving Splash Screen A State'
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            Confirm-Context $Context

            # CONTEXT LAYOUT HERE IS
            # 0 - DELTA TIME
            # 1 - KEYS PRESSED
            # 2 - ELDORIA CORE
            If($Context.References[1].Count -GT 0) {
                Foreach($KeyPress in $Context.References[1]) {
                    Write-Host "$($KeyPress.Key.ToString())"
                }
            }

            Write-Host "$([ATControlSequences]::DrawOptimizeOn)" -NoNewline

            # THIS IS SUPER FUCKING DISGUSTING, AND POTENTIALLY UNSAFE, BUT REFERENCES ARE REFERENCES, AND I'M LAZY
            $Context.References[2].GameState.States[$Context.References[2].GameState.CurrentState].SampleContainer.Draw()
            
            Write-Host "$([ATControlSequences]::DrawOptimizeOff)" -NoNewline
        }
    }
}
