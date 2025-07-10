using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSWORNGAUNTLETS
#
###############################################################################

Class BEDragonswornGauntlets : BEGauntlets {
	BEDragonswornGauntlets() : base() {
		$this.Name               = 'Dragonsworn Gauntlets'
		$this.MapObjName         = 'dragonsworngauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of those who pledge loyalty to dragons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
