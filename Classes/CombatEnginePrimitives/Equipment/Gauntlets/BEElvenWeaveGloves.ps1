using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENWEAVEGLOVES
#
###############################################################################

Class BEElvenWeaveGloves : BEGauntlets {
	BEElvenWeaveGloves() : base() {
		$this.Name               = 'Elven Weave Gloves'
		$this.MapObjName         = 'elvenweavegloves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Intricately woven gloves, light and magically resistant.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
