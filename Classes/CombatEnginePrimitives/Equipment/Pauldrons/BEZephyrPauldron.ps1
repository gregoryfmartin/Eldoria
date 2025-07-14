using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRPAULDRON
#
###############################################################################

Class BEZephyrPauldron : BEPauldron {
	BEZephyrPauldron() : base() {
		$this.Name               = 'Zephyr Pauldron'
		$this.MapObjName         = 'zephyrpauldron'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light as a feather, granting incredible agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
