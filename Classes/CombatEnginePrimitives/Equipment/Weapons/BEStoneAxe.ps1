using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STONE AXE
#
###############################################################################

Class BEStoneAxe : BEWeapon {
	BEStoneAxe() : base() {
		$this.Name          = 'Stone Axe'
		$this.MapObjName    = 'stoneaxe'
		$this.PurchasePrice = 70
		$this.SellPrice     = 35
		$this.TargetStats   = @{
			[StatId]::Attack = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rudimentary axe with a stone head.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
