using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARGOYLEGAUNTLETS
#
###############################################################################

Class BEGargoyleGauntlets : BEGauntlets {
	BEGargoyleGauntlets() : base() {
		$this.Name               = 'Gargoyle Gauntlets'
		$this.MapObjName         = 'gargoylegauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets resembling gargoyle claws, stony and imposing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
