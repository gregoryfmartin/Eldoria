using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELLBINDERSGLOVES
#
###############################################################################

Class BESpellbindersGloves : BEGauntlets {
	BESpellbindersGloves() : base() {
		$this.Name               = 'Spellbinder''s Gloves'
		$this.MapObjName         = 'spellbindersgloves'
		$this.PurchasePrice      = 360
		$this.SellPrice          = 180
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves designed to assist in the casting of complex spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
