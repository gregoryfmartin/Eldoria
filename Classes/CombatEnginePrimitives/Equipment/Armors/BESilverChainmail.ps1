using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERCHAINMAIL
#
###############################################################################

Class BESilverChainmail : BEArmor {
	BESilverChainmail() : base() {
		$this.Name               = 'Silver Chainmail'
		$this.MapObjName         = 'silverchainmail'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail woven with strands of silver, effective against dark creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
