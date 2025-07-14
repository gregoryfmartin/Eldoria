using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCULPTORSCHISELPENDANT
#
###############################################################################

Class BESculptorsChiselPendant : BEJewelry {
	BESculptorsChiselPendant() : base() {
		$this.Name               = 'Sculptor''s Chisel Pendant'
		$this.MapObjName         = 'sculptorschiselpendant'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Attack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pendant shaped like a tiny chisel, for precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
