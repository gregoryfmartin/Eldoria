using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZECOREGAUNTLETSII
#
###############################################################################

Class BEBlazecoreGauntletsII : BEGauntlets {
	BEBlazecoreGauntletsII() : base() {
		$this.Name               = 'Blazecore Gauntlets II'
		$this.MapObjName         = 'blazecoregauntletsii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Blazecore Gauntlets, hotter and more resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
