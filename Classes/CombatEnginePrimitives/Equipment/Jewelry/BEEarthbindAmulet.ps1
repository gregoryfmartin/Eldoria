using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHBINDAMULET
#
###############################################################################

Class BEEarthbindAmulet : BEJewelry {
	BEEarthbindAmulet() : base() {
		$this.Name               = 'Earthbind Amulet'
		$this.MapObjName         = 'earthbindamulet'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet made of rough stone, rooting the wearer to the ground.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
