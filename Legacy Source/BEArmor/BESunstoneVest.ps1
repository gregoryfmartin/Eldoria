using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONEVEST
#
###############################################################################

Class BESunstoneVest : BEArmor {
	BESunstoneVest() : base() {
		$this.Name               = 'Sunstone Vest'
		$this.MapObjName         = 'sunstonevest'
		$this.PurchasePrice      = 270
		$this.SellPrice          = 135
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with sunstone fragments, offering fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
