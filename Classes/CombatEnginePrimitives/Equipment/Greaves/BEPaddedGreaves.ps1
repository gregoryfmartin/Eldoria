using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPADDEDGREAVES
#
###############################################################################

Class BEPaddedGreaves : BEGreaves {
	BEPaddedGreaves() : base() {
		$this.Name               = 'Padded Greaves'
		$this.MapObjName         = 'paddedgreaves'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 3
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightly padded greaves for agile combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
