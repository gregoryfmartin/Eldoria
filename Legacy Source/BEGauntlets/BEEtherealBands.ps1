using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHEREALBANDS
#
###############################################################################

Class BEEtherealBands : BEGauntlets {
	BEEtherealBands() : base() {
		$this.Name               = 'Ethereal Bands'
		$this.MapObjName         = 'etherealbands'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands composed of pure ether, granting magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
