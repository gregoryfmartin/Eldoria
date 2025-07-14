using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDGREAVES
#
###############################################################################

Class BEWarlordGreaves : BEGreaves {
	BEWarlordGreaves() : base() {
		$this.Name               = 'Warlord Greaves'
		$this.MapObjName         = 'warlordgreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a powerful military leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
