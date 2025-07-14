using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANGELICGAUNTLETS
#
###############################################################################

Class BEAngelicGauntlets : BEGauntlets {
	BEAngelicGauntlets() : base() {
		$this.Name               = 'Angelic Gauntlets'
		$this.MapObjName         = 'angelicgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the heavens, radiating purity and light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
