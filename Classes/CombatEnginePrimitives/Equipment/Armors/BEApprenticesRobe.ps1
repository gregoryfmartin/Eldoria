using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPPRENTICESROBE
#
###############################################################################

Class BEApprenticesRobe : BEArmor {
	BEApprenticesRobe() : base() {
		$this.Name               = 'Apprentice''s Robe'
		$this.MapObjName         = 'apprenticesrobe'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain robe worn by aspiring mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
