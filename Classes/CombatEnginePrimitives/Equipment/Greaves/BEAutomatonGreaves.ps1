using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAUTOMATONGREAVES
#
###############################################################################

Class BEAutomatonGreaves : BEGreaves {
	BEAutomatonGreaves() : base() {
		$this.Name               = 'Automaton Greaves'
		$this.MapObjName         = 'automatongreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Mechanical greaves, precisely engineered.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
