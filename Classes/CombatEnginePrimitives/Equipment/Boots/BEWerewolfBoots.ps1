using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWEREWOLFBOOTS
#
###############################################################################

Class BEWerewolfBoots : BEBoots {
	BEWerewolfBoots() : base() {
		$this.Name               = 'Werewolf Boots'
		$this.MapObjName         = 'werewolfboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a shapeshifter, enhances agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
