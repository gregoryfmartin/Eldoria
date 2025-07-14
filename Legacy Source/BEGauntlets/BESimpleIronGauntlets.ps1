using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIMPLEIRONGAUNTLETS
#
###############################################################################

Class BESimpleIronGauntlets : BEGauntlets {
	BESimpleIronGauntlets() : base() {
		$this.Name               = 'Simple Iron Gauntlets'
		$this.MapObjName         = 'simpleirongauntlets'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic, unadorned iron gauntlets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
