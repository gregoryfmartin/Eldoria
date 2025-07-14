using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMULETVEST
#
###############################################################################

Class BEAmuletVest : BEArmor {
	BEAmuletVest() : base() {
		$this.Name               = 'Amulet Vest'
		$this.MapObjName         = 'amuletvest'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with various protective amulets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
