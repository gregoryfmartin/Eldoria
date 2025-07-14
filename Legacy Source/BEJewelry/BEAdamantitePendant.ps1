using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTITEPENDANT
#
###############################################################################

Class BEAdamantitePendant : BEJewelry {
	BEAdamantitePendant() : base() {
		$this.Name               = 'Adamantite Pendant'
		$this.MapObjName         = 'adamantitependant'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, heavy adamantite pendant, for ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
