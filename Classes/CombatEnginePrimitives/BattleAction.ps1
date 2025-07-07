using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE ACTION
#
# DESCRIBES AN ACTION THAT AN ENTITY CAN TAKE IN BATTLE. ACTIONS GENERALLY ARE
# CAPABLE OF DETERMINING THEIR OWN DAMAGE RESULT AND CAN RUN ROUTINES BEFORE AND
# AFTER SAID CALCULATIONS.
#
###############################################################################

Class BattleAction {
    [String]$Name
    [ScriptBlock]$Effect
    [ScriptBlock]$PreCalc
    [ScriptBlock]$PostCalc
    [BattleActionType]$Type
    [Int]$MpCost
    [Int]$EffectValue
    [Single]$Chance
    [String]$Description

    BattleAction() {
        $this.Name        = ''
        $this.Type        = [BattleActionType]::None
        $this.Effect      = $Script:BaCalc
        $this.PreCalc     = $null
        $this.PostCalc    = $null
        $this.EffectValue = 0
        $this.Chance      = 0.0
        $this.Description = ''
    }

    BattleAction(
        [BattleAction]$Copy
    ) {
        $this.Name        = $Copy.Name
        $this.Type        = $Copy.Type
        $this.Effect      = $Copy.Effect
        $this.PreCalc     = $Copy.PreCalc
        $this.PostCalc    = $Copy.PostCalc
        $this.MpCost      = $Copy.MpCost
        $this.EffectValue = $Copy.EffectValue
        $this.Chance      = $Copy.Chance
        $this.Description = $Copy.Description
    }
}
