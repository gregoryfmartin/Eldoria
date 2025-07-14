using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENATORGREAVES
#
###############################################################################

Class BESenatorGreaves : BEGreaves {
	BESenatorGreaves() : base() {
		$this.Name               = 'Senator Greaves'
		$this.MapObjName         = 'senatorgreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a governmental official.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
