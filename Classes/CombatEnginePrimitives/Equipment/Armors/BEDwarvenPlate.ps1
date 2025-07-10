using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDWARVENPLATE
#
###############################################################################

Class BEDwarvenPlate : BEArmor {
	BEDwarvenPlate() : base() {
		$this.Name               = 'Dwarven Plate'
		$this.MapObjName         = 'dwarvenplate'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and robust plate armor, masterfully forged.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
