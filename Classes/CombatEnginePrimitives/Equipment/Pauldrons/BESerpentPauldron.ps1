using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERPENTPAULDRON
#
###############################################################################

Class BESerpentPauldron : BEPauldron {
	BESerpentPauldron() : base() {
		$this.Name               = 'Serpent Pauldron'
		$this.MapObjName         = 'serpentpauldron'
		$this.PurchasePrice      = 5450
		$this.SellPrice          = 2725
		$this.TargetStats        = @{
			[StatId]::Defense = 109
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Slithers with subtle power, enhancing poison resistance and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
