using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GARDENING HOE
#
###############################################################################

Class BEGardeningHoe : BEWeapon {
	BEGardeningHoe() : base() {
		$this.Name          = 'Gardening Hoe'
		$this.MapObjName    = 'gardeninghoe'
		$this.PurchasePrice = 60
		$this.SellPrice     = 30
		$this.TargetStats   = @{
			[StatId]::Attack = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tool for digging and weeding. Can be swung.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
