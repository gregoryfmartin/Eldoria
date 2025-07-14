using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRVEST
#
###############################################################################

Class BEZephyrVest : BEArmor {
	BEZephyrVest() : base() {
		$this.Name               = 'Zephyr Vest'
		$this.MapObjName         = 'zephyrvest'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light vest that makes the wearer feel faster.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
