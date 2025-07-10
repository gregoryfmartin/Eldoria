using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDERERSBOOTSCHARM
#
###############################################################################

Class BEWanderersBootsCharm : BEJewelry {
	BEWanderersBootsCharm() : base() {
		$this.Name               = 'Wanderer''s Boots Charm'
		$this.MapObjName         = 'wanderersbootscharm'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a tiny boot, for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
