using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICSENTINELGAUNTLETS
#
###############################################################################

Class BEMysticSentinelGauntlets : BEGauntlets {
	BEMysticSentinelGauntlets() : base() {
		$this.Name               = 'Mystic Sentinel Gauntlets'
		$this.MapObjName         = 'mysticsentinelgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of an ancient order, protecting magic users.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
