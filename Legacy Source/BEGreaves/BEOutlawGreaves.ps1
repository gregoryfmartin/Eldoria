using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOUTLAWGREAVES
#
###############################################################################

Class BEOutlawGreaves : BEGreaves {
	BEOutlawGreaves() : base() {
		$this.Name               = 'Outlaw Greaves'
		$this.MapObjName         = 'outlawgreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those living outside the law.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
