using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOUNTAINHEARTMEDALLION
#
###############################################################################

Class BEMountainheartMedallion : BEJewelry {
	BEMountainheartMedallion() : base() {
		$this.Name               = 'Mountainheart Medallion'
		$this.MapObjName         = 'mountainheartmedallion'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough medallion from the heart of a mountain, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
