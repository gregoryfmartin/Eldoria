using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# GS SPLASH SCREEN A
#
###############################################################################

Class GSSplashScreenA : SMState {
    GSSplashScreenA() : base('GSSplashScreenA') {
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
        }
    }
}
