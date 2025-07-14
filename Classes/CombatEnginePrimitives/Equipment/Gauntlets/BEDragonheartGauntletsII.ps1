using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHEARTGAUNTLETSII
#
###############################################################################

Class BEDragonheartGauntletsII : BEGauntlets {
	BEDragonheartGauntletsII() : base() {
		$this.Name               = 'Dragonheart Gauntlets II'
		$this.MapObjName         = 'dragonheartgauntletsii'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating even greater draconic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
