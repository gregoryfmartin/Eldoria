using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERECONGREAVES
#
###############################################################################

Class BEReconGreaves : BEGreaves {
	BEReconGreaves() : base() {
		$this.Name               = 'Recon Greaves'
		$this.MapObjName         = 'recongreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light greaves for reconnaissance missions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
