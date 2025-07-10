using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLEPAULDRON
#
###############################################################################

Class BEOraclePauldron : BEPauldron {
	BEOraclePauldron() : base() {
		$this.Name               = 'Oracle Pauldron'
		$this.MapObjName         = 'oraclepauldron'
		$this.PurchasePrice      = 7400
		$this.SellPrice          = 3700
		$this.TargetStats        = @{
			[StatId]::Defense = 148
			[StatId]::MagicDefense = 69
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows glimpses into the future, enhancing foresight and wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
