using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWEREWOLFHIDEVEST
#
###############################################################################

Class BEWerewolfHideVest : BEArmor {
	BEWerewolfHideVest() : base() {
		$this.Name               = 'Werewolf Hide Vest'
		$this.MapObjName         = 'werewolfhidevest'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the hide of a werewolf, offers minor strength boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
