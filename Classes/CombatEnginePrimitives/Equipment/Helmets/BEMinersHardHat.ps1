using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINERSHARDHAT
#
###############################################################################

Class BEMinersHardHat : BEHelmet {
	BEMinersHardHat() : base() {
		$this.Name               = 'Miner''s Hard Hat'
		$this.MapObjName         = 'minershardhat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hard hat with a lamp, essential for mining.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
