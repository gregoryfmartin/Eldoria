using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESKYFORGEDCUIRASS
#
###############################################################################

Class BESkyforgedCuirass : BEArmor {
	BESkyforgedCuirass() : base() {
		$this.Name               = 'Skyforged Cuirass'
		$this.MapObjName         = 'skyforgedcuirass'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass said to be hammered from clouds, very light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
