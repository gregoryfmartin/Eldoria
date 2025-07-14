using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINOTAURGREAVES
#
###############################################################################

Class BEMinotaurGreaves : BEGreaves {
	BEMinotaurGreaves() : base() {
		$this.Name               = 'Minotaur Greaves'
		$this.MapObjName         = 'minotaurgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of brute strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
