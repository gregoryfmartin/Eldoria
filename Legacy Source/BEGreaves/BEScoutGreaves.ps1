using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCOUTGREAVES
#
###############################################################################

Class BEScoutGreaves : BEGreaves {
	BEScoutGreaves() : base() {
		$this.Name               = 'Scout Greaves'
		$this.MapObjName         = 'scoutgreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 8
			[StatId]::Speed = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light greaves for quick movement and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
