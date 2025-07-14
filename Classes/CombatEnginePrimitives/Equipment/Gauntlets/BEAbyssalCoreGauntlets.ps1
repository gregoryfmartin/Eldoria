using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALCOREGAUNTLETS
#
###############################################################################

Class BEAbyssalCoreGauntlets : BEGauntlets {
	BEAbyssalCoreGauntlets() : base() {
		$this.Name               = 'Abyssal Core Gauntlets'
		$this.MapObjName         = 'abyssalcoregauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with a core of abyssal energy, consuming magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
