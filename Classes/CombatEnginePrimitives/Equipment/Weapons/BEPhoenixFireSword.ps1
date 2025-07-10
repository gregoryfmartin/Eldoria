using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXFIRESWORD
#
###############################################################################

Class BEPhoenixFireSword : BEWeapon {
	BEPhoenixFireSword() : base() {
		$this.Name          = 'Phoenix Fire Sword'
		$this.MapObjName    = 'phoenixfiresword'
		$this.PurchasePrice = 6600
		$this.SellPrice     = 3300
		$this.TargetStats   = @{
			[StatId]::Attack      = 155
			[StatId]::MagicAttack = 78
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that perpetually burns with phoenix fire, igniting foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
