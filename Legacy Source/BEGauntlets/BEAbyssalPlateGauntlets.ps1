using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALPLATEGAUNTLETS
#
###############################################################################

Class BEAbyssalPlateGauntlets : BEGauntlets {
	BEAbyssalPlateGauntlets() : base() {
		$this.Name               = 'Abyssal Plate Gauntlets'
		$this.MapObjName         = 'abyssalplategauntlets'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy gauntlets from the deepest abyss, extremely resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
