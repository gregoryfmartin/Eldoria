using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGNOLLGREAVES
#
###############################################################################

Class BEGnollGreaves : BEGreaves {
	BEGnollGreaves() : base() {
		$this.Name               = 'Gnoll Greaves'
		$this.MapObjName         = 'gnollgreaves'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough greaves of hyena folk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
