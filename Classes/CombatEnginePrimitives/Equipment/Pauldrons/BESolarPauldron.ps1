using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLARPAULDRON
#
###############################################################################

Class BESolarPauldron : BEPauldron {
	BESolarPauldron() : base() {
		$this.Name               = 'Solar Pauldron'
		$this.MapObjName         = 'solarpauldron'
		$this.PurchasePrice      = 4450
		$this.SellPrice          = 2225
		$this.TargetStats        = @{
			[StatId]::Defense = 89
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blazes with the power of the sun, enhancing fire and light defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
