using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULSTEELGAUNTLETS
#
###############################################################################

Class BESoulsteelGauntlets : BEGauntlets {
	BESoulsteelGauntlets() : base() {
		$this.Name               = 'Soulsteel Gauntlets'
		$this.MapObjName         = 'soulsteelgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged from purified souls, radiant and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
