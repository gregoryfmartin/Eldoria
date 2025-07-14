using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLOCKGREAVES
#
###############################################################################

Class BEWarlockGreaves : BEGreaves {
	BEWarlockGreaves() : base() {
		$this.Name               = 'Warlock Greaves'
		$this.MapObjName         = 'warlockgreaves'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those who dabble in dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
