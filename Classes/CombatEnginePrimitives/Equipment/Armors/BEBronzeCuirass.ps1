using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRONZECUIRASS
#
###############################################################################

Class BEBronzeCuirass : BEArmor {
	BEBronzeCuirass() : base() {
		$this.Name               = 'Bronze Cuirass'
		$this.MapObjName         = 'bronzecuirass'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy chest piece crafted from bronze.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
