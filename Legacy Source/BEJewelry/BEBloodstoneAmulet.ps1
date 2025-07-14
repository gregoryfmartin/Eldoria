using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLOODSTONEAMULET
#
###############################################################################

Class BEBloodstoneAmulet : BEJewelry {
	BEBloodstoneAmulet() : base() {
		$this.Name               = 'Bloodstone Amulet'
		$this.MapObjName         = 'bloodstoneamulet'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark green bloodstone amulet, rumored to stop bleeding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
