using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERGREAVES
#
###############################################################################

Class BESorcererGreaves : BEGreaves {
	BESorcererGreaves() : base() {
		$this.Name               = 'Sorcerer Greaves'
		$this.MapObjName         = 'sorcerergreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light greaves that aid in spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
