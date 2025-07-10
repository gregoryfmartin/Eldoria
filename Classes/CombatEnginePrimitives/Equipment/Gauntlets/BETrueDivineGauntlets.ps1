using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRUEDIVINEGAUNTLETS
#
###############################################################################

Class BETrueDivineGauntlets : BEGauntlets {
	BETrueDivineGauntlets() : base() {
		$this.Name               = 'True Divine Gauntlets'
		$this.MapObjName         = 'truedivinegauntlets'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 120
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be worn by gods, ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
