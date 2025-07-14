using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFEYWILDGLOVES
#
###############################################################################

Class BEFeywildGloves : BEGauntlets {
	BEFeywildGloves() : base() {
		$this.Name               = 'Feywild Gloves'
		$this.MapObjName         = 'feywildgloves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 38
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves touched by the Feywild, shimmering with magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
