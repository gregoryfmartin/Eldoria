using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPOSTATEGREAVES
#
###############################################################################

Class BEApostateGreaves : BEGreaves {
	BEApostateGreaves() : base() {
		$this.Name               = 'Apostate Greaves'
		$this.MapObjName         = 'apostategreaves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of one who has renounced their faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
