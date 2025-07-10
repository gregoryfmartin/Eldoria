using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMISTROBE
#
###############################################################################

Class BEMistRobe : BEArmor {
	BEMistRobe() : base() {
		$this.Name               = 'Mist Robe'
		$this.MapObjName         = 'mistrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that seems to shimmer like mist, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
