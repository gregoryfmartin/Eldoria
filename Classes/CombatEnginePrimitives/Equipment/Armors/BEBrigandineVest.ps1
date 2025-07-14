using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRIGANDINEVEST
#
###############################################################################

Class BEBrigandineVest : BEArmor {
	BEBrigandineVest() : base() {
		$this.Name               = 'Brigandine Vest'
		$this.MapObjName         = 'brigandinevest'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made of small metal plates riveted to cloth or leather.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
