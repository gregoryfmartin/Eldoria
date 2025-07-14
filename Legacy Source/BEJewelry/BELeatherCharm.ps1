using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERCHARM
#
###############################################################################

Class BELeatherCharm : BEJewelry {
	BELeatherCharm() : base() {
		$this.Name               = 'Leather Charm'
		$this.MapObjName         = 'leathercharm'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small leather charm, believed to ward off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
