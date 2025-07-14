using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENINJABOOTS
#
###############################################################################

Class BENinjaBoots : BEBoots {
	BENinjaBoots() : base() {
		$this.Name               = 'Ninja Boots'
		$this.MapObjName         = 'ninjaboots'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and silent boots for covert operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
