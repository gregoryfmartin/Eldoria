using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECARVINGKNIFE
#
###############################################################################

Class BECarvingKnife : BEWeapon {
	BECarvingKnife() : base() {
		$this.Name          = 'Carving Knife'
		$this.MapObjName    = 'carvingknife'
		$this.PurchasePrice = 50
		$this.SellPrice     = 25
		$this.TargetStats   = @{
			[StatId]::Attack = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A very sharp knife used for preparing food.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
