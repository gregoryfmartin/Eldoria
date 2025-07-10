using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRONZEGREAVES
#
###############################################################################

Class BEBronzeGreaves : BEGreaves {
	BEBronzeGreaves() : base() {
		$this.Name               = 'Bronze Greaves'
		$this.MapObjName         = 'bronzegreaves'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy bronze leg protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
