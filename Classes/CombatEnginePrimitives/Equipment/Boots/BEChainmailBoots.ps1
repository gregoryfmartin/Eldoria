using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAINMAILBOOTS
#
###############################################################################

Class BEChainmailBoots : BEBoots {
	BEChainmailBoots() : base() {
		$this.Name               = 'Chainmail Boots'
		$this.MapObjName         = 'chainmailboots'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Flexible chainmail foot protection, good against piercing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
