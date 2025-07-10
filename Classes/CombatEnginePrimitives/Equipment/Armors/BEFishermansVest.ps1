using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFISHERMANSVEST
#
###############################################################################

Class BEFishermansVest : BEArmor {
	BEFishermansVest() : base() {
		$this.Name               = 'Fisherman''s Vest'
		$this.MapObjName         = 'fishermansvest'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical vest with many pockets, surprisingly resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
