using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRIUMPHGREAVES
#
###############################################################################

Class BETriumphGreaves : BEGreaves {
	BETriumphGreaves() : base() {
		$this.Name               = 'Triumph Greaves'
		$this.MapObjName         = 'triumphgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves signifying great success.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
