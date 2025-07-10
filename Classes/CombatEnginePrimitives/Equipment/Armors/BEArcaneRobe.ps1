using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANEROBE
#
###############################################################################

Class BEArcaneRobe : BEArmor {
	BEArcaneRobe() : base() {
		$this.Name               = 'Arcane Robe'
		$this.MapObjName         = 'arcanerobe'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe crackling with uncontrolled magical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
