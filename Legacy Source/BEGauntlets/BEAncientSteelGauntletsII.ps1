using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCIENTSTEELGAUNTLETSII
#
###############################################################################

Class BEAncientSteelGauntletsII : BEGauntlets {
	BEAncientSteelGauntletsII() : base() {
		$this.Name               = 'Ancient Steel Gauntlets II'
		$this.MapObjName         = 'ancientsteelgauntletsii'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Further reinforced Ancient Steel Gauntlets, nearly unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
