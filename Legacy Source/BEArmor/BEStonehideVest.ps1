using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEHIDEVEST
#
###############################################################################

Class BEStonehideVest : BEArmor {
	BEStonehideVest() : base() {
		$this.Name               = 'Stonehide Vest'
		$this.MapObjName         = 'stonehidevest'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that feels as tough as stone, surprisingly flexible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
