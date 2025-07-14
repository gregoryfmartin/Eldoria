using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRGLOVES
#
###############################################################################

Class BEZephyrGloves : BEGauntlets {
	BEZephyrGloves() : base() {
		$this.Name               = 'Zephyr Gloves'
		$this.MapObjName         = 'zephyrgloves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves light as air, granting incredible speed and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
