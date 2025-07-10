using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOATHSWORNGAUNTLETS
#
###############################################################################

Class BEOathswornGauntlets : BEGauntlets {
	BEOathswornGauntlets() : base() {
		$this.Name               = 'Oathsworn Gauntlets'
		$this.MapObjName         = 'oathsworngauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a sworn knight, unbreakable in their resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
