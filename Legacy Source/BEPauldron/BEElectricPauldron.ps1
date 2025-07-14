using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELECTRICPAULDRON
#
###############################################################################

Class BEElectricPauldron : BEPauldron {
	BEElectricPauldron() : base() {
		$this.Name               = 'Electric Pauldron'
		$this.MapObjName         = 'electricpauldron'
		$this.PurchasePrice      = 4150
		$this.SellPrice          = 2075
		$this.TargetStats        = @{
			[StatId]::Defense = 83
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crackles with static electricity, shocking nearby enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
