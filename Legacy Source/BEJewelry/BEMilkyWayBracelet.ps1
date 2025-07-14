using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMILKYWAYBRACELET
#
###############################################################################

Class BEMilkyWayBracelet : BEJewelry {
	BEMilkyWayBracelet() : base() {
		$this.Name               = 'Milky Way Bracelet'
		$this.MapObjName         = 'milkywaybracelet'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet that seems to swirl with countless stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
