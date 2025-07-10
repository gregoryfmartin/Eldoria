using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWRITERSQUILLCAP
#
###############################################################################

Class BEWritersQuillCap : BEHelmet {
	BEWritersQuillCap() : base() {
		$this.Name               = 'Writer''s Quill Cap'
		$this.MapObjName         = 'writersquillcap'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap with a quill, aiding writers in their craft.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
