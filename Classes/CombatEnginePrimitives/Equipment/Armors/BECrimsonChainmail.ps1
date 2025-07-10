using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONCHAINMAIL
#
###############################################################################

Class BECrimsonChainmail : BEArmor {
	BECrimsonChainmail() : base() {
		$this.Name               = 'Crimson Chainmail'
		$this.MapObjName         = 'crimsonchainmail'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail dyed crimson, favored by elite guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
