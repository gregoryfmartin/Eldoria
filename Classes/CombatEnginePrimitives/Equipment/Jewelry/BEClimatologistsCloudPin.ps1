using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLIMATOLOGISTSCLOUDPIN
#
###############################################################################

Class BEClimatologistsCloudPin : BEJewelry {
	BEClimatologistsCloudPin() : base() {
		$this.Name               = 'Climatologist''s Cloud Pin'
		$this.MapObjName         = 'climatologistscloudpin'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a small cloud, for predicting weather.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
