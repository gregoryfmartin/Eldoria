using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALSILKROBE
#
###############################################################################

Class BEAstralSilkRobe : BEArmor {
	BEAstralSilkRobe() : base() {
		$this.Name               = 'Astral Silk Robe'
		$this.MapObjName         = 'astralsilkrobe'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from ethereal silk, allowing slight glimpses into other dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
