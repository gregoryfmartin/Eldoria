using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZECOREGAUNTLETSIII
#
###############################################################################

Class BEBlazecoreGauntletsIII : BEGauntlets {
	BEBlazecoreGauntletsIII() : base() {
		$this.Name               = 'Blazecore Gauntlets III'
		$this.MapObjName         = 'blazecoregauntletsiii'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Blazecore Gauntlets, intensely hot and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
