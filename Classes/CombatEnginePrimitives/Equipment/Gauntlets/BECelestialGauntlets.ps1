using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALGAUNTLETS
#
###############################################################################

Class BECelestialGauntlets : BEGauntlets {
	BECelestialGauntlets() : base() {
		$this.Name               = 'Celestial Gauntlets'
		$this.MapObjName         = 'celestialgauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be forged from starlight, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
