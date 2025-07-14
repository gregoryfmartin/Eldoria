using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORATORSHEADPIECE
#
###############################################################################

Class BEOratorsHeadpiece : BEHelmet {
	BEOratorsHeadpiece() : base() {
		$this.Name               = 'Orator''s Headpiece'
		$this.MapObjName         = 'oratorsheadpiece'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stately headpiece worn by orators, enhancing their persuasive abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
