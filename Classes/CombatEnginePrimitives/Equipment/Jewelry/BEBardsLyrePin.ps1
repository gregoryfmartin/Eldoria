using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARDSLYREPIN
#
###############################################################################

Class BEBardsLyrePin : BEJewelry {
	BEBardsLyrePin() : base() {
		$this.Name               = 'Bard''s Lyre Pin'
		$this.MapObjName         = 'bardslyrepin'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small pin shaped like a lyre, enhancing charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
