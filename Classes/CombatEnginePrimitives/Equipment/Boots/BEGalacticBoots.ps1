using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGALACTICBOOTS
#
###############################################################################

Class BEGalacticBoots : BEBoots {
	BEGalacticBoots() : base() {
		$this.Name               = 'Galactic Boots'
		$this.MapObjName         = 'galacticboots'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 53
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from beyond the galaxy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
