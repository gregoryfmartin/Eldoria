using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLOWWORMLAMP
#
###############################################################################

Class BEGlowwormLamp : BEJewelry {
	BEGlowwormLamp() : base() {
		$this.Name               = 'Glowworm Lamp'
		$this.MapObjName         = 'glowwormlamp'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny lamp containing a perpetual glowworm.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
