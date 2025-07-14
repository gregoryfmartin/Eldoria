using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELEMENTALPAULDRON
#
###############################################################################

Class BEElementalPauldron : BEPauldron {
	BEElementalPauldron() : base() {
		$this.Name               = 'Elemental Pauldron'
		$this.MapObjName         = 'elementalpauldron'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 31
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels the power of the elements, offering varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
