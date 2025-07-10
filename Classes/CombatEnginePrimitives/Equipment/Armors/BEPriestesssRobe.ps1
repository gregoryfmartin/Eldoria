using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRIESTESSSROBE
#
###############################################################################

Class BEPriestesssRobe : BEArmor {
	BEPriestesssRobe() : base() {
		$this.Name               = 'Priestess''s Robe'
		$this.MapObjName         = 'priestesssrobe'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pure white robe, blessed with divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
