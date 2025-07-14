using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREAPERSSHROUD
#
###############################################################################

Class BEReapersShroud : BEArmor {
	BEReapersShroud() : base() {
		$this.Name               = 'Reaper''s Shroud'
		$this.MapObjName         = 'reapersshroud'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, flowing shroud that seems to absorb light, feared by many.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
