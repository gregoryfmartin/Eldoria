using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORCISHGREAVES
#
###############################################################################

Class BEOrcishGreaves : BEGreaves {
	BEOrcishGreaves() : base() {
		$this.Name               = 'Orcish Greaves'
		$this.MapObjName         = 'orcishgreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and brutal greaves of orcs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
