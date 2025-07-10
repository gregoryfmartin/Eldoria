using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENETHERITEGAUNTLETS
#
###############################################################################

Class BENetheriteGauntlets : BEGauntlets {
	BENetheriteGauntlets() : base() {
		$this.Name               = 'Netherite Gauntlets'
		$this.MapObjName         = 'netheritegauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 92
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from a rare, volatile metal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
