using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBULWARKPAULDRON
#
###############################################################################

Class BEBulwarkPauldron : BEPauldron {
	BEBulwarkPauldron() : base() {
		$this.Name               = 'Bulwark Pauldron'
		$this.MapObjName         = 'bulwarkpauldron'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An impenetrable defense, almost impossible to breach.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
