using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITROBE
#
###############################################################################

Class BESpiritRobe : BEArmor {
	BESpiritRobe() : base() {
		$this.Name               = 'Spirit Robe'
		$this.MapObjName         = 'spiritrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent robe that shimmers with ethereal energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
