using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMBASSADORGREAVES
#
###############################################################################

Class BEAmbassadorGreaves : BEGreaves {
	BEAmbassadorGreaves() : base() {
		$this.Name               = 'Ambassador Greaves'
		$this.MapObjName         = 'ambassadorgreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for high-ranking envoys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
