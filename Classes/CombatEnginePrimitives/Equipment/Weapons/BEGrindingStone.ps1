using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRINDINGSTONE
#
###############################################################################

Class BEGrindingStone : BEWeapon {
	BEGrindingStone() : base() {
		$this.Name          = 'Grinding Stone'
		$this.MapObjName    = 'grindingstone'
		$this.PurchasePrice = 50
		$this.SellPrice     = 25
		$this.TargetStats   = @{
			[StatId]::Attack = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy stone used for grinding. Surprisingly effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
