using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELLBLADEPAULDRON
#
###############################################################################

Class BESpellbladePauldron : BEPauldron {
	BESpellbladePauldron() : base() {
		$this.Name               = 'Spellblade Pauldron'
		$this.MapObjName         = 'spellbladepauldron'
		$this.PurchasePrice      = 7150
		$this.SellPrice          = 3575
		$this.TargetStats        = @{
			[StatId]::Defense = 143
			[StatId]::MagicDefense = 64
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances both swordplay and spellcasting defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
