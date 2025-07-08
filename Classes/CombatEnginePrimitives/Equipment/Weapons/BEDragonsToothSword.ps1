using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGONS TOOTH SWORD
#
###############################################################################

Class BEDragonsToothSword : BEWeapon {
	BEDragonsToothSword() : base() {
		$this.Name          = 'Dragon''s Tooth Sword'
		$this.MapObjName    = 'dragonstoothsword'
		$this.PurchasePrice = 6500
		$this.SellPrice     = 3250
		$this.TargetStats   = @{
			[StatId]::Attack      = 152
			[StatId]::MagicAttack = 72
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword fashioned from a dragon''s tooth, incredibly sharp and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
