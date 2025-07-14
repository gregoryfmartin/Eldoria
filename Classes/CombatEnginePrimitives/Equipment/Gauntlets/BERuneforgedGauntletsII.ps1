using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEFORGEDGAUNTLETSII
#
###############################################################################

Class BERuneforgedGauntletsII : BEGauntlets {
	BERuneforgedGauntletsII() : base() {
		$this.Name               = 'Runeforged Gauntlets II'
		$this.MapObjName         = 'runeforgedgauntletsii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Runeforged Gauntlets, stronger mystical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
