using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONERING
#
###############################################################################

Class BESunstoneRing : BEJewelry {
	BESunstoneRing() : base() {
		$this.Name               = 'Sunstone Ring'
		$this.MapObjName         = 'sunstonering'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant sunstone ring, imbued with solar warmth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
