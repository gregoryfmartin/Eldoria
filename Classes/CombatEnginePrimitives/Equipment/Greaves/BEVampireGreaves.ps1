using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIREGREAVES
#
###############################################################################

Class BEVampireGreaves : BEGreaves {
	BEVampireGreaves() : base() {
		$this.Name               = 'Vampire Greaves'
		$this.MapObjName         = 'vampiregreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that drain life from foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
