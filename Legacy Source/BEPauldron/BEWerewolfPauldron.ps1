using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWEREWOLFPAULDRON
#
###############################################################################

Class BEWerewolfPauldron : BEPauldron {
	BEWerewolfPauldron() : base() {
		$this.Name               = 'Werewolf Pauldron'
		$this.MapObjName         = 'werewolfpauldron'
		$this.PurchasePrice      = 5100
		$this.SellPrice          = 2550
		$this.TargetStats        = @{
			[StatId]::Defense = 102
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances bestial resistance and ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
