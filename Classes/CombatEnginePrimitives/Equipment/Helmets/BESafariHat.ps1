using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SAFARI HAT
#
###############################################################################

Class BESafariHat : BEHelmet {
	BESafariHat() : base() {
		$this.Name               = 'Safari Hat'
		$this.MapObjName         = 'safarihat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical hat for safaris, providing sun protection and camouflage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
