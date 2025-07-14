using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAIRYGREAVES
#
###############################################################################

Class BEFairyGreaves : BEGreaves {
	BEFairyGreaves() : base() {
		$this.Name               = 'Fairy Greaves'
		$this.MapObjName         = 'fairygreaves'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Delicate and enchanting greaves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
