using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLIATHGAUNTLETS
#
###############################################################################

Class BEGoliathGauntlets : BEGauntlets {
	BEGoliathGauntlets() : base() {
		$this.Name               = 'Goliath Gauntlets'
		$this.MapObjName         = 'goliathgauntlets'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive gauntlets designed for a giant''s strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
