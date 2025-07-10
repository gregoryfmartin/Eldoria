using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESKELETONBOOTS
#
###############################################################################

Class BESkeletonBoots : BEBoots {
	BESkeletonBoots() : base() {
		$this.Name               = 'Skeleton Boots'
		$this.MapObjName         = 'skeletonboots'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bony boots, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
