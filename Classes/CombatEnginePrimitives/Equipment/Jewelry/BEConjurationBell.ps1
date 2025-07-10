using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONJURATIONBELL
#
###############################################################################

Class BEConjurationBell : BEJewelry {
	BEConjurationBell() : base() {
		$this.Name               = 'Conjuration Bell'
		$this.MapObjName         = 'conjurationbell'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny bell that rings to summon familiars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
