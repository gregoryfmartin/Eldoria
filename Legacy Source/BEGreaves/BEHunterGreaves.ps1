using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERGREAVES
#
###############################################################################

Class BEHunterGreaves : BEGreaves {
	BEHunterGreaves() : base() {
		$this.Name               = 'Hunter Greaves'
		$this.MapObjName         = 'huntergreaves'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves designed for tracking and hunting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
