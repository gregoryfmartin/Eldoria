using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMITEGAUNTLETS
#
###############################################################################

Class BEGolemiteGauntlets : BEGauntlets {
	BEGolemiteGauntlets() : base() {
		$this.Name               = 'Golemite Gauntlets'
		$this.MapObjName         = 'golemitegauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy gauntlets made from animated stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
