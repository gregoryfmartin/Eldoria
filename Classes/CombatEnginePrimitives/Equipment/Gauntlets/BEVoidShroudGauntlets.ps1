using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSHROUDGAUNTLETS
#
###############################################################################

Class BEVoidShroudGauntlets : BEGauntlets {
	BEVoidShroudGauntlets() : base() {
		$this.Name               = 'Void Shroud Gauntlets'
		$this.MapObjName         = 'voidshroudgauntlets'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that appear to fade in and out of existence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
