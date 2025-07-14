using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRONZEPAULDRON
#
###############################################################################

Class BEBronzePauldron : BEPauldron {
	BEBronzePauldron() : base() {
		$this.Name               = 'Bronze Pauldron'
		$this.MapObjName         = 'bronzepauldron'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Solid bronze pauldron offering decent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
