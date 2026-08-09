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
        $this.GameState = [SMStateMachine]::new('GSInit')

        $this.GameState.AddState([GSInit]::new())
        $this.GameState.AddState([GSSplashScreenA]::new())
        $this.GameState.AddState([GSAnimatedSodaCanTestScreen]::new())
        $this.GameState.AddState([GSUiTestScreen]::new())

        $this.GameState.AddTransition(
            [SMTransition]::new(
                'GSInit',
                'Ready',
                'GSUiTestScreen'
            )
        )
    }   
}
