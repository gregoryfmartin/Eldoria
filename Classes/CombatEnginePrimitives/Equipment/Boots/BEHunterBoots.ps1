using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERBOOTS
#
###############################################################################

Class BEHunterBoots : BEBoots {
	BEHunterBoots() : base() {
		$this.Name               = 'Hunter Boots'
		$this.MapObjName         = 'hunterboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for tracking and hunting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
