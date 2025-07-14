using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWISDOMGREAVES
#
###############################################################################

Class BEWisdomGreaves : BEGreaves {
	BEWisdomGreaves() : base() {
		$this.Name               = 'Wisdom Greaves'
		$this.MapObjName         = 'wisdomgreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of profound insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
