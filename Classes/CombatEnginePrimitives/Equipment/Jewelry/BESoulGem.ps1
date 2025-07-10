using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULGEM
#
###############################################################################

Class BESoulGem : BEJewelry {
	BESoulGem() : base() {
		$this.Name               = 'Soul Gem'
		$this.MapObjName         = 'soulgem'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that holds a captured soul, eerie but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
