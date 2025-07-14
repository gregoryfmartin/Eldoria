using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHAMANGREAVES
#
###############################################################################

Class BEShamanGreaves : BEGreaves {
	BEShamanGreaves() : base() {
		$this.Name               = 'Shaman Greaves'
		$this.MapObjName         = 'shamangreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a spiritual guide.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
