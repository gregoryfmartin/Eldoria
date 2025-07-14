using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOW
#
###############################################################################

Class BEBow : BEWeapon {
	BEBow() : base() {
		$this.Name          = 'Bow'
		$this.MapObjName    = 'bow'
		$this.PurchasePrice = 180
		$this.SellPrice     = 90
		$this.TargetStats   = @{
			[StatId]::Attack = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic wooden bow, requires arrows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
