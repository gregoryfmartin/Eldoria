using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZECOREGAUNTLETS
#
###############################################################################

Class BEBlazeCoreGauntlets : BEGauntlets {
	BEBlazeCoreGauntlets() : base() {
		$this.Name               = 'Blaze Core Gauntlets'
		$this.MapObjName         = 'blazecoregauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with an internal core of fire, burning steadily.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
