using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENINJAGARB
#
###############################################################################

Class BENinjaGarb : BEArmor {
	BENinjaGarb() : base() {
		$this.Name               = 'Ninja Garb'
		$this.MapObjName         = 'ninjagarb'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark, flexible clothing for stealth and swift movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
