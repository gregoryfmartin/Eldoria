using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEPHYRWEAVEGAUNTLETS
#
###############################################################################

Class BEZephyrweaveGauntlets : BEGauntlets {
	BEZephyrweaveGauntlets() : base() {
		$this.Name               = 'Zephyrweave Gauntlets'
		$this.MapObjName         = 'zephyrweavegauntlets'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 27
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets woven from enchanted air, granting swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
