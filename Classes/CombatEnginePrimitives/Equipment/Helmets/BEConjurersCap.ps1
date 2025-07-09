using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CONJURER'S CAP
#
###############################################################################

Class BEConjurersCap : BEHelmet {
	BEConjurersCap() : base() {
		$this.Name               = 'Conjurer''s Cap'
		$this.MapObjName         = 'conjurerscap'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap worn by conjurers, aiding in summoning creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
