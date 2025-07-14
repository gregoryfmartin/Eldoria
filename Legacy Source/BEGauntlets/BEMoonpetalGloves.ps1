using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONPETALGLOVES
#
###############################################################################

Class BEMoonpetalGloves : BEGauntlets {
	BEMoonpetalGloves() : base() {
		$this.Name               = 'Moonpetal Gloves'
		$this.MapObjName         = 'moonpetalgloves'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from moonlit petals, soft and magically potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
