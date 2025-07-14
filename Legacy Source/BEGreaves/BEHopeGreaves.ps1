using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOPEGREAVES
#
###############################################################################

Class BEHopeGreaves : BEGreaves {
	BEHopeGreaves() : base() {
		$this.Name               = 'Hope Greaves'
		$this.MapObjName         = 'hopegreaves'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that inspire optimism.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
