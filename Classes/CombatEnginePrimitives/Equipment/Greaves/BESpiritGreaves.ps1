using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITGREAVES
#
###############################################################################

Class BESpiritGreaves : BEGreaves {
	BESpiritGreaves() : base() {
		$this.Name               = 'Spirit Greaves'
		$this.MapObjName         = 'spiritgreaves'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that resonate with spiritual energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
