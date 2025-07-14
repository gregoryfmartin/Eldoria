using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDERERBOOTS
#
###############################################################################

Class BEWandererBoots : BEBoots {
	BEWandererBoots() : base() {
		$this.Name               = 'Wanderer Boots'
		$this.MapObjName         = 'wandererboots'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 5
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for eternal travelers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
