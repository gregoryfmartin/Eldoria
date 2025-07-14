using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAINMAILGAUNTLETS
#
###############################################################################

Class BEChainmailGauntlets : BEGauntlets {
	BEChainmailGauntlets() : base() {
		$this.Name               = 'Chainmail Gauntlets'
		$this.MapObjName         = 'chainmailgauntlets'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Flexible chainmail providing good all-around protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
