using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANEWEAVEGLOVES
#
###############################################################################

Class BEArcaneWeaveGloves : BEGauntlets {
	BEArcaneWeaveGloves() : base() {
		$this.Name               = 'Arcane Weave Gloves'
		$this.MapObjName         = 'arcaneweavegloves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves intricately woven with arcane threads, enhancing spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
