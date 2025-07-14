using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIFFINBOOTS
#
###############################################################################

Class BEGriffinBoots : BEBoots {
	BEGriffinBoots() : base() {
		$this.Name               = 'Griffin Boots'
		$this.MapObjName         = 'griffinboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 22
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that grant swiftness and grace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
