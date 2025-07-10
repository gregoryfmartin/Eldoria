using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARDENERSHAT
#
###############################################################################

Class BEGardenersHat : BEHelmet {
	BEGardenersHat() : base() {
		$this.Name               = 'Gardener''s Hat'
		$this.MapObjName         = 'gardenershat'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A wide-brimmed hat for gardeners, protecting from the sun.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
