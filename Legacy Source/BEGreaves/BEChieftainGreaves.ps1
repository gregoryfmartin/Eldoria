using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHIEFTAINGREAVES
#
###############################################################################

Class BEChieftainGreaves : BEGreaves {
	BEChieftainGreaves() : base() {
		$this.Name               = 'Chieftain Greaves'
		$this.MapObjName         = 'chieftaingreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a tribal leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
