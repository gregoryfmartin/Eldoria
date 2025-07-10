using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESEERSEYEPATCH
#
###############################################################################

Class BESeersEyepatch : BEHelmet {
	BESeersEyepatch() : base() {
		$this.Name               = 'Seer''s Eyepatch'
		$this.MapObjName         = 'seerseyepatch'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An eyepatch worn by seers, sometimes to focus their prophetic visions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
