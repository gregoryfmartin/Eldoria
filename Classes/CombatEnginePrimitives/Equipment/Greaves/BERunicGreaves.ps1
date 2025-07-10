using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNICGREAVES
#
###############################################################################

Class BERunicGreaves : BEGreaves {
	BERunicGreaves() : base() {
		$this.Name               = 'Runic Greaves'
		$this.MapObjName         = 'runicgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves inscribed with ancient runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
