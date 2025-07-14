using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLCANICGREAVES
#
###############################################################################

Class BEVolcanicGreaves : BEGreaves {
	BEVolcanicGreaves() : base() {
		$this.Name               = 'Volcanic Greaves'
		$this.MapObjName         = 'volcanicgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves forged near volcanic heat, resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
