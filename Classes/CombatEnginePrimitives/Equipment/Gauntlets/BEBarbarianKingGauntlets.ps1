using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANKINGGAUNTLETS
#
###############################################################################

Class BEBarbarianKingGauntlets : BEGauntlets {
	BEBarbarianKingGauntlets() : base() {
		$this.Name               = 'Barbarian King Gauntlets'
		$this.MapObjName         = 'barbariankinggauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets fit for a tribal leader, raw and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
