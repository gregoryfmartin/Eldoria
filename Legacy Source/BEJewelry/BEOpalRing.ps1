using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOPALRING
#
###############################################################################

Class BEOpalRing : BEJewelry {
	BEOpalRing() : base() {
		$this.Name               = 'Opal Ring'
		$this.MapObjName         = 'opalring'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An iridescent opal ring, rumored to bring good fortune.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
