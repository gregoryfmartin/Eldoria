using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEFORGEDGAUNTLETSIII
#
###############################################################################

Class BERuneforgedGauntletsIII : BEGauntlets {
	BERuneforgedGauntletsIII() : base() {
		$this.Name               = 'Runeforged Gauntlets III'
		$this.MapObjName         = 'runeforgedgauntletsiii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Runeforged Gauntlets, absolute mystical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
