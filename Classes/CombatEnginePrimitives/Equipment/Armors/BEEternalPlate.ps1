using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETERNALPLATE
#
###############################################################################

Class BEEternalPlate : BEArmor {
	BEEternalPlate() : base() {
		$this.Name               = 'Eternal Plate'
		$this.MapObjName         = 'eternalplate'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor said to be from another dimension, unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
