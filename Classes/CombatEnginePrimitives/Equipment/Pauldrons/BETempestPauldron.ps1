using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPESTPAULDRON
#
###############################################################################

Class BETempestPauldron : BEPauldron {
	BETempestPauldron() : base() {
		$this.Name               = 'Tempest Pauldron'
		$this.MapObjName         = 'tempestpauldron'
		$this.PurchasePrice      = 2950
		$this.SellPrice          = 1475
		$this.TargetStats        = @{
			[StatId]::Defense = 59
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embodies the fury of a storm, enhancing elemental resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
