using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTSCUIRASS
#
###############################################################################

Class BEKnightsCuirass : BEArmor {
	BEKnightsCuirass() : base() {
		$this.Name               = 'Knight''s Cuirass'
		$this.MapObjName         = 'knightscuirass'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The polished chest plate of a valiant knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
