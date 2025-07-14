using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANSPAULDRON
#
###############################################################################

Class BETitansPauldron : BEPauldron {
	BETitansPauldron() : base() {
		$this.Name               = 'Titan''s Pauldron'
		$this.MapObjName         = 'titanspauldron'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Said to have been worn by a Titan, incredibly powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
