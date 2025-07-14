using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BA CLUB SWING
#
###############################################################################

Class BAClubSwing : BattleAction {
    BAClubSwing() : base() {
        $this.Name        = 'Club Swing'
        $this.Description = 'Me Ooga. Me swing-um big-um stick.'
        $this.Type        = [BattleActionType]::Physical
        $this.MpCost      = 0
        $this.EffectValue = 70
        $this.Chance      = 0.7
    }
}
