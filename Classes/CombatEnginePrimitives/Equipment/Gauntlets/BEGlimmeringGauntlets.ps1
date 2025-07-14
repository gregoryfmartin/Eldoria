using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLIMMERINGGAUNTLETS
#
###############################################################################

Class BEGlimmeringGauntlets : BEGauntlets {
	BEGlimmeringGauntlets() : base() {
		$this.Name               = 'Glimmering Gauntlets'
		$this.MapObjName         = 'glimmeringgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that sparkle with a faint, magical light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
