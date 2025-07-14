using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERLIGHTGLOVESII
#
###############################################################################

Class BESilverlightGlovesII : BEGauntlets {
	BESilverlightGlovesII() : base() {
		$this.Name               = 'Silverlight Gloves II'
		$this.MapObjName         = 'silverlightglovesii'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Brighter Silverlight Gloves, revealing more hidden paths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
