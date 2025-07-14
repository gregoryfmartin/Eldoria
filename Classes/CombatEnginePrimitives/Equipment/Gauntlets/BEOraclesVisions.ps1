using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLESVISIONS
#
###############################################################################

Class BEOraclesVisions : BEGauntlets {
	BEOraclesVisions() : base() {
		$this.Name               = 'Oracle''s Visions'
		$this.MapObjName         = 'oraclesvisions'
		$this.PurchasePrice      = 630
		$this.SellPrice          = 315
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that briefly glimpse the future, boosting evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
