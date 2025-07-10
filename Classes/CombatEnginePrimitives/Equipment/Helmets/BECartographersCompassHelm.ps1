using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECARTOGRAPHERSCOMPASSHELM
#
###############################################################################

Class BECartographersCompassHelm : BEHelmet {
	BECartographersCompassHelm() : base() {
		$this.Name               = 'Cartographer''s Compass Helm'
		$this.MapObjName         = 'cartographerscompasshelm'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with an integrated compass, aiding cartographers in mapping.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
