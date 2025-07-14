using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREBELPAULDRON
#
###############################################################################

Class BERebelPauldron : BEPauldron {
	BERebelPauldron() : base() {
		$this.Name               = 'Rebel Pauldron'
		$this.MapObjName         = 'rebelpauldron'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of defiance, for those who fight against oppression.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
