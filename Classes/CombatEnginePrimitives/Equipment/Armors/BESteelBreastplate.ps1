using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELBREASTPLATE
#
###############################################################################

Class BESteelBreastplate : BEArmor {
	BESteelBreastplate() : base() {
		$this.Name               = 'Steel Breastplate'
		$this.MapObjName         = 'steelbreastplate'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A standard issue breastplate for soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
