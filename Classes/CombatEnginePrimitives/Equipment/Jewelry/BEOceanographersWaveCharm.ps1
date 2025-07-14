using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANOGRAPHERSWAVECHARM
#
###############################################################################

Class BEOceanographersWaveCharm : BEJewelry {
	BEOceanographersWaveCharm() : base() {
		$this.Name               = 'Oceanographer''s Wave Charm'
		$this.MapObjName         = 'oceanographerswavecharm'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a perfect wave, for navigating seas.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
