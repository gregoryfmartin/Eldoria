using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALPAULDRON
#
###############################################################################

Class BEAstralPauldron : BEPauldron {
	BEAstralPauldron() : base() {
		$this.Name               = 'Astral Pauldron'
		$this.MapObjName         = 'astralpauldron'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Said to be woven from starlight, offering cosmic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
