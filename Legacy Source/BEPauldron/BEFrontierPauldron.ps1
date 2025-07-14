using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFRONTIERPAULDRON
#
###############################################################################

Class BEFrontierPauldron : BEPauldron {
	BEFrontierPauldron() : base() {
		$this.Name               = 'Frontier Pauldron'
		$this.MapObjName         = 'frontierpauldron'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Suited for the untamed wilds, offering rugged defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
