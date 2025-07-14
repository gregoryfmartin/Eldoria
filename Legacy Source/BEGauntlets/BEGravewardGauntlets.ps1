using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVEWARDGAUNTLETS
#
###############################################################################

Class BEGravewardGauntlets : BEGauntlets {
	BEGravewardGauntlets() : base() {
		$this.Name               = 'Graveward Gauntlets'
		$this.MapObjName         = 'gravewardgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a silent guardian, protecting sacred grounds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
