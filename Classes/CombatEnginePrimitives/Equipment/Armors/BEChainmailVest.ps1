using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAINMAILVEST
#
###############################################################################

Class BEChainmailVest : BEArmor {
	BEChainmailVest() : base() {
		$this.Name               = 'Chainmail Vest'
		$this.MapObjName         = 'chainmailvest'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made of interlocking metal rings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
