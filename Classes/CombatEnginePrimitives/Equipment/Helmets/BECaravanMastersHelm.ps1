using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECARAVANMASTERSHELM
#
###############################################################################

Class BECaravanMastersHelm : BEHelmet {
	BECaravanMastersHelm() : base() {
		$this.Name               = 'Caravan Master''s Helm'
		$this.MapObjName         = 'caravanmastershelm'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy helm worn by caravan masters, protecting during long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
