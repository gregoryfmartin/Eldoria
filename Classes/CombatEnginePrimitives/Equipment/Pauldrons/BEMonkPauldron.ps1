using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMONKPAULDRON
#
###############################################################################

Class BEMonkPauldron : BEPauldron {
	BEMonkPauldron() : base() {
		$this.Name               = 'Monk Pauldron'
		$this.MapObjName         = 'monkpauldron'
		$this.PurchasePrice      = 9150
		$this.SellPrice          = 4575
		$this.TargetStats        = @{
			[StatId]::Defense = 183
			[StatId]::MagicDefense = 82
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for agile, unarmed combat while offering spiritual defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
