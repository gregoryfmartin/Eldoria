using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZEFIREGAUNTLETS
#
###############################################################################

Class BEBlazefireGauntlets : BEGauntlets {
	BEBlazefireGauntlets() : base() {
		$this.Name               = 'Blazefire Gauntlets'
		$this.MapObjName         = 'blazefiregauntlets'
		$this.PurchasePrice      = 930
		$this.SellPrice          = 465
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating intense heat, burning enemies on contact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
