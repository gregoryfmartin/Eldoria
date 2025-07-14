using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERECONBOOTS
#
###############################################################################

Class BEReconBoots : BEBoots {
	BEReconBoots() : base() {
		$this.Name               = 'Recon Boots'
		$this.MapObjName         = 'reconboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 8
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for reconnaissance missions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
