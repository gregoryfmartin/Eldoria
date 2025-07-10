using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPARADOXPAULDRON
#
###############################################################################

Class BEParadoxPauldron : BEPauldron {
	BEParadoxPauldron() : base() {
		$this.Name               = 'Paradox Pauldron'
		$this.MapObjName         = 'paradoxpauldron'
		$this.PurchasePrice      = 6950
		$this.SellPrice          = 3475
		$this.TargetStats        = @{
			[StatId]::Defense = 139
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Defies the laws of physics, offering unpredictable defensive effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
