using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCTICBOOTS
#
###############################################################################

Class BEArcticBoots : BEBoots {
	BEArcticBoots() : base() {
		$this.Name               = 'Arctic Boots'
		$this.MapObjName         = 'arcticboots'
		$this.PurchasePrice      = 440
		$this.SellPrice          = 220
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for cold climates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
