using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANIUMRING
#
###############################################################################

Class BETitaniumRing : BEJewelry {
	BETitaniumRing() : base() {
		$this.Name               = 'Titanium Ring'
		$this.MapObjName         = 'titaniumring'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight but incredibly strong titanium ring.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
