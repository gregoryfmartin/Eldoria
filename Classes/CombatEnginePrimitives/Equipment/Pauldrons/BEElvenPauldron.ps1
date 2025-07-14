using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENPAULDRON
#
###############################################################################

Class BEElvenPauldron : BEPauldron {
	BEElvenPauldron() : base() {
		$this.Name               = 'Elven Pauldron'
		$this.MapObjName         = 'elvenpauldron'
		$this.PurchasePrice      = 5750
		$this.SellPrice          = 2875
		$this.TargetStats        = @{
			[StatId]::Defense = 115
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Graceful and light, crafted with ancient elven techniques.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
