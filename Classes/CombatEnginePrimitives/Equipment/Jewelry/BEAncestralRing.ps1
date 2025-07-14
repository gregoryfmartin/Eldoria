using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCESTRALRING
#
###############################################################################

Class BEAncestralRing : BEJewelry {
	BEAncestralRing() : base() {
		$this.Name               = 'Ancestral Ring'
		$this.MapObjName         = 'ancestralring'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring passed down through generations, holding ancient wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
