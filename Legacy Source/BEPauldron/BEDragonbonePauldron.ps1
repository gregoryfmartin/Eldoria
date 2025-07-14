using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONBONEPAULDRON
#
###############################################################################

Class BEDragonbonePauldron : BEPauldron {
	BEDragonbonePauldron() : base() {
		$this.Name               = 'Dragonbone Pauldron'
		$this.MapObjName         = 'dragonbonepauldron'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged from the bones of a fallen dragon, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
