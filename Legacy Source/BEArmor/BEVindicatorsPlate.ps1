using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVINDICATORSPLATE
#
###############################################################################

Class BEVindicatorsPlate : BEArmor {
	BEVindicatorsPlate() : base() {
		$this.Name               = 'Vindicator''s Plate'
		$this.MapObjName         = 'vindicatorsplate'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor worn by those who seek justice, glows faintly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
