using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAIRYBOOTS
#
###############################################################################

Class BEFairyBoots : BEBoots {
	BEFairyBoots() : base() {
		$this.Name               = 'Fairy Boots'
		$this.MapObjName         = 'fairyboots'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Delicate and enchanting boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
