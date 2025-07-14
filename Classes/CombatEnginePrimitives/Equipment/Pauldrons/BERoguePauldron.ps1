using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROGUEPAULDRON
#
###############################################################################

Class BERoguePauldron : BEPauldron {
	BERoguePauldron() : base() {
		$this.Name               = 'Rogue Pauldron'
		$this.MapObjName         = 'roguepauldron'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for cunning rogues, offering minimal hindrance to movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
