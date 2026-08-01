using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# BATTLE MANAGER STATE
#
# EXPRESSES THE INTERNAL STATES OF THE BATTLE MANAGER. REFER TO THE BATTLE
# MANAGER CLASS FOR FURTHER DOCUMENTATION OF EACH STATE.
#
# THIS EVENTUALLY GOES AWAY BECAUSE OF THE STATE MACHINE IMPLEMENTATION.
#
###############################################################################

Enum BattleManagerState {
    HealthCheck
    TurnIncrement
    PhaseOrdering
    PhaseAExecution
    PhaseBExecution
    Calculation
    BattleWon
    BattleLost
}
