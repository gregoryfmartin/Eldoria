using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERAINBOWPRISM
#
###############################################################################

Class BERainbowPrism : BEJewelry {
	BERainbowPrism() : base() {
		$this.Name               = 'Rainbow Prism'
		$this.MapObjName         = 'rainbowprism'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A faceted prism that refracts light into a rainbow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
