using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNHIDEVEST
#
###############################################################################

Class BEWyvernhideVest : BEArmor {
	BEWyvernhideVest() : base() {
		$this.Name               = 'Wyvernhide Vest'
		$this.MapObjName         = 'wyvernhidevest'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the tough hide of a wyvern.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
