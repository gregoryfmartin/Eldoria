using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPPRENTICESGAUNTLETS
#
###############################################################################

Class BEApprenticesGauntlets : BEGauntlets {
	BEApprenticesGauntlets() : base() {
		$this.Name               = 'Apprentice''s Gauntlets'
		$this.MapObjName         = 'apprenticesgauntlets'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic gauntlets for those learning the craft.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
