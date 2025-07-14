using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFISHERMANSKNITCAP
#
###############################################################################

Class BEFishermansKnitCap : BEHelmet {
	BEFishermansKnitCap() : base() {
		$this.Name               = 'Fisherman''s Knit Cap'
		$this.MapObjName         = 'fishermansknitcap'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm knit cap for fishermen, warding off the cold.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
