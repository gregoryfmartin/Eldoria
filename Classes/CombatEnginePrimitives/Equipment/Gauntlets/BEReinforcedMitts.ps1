using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREINFORCEDMITTS
#
###############################################################################

Class BEReinforcedMitts : BEGauntlets {
	BEReinforcedMitts() : base() {
		$this.Name               = 'Reinforced Mitts'
		$this.MapObjName         = 'reinforcedmitts'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Mitts with extra padding, offering more protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
