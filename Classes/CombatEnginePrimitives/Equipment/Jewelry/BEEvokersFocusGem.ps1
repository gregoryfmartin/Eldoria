using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEVOKERSFOCUSGEM
#
###############################################################################

Class BEEvokersFocusGem : BEJewelry {
	BEEvokersFocusGem() : base() {
		$this.Name               = 'Evoker''s Focus Gem'
		$this.MapObjName         = 'evokersfocusgem'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that intensifies elemental spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
