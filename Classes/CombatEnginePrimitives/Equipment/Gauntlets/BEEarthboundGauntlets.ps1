using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHBOUNDGAUNTLETS
#
###############################################################################

Class BEEarthboundGauntlets : BEGauntlets {
	BEEarthboundGauntlets() : base() {
		$this.Name               = 'Earthbound Gauntlets'
		$this.MapObjName         = 'earthboundgauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets rooted to the earth, granting stability.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
