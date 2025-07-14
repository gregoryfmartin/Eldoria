using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOCKWORKCUIRASS
#
###############################################################################

Class BEClockworkCuirass : BEArmor {
	BEClockworkCuirass() : base() {
		$this.Name               = 'Clockwork Cuirass'
		$this.MapObjName         = 'clockworkcuirass'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made of intricate gears and metal, offers decent defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
