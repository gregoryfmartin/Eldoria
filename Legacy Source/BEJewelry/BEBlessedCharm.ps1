using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLESSEDCHARM
#
###############################################################################

Class BEBlessedCharm : BEJewelry {
	BEBlessedCharm() : base() {
		$this.Name               = 'Blessed Charm'
		$this.MapObjName         = 'blessedcharm'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small charm blessed by a deity, granting protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
