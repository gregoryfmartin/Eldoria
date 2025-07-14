using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASSASSINBOOTS
#
###############################################################################

Class BEAssassinBoots : BEBoots {
	BEAssassinBoots() : base() {
		$this.Name               = 'Assassin Boots'
		$this.MapObjName         = 'assassinboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for silent kills.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
