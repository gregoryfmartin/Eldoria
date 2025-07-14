using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMGAUNTLETS
#
###############################################################################

Class BEGolemGauntlets : BEGauntlets {
	BEGolemGauntlets() : base() {
		$this.Name               = 'Golem Gauntlets'
		$this.MapObjName         = 'golemgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, stone-like gauntlets, nearly indestructible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
