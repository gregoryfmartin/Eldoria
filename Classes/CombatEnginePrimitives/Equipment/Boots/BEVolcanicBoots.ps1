using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLCANICBOOTS
#
###############################################################################

Class BEVolcanicBoots : BEBoots {
	BEVolcanicBoots() : base() {
		$this.Name               = 'Volcanic Boots'
		$this.MapObjName         = 'volcanicboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots forged near volcanic heat, resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
