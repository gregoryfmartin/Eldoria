using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORDERKEEPERSHELM
#
###############################################################################

Class BEOrderKeepersHelm : BEHelmet {
	BEOrderKeepersHelm() : base() {
		$this.Name               = 'Order Keeper''s Helm'
		$this.MapObjName         = 'orderkeepershelm'
		$this.PurchasePrice      = 9000
		$this.SellPrice          = 4500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 80
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that imposes order on chaos, suppressing unruly energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
