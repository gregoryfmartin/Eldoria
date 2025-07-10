using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUPERNOVAGEM
#
###############################################################################

Class BESupernovaGem : BEJewelry {
	BESupernovaGem() : base() {
		$this.Name               = 'Supernova Gem'
		$this.MapObjName         = 'supernovagem'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Attack = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that pulses with immense destructive energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Male
	}
}
