using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELEMENTALVEST
#
###############################################################################

Class BEElementalVest : BEArmor {
	BEElementalVest() : base() {
		$this.Name               = 'Elemental Vest'
		$this.MapObjName         = 'elementalvest'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that shifts color based on the nearest element, offering minor resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
