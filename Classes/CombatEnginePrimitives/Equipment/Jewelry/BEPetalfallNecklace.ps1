using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPETALFALLNECKLACE
#
###############################################################################

Class BEPetalfallNecklace : BEJewelry {
	BEPetalfallNecklace() : base() {
		$this.Name               = 'Petalfall Necklace'
		$this.MapObjName         = 'petalfallnecklace'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A necklace adorned with perpetually falling petals, ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
