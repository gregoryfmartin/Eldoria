using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANFORGEDGAUNTLETS
#
###############################################################################

Class BETitanforgedGauntlets : BEGauntlets {
	BETitanforgedGauntlets() : base() {
		$this.Name               = 'Titanforged Gauntlets'
		$this.MapObjName         = 'titanforgedgauntlets'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 110
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged in a titan''s forge, immense and heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
