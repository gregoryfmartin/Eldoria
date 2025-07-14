using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONDEATHGAUNTLETS
#
###############################################################################

Class BECrimsonDeathGauntlets : BEGauntlets {
	BECrimsonDeathGauntlets() : base() {
		$this.Name               = 'Crimson Death Gauntlets'
		$this.MapObjName         = 'crimsondeathgauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a formidable executioner, stained red.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
