using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WOODCUTTERS AXE
#
###############################################################################

Class BEWoodcuttersAxe : BEWeapon {
	BEWoodcuttersAxe() : base() {
		$this.Name          = 'Woodcutter''s Axe'
		$this.MapObjName    = 'woodcuttersaxe'
		$this.PurchasePrice = 140
		$this.SellPrice     = 70
		$this.TargetStats   = @{
			[StatId]::Attack = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe primarily for chopping wood, but sharp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
