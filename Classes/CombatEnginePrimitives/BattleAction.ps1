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

    # IT'S UNLIKELY THAT ANY OF THESE CTORS ARE NEEDED
    # BattleAction(
    #     [String]$Name,
    #     [BattleActionType]$Type,
    #     [ScriptBlock]$Effect,
    #     [Int]$Uses,
    #     [Int]$EffectValue,
    #     [Single]$Chance
    # ) {
    #     $this.Name        = $Name
    #     $this.Type        = $Type
    #     $this.Effect      = $Effect
    #     $this.PreCalc     = {}
    #     $this.PostCalc    = {}
    #     $this.EffectValue = $EffectValue
    #     $this.Chance      = $Chance
    #     $this.Description = ''
    # }

    # BattleAction(
    #     [String]$Name,
    #     [String]$Description,
    #     [BattleActionType]$Type,
    #     [ScriptBlock]$Effect,
    #     [Int]$Uses,
    #     [Int]$UsesMax,
    #     [Int]$EffectValue,
    #     [Single]$Chance
    # ) {
    #     $this.Name        = $Name
    #     $this.Type        = $Type
    #     $this.Effect      = $Effect
    #     $this.PreCalc     = {}
    #     $this.PostCalc    = {}
    #     $this.EffectValue = $EffectValue
    #     $this.Chance      = $Chance
    #     $this.Description = $Description
    # }

    # BattleAction(
    #     [String]$Name,
    #     [String]$Description,
    #     [BattleActionType]$Type,
    #     [ScriptBlock]$Effect,
    #     [Int]$MpCost,
    #     [Int]$EffectValue,
    #     [Single]$Chance
    # ) {
    #     $this.Name        = $Name
    #     $this.Type        = $Type
    #     $this.Effect      = $Effect
    #     $this.PreCalc     = {}
    #     $this.PostCalc    = {}
    #     $this.MpCost      = $MpCost
    #     $this.EffectValue = $EffectValue
    #     $this.Chance      = $Chance
    #     $this.Description = $Description
    # }

    # THIS CTOR IS NEEDED BECAUSE POWERSHELL ASSIGNMENT IS BY REFERENCE
    # THANKS C++
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
