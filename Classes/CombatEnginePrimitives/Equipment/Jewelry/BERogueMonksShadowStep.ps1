using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROGUEMONKSSHADOWSTEP
#
###############################################################################

Class BERogueMonksShadowStep : BEJewelry {
	BERogueMonksShadowStep() : base() {
		$this.Name               = 'Rogue Monk''s Shadow Step'
		$this.MapObjName         = 'roguemonksshadowstep'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small shadow-like charm, aiding in silent movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
