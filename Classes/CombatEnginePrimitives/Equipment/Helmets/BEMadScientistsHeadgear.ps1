using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMADSCIENTISTSHEADGEAR
#
###############################################################################

Class BEMadScientistsHeadgear : BEHelmet {
	BEMadScientistsHeadgear() : base() {
		$this.Name               = 'Mad Scientist''s Headgear'
		$this.MapObjName         = 'madscientistsheadgear'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Erratic headgear that amplifies chaotic experiments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
