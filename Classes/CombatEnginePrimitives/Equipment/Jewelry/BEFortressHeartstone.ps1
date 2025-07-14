using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORTRESSHEARTSTONE
#
###############################################################################

Class BEFortressHeartstone : BEJewelry {
	BEFortressHeartstone() : base() {
		$this.Name               = 'Fortress Heartstone'
		$this.MapObjName         = 'fortressheartstone'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heart shaped stone that provides immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
