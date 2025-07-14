using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPILGRIMSPAULDRON
#
###############################################################################

Class BEPilgrimsPauldron : BEPauldron {
	BEPilgrimsPauldron() : base() {
		$this.Name               = 'Pilgrim''s Pauldron'
		$this.MapObjName         = 'pilgrimspauldron'
		$this.PurchasePrice      = 9000
		$this.SellPrice          = 4500
		$this.TargetStats        = @{
			[StatId]::Defense = 180
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple yet enduring, for those on sacred journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
