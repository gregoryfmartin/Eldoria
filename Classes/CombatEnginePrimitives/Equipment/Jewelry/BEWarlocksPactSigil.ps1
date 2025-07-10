using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLOCKSPACTSIGIL
#
###############################################################################

Class BEWarlocksPactSigil : BEJewelry {
	BEWarlocksPactSigil() : base() {
		$this.Name               = 'Warlock''s Pact Sigil'
		$this.MapObjName         = 'warlockspactsigil'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark sigil representing a forbidden pact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
