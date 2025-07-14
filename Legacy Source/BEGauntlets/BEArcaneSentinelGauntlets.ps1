using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANESENTINELGAUNTLETS
#
###############################################################################

Class BEArcaneSentinelGauntlets : BEGauntlets {
	BEArcaneSentinelGauntlets() : base() {
		$this.Name               = 'Arcane Sentinel Gauntlets'
		$this.MapObjName         = 'arcanesentinelgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of an ancient order of arcane guardians, robust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
