using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMITHRILBOOTS
#
###############################################################################

Class BEMithrilBoots : BEBoots {
	BEMithrilBoots() : base() {
		$this.Name               = 'Mithril Boots'
		$this.MapObjName         = 'mithrilboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from light and strong mithril.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
