using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLEGREAVES
#
###############################################################################

Class BEOracleGreaves : BEGreaves {
	BEOracleGreaves() : base() {
		$this.Name               = 'Oracle Greaves'
		$this.MapObjName         = 'oraclegreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that enhance prophetic visions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
