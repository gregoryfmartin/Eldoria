using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONBOUNDVEST
#
###############################################################################

Class BEIronboundVest : BEArmor {
	BEIronboundVest() : base() {
		$this.Name               = 'Ironbound Vest'
		$this.MapObjName         = 'ironboundvest'
		$this.PurchasePrice      = 310
		$this.SellPrice          = 155
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest with iron plates sewn into the fabric for added protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
