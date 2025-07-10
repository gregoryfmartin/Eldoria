using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETOYSWORD
#
###############################################################################

Class BEToySword : BEWeapon {
	BEToySword() : base() {
		$this.Name          = 'Toy Sword'
		$this.MapObjName    = 'toysword'
		$this.PurchasePrice = 10
		$this.SellPrice     = 5
		$this.TargetStats   = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A harmless replica of a sword.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
