using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGMAPAULDRON
#
###############################################################################

Class BEMagmaPauldron : BEPauldron {
	BEMagmaPauldron() : base() {
		$this.Name               = 'Magma Pauldron'
		$this.MapObjName         = 'magmapauldron'
		$this.PurchasePrice      = 3450
		$this.SellPrice          = 1725
		$this.TargetStats        = @{
			[StatId]::Defense = 69
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Radiates intense heat, offering fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
