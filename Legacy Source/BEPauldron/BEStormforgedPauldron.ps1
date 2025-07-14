using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMFORGEDPAULDRON
#
###############################################################################

Class BEStormforgedPauldron : BEPauldron {
	BEStormforgedPauldron() : base() {
		$this.Name               = 'Stormforged Pauldron'
		$this.MapObjName         = 'stormforgedpauldron'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged in the heart of a storm, crackling with energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
