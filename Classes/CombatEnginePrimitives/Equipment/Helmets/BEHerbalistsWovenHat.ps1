using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE HERBALISTS WOVEN HAT
#
###############################################################################

Class BEHerbalistsWovenHat : BEHelmet {
	BEHerbalistsWovenHat() : base() {
		$this.Name               = 'Herbalist''s Woven Hat'
		$this.MapObjName         = 'herbalistswovenhat'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hat woven from herbs, enhancing knowledge of plants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
