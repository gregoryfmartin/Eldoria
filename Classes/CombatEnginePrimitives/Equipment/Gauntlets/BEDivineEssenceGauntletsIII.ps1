using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEESSENCEGAUNTLETSIII
#
###############################################################################

Class BEDivineEssenceGauntletsIII : BEGauntlets {
	BEDivineEssenceGauntletsIII() : base() {
		$this.Name               = 'Divine Essence Gauntlets III'
		$this.MapObjName         = 'divineessencegauntletsiii'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Divine Essence Gauntlets, radiating pure divine power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
