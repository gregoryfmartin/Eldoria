using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALPLATEGAUNTLETSII
#
###############################################################################

Class BEAbyssalPlateGauntletsII : BEGauntlets {
	BEAbyssalPlateGauntletsII() : base() {
		$this.Name               = 'Abyssal Plate Gauntlets II'
		$this.MapObjName         = 'abyssalplategauntletsii'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Further hardened Abyssal Plate Gauntlets, incredibly resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
