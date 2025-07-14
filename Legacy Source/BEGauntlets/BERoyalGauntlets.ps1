using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALGAUNTLETS
#
###############################################################################

Class BERoyalGauntlets : BEGauntlets {
	BERoyalGauntlets() : base() {
		$this.Name               = 'Royal Gauntlets'
		$this.MapObjName         = 'royalgauntlets'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Finely crafted gauntlets, fit for royalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
