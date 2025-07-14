using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULBOUNDVEST
#
###############################################################################

Class BESoulboundVest : BEArmor {
	BESoulboundVest() : base() {
		$this.Name               = 'Soulbound Vest'
		$this.MapObjName         = 'soulboundvest'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that has formed a mystical link with its wearer, gaining power over time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
