using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORACLEBOOTS
#
###############################################################################

Class BEOracleBoots : BEBoots {
	BEOracleBoots() : base() {
		$this.Name               = 'Oracle Boots'
		$this.MapObjName         = 'oracleboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that enhance prophetic visions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
