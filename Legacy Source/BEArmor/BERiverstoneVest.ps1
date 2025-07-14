using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERIVERSTONEVEST
#
###############################################################################

Class BERiverstoneVest : BEArmor {
	BERiverstoneVest() : base() {
		$this.Name               = 'Riverstone Vest'
		$this.MapObjName         = 'riverstonevest'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with smooth river stones, offering minor water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
