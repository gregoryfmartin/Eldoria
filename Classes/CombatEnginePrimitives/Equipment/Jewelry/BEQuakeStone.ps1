using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUAKESTONE
#
###############################################################################

Class BEQuakeStone : BEJewelry {
	BEQuakeStone() : base() {
		$this.Name               = 'Quake Stone'
		$this.MapObjName         = 'quakestone'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy stone that resonates with seismic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
