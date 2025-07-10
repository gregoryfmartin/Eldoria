using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHUNDERCLAPGAUNTLETS
#
###############################################################################

Class BEThunderclapGauntlets : BEGauntlets {
	BEThunderclapGauntlets() : base() {
		$this.Name               = 'Thunderclap Gauntlets'
		$this.MapObjName         = 'thunderclapgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that resonate with thunder, stunning foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
