using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGHOSTLYVISAGE
#
###############################################################################

Class BEGhostlyVisage : BEHelmet {
	BEGhostlyVisage() : base() {
		$this.Name               = 'Ghostly Visage'
		$this.MapObjName         = 'ghostlyvisage'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spectral helm that grants the wearer ethereal properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
