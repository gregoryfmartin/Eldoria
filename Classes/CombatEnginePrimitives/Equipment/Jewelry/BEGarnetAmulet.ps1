using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARNETAMULET
#
###############################################################################

Class BEGarnetAmulet : BEJewelry {
	BEGarnetAmulet() : base() {
		$this.Name               = 'Garnet Amulet'
		$this.MapObjName         = 'garnetamulet'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark red garnet amulet, radiating fortitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
