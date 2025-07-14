using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEPAULDRON
#
###############################################################################

Class BEStonePauldron : BEPauldron {
	BEStonePauldron() : base() {
		$this.Name               = 'Stone Pauldron'
		$this.MapObjName         = 'stonepauldron'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{
			[StatId]::Defense = 64
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and unyielding, providing immense protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
