using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOSSAMERFILAMENT
#
###############################################################################

Class BEGossamerFilament : BEJewelry {
	BEGossamerFilament() : base() {
		$this.Name               = 'Gossamer Filament'
		$this.MapObjName         = 'gossamerfilament'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An almost invisible filament, for subtle movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
