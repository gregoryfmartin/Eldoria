using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCHOLARSQUILLBROOCH
#
###############################################################################

Class BEScholarsQuillBrooch : BEJewelry {
	BEScholarsQuillBrooch() : base() {
		$this.Name               = 'Scholar''s Quill Brooch'
		$this.MapObjName         = 'scholarsquillbrooch'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brooch shaped like a quill, enhancing learning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
