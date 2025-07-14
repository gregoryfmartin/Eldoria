using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIPLOMATGREAVES
#
###############################################################################

Class BEDiplomatGreaves : BEGreaves {
	BEDiplomatGreaves() : base() {
		$this.Name               = 'Diplomat Greaves'
		$this.MapObjName         = 'diplomatgreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for negotiators and envoys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
