using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESALAMANDERGREAVES
#
###############################################################################

Class BESalamanderGreaves : BEGreaves {
	BESalamanderGreaves() : base() {
		$this.Name               = 'Salamander Greaves'
		$this.MapObjName         = 'salamandergreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a fire spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
