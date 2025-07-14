using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULBOUNDTOKEN
#
###############################################################################

Class BESoulboundToken : BEJewelry {
	BESoulboundToken() : base() {
		$this.Name               = 'Soulbound Token'
		$this.MapObjName         = 'soulboundtoken'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A token bound to a powerful soul, granting shared power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
