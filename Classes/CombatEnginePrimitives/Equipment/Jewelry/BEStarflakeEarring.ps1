using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFLAKEEARRING
#
###############################################################################

Class BEStarflakeEarring : BEJewelry {
	BEStarflakeEarring() : base() {
		$this.Name               = 'Starflake Earring'
		$this.MapObjName         = 'starflakeearring'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate earring resembling a starflake, for swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
