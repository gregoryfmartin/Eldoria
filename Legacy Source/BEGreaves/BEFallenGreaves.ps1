using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFALLENGREAVES
#
###############################################################################

Class BEFallenGreaves : BEGreaves {
	BEFallenGreaves() : base() {
		$this.Name               = 'Fallen Greaves'
		$this.MapObjName         = 'fallengreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a corrupted warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
