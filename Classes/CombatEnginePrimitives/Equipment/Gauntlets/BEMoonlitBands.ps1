using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONLITBANDS
#
###############################################################################

Class BEMoonlitBands : BEGauntlets {
	BEMoonlitBands() : base() {
		$this.Name               = 'Moonlit Bands'
		$this.MapObjName         = 'moonlitbands'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Silken bands that shimmer with lunar light, boosting mystical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
