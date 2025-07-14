using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREADKNIGHTGAUNTLETS
#
###############################################################################

Class BEDreadKnightGauntlets : BEGauntlets {
	BEDreadKnightGauntlets() : base() {
		$this.Name               = 'Dread Knight Gauntlets'
		$this.MapObjName         = 'dreadknightgauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a fearsome dark knight, chilling to the touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
