using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERSFISTS
#
###############################################################################

Class BEBerserkersFists : BEGauntlets {
	BEBerserkersFists() : base() {
		$this.Name               = 'Berserker''s Fists'
		$this.MapObjName         = 'berserkersfists'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 2
			[StatId]::Accuracy = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude, spiked gauntlets for aggressive combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}
