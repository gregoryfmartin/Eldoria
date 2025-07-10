using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERSFURHOOD
#
###############################################################################

Class BEHuntersFurHood : BEHelmet {
	BEHuntersFurHood() : base() {
		$this.Name               = 'Hunter''s Fur Hood'
		$this.MapObjName         = 'huntersfurhood'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm fur hood for hunters, providing warmth and stealth in cold climates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
