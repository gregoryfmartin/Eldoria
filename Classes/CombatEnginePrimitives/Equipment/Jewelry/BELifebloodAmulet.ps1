using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIFEBLOODAMULET
#
###############################################################################

Class BELifebloodAmulet : BEJewelry {
	BELifebloodAmulet() : base() {
		$this.Name               = 'Lifeblood Amulet'
		$this.MapObjName         = 'lifebloodamulet'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet pulsating with life energy, granting vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
