using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGYMNASTPAULDRON
#
###############################################################################

Class BEGymnastPauldron : BEPauldron {
	BEGymnastPauldron() : base() {
		$this.Name               = 'Gymnast Pauldron'
		$this.MapObjName         = 'gymnastpauldron'
		$this.PurchasePrice      = 8050
		$this.SellPrice          = 4025
		$this.TargetStats        = @{
			[StatId]::Defense = 161
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight and ergonomic, for maximum flexibility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
