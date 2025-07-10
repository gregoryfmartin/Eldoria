using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDPLATE
#
###############################################################################

Class BEVoidPlate : BEArmor {
	BEVoidPlate() : base() {
		$this.Name               = 'Void Plate'
		$this.MapObjName         = 'voidplate'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::Defense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor that seems to absorb light, offering ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
