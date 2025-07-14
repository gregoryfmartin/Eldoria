using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERSHARNESS
#
###############################################################################

Class BEBerserkersHarness : BEArmor {
	BEBerserkersHarness() : base() {
		$this.Name               = 'Berserker''s Harness'
		$this.MapObjName         = 'berserkersharness'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A minimal harness that allows for unrestrained movement and boosts attack.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
