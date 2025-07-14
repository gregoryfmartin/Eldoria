using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONESKINVEST
#
###############################################################################

Class BEStoneSkinVest : BEArmor {
	BEStoneSkinVest() : base() {
		$this.Name               = 'Stone Skin Vest'
		$this.MapObjName         = 'stoneskinvest'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that makes the wearer''s skin as hard as stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
