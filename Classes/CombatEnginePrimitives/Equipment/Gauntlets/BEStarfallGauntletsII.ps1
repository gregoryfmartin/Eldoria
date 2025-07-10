using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLGAUNTLETSII
#
###############################################################################

Class BEStarfallGauntletsII : BEGauntlets {
	BEStarfallGauntletsII() : base() {
		$this.Name               = 'Starfall Gauntlets II'
		$this.MapObjName         = 'starfallgauntletsii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhanced Starfall Gauntlets, stronger cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
