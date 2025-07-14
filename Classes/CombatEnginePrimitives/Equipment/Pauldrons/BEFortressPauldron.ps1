using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORTRESSPAULDRON
#
###############################################################################

Class BEFortressPauldron : BEPauldron {
	BEFortressPauldron() : base() {
		$this.Name               = 'Fortress Pauldron'
		$this.MapObjName         = 'fortresspauldron'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Turns its wearer into a walking fortress, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
