using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELLBOUNDGAUNTLETSII
#
###############################################################################

Class BESpellboundGauntletsII : BEGauntlets {
	BESpellboundGauntletsII() : base() {
		$this.Name               = 'Spellbound Gauntlets II'
		$this.MapObjName         = 'spellboundgauntletsii'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Spellbound Gauntlets, stronger protective spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
