using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORTUNECOIN
#
###############################################################################

Class BEFortuneCoin : BEJewelry {
	BEFortuneCoin() : base() {
		$this.Name               = 'Fortune Coin'
		$this.MapObjName         = 'fortunecoin'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A coin that seems to always land on its desired side.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
