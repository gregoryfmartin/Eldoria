using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOACHBOOTS
#
###############################################################################

Class BECoachBoots : BEBoots {
	BECoachBoots() : base() {
		$this.Name               = 'Coach Boots'
		$this.MapObjName         = 'coachboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for athletic guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
