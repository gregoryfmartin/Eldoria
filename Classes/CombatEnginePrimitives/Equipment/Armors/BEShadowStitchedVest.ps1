using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWSTITCHEDVEST
#
###############################################################################

Class BEShadowStitchedVest : BEArmor {
	BEShadowStitchedVest() : base() {
		$this.Name               = 'Shadow-Stitched Vest'
		$this.MapObjName         = 'shadowstitchedvest'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest sewn with threads of shadow, enhancing stealth and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
