using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE NINJA HOOD
#
###############################################################################

Class BENinjaHood : BEHelmet {
	BENinjaHood() : base() {
		$this.Name               = 'Ninja Hood'
		$this.MapObjName         = 'ninjahood'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stealthy hood worn by ninjas, aiding in clandestine operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
