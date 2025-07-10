using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECURATORPAULDRON
#
###############################################################################

Class BECuratorPauldron : BEPauldron {
	BECuratorPauldron() : base() {
		$this.Name               = 'Curator Pauldron'
		$this.MapObjName         = 'curatorpauldron'
		$this.PurchasePrice      = 9750
		$this.SellPrice          = 4875
		$this.TargetStats        = @{
			[StatId]::Defense = 195
			[StatId]::MagicDefense = 87
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Preserves precious artifacts and enhances identification abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
