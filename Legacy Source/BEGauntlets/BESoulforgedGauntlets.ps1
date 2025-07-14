using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULFORGEDGAUNTLETS
#
###############################################################################

Class BESoulforgedGauntlets : BEGauntlets {
	BESoulforgedGauntlets() : base() {
		$this.Name               = 'Soulforged Gauntlets'
		$this.MapObjName         = 'soulforgedgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 68
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a captured soul, granting dark power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
