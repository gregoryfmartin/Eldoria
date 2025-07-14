using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUDECUIRASS
#
###############################################################################

Class BECrudeCuirass : BEArmor {
	BECrudeCuirass() : base() {
		$this.Name               = 'Crude Cuirass'
		$this.MapObjName         = 'crudecuirass'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A poorly made cuirass, offers basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
