using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWOODENBEADS
#
###############################################################################

Class BEWoodenBeads : BEJewelry {
	BEWoodenBeads() : base() {
		$this.Name               = 'Wooden Beads'
		$this.MapObjName         = 'woodenbeads'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple wooden beads, sometimes used in rituals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
