using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# FINITE STATE MACHINE IMPLEMENTATION
#
# SMSTATE
#
# A SINGLE STATE DEFINITION.
#
###############################################################################

Class SMState {
    Static [Int]$ContextDeltaTime   = 0
    Static [Int]$ContextKeysPressed = 1
    Static [Int]$ContextEldoriaCore = 2

    [String]$Name
    [ScriptBlock]$OnEnter
    [ScriptBlock]$OnExit
    [ScriptBlock]$OnUpdate

    SMState(
        [String]$Name
    ) {
        $this.Name = $Name
    }

    SMState(
        [String]$Name,
        [ScriptBlock]$OnEnter,
        [ScriptBlock]$OnExit
    ) {
        $this.Name    = $Name
        $this.OnEnter = $OnEnter
        $this.OnExit  = $OnExit
    }

    SMState(
        [String]$Name,
        [ScriptBlock]$OnEnter,
        [ScriptBlock]$OnExit,
        [ScriptBlock]$OnUpdate
    ) {
        $this.Name     = $Name
        $this.OnEnter  = $OnEnter
        $this.OnExit   = $OnExit
        $this.OnUpdate = $OnUpdate
    }
}
