using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPILGRIMSVEST
#
###############################################################################

Class BEPilgrimsVest : BEArmor {
	BEPilgrimsVest() : base() {
		$this.Name               = 'Pilgrim''s Vest'
		$this.MapObjName         = 'pilgrimsvest'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, durable vest for long journeys of faith.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
