using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANGELSROBE
#
###############################################################################

Class BEAngelsRobe : BEArmor {
	BEAngelsRobe() : base() {
		$this.Name               = 'Angel''s Robe'
		$this.MapObjName         = 'angelsrobe'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant robe that offers powerful divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
