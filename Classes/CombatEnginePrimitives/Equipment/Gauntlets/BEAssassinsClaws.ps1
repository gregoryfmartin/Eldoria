using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASSASSINSCLAWS
#
###############################################################################

Class BEAssassinsClaws : BEGauntlets {
	BEAssassinsClaws() : base() {
		$this.Name               = 'Assassin''s Claws'
		$this.MapObjName         = 'assassinsclaws'
		$this.PurchasePrice      = 340
		$this.SellPrice          = 170
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 9
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sleek, sharp gauntlets designed for quick strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
