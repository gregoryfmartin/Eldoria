using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEGENDARYPLATE
#
###############################################################################

Class BELegendaryPlate : BEArmor {
	BELegendaryPlate() : base() {
		$this.Name               = 'Legendary Plate'
		$this.MapObjName         = 'legendaryplate'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor of unfathomable strength, rumored to be divine.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
