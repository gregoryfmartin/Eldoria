using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESKELETONGREAVES
#
###############################################################################

Class BESkeletonGreaves : BEGreaves {
	BESkeletonGreaves() : base() {
		$this.Name               = 'Skeleton Greaves'
		$this.MapObjName         = 'skeletongreaves'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bony greaves, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
