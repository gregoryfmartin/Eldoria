using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALIANTCUIRASS
#
###############################################################################

Class BEValiantCuirass : BEArmor {
	BEValiantCuirass() : base() {
		$this.Name               = 'Valiant Cuirass'
		$this.MapObjName         = 'valiantcuirass'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shining cuirass worn by courageous warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
