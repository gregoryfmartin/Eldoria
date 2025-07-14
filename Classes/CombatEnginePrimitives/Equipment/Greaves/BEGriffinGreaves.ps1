using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINGREAVES
#
###############################################################################

Class BEGriffinGreaves : BEGreaves {
	BEGriffinGreaves() : base() {
		$this.Name               = 'Griffin Greaves'
		$this.MapObjName         = 'griffingreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that grant swiftness and grace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
