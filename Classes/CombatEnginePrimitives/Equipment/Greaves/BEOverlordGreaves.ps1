using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOVERLORDGREAVES
#
###############################################################################

Class BEOverlordGreaves : BEGreaves {
	BEOverlordGreaves() : base() {
		$this.Name               = 'Overlord Greaves'
		$this.MapObjName         = 'overlordgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a supreme master.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
