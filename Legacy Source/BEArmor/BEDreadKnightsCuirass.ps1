using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREADKNIGHTSCUIRASS
#
###############################################################################

Class BEDreadKnightsCuirass : BEArmor {
	BEDreadKnightsCuirass() : base() {
		$this.Name               = 'Dread Knight''s Cuirass'
		$this.MapObjName         = 'dreadknightscuirass'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying black cuirass, instilling fear in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
