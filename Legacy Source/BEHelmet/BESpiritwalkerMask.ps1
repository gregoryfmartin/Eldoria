using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWALKERMASK
#
###############################################################################

Class BESpiritwalkerMask : BEHelmet {
	BESpiritwalkerMask() : base() {
		$this.Name               = 'Spiritwalker Mask'
		$this.MapObjName         = 'spiritwalkermask'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial mask that allows communion with spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
