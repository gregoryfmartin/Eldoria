using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTCHAINMAIL
#
###############################################################################

Class BEFrostChainmail : BEArmor {
	BEFrostChainmail() : base() {
		$this.Name               = 'Frost Chainmail'
		$this.MapObjName         = 'frostchainmail'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail that shimmers with icy energy, resisting cold.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
