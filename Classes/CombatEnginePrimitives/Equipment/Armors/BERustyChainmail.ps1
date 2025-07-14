using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUSTYCHAINMAIL
#
###############################################################################

Class BERustyChainmail : BEArmor {
	BERustyChainmail() : base() {
		$this.Name               = 'Rusty Chainmail'
		$this.MapObjName         = 'rustychainmail'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Old and rusted chainmail, prone to breaking.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
