using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLESHANDGUARDS
#
###############################################################################

Class BEOraclesHandguards : BEGauntlets {
	BEOraclesHandguards() : base() {
		$this.Name               = 'Oracle''s Handguards'
		$this.MapObjName         = 'oracleshandguards'
		$this.PurchasePrice      = 540
		$this.SellPrice          = 270
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 27
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards that hum with prophetic energy, aiding foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
