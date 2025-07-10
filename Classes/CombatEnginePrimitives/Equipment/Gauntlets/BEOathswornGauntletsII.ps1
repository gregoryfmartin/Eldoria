using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOATHSWORNGAUNTLETSII
#
###############################################################################

Class BEOathswornGauntletsII : BEGauntlets {
	BEOathswornGauntletsII() : base() {
		$this.Name               = 'Oathsworn Gauntlets II'
		$this.MapObjName         = 'oathsworngauntletsii'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Oathsworn Gauntlets, unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
