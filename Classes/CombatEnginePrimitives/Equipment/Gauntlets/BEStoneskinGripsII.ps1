using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONESKINGRIPSII
#
###############################################################################

Class BEStoneskinGripsII : BEGauntlets {
	BEStoneskinGripsII() : base() {
		$this.Name               = 'Stoneskin Grips II'
		$this.MapObjName         = 'stoneskingripsii'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Stoneskin Grips, turning skin to tougher stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
