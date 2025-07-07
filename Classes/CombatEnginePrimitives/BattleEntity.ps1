using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE ENTITY
#
# AN AGGREGATE OF MULTIPLE CLASSES. INTENDED TO DESCRIBE AN ENTITY THAT COULD
# PARTICIPATE IN A BATTLE SITUATION.
#
# NOTABLE PROPERTIES HERE ARE AS FOLLOWS:
#
#  STATS - A HASTABLE [STATID], [BATTLEENTITYPROPERTY]
#  ACTIONLISTING - A HASHTABLE [ACTIONSLOT], [BATTLEACTION]
#  ACTIONMARBLEBAG - A LIST OF FIXED SIZE (10) TO DETMINE ACTION CHANGE LAYOUT
#
###############################################################################

Class BattleEntity {
    [String]$Name
    [Boolean]$CanAct
    [Hashtable]$Stats
    [Hashtable]$ActionListing
    [ScriptBlock]$SpoilsEffect
    [ActionSlot[]]$ActionMarbleBag
    [ConsoleColor24]$NameDrawColor
    [BattleActionType]$Affinity

    BattleEntity() {
        $this.Name            = ''
        $this.CanAct          = $true
        $this.Stats           = @{}
        $this.ActionListing   = @{}
        $this.SpoilsEffect    = $null
        $this.ActionMarbleBag = $null
        $this.NameDrawColor   = [CCTextDefault24]::new()
        $this.Affinity        = [BattleActionType]::None
    }

    [Void]Update() {
        Foreach($a in $this.Stats.Values) {
            $a.Update()
        }
    }
}
