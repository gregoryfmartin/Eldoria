using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADEGREAVES
#
###############################################################################

Class BEShadeGreaves : BEGreaves {
	BEShadeGreaves() : base() {
		$this.Name               = 'Shade Greaves'
		$this.MapObjName         = 'shadegreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a shadowy entity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
