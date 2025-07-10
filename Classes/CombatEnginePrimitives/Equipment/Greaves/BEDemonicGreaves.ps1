using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONICGREAVES
#
###############################################################################

Class BEDemonicGreaves : BEGreaves {
	BEDemonicGreaves() : base() {
		$this.Name               = 'Demonic Greaves'
		$this.MapObjName         = 'demonicgreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves infused with the essence of demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
