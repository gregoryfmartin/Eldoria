using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEMAIDENPAULDRON
#
###############################################################################

Class BEDivineMaidenPauldron : BEPauldron {
	BEDivineMaidenPauldron() : base() {
		$this.Name               = 'Divine Maiden Pauldron'
		$this.MapObjName         = 'divinemaidenpauldron'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 21
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed by ancient goddesses, warding off malevolent forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
