using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREGAUNTLETS
#
###############################################################################

Class BEOgreGauntlets : BEGauntlets {
	BEOgreGauntlets() : base() {
		$this.Name               = 'Ogre Gauntlets'
		$this.MapObjName         = 'ogregauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude and massive gauntlets, for the strongest warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
