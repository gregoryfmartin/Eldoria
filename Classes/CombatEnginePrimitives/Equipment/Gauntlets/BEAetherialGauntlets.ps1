using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAETHERIALGAUNTLETS
#
###############################################################################

Class BEAetherialGauntlets : BEGauntlets {
	BEAetherialGauntlets() : base() {
		$this.Name               = 'Aetherial Gauntlets'
		$this.MapObjName         = 'aetherialgauntlets'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets infused with faint Aether, granting resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
