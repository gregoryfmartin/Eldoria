using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOLYGAUNTLETS
#
###############################################################################

Class BEHolyGauntlets : BEGauntlets {
	BEHolyGauntlets() : base() {
		$this.Name               = 'Holy Gauntlets'
		$this.MapObjName         = 'holygauntlets'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed gauntlets, offering protection against dark forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
