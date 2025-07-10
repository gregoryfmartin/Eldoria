using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOCKWORKGREAVES
#
###############################################################################

Class BEClockworkGreaves : BEGreaves {
	BEClockworkGreaves() : base() {
		$this.Name               = 'Clockwork Greaves'
		$this.MapObjName         = 'clockworkgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves with intricate clockwork mechanisms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
