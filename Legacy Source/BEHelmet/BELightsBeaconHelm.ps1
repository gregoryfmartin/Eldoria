using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTSBEACONHELM
#
###############################################################################

Class BELightsBeaconHelm : BEHelmet {
	BELightsBeaconHelm() : base() {
		$this.Name               = 'Light''s Beacon Helm'
		$this.MapObjName         = 'lightsbeaconhelm'
		$this.PurchasePrice      = 13000
		$this.SellPrice          = 6500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 105
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that acts as a beacon of pure light, dispelling all darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
