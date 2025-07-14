using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDARKFORGEDHELM
#
###############################################################################

Class BEDarkforgedHelm : BEHelmet {
	BEDarkforgedHelm() : base() {
		$this.Name               = 'Darkforged Helm'
		$this.MapObjName         = 'darkforgedhelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged in darkness, powerful against light creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
