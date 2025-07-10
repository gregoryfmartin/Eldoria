using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEMASTERSSTONE
#
###############################################################################

Class BERunemastersStone : BEJewelry {
	BERunemastersStone() : base() {
		$this.Name               = 'Runemaster''s Stone'
		$this.MapObjName         = 'runemastersstone'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stone engraved with powerful runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
