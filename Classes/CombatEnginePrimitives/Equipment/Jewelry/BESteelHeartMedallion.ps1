using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELHEARTMEDALLION
#
###############################################################################

Class BESteelHeartMedallion : BEJewelry {
	BESteelHeartMedallion() : base() {
		$this.Name               = 'Steel Heart Medallion'
		$this.MapObjName         = 'steelheartmedallion'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy steel medallion, for unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
