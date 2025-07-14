using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRAMBLETHORNBROOCH
#
###############################################################################

Class BEBramblethornBrooch : BEJewelry {
	BEBramblethornBrooch() : base() {
		$this.Name               = 'Bramblethorn Brooch'
		$this.MapObjName         = 'bramblethornbrooch'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like thorny brambles, deterring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
