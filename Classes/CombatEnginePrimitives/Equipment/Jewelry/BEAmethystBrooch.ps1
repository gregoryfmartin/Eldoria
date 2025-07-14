using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMETHYSTBROOCH
#
###############################################################################

Class BEAmethystBrooch : BEJewelry {
	BEAmethystBrooch() : base() {
		$this.Name               = 'Amethyst Brooch'
		$this.MapObjName         = 'amethystbrooch'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A purple amethyst brooch, known to enhance wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
