using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAMPIONSGLORYGAUNTLETS
#
###############################################################################

Class BEChampionsGloryGauntlets : BEGauntlets {
	BEChampionsGloryGauntlets() : base() {
		$this.Name               = 'Champion''s Glory Gauntlets'
		$this.MapObjName         = 'championsglorygauntlets'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating the glory of a champion, inspiring allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
