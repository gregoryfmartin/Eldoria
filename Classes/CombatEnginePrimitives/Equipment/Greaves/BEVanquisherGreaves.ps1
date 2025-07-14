using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVANQUISHERGREAVES
#
###############################################################################

Class BEVanquisherGreaves : BEGreaves {
	BEVanquisherGreaves() : base() {
		$this.Name               = 'Vanquisher Greaves'
		$this.MapObjName         = 'vanquishergreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of one who utterly defeats their foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
