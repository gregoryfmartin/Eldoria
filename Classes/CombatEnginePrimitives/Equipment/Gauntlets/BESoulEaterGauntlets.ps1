using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULEATERGAUNTLETS
#
###############################################################################

Class BESoulEaterGauntlets : BEGauntlets {
	BESoulEaterGauntlets() : base() {
		$this.Name               = 'Soul Eater Gauntlets'
		$this.MapObjName         = 'souleatergauntlets'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 125
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that devour the souls of defeated enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
