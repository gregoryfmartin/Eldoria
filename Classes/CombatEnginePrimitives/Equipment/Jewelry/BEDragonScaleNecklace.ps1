using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSCALENECKLACE
#
###############################################################################

Class BEDragonScaleNecklace : BEJewelry {
	BEDragonScaleNecklace() : base() {
		$this.Name               = 'Dragon Scale Necklace'
		$this.MapObjName         = 'dragonscalenecklace'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A necklace made of hardened dragon scales, very protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
