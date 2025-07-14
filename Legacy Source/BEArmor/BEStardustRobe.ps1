using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARDUSTROBE
#
###############################################################################

Class BEStardustRobe : BEArmor {
	BEStardustRobe() : base() {
		$this.Name               = 'Stardust Robe'
		$this.MapObjName         = 'stardustrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that shimmers like scattered stardust, boosting cosmic magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
