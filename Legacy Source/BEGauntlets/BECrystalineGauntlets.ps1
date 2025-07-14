using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALINEGAUNTLETS
#
###############################################################################

Class BECrystalineGauntlets : BEGauntlets {
	BECrystalineGauntlets() : base() {
		$this.Name               = 'Crystaline Gauntlets'
		$this.MapObjName         = 'crystalinegauntlets'
		$this.PurchasePrice      = 910
		$this.SellPrice          = 455
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets formed from pure crystal, fragile yet powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
