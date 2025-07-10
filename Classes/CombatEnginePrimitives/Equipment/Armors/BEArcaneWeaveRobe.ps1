using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANEWEAVEROBE
#
###############################################################################

Class BEArcaneWeaveRobe : BEArmor {
	BEArcaneWeaveRobe() : base() {
		$this.Name               = 'Arcane Weave Robe'
		$this.MapObjName         = 'arcaneweaverobe'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven with pure arcane energy, granting significant magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
