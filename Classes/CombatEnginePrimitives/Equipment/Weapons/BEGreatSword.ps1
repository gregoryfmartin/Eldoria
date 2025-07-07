using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GREAT SWORD
#
###############################################################################

Class BEGreatSword : BEWeapon {
	BEGreatSword() : base() {
		$this.Name          = 'Great Sword'
		$this.MapObjName    = 'greatsword'
		$this.PurchasePrice = 900
		$this.SellPrice     = 450
		$this.TargetStats   = @{
			[StatId]::Attack = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive two-handed sword, capable of cleaving through enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
