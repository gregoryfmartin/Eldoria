using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGROTTOGREAVES
#
###############################################################################

Class BEGrottoGreaves : BEGreaves {
	BEGrottoGreaves() : base() {
		$this.Name               = 'Grotto Greaves'
		$this.MapObjName         = 'grottogreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for small cave systems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
