using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTCHAINMAIL
#
###############################################################################

Class BELightChainmail : BEArmor {
	BELightChainmail() : base() {
		$this.Name               = 'Light Chainmail'
		$this.MapObjName         = 'lightchainmail'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lighter version of chainmail, for increased mobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
