using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CANDLESTICK
#
###############################################################################

Class BECandlestick : BEWeapon {
	BECandlestick() : base() {
		$this.Name          = 'Candlestick'
		$this.MapObjName    = 'candlestick'
		$this.PurchasePrice = 50
		$this.SellPrice     = 25
		$this.TargetStats   = @{
			[StatId]::Attack = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy metal candlestick.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
