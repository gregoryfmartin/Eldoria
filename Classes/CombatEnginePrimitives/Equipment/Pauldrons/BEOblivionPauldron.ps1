using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOBLIVIONPAULDRON
#
###############################################################################

Class BEOblivionPauldron : BEPauldron {
	BEOblivionPauldron() : base() {
		$this.Name               = 'Oblivion Pauldron'
		$this.MapObjName         = 'oblivionpauldron'
		$this.PurchasePrice      = 6850
		$this.SellPrice          = 3425
		$this.TargetStats        = @{
			[StatId]::Defense = 137
			[StatId]::MagicDefense = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Drifts from beyond existence, absorbing all it touches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
