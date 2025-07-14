using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWEREWOLFCLAWRING
#
###############################################################################

Class BEWerewolfClawRing : BEJewelry {
	BEWerewolfClawRing() : base() {
		$this.Name               = 'Werewolf Claw Ring'
		$this.MapObjName         = 'werewolfclawring'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ring with a werewolf claw, granting ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
