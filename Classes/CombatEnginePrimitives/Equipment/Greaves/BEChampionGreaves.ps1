using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAMPIONGREAVES
#
###############################################################################

Class BEChampionGreaves : BEGreaves {
	BEChampionGreaves() : base() {
		$this.Name               = 'Champion Greaves'
		$this.MapObjName         = 'championgreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of an undisputed champion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
