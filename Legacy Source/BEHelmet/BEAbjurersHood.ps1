using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABJURERSHOOD
#
###############################################################################

Class BEAbjurersHood : BEHelmet {
	BEAbjurersHood() : base() {
		$this.Name               = 'Abjurer''s Hood'
		$this.MapObjName         = 'abjurershood'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood worn by abjurers, specializing in defensive magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
