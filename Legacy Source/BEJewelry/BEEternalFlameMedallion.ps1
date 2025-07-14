using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETERNALFLAMEMEDALLION
#
###############################################################################

Class BEEternalFlameMedallion : BEJewelry {
	BEEternalFlameMedallion() : base() {
		$this.Name               = 'Eternal Flame Medallion'
		$this.MapObjName         = 'eternalflamemedallion'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A medallion with a small, perpetual flame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}
