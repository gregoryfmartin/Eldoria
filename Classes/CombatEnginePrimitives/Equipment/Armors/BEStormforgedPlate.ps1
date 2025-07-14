using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMFORGEDPLATE
#
###############################################################################

Class BEStormforgedPlate : BEArmor {
	BEStormforgedPlate() : base() {
		$this.Name               = 'Stormforged Plate'
		$this.MapObjName         = 'stormforgedplate'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor that hums with static electricity, resisting lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
