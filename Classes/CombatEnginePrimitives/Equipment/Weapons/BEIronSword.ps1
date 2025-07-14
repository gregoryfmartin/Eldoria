using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONSWORD
#
###############################################################################

Class BEIronSword : BEWeapon {
	BEIronSword() : base() {
		$this.Name          = 'Iron Sword'
		$this.MapObjName    = 'ironsword'
		$this.PurchasePrice = 280
		$this.SellPrice     = 140
		$this.TargetStats   = @{
			[StatId]::Attack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A well-forged iron sword, more durable than bronze.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
