using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMERSROBE
#
###############################################################################

Class BEDreamersRobe : BEArmor {
	BEDreamersRobe() : base() {
		$this.Name               = 'Dreamer''s Robe'
		$this.MapObjName         = 'dreamersrobe'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A soft robe that aids in lucid dreaming, enhancing magical recovery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
