using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMSTEELGAUNTLETS
#
###############################################################################

Class BEDreamsteelGauntlets : BEGauntlets {
	BEDreamsteelGauntlets() : base() {
		$this.Name               = 'Dreamsteel Gauntlets'
		$this.MapObjName         = 'dreamsteelgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from solidified dreams, both light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
