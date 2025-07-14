using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDENTEDBREASTPLATE
#
###############################################################################

Class BEDentedBreastplate : BEArmor {
	BEDentedBreastplate() : base() {
		$this.Name               = 'Dented Breastplate'
		$this.MapObjName         = 'dentedbreastplate'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate that has seen better days, but still functions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
