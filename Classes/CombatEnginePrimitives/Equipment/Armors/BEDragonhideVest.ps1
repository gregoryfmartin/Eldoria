using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHIDEVEST
#
###############################################################################

Class BEDragonhideVest : BEArmor {
	BEDragonhideVest() : base() {
		$this.Name               = 'Dragonhide Vest'
		$this.MapObjName         = 'dragonhidevest'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the tough hide of a dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
