using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALROBE
#
###############################################################################

Class BEAstralRobe : BEArmor {
	BEAstralRobe() : base() {
		$this.Name               = 'Astral Robe'
		$this.MapObjName         = 'astralrobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be woven from threads of the cosmos.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
