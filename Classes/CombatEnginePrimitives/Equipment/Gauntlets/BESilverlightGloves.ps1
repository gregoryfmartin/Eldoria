using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERLIGHTGLOVES
#
###############################################################################

Class BESilverlightGloves : BEGauntlets {
	BESilverlightGloves() : base() {
		$this.Name               = 'Silverlight Gloves'
		$this.MapObjName         = 'silverlightgloves'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that emanate a faint silver light, revealing hidden paths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
