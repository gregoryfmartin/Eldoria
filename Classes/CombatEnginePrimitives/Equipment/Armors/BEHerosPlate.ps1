using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROSPLATE
#
###############################################################################

Class BEHerosPlate : BEArmor {
	BEHerosPlate() : base() {
		$this.Name               = 'Hero''s Plate'
		$this.MapObjName         = 'herosplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The legendary plate armor of a true hero.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
