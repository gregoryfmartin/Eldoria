using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETORCH
#
###############################################################################

Class BETorch : BEWeapon {
	BETorch() : base() {
		$this.Name          = 'Torch'
		$this.MapObjName    = 'torch'
		$this.PurchasePrice = 20
		$this.SellPrice     = 10
		$this.TargetStats   = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A burning stick. Can be used to ward off some creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
