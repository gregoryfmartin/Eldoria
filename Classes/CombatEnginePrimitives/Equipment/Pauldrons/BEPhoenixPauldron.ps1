using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXPAULDRON
#
###############################################################################

Class BEPhoenixPauldron : BEPauldron {
	BEPhoenixPauldron() : base() {
		$this.Name               = 'Phoenix Pauldron'
		$this.MapObjName         = 'phoenixpauldron'
		$this.PurchasePrice      = 5300
		$this.SellPrice          = 2650
		$this.TargetStats        = @{
			[StatId]::Defense = 106
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blazes with eternal flame, granting resistance to fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
