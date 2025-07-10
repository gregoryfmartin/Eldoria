using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPERIDOTRING
#
###############################################################################

Class BEPeridotRing : BEJewelry {
	BEPeridotRing() : base() {
		$this.Name               = 'Peridot Ring'
		$this.MapObjName         = 'peridotring'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bright green peridot ring, radiating freshness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
