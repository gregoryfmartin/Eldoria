using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHARITYGREAVES
#
###############################################################################

Class BECharityGreaves : BEGreaves {
	BECharityGreaves() : base() {
		$this.Name               = 'Charity Greaves'
		$this.MapObjName         = 'charitygreaves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that embody benevolence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
