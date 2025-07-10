using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHEARTGAUNTLETSIII
#
###############################################################################

Class BEDragonheartGauntletsIII : BEGauntlets {
	BEDragonheartGauntletsIII() : base() {
		$this.Name               = 'Dragonheart Gauntlets III'
		$this.MapObjName         = 'dragonheartgauntletsiii'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating the heart of a true dragon, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
