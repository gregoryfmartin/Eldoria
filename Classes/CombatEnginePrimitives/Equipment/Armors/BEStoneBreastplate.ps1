using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEBREASTPLATE
#
###############################################################################

Class BEStoneBreastplate : BEArmor {
	BEStoneBreastplate() : base() {
		$this.Name               = 'Stone Breastplate'
		$this.MapObjName         = 'stonebreastplate'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy breastplate carved from a single piece of stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
