using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGISTRATEGREAVES
#
###############################################################################

Class BEMagistrateGreaves : BEGreaves {
	BEMagistrateGreaves() : base() {
		$this.Name               = 'Magistrate Greaves'
		$this.MapObjName         = 'magistrategreaves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a civil officer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
