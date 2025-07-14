using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFARMERSSMOCK
#
###############################################################################

Class BEFarmersSmock : BEArmor {
	BEFarmersSmock() : base() {
		$this.Name               = 'Farmer''s Smock'
		$this.MapObjName         = 'farmerssmock'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough smock, offering almost no protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
