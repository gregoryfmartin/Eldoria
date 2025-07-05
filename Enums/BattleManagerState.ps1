#//////////////////////////////////////////////////////////////////////////////
#
# BATTLE MANAGER STATE
#
# EXPRESSES THE INTERNAL STATES OF THE BATTLE MANAGER. REFER TO THE BATTLE
# MANAGER CLASS FOR FURTHER DOCUMENTATION OF EACH STATE.
#
#//////////////////////////////////////////////////////////////////////////////

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
