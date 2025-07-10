using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUARRYMANGREAVES
#
###############################################################################

Class BEQuarrymanGreaves : BEGreaves {
	BEQuarrymanGreaves() : base() {
		$this.Name               = 'Quarryman Greaves'
		$this.MapObjName         = 'quarrymangreaves'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for stone extraction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
