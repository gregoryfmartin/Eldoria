using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEATHWHISPERRING
#
###############################################################################

Class BEDeathwhisperRing : BEJewelry {
	BEDeathwhisperRing() : base() {
		$this.Name               = 'Deathwhisper Ring'
		$this.MapObjName         = 'deathwhisperring'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring that whispers of death, chilling to the touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
