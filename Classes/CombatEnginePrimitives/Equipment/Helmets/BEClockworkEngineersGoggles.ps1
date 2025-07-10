using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOCKWORKENGINEERSGOGGLES
#
###############################################################################

Class BEClockworkEngineersGoggles : BEHelmet {
	BEClockworkEngineersGoggles() : base() {
		$this.Name               = 'Clockwork Engineer''s Goggles'
		$this.MapObjName         = 'clockworkengineersgoggles'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles that aid in precise clockwork construction and repair.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
