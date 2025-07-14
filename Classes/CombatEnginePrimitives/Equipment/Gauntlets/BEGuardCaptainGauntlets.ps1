using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDCAPTAINGAUNTLETS
#
###############################################################################

Class BEGuardCaptainGauntlets : BEGauntlets {
	BEGuardCaptainGauntlets() : base() {
		$this.Name               = 'Guard Captain Gauntlets'
		$this.MapObjName         = 'guardcaptaingauntlets'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by experienced guards, providing reliable defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
