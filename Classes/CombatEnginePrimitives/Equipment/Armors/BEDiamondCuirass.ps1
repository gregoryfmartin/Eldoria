using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIAMONDCUIRASS
#
###############################################################################

Class BEDiamondCuirass : BEArmor {
	BEDiamondCuirass() : base() {
		$this.Name               = 'Diamond Cuirass'
		$this.MapObjName         = 'diamondcuirass'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sparkling cuirass inlaid with diamonds, very durable and beautiful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
