using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPACEWARPCUBE
#
###############################################################################

Class BESpaceWarpCube : BEJewelry {
	BESpaceWarpCube() : base() {
		$this.Name               = 'Space Warp Cube'
		$this.MapObjName         = 'spacewarpcube'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small cube that momentarily bends space.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
