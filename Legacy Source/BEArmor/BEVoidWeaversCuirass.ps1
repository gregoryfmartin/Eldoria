using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDWEAVERSCUIRASS
#
###############################################################################

Class BEVoidWeaversCuirass : BEArmor {
	BEVoidWeaversCuirass() : base() {
		$this.Name               = 'Void Weaver''s Cuirass'
		$this.MapObjName         = 'voidweaverscuirass'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass that seems to absorb all light, making the wearer harder to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
