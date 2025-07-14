using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSLAYERSPLATE
#
###############################################################################

Class BEDragonSlayersPlate : BEArmor {
	BEDragonSlayersPlate() : base() {
		$this.Name               = 'Dragon Slayer''s Plate'
		$this.MapObjName         = 'dragonslayersplate'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{
			[StatId]::Defense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor designed specifically to combat dragons, immensely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
