using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLESSEDCHAINMAIL
#
###############################################################################

Class BEBlessedChainmail : BEArmor {
	BEBlessedChainmail() : base() {
		$this.Name               = 'Blessed Chainmail'
		$this.MapObjName         = 'blessedchainmail'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail consecrated by holy rites, effective against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
