using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAMPIONSGAUNTLETS
#
###############################################################################

Class BEChampionsGauntlets : BEGauntlets {
	BEChampionsGauntlets() : base() {
		$this.Name               = 'Champion''s Gauntlets'
		$this.MapObjName         = 'championsgauntlets'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a legendary champion, imbued with their might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
