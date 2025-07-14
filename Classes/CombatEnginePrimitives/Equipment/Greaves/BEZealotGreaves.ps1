using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTGREAVES
#
###############################################################################

Class BEZealotGreaves : BEGreaves {
	BEZealotGreaves() : base() {
		$this.Name               = 'Zealot Greaves'
		$this.MapObjName         = 'zealotgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of unwavering devotion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
