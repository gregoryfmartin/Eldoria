using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWEAVERSROBE
#
###############################################################################

Class BESpiritWeaversRobe : BEArmor {
	BESpiritWeaversRobe() : base() {
		$this.Name               = 'Spirit Weaver''s Robe'
		$this.MapObjName         = 'spiritweaversrobe'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe used to commune with spirits, enhancing spiritual magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
