using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTITEFISTGAUNTLETS
#
###############################################################################

Class BEAdamantiteFistGauntlets : BEGauntlets {
	BEAdamantiteFistGauntlets() : base() {
		$this.Name               = 'Adamantite Fist Gauntlets'
		$this.MapObjName         = 'adamantitefistgauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of pure adamantite, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
