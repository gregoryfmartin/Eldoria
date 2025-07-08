using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STONE GOLEM HAMMER
#
###############################################################################

Class BEStoneGolemHammer : BEWeapon {
	BEStoneGolemHammer() : base() {
		$this.Name          = 'Stone Golem Hammer'
		$this.MapObjName    = 'stonegolemhammer'
		$this.PurchasePrice = 5000
		$this.SellPrice     = 2500
		$this.TargetStats   = @{
			[StatId]::Attack = 135
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive hammer crafted from a golem''s remains, incredibly heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
