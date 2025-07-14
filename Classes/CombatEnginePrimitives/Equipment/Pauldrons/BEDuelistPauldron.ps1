using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDUELISTPAULDRON
#
###############################################################################

Class BEDuelistPauldron : BEPauldron {
	BEDuelistPauldron() : base() {
		$this.Name               = 'Duelist Pauldron'
		$this.MapObjName         = 'duelistpauldron'
		$this.PurchasePrice      = 8100
		$this.SellPrice          = 4050
		$this.TargetStats        = @{
			[StatId]::Defense = 162
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed for swift, precise movements and countering.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
