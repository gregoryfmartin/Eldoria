using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECINDERSTONEBRACELET
#
###############################################################################

Class BECinderstoneBracelet : BEJewelry {
	BECinderstoneBracelet() : base() {
		$this.Name               = 'Cinderstone Bracelet'
		$this.MapObjName         = 'cinderstonebracelet'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet made of cooled volcanic cinder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
