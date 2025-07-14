using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHITINOUSGAUNTLETS
#
###############################################################################

Class BEChitinousGauntlets : BEGauntlets {
	BEChitinousGauntlets() : base() {
		$this.Name               = 'Chitinous Gauntlets'
		$this.MapObjName         = 'chitinousgauntlets'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from hardened insect chitin, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
