using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAINMAILGREAVES
#
###############################################################################

Class BEChainmailGreaves : BEGreaves {
	BEChainmailGreaves() : base() {
		$this.Name               = 'Chainmail Greaves'
		$this.MapObjName         = 'chainmailgreaves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Flexible chainmail leg guards, good against piercing attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
