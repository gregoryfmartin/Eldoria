using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEASTKINGAUNTLETS
#
###############################################################################

Class BEBeastkinGauntlets : BEGauntlets {
	BEBeastkinGauntlets() : base() {
		$this.Name               = 'Beastkin Gauntlets'
		$this.MapObjName         = 'beastkingauntlets'
		$this.PurchasePrice      = 430
		$this.SellPrice          = 215
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from tough beast hide, wild and untamed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
