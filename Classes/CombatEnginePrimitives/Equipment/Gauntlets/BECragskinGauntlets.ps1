using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRAGSKINGAUNTLETS
#
###############################################################################

Class BECragskinGauntlets : BEGauntlets {
	BECragskinGauntlets() : base() {
		$this.Name               = 'Cragskin Gauntlets'
		$this.MapObjName         = 'cragskingauntlets'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from hardened mountain hide, durable and rugged.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
