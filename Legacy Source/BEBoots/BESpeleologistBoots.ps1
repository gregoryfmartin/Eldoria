using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPELEOLOGISTBOOTS
#
###############################################################################

Class BESpeleologistBoots : BEBoots {
	BESpeleologistBoots() : base() {
		$this.Name               = 'Speleologist Boots'
		$this.MapObjName         = 'speleologistboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for cave explorers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
