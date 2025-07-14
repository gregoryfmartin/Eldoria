using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEFORGEDGAUNTLETS
#
###############################################################################

Class BERuneforgedGauntlets : BEGauntlets {
	BERuneforgedGauntlets() : base() {
		$this.Name               = 'Runeforged Gauntlets'
		$this.MapObjName         = 'runeforgedgauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged with powerful runes, radiating mystical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
