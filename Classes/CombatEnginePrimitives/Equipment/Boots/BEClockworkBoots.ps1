using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOCKWORKBOOTS
#
###############################################################################

Class BEClockworkBoots : BEBoots {
	BEClockworkBoots() : base() {
		$this.Name               = 'Clockwork Boots'
		$this.MapObjName         = 'clockworkboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots with intricate clockwork mechanisms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
