using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECYCLONEPAULDRON
#
###############################################################################

Class BECyclonePauldron : BEPauldron {
	BECyclonePauldron() : base() {
		$this.Name               = 'Cyclone Pauldron'
		$this.MapObjName         = 'cyclonepauldron'
		$this.PurchasePrice      = 3100
		$this.SellPrice          = 1550
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by masters of wind magic, creating defensive gusts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
