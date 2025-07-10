using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAUTOMATONBOOTS
#
###############################################################################

Class BEAutomatonBoots : BEBoots {
	BEAutomatonBoots() : base() {
		$this.Name               = 'Automaton Boots'
		$this.MapObjName         = 'automatonboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Mechanical boots, precisely engineered.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
