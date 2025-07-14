using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONKINGPAULDRON
#
###############################################################################

Class BEDragonKingPauldron : BEPauldron {
	BEDragonKingPauldron() : base() {
		$this.Name               = 'Dragon King Pauldron'
		$this.MapObjName         = 'dragonkingpauldron'
		$this.PurchasePrice      = 5400
		$this.SellPrice          = 2700
		$this.TargetStats        = @{
			[StatId]::Defense = 108
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by ancient dragon kings, embodying immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
