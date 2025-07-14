using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONICCUIRASS
#
###############################################################################

Class BEDemonicCuirass : BEArmor {
	BEDemonicCuirass() : base() {
		$this.Name               = 'Demonic Cuirass'
		$this.MapObjName         = 'demoniccuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, imposing cuirass said to be forged in hellfire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
