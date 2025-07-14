using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLESTOUCH
#
###############################################################################

Class BEOraclesTouch : BEGauntlets {
	BEOraclesTouch() : base() {
		$this.Name               = 'Oracle''s Touch'
		$this.MapObjName         = 'oraclestouch'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 36
			[StatId]::Accuracy = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves allowing brief glimpses into the future, improving reaction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
