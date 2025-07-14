using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSWORNGAUNTLETSII
#
###############################################################################

Class BEDragonswornGauntletsII : BEGauntlets {
	BEDragonswornGauntletsII() : base() {
		$this.Name               = 'Dragonsworn Gauntlets II'
		$this.MapObjName         = 'dragonsworngauntletsii'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Dragonsworn Gauntlets, stronger loyalty to dragons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
