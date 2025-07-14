using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITBOUNDGAUNTLETS
#
###############################################################################

Class BESpiritboundGauntlets : BEGauntlets {
	BESpiritboundGauntlets() : base() {
		$this.Name               = 'Spiritbound Gauntlets'
		$this.MapObjName         = 'spiritboundgauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that link to a spirit, enhancing defense and magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
