using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETIDALPAULDRON
#
###############################################################################

Class BETidalPauldron : BEPauldron {
	BETidalPauldron() : base() {
		$this.Name               = 'Tidal Pauldron'
		$this.MapObjName         = 'tidalpauldron'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels the power of the tides, enhancing water defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
