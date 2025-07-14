using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREINFORCEDLEATHER
#
###############################################################################

Class BEReinforcedLeather : BEArmor {
	BEReinforcedLeather() : base() {
		$this.Name               = 'Reinforced Leather'
		$this.MapObjName         = 'reinforcedleather'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather armor with additional plating for better defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
