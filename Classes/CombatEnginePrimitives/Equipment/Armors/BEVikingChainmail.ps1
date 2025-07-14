using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVIKINGCHAINMAIL
#
###############################################################################

Class BEVikingChainmail : BEArmor {
	BEVikingChainmail() : base() {
		$this.Name               = 'Viking Chainmail'
		$this.MapObjName         = 'vikingchainmail'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, sturdy chainmail favored by northern warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
