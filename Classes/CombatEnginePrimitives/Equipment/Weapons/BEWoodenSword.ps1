using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WOODEN SWORD
#
###############################################################################

Class BEWoodenSword : BEWeapon {
	BEWoodenSword() : base() {
		$this.Name          = 'Wooden Sword'
		$this.MapObjName    = 'woodensword'
		$this.PurchasePrice = 50
		$this.SellPrice     = 25
		$this.TargetStats   = @{
			[StatId]::Attack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, crudely carved wooden sword. Ideal for beginners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
