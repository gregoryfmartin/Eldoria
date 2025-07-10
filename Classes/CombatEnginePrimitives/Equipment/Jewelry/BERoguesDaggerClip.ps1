using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROGUESDAGGERCLIP
#
###############################################################################

Class BERoguesDaggerClip : BEJewelry {
	BERoguesDaggerClip() : base() {
		$this.Name               = 'Rogue''s Dagger Clip'
		$this.MapObjName         = 'roguesdaggerclip'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A clip shaped like a small dagger, for quick action.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
