using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICGREAVES
#
###############################################################################

Class BEMysticGreaves : BEGreaves {
	BEMysticGreaves() : base() {
		$this.Name               = 'Mystic Greaves'
		$this.MapObjName         = 'mysticgreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that enhance magical aptitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
