using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMBEREARRING
#
###############################################################################

Class BEAmberEarring : BEJewelry {
	BEAmberEarring() : base() {
		$this.Name               = 'Amber Earring'
		$this.MapObjName         = 'amberearring'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm amber earring, preserving ancient energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
