using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRANDMASTERGREAVES
#
###############################################################################

Class BEGrandmasterGreaves : BEGreaves {
	BEGrandmasterGreaves() : base() {
		$this.Name               = 'Grandmaster Greaves'
		$this.MapObjName         = 'grandmastergreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of unparalleled skill and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
