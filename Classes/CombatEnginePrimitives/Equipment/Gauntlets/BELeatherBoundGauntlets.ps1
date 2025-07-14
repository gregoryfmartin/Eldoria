using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERBOUNDGAUNTLETS
#
###############################################################################

Class BELeatherBoundGauntlets : BEGauntlets {
	BELeatherBoundGauntlets() : base() {
		$this.Name               = 'Leather-Bound Gauntlets'
		$this.MapObjName         = 'leatherboundgauntlets'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather gauntlets reinforced with metal bands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
