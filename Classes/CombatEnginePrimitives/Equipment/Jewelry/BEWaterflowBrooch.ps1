using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWATERFLOWBROOCH
#
###############################################################################

Class BEWaterflowBrooch : BEJewelry {
	BEWaterflowBrooch() : base() {
		$this.Name               = 'Waterflow Brooch'
		$this.MapObjName         = 'waterflowbrooch'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch that seems to flow like water, granting agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
