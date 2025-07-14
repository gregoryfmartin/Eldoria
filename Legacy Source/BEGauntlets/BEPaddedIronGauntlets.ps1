using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPADDEDIRONGAUNTLETS
#
###############################################################################

Class BEPaddedIronGauntlets : BEGauntlets {
	BEPaddedIronGauntlets() : base() {
		$this.Name               = 'Padded Iron Gauntlets'
		$this.MapObjName         = 'paddedirongauntlets'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets with padded interior for comfort.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
