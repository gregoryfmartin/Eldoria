using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMAZONIANPAULDRON
#
###############################################################################

Class BEAmazonianPauldron : BEPauldron {
	BEAmazonianPauldron() : base() {
		$this.Name               = 'Amazonian Pauldron'
		$this.MapObjName         = 'amazonianpauldron'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by the legendary Amazons, light yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
