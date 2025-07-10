using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEGUARDTUNIC
#
###############################################################################

Class BEStoneGuardTunic : BEArmor {
	BEStoneGuardTunic() : base() {
		$this.Name               = 'Stone Guard Tunic'
		$this.MapObjName         = 'stoneguardtunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic reinforced with small stone plates for basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
