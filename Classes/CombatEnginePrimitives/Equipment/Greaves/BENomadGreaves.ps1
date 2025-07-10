using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOMADGREAVES
#
###############################################################################

Class BENomadGreaves : BEGreaves {
	BENomadGreaves() : base() {
		$this.Name               = 'Nomad Greaves'
		$this.MapObjName         = 'nomadgreaves'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 7
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those who live on the move.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
