using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMMANDERGREAVES
#
###############################################################################

Class BECommanderGreaves : BEGreaves {
	BECommanderGreaves() : base() {
		$this.Name               = 'Commander Greaves'
		$this.MapObjName         = 'commandergreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a battle hardened commander.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
