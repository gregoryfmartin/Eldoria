using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXSOULGAUNTLETS
#
###############################################################################

Class BEPhoenixSoulGauntlets : BEGauntlets {
	BEPhoenixSoulGauntlets() : base() {
		$this.Name               = 'Phoenix Soul Gauntlets'
		$this.MapObjName         = 'phoenixsoulgauntlets'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with the spirit of a phoenix, granting rebirth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
