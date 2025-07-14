using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONGREAVES
#
###############################################################################

Class BEIronGreaves : BEGreaves {
	BEIronGreaves() : base() {
		$this.Name               = 'Iron Greaves'
		$this.MapObjName         = 'irongreaves'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Common iron greaves, reliable and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
