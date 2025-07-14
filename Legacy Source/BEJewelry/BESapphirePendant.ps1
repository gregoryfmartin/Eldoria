using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAPPHIREPENDANT
#
###############################################################################

Class BESapphirePendant : BEJewelry {
	BESapphirePendant() : base() {
		$this.Name               = 'Sapphire Pendant'
		$this.MapObjName         = 'sapphirependant'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A silver pendant featuring a deep blue sapphire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
