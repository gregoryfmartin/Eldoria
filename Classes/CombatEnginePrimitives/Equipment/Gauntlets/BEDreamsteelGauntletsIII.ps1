using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMSTEELGAUNTLETSIII
#
###############################################################################

Class BEDreamsteelGauntletsIII : BEGauntlets {
	BEDreamsteelGauntletsIII() : base() {
		$this.Name               = 'Dreamsteel Gauntlets III'
		$this.MapObjName         = 'dreamsteelgauntletsiii'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Dreamsteel Gauntlets, impossibly light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
