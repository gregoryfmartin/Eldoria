using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDWARVENPAULDRON
#
###############################################################################

Class BEDwarvenPauldron : BEPauldron {
	BEDwarvenPauldron() : base() {
		$this.Name               = 'Dwarven Pauldron'
		$this.MapObjName         = 'dwarvenpauldron'
		$this.PurchasePrice      = 3300
		$this.SellPrice          = 1650
		$this.TargetStats        = @{
			[StatId]::Defense = 66
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Masterfully crafted by dwarves, incredibly sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
