using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERBALISTSTUNIC
#
###############################################################################

Class BEHerbalistsTunic : BEArmor {
	BEHerbalistsTunic() : base() {
		$this.Name               = 'Herbalist''s Tunic'
		$this.MapObjName         = 'herbaliststunic'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic with many pockets for herbs, slightly protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
