using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMETDUSTVIAL
#
###############################################################################

Class BECometDustVial : BEJewelry {
	BECometDustVial() : base() {
		$this.Name               = 'Comet Dust Vial'
		$this.MapObjName         = 'cometdustvial'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Speed = 2
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vial filled with the dust of a passing comet.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
