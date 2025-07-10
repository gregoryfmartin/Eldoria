using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTORMFORGEDFISTS
#
###############################################################################

Class BEStormforgedFists : BEGauntlets {
	BEStormforgedFists() : base() {
		$this.Name               = 'Stormforged Fists'
		$this.MapObjName         = 'stormforgedfists'
		$this.PurchasePrice      = 960
		$this.SellPrice          = 480
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged in a thunderstorm, crackling with power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
