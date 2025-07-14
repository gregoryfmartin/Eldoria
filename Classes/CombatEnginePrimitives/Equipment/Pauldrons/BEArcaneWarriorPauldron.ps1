using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANEWARRIORPAULDRON
#
###############################################################################

Class BEArcaneWarriorPauldron : BEPauldron {
	BEArcaneWarriorPauldron() : base() {
		$this.Name               = 'Arcane Warrior Pauldron'
		$this.MapObjName         = 'arcanewarriorpauldron'
		$this.PurchasePrice      = 7100
		$this.SellPrice          = 3550
		$this.TargetStats        = @{
			[StatId]::Defense = 142
			[StatId]::MagicDefense = 63
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends magical and physical defense, for versatile fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
