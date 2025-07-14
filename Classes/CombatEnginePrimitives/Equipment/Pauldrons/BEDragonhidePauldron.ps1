using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHIDEPAULDRON
#
###############################################################################

Class BEDragonhidePauldron : BEPauldron {
	BEDragonhidePauldron() : base() {
		$this.Name               = 'Dragonhide Pauldron'
		$this.MapObjName         = 'dragonhidepauldron'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crafted from the tough hide of a dragon, resistant to many elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
