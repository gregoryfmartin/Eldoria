using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETIDALCURRENTPEARL
#
###############################################################################

Class BETidalCurrentPearl : BEJewelry {
	BETidalCurrentPearl() : base() {
		$this.Name               = 'Tidal Current Pearl'
		$this.MapObjName         = 'tidalcurrentpearl'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pearl that gently pulls and pushes, aiding movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
