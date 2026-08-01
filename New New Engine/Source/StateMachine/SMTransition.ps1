using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# FINITE STATE MACHINE IMPLEMENTATION
#
# SMTRANSITION
#
# HOW TO TRANSITION BETWEEN STATES.
#
###############################################################################

Class SMTransition {
    [String]$FromState
    [String]$UserEvent
    [String]$ToState
    [ScriptBlock]$Action

    SMTransition(
        [String]$FromState,
        [String]$UserEvent,
        [String]$ToState
    ) {
        $this.FromState = $FromState
        $this.UserEvent = $UserEvent
        $this.ToState   = $ToState
    }

    SMTransition(
        [String]$FromState,
        [String]$UserEvent,
        [String]$ToState,
        [ScriptBlock]$Action
    ) {
        $this.FromState = $FromState
        $this.UserEvent = $UserEvent
        $this.ToState   = $ToState
        $this.Action    = $Action
    }
}
