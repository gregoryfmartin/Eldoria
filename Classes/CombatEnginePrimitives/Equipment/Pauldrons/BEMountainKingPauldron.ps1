using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOUNTAINKINGPAULDRON
#
###############################################################################

Class BEMountainKingPauldron : BEPauldron {
	BEMountainKingPauldron() : base() {
		$this.Name               = 'Mountain King Pauldron'
		$this.MapObjName         = 'mountainkingpauldron'
		$this.PurchasePrice      = 8750
		$this.SellPrice          = 4375
		$this.TargetStats        = @{
			[StatId]::Defense = 175
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by dwarven royalty, imbued with the strength of the mountains.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
