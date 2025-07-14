using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANSPLATE
#
###############################################################################

Class BETitansPlate : BEArmor {
	BETitansPlate() : base() {
		$this.Name               = 'Titan''s Plate'
		$this.MapObjName         = 'titansplate'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor said to be forged by ancient titans, immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
