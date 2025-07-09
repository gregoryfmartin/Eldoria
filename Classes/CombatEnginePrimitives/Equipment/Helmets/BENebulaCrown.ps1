using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE NUBULA CROWN
#
###############################################################################

Class BENebulaCrown : BEHelmet {
	BENebulaCrown() : base() {
		$this.Name               = 'Nebula Crown'
		$this.MapObjName         = 'nebulacrown'
		$this.PurchasePrice      = 7500
		$this.SellPrice          = 3750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that shimmers with the colors of a nebula, granting astral powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
