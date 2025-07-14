using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWOVENPAULDRON
#
###############################################################################

Class BEWovenPauldron : BEPauldron {
	BEWovenPauldron() : base() {
		$this.Name               = 'Woven Pauldron'
		$this.MapObjName         = 'wovenpauldron'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple pauldron woven from sturdy fibers. Offers basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
