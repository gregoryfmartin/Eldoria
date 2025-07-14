using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLATILEVEST
#
###############################################################################

Class BEVolatileVest : BEArmor {
	BEVolatileVest() : base() {
		$this.Name               = 'Volatile Vest'
		$this.MapObjName         = 'volatilevest'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that sometimes explodes with magical energy, risky but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
