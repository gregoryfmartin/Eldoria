using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCORPIONPAULDRON
#
###############################################################################

Class BEScorpionPauldron : BEPauldron {
	BEScorpionPauldron() : base() {
		$this.Name               = 'Scorpion Pauldron'
		$this.MapObjName         = 'scorpionpauldron'
		$this.PurchasePrice      = 5550
		$this.SellPrice          = 2775
		$this.TargetStats        = @{
			[StatId]::Defense = 111
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sharp and deadly, enhancing critical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
