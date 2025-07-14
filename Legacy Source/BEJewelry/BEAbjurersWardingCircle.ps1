using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABJURERSWARDINGCIRCLE
#
###############################################################################

Class BEAbjurersWardingCircle : BEJewelry {
	BEAbjurersWardingCircle() : base() {
		$this.Name               = 'Abjurer''s Warding Circle'
		$this.MapObjName         = 'abjurerswardingcircle'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny warding circle, for defensive spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
