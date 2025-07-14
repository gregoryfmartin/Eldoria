using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGALAXYPEARL
#
###############################################################################

Class BEGalaxyPearl : BEJewelry {
	BEGalaxyPearl() : base() {
		$this.Name               = 'Galaxy Pearl'
		$this.MapObjName         = 'galaxypearl'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Luck = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pearl that reflects entire galaxies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
