using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTITEPLATE
#
###############################################################################

Class BEAdamantitePlate : BEArmor {
	BEAdamantitePlate() : base() {
		$this.Name               = 'Adamantite Plate'
		$this.MapObjName         = 'adamantiteplate'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Extremely durable armor forged from adamantite.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
