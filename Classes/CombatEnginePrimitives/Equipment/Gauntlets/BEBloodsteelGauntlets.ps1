using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLOODSTEELGAUNTLETS
#
###############################################################################

Class BEBloodsteelGauntlets : BEGauntlets {
	BEBloodsteelGauntlets() : base() {
		$this.Name               = 'Bloodsteel Gauntlets'
		$this.MapObjName         = 'bloodsteelgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged with blood ritual, dark and potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
