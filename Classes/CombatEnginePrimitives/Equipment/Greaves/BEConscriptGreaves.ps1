using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONSCRIPTGREAVES
#
###############################################################################

Class BEConscriptGreaves : BEGreaves {
	BEConscriptGreaves() : base() {
		$this.Name               = 'Conscript Greaves'
		$this.MapObjName         = 'conscriptgreaves'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic greaves for newly drafted soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
