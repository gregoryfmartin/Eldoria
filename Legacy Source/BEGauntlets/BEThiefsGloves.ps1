using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFSGLOVES
#
###############################################################################

Class BEThiefsGloves : BEGauntlets {
	BEThiefsGloves() : base() {
		$this.Name               = 'Thief''s Gloves'
		$this.MapObjName         = 'thiefsgloves'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 6
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Thin, dark gloves used for stealth and quick movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
