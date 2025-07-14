using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFISHERMANSHAT
#
###############################################################################

Class BEFishermansHat : BEHelmet {
	BEFishermansHat() : base() {
		$this.Name               = 'Fisherman''s Hat'
		$this.MapObjName         = 'fishermanshat'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wide-brimmed hat that protects fishermen from the elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
