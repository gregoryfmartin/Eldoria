using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMAZONIANBREASTPLATE
#
###############################################################################

Class BEAmazonianBreastplate : BEArmor {
	BEAmazonianBreastplate() : base() {
		$this.Name               = 'Amazonian Breastplate'
		$this.MapObjName         = 'amazonianbreastplate'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light but sturdy breastplate for female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
