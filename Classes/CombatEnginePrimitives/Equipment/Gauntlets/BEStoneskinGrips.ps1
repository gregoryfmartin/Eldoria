using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONESKINGRIPS
#
###############################################################################

Class BEStoneskinGrips : BEGauntlets {
	BEStoneskinGrips() : base() {
		$this.Name               = 'Stoneskin Grips'
		$this.MapObjName         = 'stoneskingrips'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that harden the skin, making it resistant.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
