using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONGREAVES
#
###############################################################################

Class BEDemonGreaves : BEGreaves {
	BEDemonGreaves() : base() {
		$this.Name               = 'Demon Greaves'
		$this.MapObjName         = 'demongreaves'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves infused with demonic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
