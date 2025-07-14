using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHORNSEMBRACERING
#
###############################################################################

Class BEThornsEmbraceRing : BEJewelry {
	BEThornsEmbraceRing() : base() {
		$this.Name               = 'Thorns Embrace Ring'
		$this.MapObjName         = 'thornsembracering'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring resembling thorny vines, protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
