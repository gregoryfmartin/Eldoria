using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUSADERPAULDRON
#
###############################################################################

Class BECrusaderPauldron : BEPauldron {
	BECrusaderPauldron() : base() {
		$this.Name               = 'Crusader Pauldron'
		$this.MapObjName         = 'crusaderpauldron'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and imposing, a symbol of unwavering faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
