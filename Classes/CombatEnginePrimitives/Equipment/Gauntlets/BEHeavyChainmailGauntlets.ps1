using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEAVYCHAINMAILGAUNTLETS
#
###############################################################################

Class BEHeavyChainmailGauntlets : BEGauntlets {
	BEHeavyChainmailGauntlets() : base() {
		$this.Name               = 'Heavy Chainmail Gauntlets'
		$this.MapObjName         = 'heavychainmailgauntlets'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dense chainmail gauntlets, offering robust defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
