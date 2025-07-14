using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTBOOTS
#
###############################################################################

Class BEDesertBoots : BEBoots {
	BEDesertBoots() : base() {
		$this.Name               = 'Desert Boots'
		$this.MapObjName         = 'desertboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots suitable for arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
