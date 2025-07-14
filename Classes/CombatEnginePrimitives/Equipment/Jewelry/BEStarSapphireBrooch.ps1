using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARSAPPHIREBROOCH
#
###############################################################################

Class BEStarSapphireBrooch : BEJewelry {
	BEStarSapphireBrooch() : base() {
		$this.Name               = 'Star Sapphire Brooch'
		$this.MapObjName         = 'starsapphirebrooch'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rare star sapphire brooch, said to grant wishes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}
