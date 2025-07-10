using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOACHGREAVES
#
###############################################################################

Class BECoachGreaves : BEGreaves {
	BECoachGreaves() : base() {
		$this.Name               = 'Coach Greaves'
		$this.MapObjName         = 'coachgreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for athletic guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
