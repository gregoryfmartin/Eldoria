using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOUTLAWBOOTS
#
###############################################################################

Class BEOutlawBoots : BEBoots {
	BEOutlawBoots() : base() {
		$this.Name               = 'Outlaw Boots'
		$this.MapObjName         = 'outlawboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those living outside the law.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
