using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDSCALEGAUNTLETSII
#
###############################################################################

Class BEEmeraldScaleGauntletsII : BEGauntlets {
	BEEmeraldScaleGauntletsII() : base() {
		$this.Name               = 'Emerald Scale Gauntlets II'
		$this.MapObjName         = 'emeraldscalegauntletsii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More vibrant Emerald Scale Gauntlets, stronger protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
