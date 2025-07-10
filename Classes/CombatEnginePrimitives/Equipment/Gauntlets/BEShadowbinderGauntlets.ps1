using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWBINDERGAUNTLETS
#
###############################################################################

Class BEShadowbinderGauntlets : BEGauntlets {
	BEShadowbinderGauntlets() : base() {
		$this.Name               = 'Shadowbinder Gauntlets'
		$this.MapObjName         = 'shadowbindergauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to control shadows, binding foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
