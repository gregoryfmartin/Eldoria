using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREALITYANCHOR
#
###############################################################################

Class BERealityAnchor : BEJewelry {
	BERealityAnchor() : base() {
		$this.Name               = 'Reality Anchor'
		$this.MapObjName         = 'realityanchor'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy anchor that stabilizes reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
