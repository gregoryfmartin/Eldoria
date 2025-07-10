using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASSASSINGREAVES
#
###############################################################################

Class BEAssassinGreaves : BEGreaves {
	BEAssassinGreaves() : base() {
		$this.Name               = 'Assassin Greaves'
		$this.MapObjName         = 'assassingreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves designed for silent kills.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
