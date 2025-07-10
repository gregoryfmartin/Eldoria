using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHYDRAHEADHELM
#
###############################################################################

Class BEHydraHeadHelm : BEHelmet {
	BEHydraHeadHelm() : base() {
		$this.Name               = 'Hydra Head Helm'
		$this.MapObjName         = 'hydraheadhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A monstrous helm adorned with a hydra head, granting multiple perspectives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
