using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONBREASTPLATE
#
###############################################################################

Class BEIronBreastplate : BEArmor {
	BEIronBreastplate() : base() {
		$this.Name               = 'Iron Breastplate'
		$this.MapObjName         = 'ironbreastplate'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solid iron plate protecting the chest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
