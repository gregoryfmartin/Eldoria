using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIALSPIKEGAUNTLETS
#
###############################################################################

Class BEGlacialSpikeGauntlets : BEGauntlets {
	BEGlacialSpikeGauntlets() : base() {
		$this.Name               = 'Glacial Spike Gauntlets'
		$this.MapObjName         = 'glacialspikegauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with sharp ice spikes, chilling to touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
