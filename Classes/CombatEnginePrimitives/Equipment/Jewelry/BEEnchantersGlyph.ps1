using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTERSGLYPH
#
###############################################################################

Class BEEnchantersGlyph : BEJewelry {
	BEEnchantersGlyph() : base() {
		$this.Name               = 'Enchanter''s Glyph'
		$this.MapObjName         = 'enchantersglyph'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, glowing glyph, for imbuing items.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
