using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEICEWARDENPAULDRON
#
###############################################################################

Class BEIceWardenPauldron : BEPauldron {
	BEIceWardenPauldron() : base() {
		$this.Name               = 'Ice Warden Pauldron'
		$this.MapObjName         = 'icewardenpauldron'
		$this.PurchasePrice      = 8700
		$this.SellPrice          = 4350
		$this.TargetStats        = @{
			[StatId]::Defense = 174
			[StatId]::MagicDefense = 79
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Wards off the bitter cold and enhances ice-based defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
