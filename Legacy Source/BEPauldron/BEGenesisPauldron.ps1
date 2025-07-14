using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGENESISPAULDRON
#
###############################################################################

Class BEGenesisPauldron : BEPauldron {
	BEGenesisPauldron() : base() {
		$this.Name               = 'Genesis Pauldron'
		$this.MapObjName         = 'genesispauldron'
		$this.PurchasePrice      = 6750
		$this.SellPrice          = 3375
		$this.TargetStats        = @{
			[StatId]::Defense = 135
			[StatId]::MagicDefense = 56
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron of creation, capable of altering reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
