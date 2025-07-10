using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONICCLAWS
#
###############################################################################

Class BEDemonicClaws : BEGauntlets {
	BEDemonicClaws() : base() {
		$this.Name               = 'Demonic Claws'
		$this.MapObjName         = 'demonicclaws'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vicious gauntlets from the fiery pits, dripping with malice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
