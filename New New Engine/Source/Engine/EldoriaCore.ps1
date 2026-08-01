using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# ELDORIA CORE
#
###############################################################################

Class EldoriaCore : GameCore {
    EldoriaCore() {}

    [Void]InitializeStates() {
        $this.GameState = [SMStateMachine]::new('Init')

        $this.GameState.AddState([GSInit]::new())

        # $this.GameState.AddState(
        #     [SMState]::new(
        #         'Init',
        #         $null, # ENTER WILL NEVER BE CALLED ON INITIAL STATE ASSIGNMENT
        #         {
        #             Write-Host 'Leaving the Init State.'
        #         }, # EXITING THIS STATE ISN'T YET WELL DEFINED
        #         {
        #             Param(
        #                 [Context]$Context
        #             )

        #             # CONTEXT LAYOUT HERE IS
        #             # 0 - DELTA TIME
        #             # 1 - KEYS PRESSED
        #             # 2 - SELF
        #             $Context.References[2].GameState.Trigger('Ready')
        #         }
        #     )
        # )

        $this.GameState.AddState(
            [SMState]::new(
                'SplashScreenA',
                {
                    Write-Host 'Entered Splash Screen A State'
                }, # ENTER WILL BE CALLED HERE SINCE IT'S COMING FROM INIT
                {
                    Write-Host 'Leaving the Splash Screen A State'
                }, # EXITING THIS STATE ISN'T YET WELL DEFINED
                {
                    Param(
                        [Context]$Context
                    )

                    # CONTEXT LAYOUT HERE IS
                    # 0 - DELTA TIME
                    # 1 - KEYS PRESSED
                    # 2 - SELF
                    If($Context.References[1].Count -GT 0) {
                        Foreach($KeyPress in $Context.References[1]) {
                            Write-Host "$($KeyPress.Key.ToString())"
                        }
                    }
                }
            )
        )

        $this.GameState.AddTransition(
            [SMTransition]::new(
                'Init',
                'Ready',
                'SplashScreenA'
            )
        )
    }
}
