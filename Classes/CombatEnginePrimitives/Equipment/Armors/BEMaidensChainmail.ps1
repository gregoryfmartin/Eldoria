using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAIDENSCHAINMAIL
#
###############################################################################

Class BEMaidensChainmail : BEArmor {
	BEMaidensChainmail() : base() {
		$this.Name               = 'Maiden''s Chainmail'
		$this.MapObjName         = 'maidenschainmail'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lighter, more flexible chainmail designed for female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
