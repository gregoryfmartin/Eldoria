using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERSGRIPS
#
###############################################################################

Class BEHuntersGrips : BEGauntlets {
	BEHuntersGrips() : base() {
		$this.Name               = 'Hunter''s Grips'
		$this.MapObjName         = 'huntersgrips'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 5
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Agile gauntlets favored by hunters, enhancing precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
