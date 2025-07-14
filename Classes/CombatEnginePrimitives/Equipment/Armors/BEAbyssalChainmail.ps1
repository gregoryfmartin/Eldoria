using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALCHAINMAIL
#
###############################################################################

Class BEAbyssalChainmail : BEArmor {
	BEAbyssalChainmail() : base() {
		$this.Name               = 'Abyssal Chainmail'
		$this.MapObjName         = 'abyssalchainmail'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail found in the deepest parts of the ocean, resistant to pressure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
