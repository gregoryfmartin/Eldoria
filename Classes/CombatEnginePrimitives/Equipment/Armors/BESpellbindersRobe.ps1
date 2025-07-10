using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELLBINDERSROBE
#
###############################################################################

Class BESpellbindersRobe : BEArmor {
	BESpellbindersRobe() : base() {
		$this.Name               = 'Spellbinder''s Robe'
		$this.MapObjName         = 'spellbindersrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant robe that hums with magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
