using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWISPWEAVEGLOVES
#
###############################################################################

Class BEWispweaveGloves : BEGauntlets {
	BEWispweaveGloves() : base() {
		$this.Name               = 'Wispweave Gloves'
		$this.MapObjName         = 'wispweavegloves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 32
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made of ethereal wisp material, nearly invisible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
