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

            If($null -EQ $Context) {
                # THIS IS A FATAL ERROR
                [ContextBroadcaster]::StaticBroadcast(
                    "$([CustomEvents]::BadContext)",
                    $this,
                    [Context]::new(
                        @(
                            $this
                        )
                    )
                )

                Return
            }
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            If($null -EQ $Context) {
                # THIS IS A FATAL ERROR
                [ContextBroadcaster]::StaticBroadcast(
                    "$([CustomEvents]::BadContext)",
                    $this,
                    [Context]::new(
                        @(
                            $this
                        )
                    )
                )

                Return
            }
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            If($null -EQ $Context) {
                # THIS IS A FATAL ERROR
                [ContextBroadcaster]::StaticBroadcast(
                    "$([CustomEvents]::BadContext)",
                    $this,
                    [Context]::new(
                        @(
                            $this
                        )
                    )
                )

                Return
            }

            # THE FIRST ELEMENT IN THE CONTEXT IS THE DELTA TIME
        }
    }
}
