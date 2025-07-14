using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEPRECHAUNGREAVES
#
###############################################################################

Class BELeprechaunGreaves : BEGreaves {
	BELeprechaunGreaves() : base() {
		$this.Name               = 'Leprechaun Greaves'
		$this.MapObjName         = 'leprechaungreaves'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that bring good fortune.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
