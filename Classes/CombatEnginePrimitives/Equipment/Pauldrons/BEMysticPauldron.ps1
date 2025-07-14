using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICPAULDRON
#
###############################################################################

Class BEMysticPauldron : BEPauldron {
	BEMysticPauldron() : base() {
		$this.Name               = 'Mystic Pauldron'
		$this.MapObjName         = 'mysticpauldron'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with arcane energies, enhancing magical defenses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
