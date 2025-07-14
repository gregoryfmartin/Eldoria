using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSCALEPLATE
#
###############################################################################

Class BEDragonScalePlate : BEArmor {
	BEDragonScalePlate() : base() {
		$this.Name               = 'Dragon Scale Plate'
		$this.MapObjName         = 'dragonscaleplate'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor crafted from genuine dragon scales, incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
