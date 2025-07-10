using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEBOUNDGAUNTLETS
#
###############################################################################

Class BERuneboundGauntlets : BEGauntlets {
	BERuneboundGauntlets() : base() {
		$this.Name               = 'Runebound Gauntlets'
		$this.MapObjName         = 'runeboundgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets strongly bound by ancient runes, powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
