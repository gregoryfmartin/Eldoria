using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAKESKINGAUNTLETS
#
###############################################################################

Class BEDrakeskinGauntlets : BEGauntlets {
	BEDrakeskinGauntlets() : base() {
		$this.Name               = 'Drakeskin Gauntlets'
		$this.MapObjName         = 'drakeskingauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from the durable hide of a drake.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
