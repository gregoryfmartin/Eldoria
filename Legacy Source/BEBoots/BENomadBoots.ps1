using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOMADBOOTS
#
###############################################################################

Class BENomadBoots : BEBoots {
	BENomadBoots() : base() {
		$this.Name               = 'Nomad Boots'
		$this.MapObjName         = 'nomadboots'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 6
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who live on the move.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
