using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREINFORCEDCUIRASS
#
###############################################################################

Class BEReinforcedCuirass : BEArmor {
	BEReinforcedCuirass() : base() {
		$this.Name               = 'Reinforced Cuirass'
		$this.MapObjName         = 'reinforcedcuirass'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass with extra plating in vital areas.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
