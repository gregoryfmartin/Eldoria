using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRFEATHER
#
###############################################################################

Class BEZephyrFeather : BEJewelry {
	BEZephyrFeather() : base() {
		$this.Name               = 'Zephyr Feather'
		$this.MapObjName         = 'zephyrfeather'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A feather from the swift zephyr bird, granting speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
