using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEPOWDERGAUNTLETS
#
###############################################################################

Class BERunepowderGauntlets : BEGauntlets {
	BERunepowderGauntlets() : base() {
		$this.Name               = 'Runepowder Gauntlets'
		$this.MapObjName         = 'runepowdergauntlets'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets infused with explosive runepowder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
