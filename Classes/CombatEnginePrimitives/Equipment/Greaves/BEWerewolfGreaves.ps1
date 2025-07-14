using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWEREWOLFGREAVES
#
###############################################################################

Class BEWerewolfGreaves : BEGreaves {
	BEWerewolfGreaves() : base() {
		$this.Name               = 'Werewolf Greaves'
		$this.MapObjName         = 'werewolfgreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a shapeshifter, enhances agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
