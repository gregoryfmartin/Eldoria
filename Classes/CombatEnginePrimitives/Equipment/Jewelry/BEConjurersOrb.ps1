using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONJURERSORB
#
###############################################################################

Class BEConjurersOrb : BEJewelry {
	BEConjurersOrb() : base() {
		$this.Name               = 'Conjurer''s Orb'
		$this.MapObjName         = 'conjurersorb'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small orb that can manifest minor objects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
