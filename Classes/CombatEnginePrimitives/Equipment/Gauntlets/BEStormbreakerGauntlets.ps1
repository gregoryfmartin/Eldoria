using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMBREAKERGAUNTLETS
#
###############################################################################

Class BEStormbreakerGauntlets : BEGauntlets {
	BEStormbreakerGauntlets() : base() {
		$this.Name               = 'Stormbreaker Gauntlets'
		$this.MapObjName         = 'stormbreakergauntlets'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that can channel and disperse stormy energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
