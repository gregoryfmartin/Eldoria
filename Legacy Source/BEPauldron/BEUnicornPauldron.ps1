using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNICORNPAULDRON
#
###############################################################################

Class BEUnicornPauldron : BEPauldron {
	BEUnicornPauldron() : base() {
		$this.Name               = 'Unicorn Pauldron'
		$this.MapObjName         = 'unicornpauldron'
		$this.PurchasePrice      = 5350
		$this.SellPrice          = 2675
		$this.TargetStats        = @{
			[StatId]::Defense = 107
			[StatId]::MagicDefense = 41
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pure and benevolent, warding off evil and healing wounds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
