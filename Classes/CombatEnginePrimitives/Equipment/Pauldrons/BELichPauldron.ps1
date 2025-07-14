using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELICHPAULDRON
#
###############################################################################

Class BELichPauldron : BEPauldron {
	BELichPauldron() : base() {
		$this.Name               = 'Lich Pauldron'
		$this.MapObjName         = 'lichpauldron'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A relic of immense power, brimming with dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
