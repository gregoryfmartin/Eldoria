using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREPEATINGCROSSBOW
#
###############################################################################

Class BERepeatingCrossbow : BEWeapon {
	BERepeatingCrossbow() : base() {
		$this.Name          = 'Repeating Crossbow'
		$this.MapObjName    = 'repeatingcrossbow'
		$this.PurchasePrice = 1100
		$this.SellPrice     = 550
		$this.TargetStats   = @{
			[StatId]::Attack = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A complex crossbow capable of rapid firing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
