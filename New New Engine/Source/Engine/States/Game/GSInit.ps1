using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# GS INIT
#
###############################################################################

Class GSInit : SMState {
    GSInit() : base('Init') {
        $this.OnEnter = $null

        $this.OnExit = {
            # THIS IS ONLY FOR TESTING PURPOSES ONLY!
            # INIT WOULD NEVER ACTUALLY WRITE ANYTHING OUT TO CONSOLE
            # IN PROD!
            Write-Host 'Leaving init state'
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            # CONTEXT LAYOUT HERE IS
            # 0 - DELTA TIME
            # 1 - KEYS PRESSED
            # 2 - ELDORIA CORE
            $Context.References[2].GameState.Trigger('Ready')
        }
    }
}
