using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECINDERPAULDRON
#
###############################################################################

Class BECinderPauldron : BEPauldron {
	BECinderPauldron() : base() {
		$this.Name               = 'Cinder Pauldron'
		$this.MapObjName         = 'cinderpauldron'
		$this.PurchasePrice      = 3600
		$this.SellPrice          = 1800
		$this.TargetStats        = @{
			[StatId]::Defense = 72
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Still smoldering from its creation, radiates warmth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
