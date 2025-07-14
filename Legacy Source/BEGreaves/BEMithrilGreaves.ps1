using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMITHRILGREAVES
#
###############################################################################

Class BEMithrilGreaves : BEGreaves {
	BEMithrilGreaves() : base() {
		$this.Name               = 'Mithril Greaves'
		$this.MapObjName         = 'mithrilgreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 15
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves crafted from light and strong mithril.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
