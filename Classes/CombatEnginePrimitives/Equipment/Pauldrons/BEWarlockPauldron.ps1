using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLOCKPAULDRON
#
###############################################################################

Class BEWarlockPauldron : BEPauldron {
	BEWarlockPauldron() : base() {
		$this.Name               = 'Warlock Pauldron'
		$this.MapObjName         = 'warlockpauldron'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark and potent, for those who wield forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
