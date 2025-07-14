using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINSVAMBRACES
#
###############################################################################

Class BEPaladinsVambraces : BEGauntlets {
	BEPaladinsVambraces() : base() {
		$this.Name               = 'Paladin''s Vambraces'
		$this.MapObjName         = 'paladinsvambraces'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Polished vambraces of a sworn protector.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
