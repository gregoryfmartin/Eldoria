using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDFORGEDGAUNTLETS
#
###############################################################################

Class BEVoidforgedGauntlets : BEGauntlets {
	BEVoidforgedGauntlets() : base() {
		$this.Name               = 'Voidforged Gauntlets'
		$this.MapObjName         = 'voidforgedgauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted in the heart of the void, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
