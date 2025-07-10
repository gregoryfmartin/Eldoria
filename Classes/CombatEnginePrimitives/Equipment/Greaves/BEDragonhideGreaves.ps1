using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHIDEGREAVES
#
###############################################################################

Class BEDragonhideGreaves : BEGreaves {
	BEDragonhideGreaves() : base() {
		$this.Name               = 'Dragonhide Greaves'
		$this.MapObjName         = 'dragonhidegreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves made from the tough hide of a dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
