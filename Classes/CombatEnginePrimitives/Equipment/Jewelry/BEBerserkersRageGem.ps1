using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERSRAGEGEM
#
###############################################################################

Class BEBerserkersRageGem : BEJewelry {
	BEBerserkersRageGem() : base() {
		$this.Name               = 'Berserker''s Rage Gem'
		$this.MapObjName         = 'berserkersragegem'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Attack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A volatile gem that pulses with raw anger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}
