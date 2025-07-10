using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICWHISPERPEARL
#
###############################################################################

Class BECosmicWhisperPearl : BEJewelry {
	BECosmicWhisperPearl() : base() {
		$this.Name               = 'Cosmic Whisper Pearl'
		$this.MapObjName         = 'cosmicwhisperpearl'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pearl that seems to hum with the sounds of the cosmos.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
