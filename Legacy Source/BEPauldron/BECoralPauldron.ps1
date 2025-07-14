using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECORALPAULDRON
#
###############################################################################

Class BECoralPauldron : BEPauldron {
	BECoralPauldron() : base() {
		$this.Name               = 'Coral Pauldron'
		$this.MapObjName         = 'coralpauldron'
		$this.PurchasePrice      = 3950
		$this.SellPrice          = 1975
		$this.TargetStats        = @{
			[StatId]::Defense = 79
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from hardened coral, surprisingly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
