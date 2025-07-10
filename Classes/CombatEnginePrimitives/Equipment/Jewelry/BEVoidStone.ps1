using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSTONE
#
###############################################################################

Class BEVoidStone : BEJewelry {
	BEVoidStone() : base() {
		$this.Name               = 'Void Stone'
		$this.MapObjName         = 'voidstone'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stone that absorbs all light, connected to the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
