using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE ACTION RESULT
#
###############################################################################

Class BattleActionResult {
    [Int]$ActionEffectSum
    [BattleEntity]$Originator
    [BattleEntity]$Target
    [BattleActionResultType]$Type

    BattleActionResult() {
        $this.ActionEffectSum = 0
        $this.Originator      = $null
        $this.Target          = $null
        $this.Type            = [BattleActionResultType]::Success
    }
}
