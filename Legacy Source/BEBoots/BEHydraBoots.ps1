using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHYDRABOOTS
#
###############################################################################

Class BEHydraBoots : BEBoots {
	BEHydraBoots() : base() {
		$this.Name               = 'Hydra Boots'
		$this.MapObjName         = 'hydraboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of multi-headed beasts, regenerating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
