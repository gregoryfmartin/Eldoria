using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMSTEELGAUNTLETSII
#
###############################################################################

Class BEDreamsteelGauntletsII : BEGauntlets {
	BEDreamsteelGauntletsII() : base() {
		$this.Name               = 'Dreamsteel Gauntlets II'
		$this.MapObjName         = 'dreamsteelgauntletsii'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Dreamsteel Gauntlets, lighter and stronger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
