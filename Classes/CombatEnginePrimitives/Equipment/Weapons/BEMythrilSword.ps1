using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MYTHRIL SWORD
#
###############################################################################

Class BEMythrilSword : BEWeapon {
	BEMythrilSword() : base() {
		$this.Name          = 'Mythril Sword'
		$this.MapObjName    = 'mythrilsword'
		$this.PurchasePrice = 800
		$this.SellPrice     = 400
		$this.TargetStats   = @{
			[StatId]::Attack = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely crafted sword made from rare mythril, light and sharp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
